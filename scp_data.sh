#!/bin/bash

## scp data for subject ($0) to current location

file_path="/home/knight/deborahm/DataWorkspace/_projects/Dictator/Preprocessing/$0/Around_presentation/data_final_padding.mat"

scp $file_path $1
