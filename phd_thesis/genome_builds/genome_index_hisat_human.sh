#!/bin/bash
#This a Slurm script to build a genome index using Hisat for Humans
module load HISAT2/2.2.1-gimkl-2020a
BASE_PATH=/nesi/nobackup/vuw03607/mouse_rnaseq
GENOME_FA=$BASE_PATH/h_genome_download/Homo_sapiens.GRCh38.dna.primary_assembly.fa
hisat2-build -p 16 -f $GENOME_FA $BASE_PATH/h_indexed_genome/Homo_sapiens.GRCh38.dna.primary_assembly
