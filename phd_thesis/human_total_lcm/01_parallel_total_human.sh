for fq in /nesi/nobackup/vuw03607/mouse_rnaseq/hlcm_data/total_hlcm_novaseq_data/SCZ10636/r2_reads/*.fastq.gz
do
sbatch -t 0-24:00 -c 2 --job-name rnaseq-workflow --mem 32G --output="/nesi/nobackup/vuw03607/total_hlcm_novaseq%j.out" --error="/nesi/nobackup/vuw03607/total_hlcm_novaseq%j.err" --mail-type="ALL" --mail-user="sarah.sczelecki@vuw.ac.nz" --wrap="bash /nesi/nobackup/vuw03607/mouse_rnaseq/scripts/03_total_hisat_human.sh $fq"
sleep 5	# wait 5 seconds between each job submission
done
