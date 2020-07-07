#!/bin/bash

## scp data for subject ($1) to cluster ($2) ##

# create file path, add presentation vs choice functionality next #
file_path="/home/knight/deborahm/DataWorkspace/_projects/Dictator/Preprocessing/$1/Around_presentation/data_final_padding.mat"

# if exists, scp #
if test -f "$file_path"; then
    rsync -v --no-g $file_path $2
else
    echo "$file_path does not exist"
fi
