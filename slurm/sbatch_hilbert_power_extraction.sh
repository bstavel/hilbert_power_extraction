#!/bin/bash
#SBATCH --job-name=dhilbert_power_extraction_CP34
#SBATCH --account=fc_knightlab
#SBATCH --partition=savio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=6
#SBATCH --cpus-per-task=1
#SBATCH --time=03:00:00
#SBATCH --output=./slurm/hilbert_job_%j.out
#SBATCH --error=./slurm/hilbert_job_%j.err
#SBATCH --mail-user=bstavel@berkeley.edu
#SBATCH --mail-type=ALL
#
## Command(s) to run:
module load matlab
matlab -nodisplay -nosplash -nodesktop -r batch_hilbert_extraction
