#!/usr/bin/env bash

#SBATCH --cpus-per-task=15
#SBATCH --mem-per-cpu=10G
#SBATCH --time=24:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=begin,end

#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####             Script to prepare for the kallisto quantification (gffread to create the transcriptomic     #####
#####             FASTA file and kallisto index to create an index out of said file)                          #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

THREADS=$SLURM_CPUS_PER_TASK

EXPRESSION=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/expression
TRANSCRIPTOME=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/SAM_BAM_GTF/GTFs
FASTQ=/data/courses/rnaseq_course/lncRNAs/fastq
REFERENCES=/data/courses/rnaseq_course/lncRNAs/Project2/references

module add UHTS/Analysis/kallisto/0.46.0
module add UHTS/Assembler/cufflinks/2.2.1

#mkdir -p /data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/expression

#creation transcriptomic fasta file
gffread -w $EXPRESSION/all_transcriptome.fa -g $REFERENCES/GRCh38.genome.fa $TRANSCRIPTOME/merged.gtf

#building the index
kallisto index -i $EXPRESSION/all_kallisto_index $EXPRESSION/all_transcriptome.fa