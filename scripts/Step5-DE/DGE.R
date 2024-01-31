

###                         CODE RUNNED LOCALLY NOT ON THE CLUSTER !!!



#setting up environment path (working directory and library path)
setwd("/Users/michaeljopiti/A_SA-23/RNA-sequencing/RNA-seq_lncRNA/RNA-seq/scripts/Step5-DE")
.libPaths("/Users/michaeljopiti/A_SA-23/RNA-sequencing/library")

#importing needed packages
library(ggplot2)
library(ggrepel)
library(EnhancedVolcano)
library(sleuth)

#setting up positions for Holoclonal and Parental DGE files from Kallisto
expressionPDir <- "/Users/michaeljopiti/A_SA-23/RNA-sequencing/expression"
expressionContent <- c("HOLO_1_1", "HOLO_1_2","HOLO_1_5",
                       "PAR_1","PAR_2","PAR_3")
expressionPath <- file.path(expressionPDir, expressionContent)

#preparation of metadata table
s2c <- read.table("metadata.txt", header = TRUE, stringsAsFactors=FALSE)
#s2c <- dplyr::select(s2c, sample = run_accession, condition)
  ### adding path to single directory containing Kallisto outputs per sample
s2c <- dplyr::mutate(s2c, path = expressionPath)

###             corrected version             ###

#imported custom table with gene names, types, ... prepared on the cluster
t2g <- read.csv("../../expression/target_mapping.txt", header = FALSE) 
colnames(t2g) <-  c("target_id", "gene_name", "gene_type")

#preparation of sleuth object
so <- sleuth_prep(s2c, target_mapping = t2g, extra_bootstrap_summary=T)
so <- sleuth_fit(so, ~condition, 'full')
so <- sleuth_fit(so, ~1, 'reduced')
so <- sleuth_wt(so, 'conditionHoloclonal')
models(so)

#create final table
result_table <- sleuth_results(so, 'conditionHoloclonal', show_all = F)
#if gene is known, not NA will appear under gene type (still not annotated -> possible novel lncRNA)
known_genes_table <- result_table[!is.na(result_table$gene_type),]
#reverse case, not known are represented by NA
unknown_genes_table <- result_table[is.na(result_table$gene_type),]

#novel significant genes are represented by a qval <= 0.05 (corrected pvalue under 5%)
significant_genes <- dplyr::filter(unknown_genes_table, qval <=0.05)
head(significant_genes, 20)

#volcano plot for data visualization
EnhancedVolcano(result_table,
                lab=result_table$target_id,
                x="b",
                y="qval")
EnhancedVolcano(unknown_genes_table,
                lab=unknown_genes_table$target_id,
                x="b",
                y="qval")
EnhancedVolcano(known_genes_table,
                lab=known_genes_table$gene_name,
                x="b",
                y="qval")

# Select the top 20 most significant genes by q-value
top_genes <- known_genes_table[order(known_genes_table$qval)[1:20], ]

# Create the EnhancedVolcano plot with labels for the top 20 genes
report_graph <- EnhancedVolcano(known_genes_table,
                                lab = ifelse(known_genes_table$gene_name %in% top_genes$gene_name, as.character(known_genes_table$gene_name), ""),
                                x = "b",
                                y = "qval",
                                pCutoff = 0.001,
                                FCcutoff = 0.05,
                                shape = 2,
                                labSize = 3.0,
                                title = "Volcano plot for Holoclonal DE genes",
                                titleLabSize = 15.0,
                                subtitle = "Annotated Genes",
                                subtitleLabSize = 10.0,
                                legendLabSize = 7.0,
                                legendIconSize = 3.0,
                                drawConnectors = TRUE) + coord_flip()
report_graph

## Individual plots for single gene testing
### genes taken from paper or most differential expressed table
#CDH17 from paper for EMT is over present in my analysis as well
plot_bootstrap(so, "ENST00000441892.6", units = "est_counts", color_by = "condition")
#EpCAM from paper for CSC marker  is over present in my analysis as well
plot_bootstrap(so, "ENST00000263735.9", units = "est_counts", color_by = "condition")
#TP53
plot_bootstrap(so, "ENST00000505014.5", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENST00000508793.6", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENST00000571370.2", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENST00000618944.4", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENST00000619485.4", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENST00000620739.4", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENST00000622645.4", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENST00000635293.1", units = "est_counts", color_by = "condition")
plot_bootstrap(so, "ENST00000622645.4", units = "est_counts", color_by = "condition")

#PCA plot
plot_pca(so, color_by = 'condition')
#quality check for amount of counts between conditions
plot_group_density(so, use_filtered = TRUE, units = "est_counts",
                   trans = "log", grouping = setdiff(colnames(so$sample_to_covariates),
                                                     "sample"), offset = 1)