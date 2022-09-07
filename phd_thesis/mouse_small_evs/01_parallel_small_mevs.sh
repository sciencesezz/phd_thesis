#!/bin/bash

for fq in /nesi/nobackup/vuw03607/mouse_rnaseq/mevs/novaseq_mevs/SCZ10634/fastq_merged/*.fastq.gz
do
sbatch -t 0-3:00 -c 2 --job-name rnaseq-workflow --mem 20G --output="/nesi/nobackup/vuw03607/novaseq_small_mevs_all_%j.out" --error="/nesi/nobackup/vuw03607/novaseq_small_mevs_all_%j.err" --mail-type="ALL" --mail-user="sarah.sczelecki@vuw.ac.nz" --wrap="bash /nesi/nobackup/vuw03607/mouse_rnaseq/scripts/03_small_subread_nesi_mouse.sh $fq"
sleep 5	# wait 5 seconds between each job submission
done
