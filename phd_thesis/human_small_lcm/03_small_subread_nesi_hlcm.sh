#!/bin/bash

#This is a Bash Script for Human Small RNA Seq Analysis - one sample at a time

# initialize a variable with an intuitive name to store the name of the input fastq file

fq=$1

# grab base of filename for naming outputs

base=`basename $fq .fastq.gz`
echo "Sample name is $base"

#navigate to directory and set-up project directory
cd /nesi/nobackup/vuw03607/mouse_rnaseq
BASE_PATH=/nesi/nobackup/vuw03607/mouse_rnaseq
mkdir -p novaseq_small_hlcm_all
proBASE_PATH=$BASE_PATH/novaseq_small_hlcm_all

#make a variable for the required genome .fa file and .gtf and index genome
#index genome in the first instance and skip subread build
#this needs to be edited depending on sample type. Align to fa, sort to gtf

INDEX=$BASE_PATH/h_indexed_genome_subread/Homo_sapiens.GRCh38.dna.primary_assembly

#make all of the output directories
#flag so that the directory will not be created if it already exists
mkdir -p $proBASE_PATH/fastqc_untrimmed
mkdir -p $proBASE_PATH/multiqc_untrimmed
mkdir -p $proBASE_PATH/trimmed_reads
mkdir -p $proBASE_PATH/indexed_genome
mkdir -p $proBASE_PATH/fastqc_trimmed
mkdir -p $proBASE_PATH/multiqc_trimmed
mkdir -p $proBASE_PATH/counts
mkdir -p $proBASE_PATH/subread

echo "Directories Created"

#set up output filenames and locations

fastqc_untrimmed_out=$proBASE_PATH/fastqc_untrimmed
fastqc_trimmed_out=$proBASE_PATH/fastqc_trimmed
trimmed_reads=$proBASE_PATH/trimmed_reads/${base}.trimmed.fastq.gz
fastqc_trimmed_out=$proBASE_PATH/fastqc_trimmed
subread_bam=$proBASE_PATH/subread/${base}.bam


#set up the software environment
module purge
module load FastQC/0.11.7
module load MultiQC/1.9-gimkl-2020a-Python-3.8.2
module load cutadapt/3.5-gimkl-2020a-Python-3.8.2
module load HISAT2/2.2.1-gimkl-2020a
module load SAMtools/1.13-GCC-9.2.0
module load Subread/2.0.0-GCC-9.2.0

echo "Modules Loaded"

echo "Processing file $base"

#run fastqc on untrimmed source data, source data directory needs to change for each data set
fastqc -o $fastqc_untrimmed_out $fq
echo "Untrimmed FastQC done on $base"

#don't run multiqc because only one file at a time are being loaded into the directory

#trim read
echo "trimming sample $base"
cutadapt -q 20 -a TGGAATTCTCGGGTGCCAAGG -u 4 -u -4 -m 15 -o $trimmed_reads $fq > $proBASE_PATH/multiqc_trimmed/${base}.log
echo "Cutadapt Complete!"

#fastqc on trimmed reads
echo "Starting Trimmed FastQC..."
fastqc -o $fastqc_trimmed_out $trimmed_reads
echo "FastQC Trimmed $base Complete!"

#align to genome using Subread, genome already indexed, so skips Subread build step
echo "Starting Alignment..."
for filename in $proBASE_PATH/trimmed_reads/*.trimmed.fastq.gz
do
base=$(basename ${filename} .fastq.gz)
echo "on sample: $base"
subread-align -t 1 -i $INDEX -n 35 -m 2 -M 3 -T 10 -I 0 --multiMapping -B 10 -r $filename -o $proBASE_PATH/subread/${base}.bam
done
echo "Alignment of $base Complete!"

#do counting separately after all samples have been processed individually

echo "end of script"
