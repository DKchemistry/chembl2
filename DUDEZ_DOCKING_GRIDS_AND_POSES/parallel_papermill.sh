#!/bin/bash

# Clear old output
rm -rf ./papermill/*_torsion_notebooks
rm -f ./papermill/torsion_csv/*
rm -f ./merged_data/*

# Run all processors using papermill in parallel
papermill dudez_0pt5LD_torsion_runner.ipynb - &
papermill dudez_1pt0LD_torsion_runner.ipynb - &
papermill extrema_0pt5LD_torsion_runner.ipynb - &
papermill extrema_1pt0LD_torsion_runner.ipynb - &
papermill goldilocks_0pt5_torsion_runner.ipynb - &
papermill goldilocks_1pt0LD_torsion_runner.ipynb - &

# Wait for all background processes to finish
wait

# Run merge script
python merge_datasets.py

# Run validation
python validate_merger.py

echo "Run python merged_data/analyze_torsion_data.py in an interactive window to see data"

# Run this code in an interactive window to see data, its still a WIP 
# So I don't want to force it to run
#python merged_data/analyze_torsion_data.py