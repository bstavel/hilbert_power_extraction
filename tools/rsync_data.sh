#!/bin/bash

## scp data for subject ($1) to path ($2), if ($3) is true, use choice ##


if [$3 == TRUE ] ; then
  # create file path #
  file_path="bstavel@nx6.neuro.berkeley.edu:/home/knight/deborahm/DataWorkspace/_projects/Dictator/Preprocessing/${1}/Around_choice/data_final_choice_padding.mat"
  # do the rsync
  rsync -v --no-g $file_path "$2/${1}_data_final_choice_padding.mat"
elif [$3 == FALSE ] ; then
  # create file path #
  file_path="bstavel@nx6.neuro.berkeley.edu:/home/knight/deborahm/DataWorkspace/_projects/Dictator/Preprocessing/${1}/Around_presentation/data_final_padding.mat"
  # do the rsync
  rsync -v --no-g $file_path "$2/${1}_data_final_padding.mat"
fi
