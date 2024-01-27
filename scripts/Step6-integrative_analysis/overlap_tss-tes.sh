#!/usr/bin/env bash

#SBATCH --cpus-per-task=3
#SBATCH --mem-per-cpu=1G
#SBATCH --time=05:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=fail,end
#SBATCH --job-name="BED_SH"
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/scripts/Step6-integrative_analysis/output_overlap_script-%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/scripts/Step6-integrative_analysis/error_overlap_script-%j.e

#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####                                BED of overlapping 5' and 3' ends                                        #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

module load UHTS/Analysis/BEDTools/2.29.2

BED=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/BED
TSS=/data/courses/rnaseq_course/lncRNAs/Project1/references
TES=/data/courses/rnaseq_course/lncRNAs

#tss + AND -
#else print to invert count of 50nt nucleotides window depending on strandness
awk '{if ($5 == "+") print $1"\t"$2-50"\t"$2+50"\t"$6"\t"$4"\t"$5; else print $1"\t"$3-50"\t"$3+50"\t"$6"\t"$4"\t"$5}' $BED/novel_transcripts.bed > $BED/tss_novel.bed
#check for negative starting sites, if there are, set them to 0
awk '{if($3<0 || $2<0) print $1,0,$3,$4,$5,$6; else print $1,$2,$3,$4,$5,$6}' $BED/tss_novel.bed  | tr ' ' '\t' > $BED/tss_novel_non-neg.bed

#tes + AND -
awk '{if ($5 == "+") print $1"\t"$3-50"\t"$3+50"\t"$6"\t"$4"\t"$5; else print $1"\t"$2-50"\t"$2+50"\t"$6"\t"$4"\t"$5}' $BED/novel_transcripts.bed > $BED/tes_novel.bed
#check for negative starting sites, if there are, set them to 0
awk '{if($3<0 || $2<0) print $1,0,$3,$4,$5,$6; else print $1,$2,$3,$4,$5,$6}' $BED/tes_novel.bed  | tr ' ' '\t' > $BED/tes_novel_non-neg.bed


#intersect BED files to assess overlapping on 5' and 3' ends respectively
bedtools intersect -wa -s -a $BED/tss_novel_non-neg.bed -b $TSS/refTSS_v4.1_human_coordinate.hg38.bed > $BED/tss_overlap.bed
bedtools intersect -wa -s -a $BED/tes_novel_non-neg.bed -b $TES/atlas.clusters.2.0.GRCh38.96.bed > $BED/tes_overlap.bed