#!/usr/bin/env bash

#SBATCH --cpus-per-task=3
#SBATCH --mem-per-cpu=1G
#SBATCH --time=05:00:00
#SBATCH --mail-user=michael.jopiti@unifr.ch
#SBATCH --mail-type=fail,end
#SBATCH --job-name="BED_SH"
#SBATCH --output=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/scripts/Step6-integrative_analysis/output_CPAT_script-%j.o
#SBATCH --error=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/scripts/Step6-integrative_analysis/error_CPAT_script-%j.e

#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####
#####                                                                                                         #####
#####                          CPAT evaluation for potential protein coding genes                             #####
#####                                                                                                         #####
#####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####     #####

module load SequenceAnalysis/GenePrediction/cpat/1.2.4
module load UHTS/Analysis/BEDTools/2.29.2

REFERENCE=/data/courses/rnaseq_course/lncRNAs/Project1/references
BED=/data/courses/rnaseq_course/lncRNAs/Project1/users/mjopiti/BED

#create fasta file out of BED of novel transcript
bedtools getfasta -s -name -fi $REFERENCE/GRCh38.genome.fa -bed $BED/novel_transcripts.bed -fo $BED/ref_novel_transcripts.fa
#use said fasta to search for potential protein coding genes out of our novel genes just discovered
cpat.py --gene $BED/ref_novel_transcripts.fa --logitModel $REFERENCE/Human_logitModel.RData --hex $REFERENCE/Human_Hexamer.tsv -o $BED/potential_protein_coding.txt