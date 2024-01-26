

            ################################################################################################
            ###     ###     ###     EVERYTHING RUNNED FROM TERMINAL, NOT AS A SCRIPT     ###     ###     ### 
            ################################################################################################

#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####         From terminal command line, create the custom table for the annotated genes and genes types.    #####
#####         It is fundamental to be able to separate the novel genes from our analysis from other already   #####
#####         annotated/known.                                                                                #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

#As biomart API (???) is for some reason not accessible from the R script, I manually created the custom table for the known genes to be used with sleuth

#extract genes from our merged.gtf
awk -F $'\t' '$3=="transcript"' merged.gtf | grep 'gene_name' | awk -F $'\t' '{print $9}' | awk -F ';' '{print $2, $3}' | awk '{print $2"\t"$4}' | sed 's/"//g' > gene_name.txt
#extract information to match our results to respectively annotated gene type
awk -F $'\t' '{print $9}' /data/courses/rnaseq_course/lncRNAs/Project1/references/gencode.v44.primary_assembly.annotation.gtf | awk -F ';' '$2 ~ "transcript_id" {print $2 $3}' | awk '{print $2 $4}' | sed 's/"/\t/g' > reference_gene_type.txt
#sort the files before merging
sort gene_name.txt > gene_name.sorted
sort reference_gene_type.txt > reference_genetype.sorted
#join and remove unique from the content to finalize the table
join gene_name.sorted reference_genetype.sorted > mapped_Genes.txt
uniq mapped_Genes.txt > mapped_Genes_unique.txt
sed 's/\t/,/g' mapped_Genes_unique.txt > target_mapping.txt
sed 's/\t/,/g; s/ \+/,/g' mapped_Genes_unique.txt > target_mapping.txt
sed 's/\t/,/g; s/ \+/,/g; s/,$//' mapped_Genes_unique.txt > target_mapping.txt


#awk -F $'\t' '$3=="transcript"' ALL_cells_merged.gtf | grep 'gene_name' | awk -F $'\t' '{print $9}' | awk -F ';' '{print $2, $3}' | awk '{print $2, $4}' | sed 's/"//g' > TranscriptID_GeneName.txt
