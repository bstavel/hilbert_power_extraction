#!/bin/bash
#SBATCH --job-name=hilbert_power_extraction_IR19
#SBATCH --account=fc_knightlab
#SBATCH --partition=savio
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --output=hilbert_job_%j.out
#SBATCH --error=hilbert_job_%j.err
#SBATCH --mail-user=bstavel@berkeley.edu
#SBATCH --mail-type=ALL
#
## Command(s) to run:
module load matlab
matlab -nodisplay -nosplash -nodesktop -singleCompThread -r batch_hilbert_extraction
