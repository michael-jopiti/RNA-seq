#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=20G
#SBATCH --time=01:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=begin,end


#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####     using hisat2 command, mapping of individual reads into a respectiva SAM file        #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

module load UHTS/Aligner/hisat/2.2.1

mkdir -p Mapped

WD=$pwd
READS=/data/courses/rnaseq_course/lncRNAs/fastq
THREADS=$SLURM_CPUS_PER_TASK
INDEX=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA
MAP=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/SAM_BAM_GTF/SAMs

#Holoclones
hisat2 -p $THREADS -x $INDEX/human_Genome -1 $READS/1_1_L3_R1_001_ij43KLkHk1vK.fastq.gz -2 $READS/1_1_L3_R2_001_qyjToP2TB6N7.fastq.gz -S $MAP/1_1.sam
hisat2 -p $THREADS -x $INDEX/human_Genome -1 $READS/1_2_L3_R1_001_DnNWKUYhfc9S.fastq.gz -2 $READS/1_2_L3_R2_001_SNLaVsTQ6pwl.fastq.gz -S $MAP/1_2.sam
hisat2 -p $THREADS -x $INDEX/human_Genome -1 $READS/1_5_L3_R1_001_iXvvRzwmFxF3.fastq.gz -2 $READS/1_5_L3_R2_001_iXCMrktKyEh0.fastq.gz  -S $MAP/1_5.sam

#Parental
hisat2 -p $THREADS -x $INDEX/human_Genome -1 $READS/P1_L3_R1_001_9L0tZ86sF4p8.fastq.gz -2 $READS/P1_L3_R2_001_yd9NfV9WdvvL.fastq.gz  -S $MAP/P_1.sam
hisat2 -p $THREADS -x $INDEX/human_Genome -1 $READS/P2_L3_R1_001_R82RphLQ2938.fastq.gz -2 $READS/P2_L3_R2_001_06FRMIIGwpH6.fastq.gz  -S $MAP/P_2.sam
hisat2 -p $THREADS -x $INDEX/human_Genome -1 $READS/P3_L3_R1_001_fjv6hlbFgCST.fastq.gz -2 $READS/P3_L3_R2_001_xo7RBLLYYqeu.fastq.gz  -S $MAP/P_3.sam
