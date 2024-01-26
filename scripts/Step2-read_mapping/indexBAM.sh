#!/usr/bin/env bash

#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH --time=24:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=begin,end


#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####                         create files to store the bam's content indexes                                  #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####


module load UHTS/Analysis/samtools/1.10

cd /data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/SAM_BAM_GTF/BAMs

for file in *_sorted.bam; do
    samtools index -@10 $file $file.bai
done

