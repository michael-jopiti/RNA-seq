#!/usr/bin/env bash

#SBATCH --cpus-per-task=3
#SBATCH --mem-per-cpu=1G
#SBATCH --time=05:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=fail,end
#SBATCH --job-name="BED_SH"
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/scripts/Step6-integrative_analysis/output_BED_script-%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/scripts/Step6-integrative_analysis/error_BED_script-%j.e

#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####                                       Creation of BED files                                             #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

module load UHTS/Analysis/BEDTools/2.29.2

TRANSCRIPTOME=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/SAM_BAM_GTF/GTFs
BED=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/BED


#Parsing merged.gtf to create BED files
awk -F $'\t' '$3=="transcript"' $TRANSCRIPTOME/merged.gtf | awk '$1 ~ /chr/ {print $1, $4, $5, $6, $7, $12}' | sed 's/;//g' | sed 's/"//g' | sed 's/ /\t/g' > $BED/all_transcripts.bed
awk -F $'\t' '$3=="transcript"' $TRANSCRIPTOME/merged.gtf | grep -v 'ENS' | awk '$1 ~ /chr/ {print $1, $4, $5, $6, $7, $12}' | sed 's/;//g' | sed 's/"//g' | sed 's/ /\t/g' > $BED/novel_transcripts.bed
awk -F $'\t' '$3=="transcript"' $TRANSCRIPTOME/merged.gtf | grep 'ENS' | awk '$1 ~ /chr/ {print $1, $4, $5, $6, $7, $12}' | sed 's/;//g' | sed 's/"//g' | sed 's/ /\t/g' > $BED/annot_transcripts.bed

#Content order: chromosome,start,end,name,score and strand
awk -F '\t' '$5=="+"' $BED/novel_transcripts.bed | awk '{print $1"\t"$2"\t"$3"\t"$6"\t"$4"\t"$5}' > $BED/pos_Strand.bed
awk -F '\t' '$5=="-"' $BED/novel_transcripts.bed | awk '{print $1"\t"$2"\t"$3"\t"$6"\t"$4"\t"$5}' > $BED/neg_Strand.bed

#exploiting inverse of bed tools intersect to find intergenic regions
bedtools intersect -v -a $BED/novel_transcripts.bed -b $BED/annot_transcripts.bed > $BED/intergenic_novel.bed