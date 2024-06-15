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
    
    # Run prepwizard with corrected arguments using relative paths
    $SCHRODINGER/utilities/prepwizard "complex.pdb" "prepared_complex.maegz" \
        -disulfides -rehtreat \
        -ms 1 -epik_pH 7.4 -epik_pHt 2.0 -s -propka_pH 7.4 -f 2005 -r 0.3 \
        -watdist 5.0 -j "$directory" -HOST localhost:3
    
    echo "Preparation completed for ${directory}"
    
    # Return to the original directory
    cd - > /dev/null
done