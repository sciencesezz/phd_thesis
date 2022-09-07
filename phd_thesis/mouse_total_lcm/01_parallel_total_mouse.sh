#!/bin/bash

for fq in /nesi/nobackup/vuw03607/mouse_rnaseq/mlcm/total_mlcm_novaseq_data/SCZ9874/fastq_r2_merged/*.fastq.gz
do
sbatch -t 0-3:00 -c 2 --job-name rnaseq-workflow --mem 20G --output="/nesi/nobackup/vuw03607/novaseq_total_mlcm_all_%j.out" --error="/nesi/nobackup/vuw03607/novaseq_total_mlcm_all_%j.err" --mail-type="ALL" --mail-user="sarah.sczelecki@vuw.ac.nz" --wrap="bash /nesi/nobackup/vuw03607/mouse_rnaseq/scripts/03_total_hisat_mouse.sh $fq"
sleep 5	# wait 5 seconds between each job submission
done
