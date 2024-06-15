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
    # Get the absolute path of the current directory
    abs_directory=$(readlink -f "$directory")
    # Paths to input and output files
    complex_pdb="${abs_directory}/complex.pdb"
    prepared_mae="${abs_directory}/prepared_complex.maegz"

    # Run prepwizard
    $SCHRODINGER/utilities/prepwizard "$complex_pdb" "$prepared_mae" \
        -fillsidechains -disulfides -assign_all_residues -rehtreat \
        -max_states 1 -epik_pH 7.4 -epik_pHt 2.0 -antibody_cdr_scheme Kabat \
        -samplewater -propka_pH 7.4 -f S-OPLS -rmsd 0.3 -watdist 5.0 \
        -JOBNAME "$directory" -HOST localhost:3

    echo "Preparation completed for ${directory}"
done
