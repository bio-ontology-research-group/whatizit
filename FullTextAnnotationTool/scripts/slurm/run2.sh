#!/bin/bash


#SBATCH --mem 10Gb # memory pool for all cores
#SBATCH --time 2-00:00:00 # time, specify max time allocation
#SBATCH -e slurm.%N.%j.err # STDERR , $1 represents the file name processed from your corpora folder
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=senay.kafkas@kaust.edu.sa  
#SBATCH --job-name=OA_FT_Annotation
#SBATCH --array=0-1 ##1 is the last index in the input file (e.g. OA.files.txt)


echo "Job ID=$SLURM_JOB_ID,  Running task:$SLURM_ARRAY_TASK_ID" 

#  Use this command to run the Whatizit annotation pipeline
INPUT_DIR="/scratch/dragon/intel/kafkass/whatizit/FullTextAnnotationTool/corpora";
OUTPUT_DIR="/scratch/dragon/intel/kafkass/whatizit/FullTextAnnotationTool/scripts/slurm"

values=$(grep "^${SLURM_ARRAY_TASK_ID}:" $INPUT_DIR/OA.files.txt)
filename=$(echo $values | cut -f 2 -d:)

zcat $INPUT_DIR/$filename | sh ./FT_Annotator.sh |gzip > $OUTPUT_DIR/Out.$filename
