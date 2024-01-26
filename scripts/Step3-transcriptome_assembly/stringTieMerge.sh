#!/usr/bin/env bash

#SBATCH --cpus-per-task=15
#SBATCH --mem-per-cpu=10G
#SBATCH --time=24:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=begin,end

#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####            stringtie merge, merges all the gtf files listed in gtf.txt into one single gtf              #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####


module load UHTS/Aligner/stringtie/1.3.3b

TRANSCRIPTOME=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/SAM_BAM
SCRIPTS=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/scripts
LIST=$SCRIPTS/gtf.txt
REFERENCES=/data/courses/rnaseq_course/lncRNAs/Project2/references/gencode.v44.annotation.gtf


cd $TRANSCRIPTOME
stringtie --merge -p 15 --rf -G $REFERENCES -o merged.gtf $SCRIPTS/gtf.txt