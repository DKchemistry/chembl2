#!/bin/bash

# Base directory
BASE_DIR=$(pwd)

# Find all *_sorted.sdf files and process them with GNU parallel
find "$BASE_DIR" -name "*_sorted.sdf" | parallel -j 150 '
    source ~/miniconda3/etc/profile.d/conda.sh
    conda activate analytics_env
    INPUT_FILE={}
    OUTPUT_FILE=$(echo {} | sed "s/\.sdf/_tstrain.csv/")
    python ~/scripts/strain/refactor_Torsion_Strain.py -i "$INPUT_FILE" -o "$OUTPUT_FILE"
    conda deactivate
'
