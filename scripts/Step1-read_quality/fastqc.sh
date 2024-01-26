#!/usr/bin/env bash

#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=5G
#SBATCH --time=05:00:00
#SBATCH --job-name=FASTQC_Holo
#SBATCH --mail-user=michael.jopiti@students.unibe.ch
#SBATCH --mail-type=begin,end

WD=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA
FILES=/data/courses/rnaseq_course/lncRNAs/fastq/
mkdir -p Fastqc
FASTQC=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/RNA-seq_lncRNA/Fastqc
 
module load UHTS/Quality_control/fastqc/0.11.9

#FASTQC for Parental
for file1 in $FILES/1*.fastq.gz
do
    fastqc $file1
done

for file2 in $FILES/*.html 
do
    mv $file2 $FASTQC
done

for file3 in $FILES/*.zip
do
    mv $file3 $FASTQC
done