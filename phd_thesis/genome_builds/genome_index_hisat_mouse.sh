#!/bin/bash
#This a Slurm script to build a genome index using Hisat for Mice
module load HISAT2/2.2.1-gimkl-2020a
BASE_PATH=/nesi/nobackup/vuw03607/mouse_rnaseq
GENOME_FA=$BASE_PATH/genome_download/Mus_musculus.GRCm38.dna.toplevel.fa
hisat2-build -p 16 -f $GENOME_FA $BASE_PATH/indexed_genome/Mus_musculus.GRCm38.dna.toplevel
