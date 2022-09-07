#!/bin/bash

#This is a Bash Script for MultiQC and FeatureCounts for Human Total RNA Seq Analysis

#SBATCH --job-name=test
#SBATCH --account=vuw03607
#SBATCH --time=96:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --output=/nesi/nobackup/vuw03607/novaseq_total_hlcm_04_%j.out
#SBATCH --error=/nesi/nobackup/vuw03607/novaseq_total_hlcm_04_%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=sarah.sczelecki@vuw.ac.nz

cd /nesi/nobackup/vuw03607/mouse_rnaseq/novaseq_total_hlcm_all

#set up required variables for script
BASE_PATH=/nesi/nobackup/vuw03607/mouse_rnaseq
proBASE_PATH=/nesi/nobackup/vuw03607/mouse_rnaseq/novaseq_total_hlcm_all
GENOME_FA=$BASE_PATH/h_genome_download/Homo_sapiens.GRCh38.dna.primary_assembly.fa
GENOME_GTF=$BASE_PATH/h_genome_download/Homo_sapiens.GRCh38.106.chr.gtf
INDEX=$BASE_PATH/h_indexed_genome/Homo_sapiens.GRCh38.dna.primary_assembly

#setup software environment
module purge
module load FastQC/0.11.7
module load MultiQC/1.9-gimkl-2020a-Python-3.8.2
module load cutadapt/3.5-gimkl-2020a-Python-3.8.2
module load HISAT2/2.2.1-gimkl-2020a
module load SAMtools/1.13-GCC-9.2.0
module load Subread/2.0.0-GCC-9.2.0

#run multiqc on untrimmed source data
echo "Starting MultiQC"
multiqc -f $proBASE_PATH/fastqc_untrimmed/* -o $proBASE_PATH/multiqc_untrimmed
echo "Untrimmed MultiQC done"

#multiqc on trimmed Reads
echo "Starting Trimmed MultiQC..."
multiqc -f $proBASE_PATH/fastqc_trimmed/* -o $proBASE_PATH/multiqc_trimmed
echo "MultiQC Trimmed Complete!"

#counting of sorted bam files
for filename in $proBASE_PATH/hisat2_sorted/*.trimmed.sorted.bam
do
  featureCounts -a $GENOME_GTF -o $proBASE_PATH/counts/novaseq_total_hlcm_all_counts.txt -T 2 -t exon -g gene_id $proBASE_PATH/hisat2_sorted/*.trimmed.sorted.bam
done

echo "counting complete"
echo "end of script"
