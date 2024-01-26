#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --time=03:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=begin,end


#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####            convert SAM to respective BAM file (just binary conversion, no content is changed)           #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

module load UHTS/Analysis/samtools/1.10;

cd /data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/SAM_BAM

for file in *.sam ; do
    samtools view -bS $file -o ${file%.*}.bam
done