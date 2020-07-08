#!/bin/bash

## scp data for subject ($1) to path ($2) ##

# create file path, add presentation vs choice functionality next #
file_path="bstavel@nx6.neuro.berkeley.edu:/home/knight/deborahm/DataWorkspace/_projects/Dictator/Preprocessing/$1/Around_presentation/part2_data_final_padding.mat"

# if exists, scp #
if test -f "$file_path"; then
    rsync -v --no-g $file_path "$2/$(1)_data_final_padding.mat"
else
    echo "$file_path does not exist"
fi
