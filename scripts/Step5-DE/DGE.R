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
so <- sleuth_prep(s2c, target_mapping = t2g)
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
