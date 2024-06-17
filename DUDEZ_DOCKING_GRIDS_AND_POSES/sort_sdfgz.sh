#!/bin/bash

# Base directory
BASE_DIR=$(pwd)

# Find all .sdfgz files and process them
find "$BASE_DIR" -name "*.sdfgz" | parallel -j 150 --bar '
    INPUT_FILE={}
    OUTPUT_FILE=$(echo {} | sed "s/\.sdfgz/_sorted.sdf/")
    $SCHRODINGER/utilities/glide_sort -o "$OUTPUT_FILE" -use_dscore -best_by_title "$INPUT_FILE"
'
