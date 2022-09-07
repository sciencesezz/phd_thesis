#!/bin/bash

#This is a Bash Script for Mouse Total RNA Seq Analysis - one sample at a time

# initialize a variable with an intuitive name to store the name of the input fastq file

fq=$1

# grab base of filename for naming outputs

base=`basename $fq .fastq.gz`
echo "Sample name is $base"

#navigate to directory and set-up project directory
cd /nesi/nobackup/vuw03607/mouse_rnaseq
BASE_PATH=/nesi/nobackup/vuw03607/mouse_rnaseq
mkdir -p novaseq_total_mlcm_all
proBASE_PATH=$BASE_PATH/novaseq_total_mlcm_all

#make a variable for the required genome .fa file and .gtf and index genome
#index genome in the first instance and skip hisat2 build
#this needs to be edited depending on sample type. Align to fa, sort to gtf

GENOME_FA=$BASE_PATH/genome_download/Mus_musculus.GRCm38.dna.toplevel.fa
GENOME_GTF=$BASE_PATH/genome_download/Mus_musculus.GRCm38.102.gtf
INDEX=$BASE_PATH/indexed_genome/Mus_musculus.GRCm38.dna.toplevel

#make all of the output directories
#flag so that the directory will not be created if it already exists
mkdir -p $proBASE_PATH/fastqc_untrimmed
mkdir -p $proBASE_PATH/multiqc_untrimmed
mkdir -p $proBASE_PATH/trimmed_reads
mkdir -p $proBASE_PATH/indexed_genome
mkdir -p $proBASE_PATH/fastqc_trimmed
mkdir -p $proBASE_PATH/multiqc_trimmed
mkdir -p $proBASE_PATH/hisat2
mkdir -p $proBASE_PATH/hisat2_sorted
mkdir -p $proBASE_PATH/counts

echo "Directories Created"

#set up output filenames and locations

fastqc_untrimmed_out=$proBASE_PATH/fastqc_untrimmed
fastqc_trimmed_out=$proBASE_PATH/fastqc_trimmed
trimmed_reads=$proBASE_PATH/trimmed_reads/${base}.trimmed.fastq.gz
fastqc_trimmed_out=$proBASE_PATH/fastqc_trimmed
trimmed_sam=$proBASE_PATH/hisat2/${base}.trimmed.sam
trimmed_bam=$proBASE_PATH/hisat2/${base}.trimmed.bam
sorted_bam=$proBASE_PATH/hisat2_sorted/${base}.trimmed.sorted.bam


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
cutadapt -q 20 -a AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -u 3 -m 15 -o $trimmed_reads $fq > $proBASE_PATH/multiqc_trimmed/${base}.log
echo "Cutadapt Complete!"

#fastqc on trimmed reads
echo "Starting Trimmed FastQC..."
fastqc -o $fastqc_trimmed_out $trimmed_reads
echo "FastQC Trimmed $base Complete!"

#align to genome using Hisat2, genome already indexed, so skips hisat2 build step
echo "Starting Alignment on ${base}..."
hisat2 -p 16 -x $INDEX -U $trimmed_reads -S $trimmed_sam --summary-file $proBASE_PATH/hisat2/${base}_summary.txt
echo "Alignment of $base Complete!"

#conversion of .sam to .bam files
echo "Staring $base conversion of .sam to .bam..."
samtools view -S -b $trimmed_sam -o $trimmed_bam
echo "conversion of $base Complete!"


#sort .bam files
echo "Starting $base .bam sorting..."
samtools sort -o $sorted_bam $trimmed_bam
echo "$base .bam sorting complete!"

#do counting separately after all samples have been processed individually

echo "end of script"
