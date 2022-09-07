#!/bin/bash

#This a Slurm script to build a genome index using Subread for mice

#SBATCH --job-name=subread_index
#SBATCH --account=vuw03607
#SBATCH --time=02:30:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=20G
#SBATCH --output=/nesi/nobackup/vuw03607/subread_index_mouse%j.out
#SBATCH --error=/nesi/nobackup/vuw03607/subread_index_mouse%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sarah.sczelecki@vuw.ac.nz

module load Subread/2.0.0-GCC-9.2.0
cd /nesi/nobackup/vuw03607/mouse_rnaseq/genome_download
subread-buildindex -F -B -o /nesi/nobackup/vuw03607/mouse_rnaseq/m_indexed_genome_subread/Mus_musculus.GRCm38.dna.primary_assembly ./Mus_musculus.GRCm38.dna.primary_assembly.fa
