#!/bin/bash
#SBATCH --job-name=dhilbert_power_extraction_CP34
#SBATCH --account=fc_knightlab
#SBATCH --partition=savio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:30:00
#SBATCH --output=./slurm/hilbert_job_%j.out
#SBATCH --error=./slurm/hilbert_job_%j.err
#SBATCH --mail-user=bstavel@berkeley.edu
#SBATCH --mail-type=ALL
#
## Command(s) to run:
module load matlab
/usr/bin/time matlab -nodisplay -nosplash -nodesktop -singleCompThread -r batch_hilbert_extraction
