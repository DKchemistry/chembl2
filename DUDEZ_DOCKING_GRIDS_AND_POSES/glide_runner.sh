#!/bin/bash

# List of directories
directories=(
    "AA2AR" "ABL1" "ACES" "ADA" "ADRB2" "AMPC" "ANDR" "CSF1R" "CXCR4" "DEF"
    "DRD4" "EGFR" "FA10" "FA7" "FABP4" "FGFR1" "FKB1A" "GLCM" "HDAC8" "HIVPR"
    "HMDH" "HS90A" "ITAL" "KIT" "KITH" "LCK" "MAPK2" "MK01" "MT1" "NRAM"
    "PARP1" "PLK1" "PPARA" "PTN1" "PUR2" "RENI" "ROCK1" "SRC" "THRB" "TRY1"
    "TRYB1" "UROK" "XIAP"
)

# Iterate over each directory
for directory in "${directories[@]}"; do
    # Change to the target directory
    cd "$directory" || { echo "Failed to change to directory $directory"; exit 1; }

    # Find all .in files in the directory
    for in_file in glide_*.in; do
        # Extract the basename of the input sdf file from the .in filename
        base_sdf=$(basename "$in_file" .in | sed 's/^glide_//')
        job_name="${directory}_${base_sdf}"

        # Run the Glide docking command
        $SCHRODINGER/glide -HOST localhost:1 -NJOBS 1 -OVERWRITE -JOBNAME "$job_name" "$in_file"

        echo "Docking completed for ${directory}/${in_file}"
    done

    # Return to the original directory
    cd - > /dev/null
done
