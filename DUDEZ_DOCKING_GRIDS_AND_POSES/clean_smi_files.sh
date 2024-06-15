#!/bin/bash

# Base directory
base_dir="/Users/lkv206/work/to_do_projects/chembl_ligands/DUDEZ_DOCKING_GRIDS_AND_POSES"

# Function to clean .smi files
clean_files() {
    smifile=$1

    # Remove the "none" and trailing whitespace from the second field in the .smi file
    awk '{$NF=""; sub(/[ \t]+$/, ""); print}' "$smifile" > "${smifile}.tmp" && mv "${smifile}.tmp" "$smifile"
}

# Export the function to use with find
export -f clean_files

# Find all .smi files and clean them
find "$base_dir" -type f -name "*.smi" -exec bash -c 'clean_files "$0"' {} \;
