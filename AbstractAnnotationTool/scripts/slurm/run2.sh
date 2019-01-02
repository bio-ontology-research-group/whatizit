#!/bin/bash


#SBATCH --mem 10Gb # memory pool for all cores
#SBATCH --time 2-00:00:00 # time, specify max time allocation
#SBATCH -e slurm.%N.%j.err # STDERR , $1 represents the file name processed from your corpora folder
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=xx@yy.com #your_email_address 
#SBATCH --job-name=OA_FT_Annotation

###     #SBATCH --partition=batch

#SBATCH --array=0-1 ## 1 is the last index in the input file (e.g. OA.files.txt)


echo "Job ID=$SLURM_JOB_ID,  Running task:$SLURM_ARRAY_TASK_ID" 

#  Use this command to run the Whatizit annotation pipeline
INPUT_DIR="/scratch/dragon/intel/kafkass/whatizit/AbstractAnnotationTool/corpora";
OUTPUT_DIR="/scratch/dragon/intel/kafkass/whatizit/AbstractAnnotationTool/scripts/slurm"

values=$(grep "^${SLURM_ARRAY_TASK_ID}:" $INPUT_DIR/OA.files.txt)
filename=$(echo $values | cut -f 2 -d:)

cat $INPUT_DIR/$filename | sh ./Abs_Annotator.sh |gzip > $OUTPUT_DIR/Out.$filename.gz
