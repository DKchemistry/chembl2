#!/bin/bash

# List of directories
directories=(
    "AA2AR" "ABL1" "ACES" "ADA" "ADRB2" "AMPC" "ANDR" "CSF1R" "CXCR4" "DEF"
    "DRD4" "EGFR" "FA10" "FA7" "FABP4" "FGFR1" "FKB1A" "GLCM" "HDAC8" "HIVPR"
    "HMDH" "HS90A" "ITAL" "KIT" "KITH" "LCK" "MAPK2" "MK01" "MT1" "NRAM"
    "PARP1" "PLK1" "PPARA" "PTN1" "PUR2" "RENI" "ROCK1" "SRC" "THRB" "TRY1"
    "TRYB1" "UROK" "XIAP"
)

for directory in "${directories[@]}"; do
    # Change to the target directory
    cd "$directory" || { echo "Failed to change to directory $directory"; exit 1; }

    # Run generate_glide_grids with the specified arguments
    $SCHRODINGER/utilities/generate_glide_grids \
        -rec_file "prepared_complex.maegz" \
        -lig_asl "chain.name M" \
        -j "$directory" \
        -HOST localhost:1

    echo "Grid generation completed for ${directory}"

    # Return to the original directory
    cd - > /dev/null
done
