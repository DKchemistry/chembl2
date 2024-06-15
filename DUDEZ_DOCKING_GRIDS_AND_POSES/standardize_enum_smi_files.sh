#!/bin/bash

# Get the current working directory
base_dir=$(pwd)

# Function to standardize molecules
standardize_molecules() {
    smifile=$1
    outdir=$(dirname "$smifile")
    outfile="$outdir/$(basename "$smifile" | sed 's/enum/std/')"
    
    # Run the RDKitStandardizeMolecules command
    $MCT/RDKitStandardizeMolecules.py --overwrite -i "$smifile" -o "$outfile"
}

export -f standardize_molecules
export MCT

# Find all enum*.smi files and standardize them in parallel   
find "$base_dir" -type f -name "enum*.smi" | parallel standardize_molecules {}
