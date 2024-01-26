#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --time=04:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=begin,end


#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####               hisat2-build is used to create an index file from the fasta reference                     #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

module load UHTS/Aligner/hisat/2.2.1;

hisat2-build -p8 -f /data/courses/rnaseq_course/lncRNAs/Project1/references/GRCh38.genome.fa human_Genome
