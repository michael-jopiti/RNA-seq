#!/usr/bin/env bash

#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=8G
#SBATCH --time=24:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=begin,end

#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####             with kallisto quant, create quantifications tables for next step (R) analysis               #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####


THREADS=$SLURM_CPUS_PER_TASK

EXPRESSION=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/expression
TRANSCRIPTOME=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/SAM_BAM_GTF/GTFs
FASTQ=/data/courses/rnaseq_course/lncRNAs/fastq
REFERENCES=/data/courses/rnaseq_course/lncRNAs/Project2/references

HOLO_1="HOLO_1"
HOLO_2="HOLO_2"
HOLO_3="HOLO_3"
PAR_1="PAR_1"
PAR_2="PAR_2"
PAR_3="PAR_3"

module add UHTS/Analysis/kallisto/0.46.0
module add UHTS/Assembler/cufflinks/2.2.1

#holoclonal
DIR=$EXPRESSION/$HOLO_1
mkdir -p $
kallisto quant -i $EXPRESSION/all_kallisto_index -o $DIR -b 600 --rf-stranded --threads $THREADS $FASTQ/1_2_L3_R1_001_DnNWKUYhfc9S.fastq.gz  $FASTQ/1_2_L3_R2_001_SNLaVsTQ6pwl.fastq.gz

DIR=$EXPRESSION/$HOLO_2
mkdir -p $DIR
kallisto quant -i $EXPRESSION/all_kallisto_index -o $DIR -b 600 --rf-stranded --threads $THREADS $FASTQ/1_5_L3_R1_001_iXvvRzwmFxF3.fastq.gz  $FASTQ/1_5_L3_R2_001_iXCMrktKyEh0.fastq.gz

DIR=$EXPRESSION/$HOLO_3
mkdir -p $DIR
kallisto quant -i $EXPRESSION/all_kallisto_index -o $DIR -b 600 --rf-stranded --threads $THREADS $FASTQ/1_1_L3_R1_001_ij43KLkHk1vK.fastq.gz $FASTQ/1_1_L3_R2_001_qyjToP2TB6N7.fastq.gz

#parental
DIR=$EXPRESSION/$PAR_1
mkdir -p $DIR
kallisto quant -i $EXPRESSION/all_kallisto_index -o $DIR -b 600 --rf-stranded --threads $THREADS $FASTQ/P1_L3_R1_001_9L0tZ86sF4p8.fastq.gz  $FASTQ/P1_L3_R2_001_yd9NfV9WdvvL.fastq.gz

DIR=$EXPRESSION/$PAR_2
mkdir -p $DIR
kallisto quant -i $EXPRESSION/all_kallisto_index -o $DIR -b 600 --rf-stranded --threads $THREADS $FASTQ/P2_L3_R1_001_R82RphLQ2938.fastq.gz  $FASTQ/P2_L3_R2_001_06FRMIIGwpH6.fastq.gz

DIR=$EXPRESSION/$PAR_3
mkdir -p $DIR
kallisto quant -i $EXPRESSION/all_kallisto_index -o $DIR -b 600 --rf-stranded --threads $THREADS $FASTQ/P3_L3_R1_001_fjv6hlbFgCST.fastq.gz  $FASTQ/P3_L3_R2_001_xo7RBLLYYqeu.fastq.gz