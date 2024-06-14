#!/bin/bash

# Base directory
base_dir="/Users/lkv206/work/to_do_projects/chembl_ligands/DUDEZ_DOCKING_GRIDS_AND_POSES"

# Function to convert files
convert_files() {
    inputfile=$1
    outputfile=${inputfile%.mol2}.smi

    # Run the structconvert command
    $SCHRODINGER/utilities/structconvert "$inputfile" "$outputfile"
}

export -f convert_files
export SCHRODINGER

# Find all .mol2 files and convert them in parallel with a limit of 10 jobs at a time
find "$base_dir" -type f -name "*.mol2" | parallel -j 10 convert_files {}
