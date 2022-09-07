#!/bin/bash

#This a Slurm script to build a genome index using Subread for Humans

#SBATCH --job-name=subread_index_human
#SBATCH --account=vuw03607
#SBATCH --time=05:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=20G
#SBATCH --output=/nesi/nobackup/vuw03607/subread_index_human%j.out
#SBATCH --error=/nesi/nobackup/vuw03607/subread_index_human%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sarah.sczelecki@vuw.ac.nz

module load Subread/2.0.0-GCC-9.2.0
cd /nesi/nobackup/vuw03607/mouse_rnaseq/h_genome_download
subread-buildindex -F -B -o /nesi/nobackup/vuw03607/mouse_rnaseq/h_indexed_genome_subread/Homo_sapiens.GRCh38.dna.primary_assembly /nesi/nobackup/vuw03607/mouse_rnaseq/h_genome_download/Homo_sapiens.GRCh38.dna.primary_assembly.fa
