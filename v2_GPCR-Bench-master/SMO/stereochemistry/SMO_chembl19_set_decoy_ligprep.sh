#!/bin/bash

$SCHRODINGER/ligprep -inp ligprep_noepik.inp -NJOBS 5 -JOBNAME SMO_chembl19_set_decoy_ligprep -HOST localhost:5 -ismi SMO_chembl19_set_decoy_sc.smi -osd SMO_chembl19_set_decoy.sdf
