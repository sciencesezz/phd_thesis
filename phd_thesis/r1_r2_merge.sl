#!/bin/bash

#This is a script to merge R1 & R2 reads from different lanes of the flowcell. You can silence R2 merge, if you have only single end sequencing

#SBATCH --job-name=R_merge_total
#SBATCH --account=vuw03607
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --output=/nesi/nobackup/vuw03607/R_merge_total%j.out
#SBATCH --error=/nesi/nobackup/vuw03607/R_merge_total%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sarah.sczelecki@vuw.ac.nz

#change directory to where .fastq.gz files are, since merging code uses ./ to find .fastq.gz files for concatenating

cd /nesi/nobackup/vuw03607/mouse_rnaseq/mlcm/total_mlcm_novaseq_data/SCZ9874

#make a directory for all the merged files
mkdir fastq_merged

#Run for loop to merge R1 reads from two lanes into 1 .fastq.gz file

for i in $(find ./ -type f -name "*.fastq.gz" | while read F; do basename $F | rev | cut -c 22- | rev; done | sort | uniq)

do echo "Merging R1"

cat "$i"_L00*_R1_001.fastq.gz > "$i"_ME_L003_R1_001.fastq.gz

echo "Merging R2"

cat "$i"_L00*_R2_001.fastq.gz > "$i"_ME_L004_R2_001.fastq.gz

done

#separate fastq merged files from separate lane files

mv *_ME_L00*_R1_001.fastq.gz ./fastq_merged
