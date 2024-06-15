#!/bin/bash

# Get the current working directory
base_dir=$(pwd)

# Function to run ligprep on each std*.smi file
run_ligprep() {
    smifile=$1
    outdir=$(dirname "$smifile")
    outfile="${smifile%.smi}.sdf"

    # Run the Schrodinger ligprep command
    $SCHRODINGER/ligprep -NJOBS 1 -HOST localhost:1 -g -s 1 -i 2 -W i,-ph,7.4,-pht,0.0 -t 1 -ismi "$smifile" -osd "$outfile"
}

# Export the function and SCHRODINGER variable
export -f run_ligprep
export SCHRODINGER

# Find all std*.smi files and run ligprep on each
find "$base_dir" -type f -name "std*.smi" -exec bash -c 'run_ligprep "$0"' {} \;
