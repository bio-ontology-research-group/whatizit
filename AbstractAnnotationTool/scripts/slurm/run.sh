#!/bin/bash


#SBATCH --mem 10Gb # memory pool for all cores
#SBATCH --time 08:00:00 # time, specify max time allocation
#SBATCH -e slurm.%N.%j.err # STDERR , $1 represents the file name processed from your corpora folder
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=xx@yy.com #specify your e-mail  


INPUT_DIR="/scratch/dragon/intel/kafkass/whatizit/AbstractAnnotationTool/corpora";
OUTPUT_DIR="/scratch/dragon/intel/kafkass/whatizit/AbstractAnnotationTool/scripts/slurm"


cat $INPUT_DIR/$1 | sh ./Abs_Annotator.sh |gzip > $OUTPUT_DIR/Out.$1.gz
