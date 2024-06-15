#!/bin/bash

# Get the current working directory
base_dir=$(pwd)

# Function to enumerate stereoisomers
enumerate_stereoisomers() {
    smifile=$1
    outdir=$(dirname "$smifile")
    outfile="$outdir/enum_$(basename "$smifile")"
    
    # Run the RDKitEnumerateStereoisomers command
    $MCT/RDKitEnumerateStereoisomers.py -d yes -m UnassignedOnly --overwrite -i "$smifile" -o "$outfile"
}

export -f enumerate_stereoisomers
export MCT

# Find all .smi files and enumerate stereoisomers in parallel with a limit of 10 jobs at a time
find "$base_dir" -type f -name "*.smi" | parallel -j enumerate_stereoisomers {}
