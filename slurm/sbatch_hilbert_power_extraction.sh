#!/bin/bash
#SBATCH --job-name=hilbert_power_extraction_choice
#SBATCH --account=fc_knightlab
#SBATCH --partition=savio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=2
#SBATCH --time=06:00:00
#SBATCH --output=./slurm/hilbert_job_%j.out
#SBATCH --error=./slurm/hilbert_job_%j.err
#SBATCH --mail-user=bstavel@berkeley.edu
#SBATCH --mail-type=ALL
#
## Command(s) to run:
module load matlab
matlab -nodisplay -nosplash -nodesktop -singleCompThread -r batch_hilbert_extraction
