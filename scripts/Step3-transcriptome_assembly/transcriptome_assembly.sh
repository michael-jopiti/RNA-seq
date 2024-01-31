#!/usr/bin/env bash

#SBATCH --cpus-per-task=15
#SBATCH --mem-per-cpu=10G
#SBATCH --time=24:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=begin,end

#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####        for all BAM files created in step 2, stringite create an assembly a transcriptome assembly       #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

module load UHTS/Aligner/stringtie/1.3.3b

BAM=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/SAM_BAM_GTF/BAMs
REFERENCES=/data/courses/rnaseq_course/lncRNAs/Project2/references/gencode.v44.annotation.gtf     


for file in $BAM/*_sorted.bam; do
    stringtie -p 15 --rf -G $REFERENCES -o ${file%_sorted.bam}.gtf -G $REFERENCES $file
done

