#!/bin/bash

$SCHRODINGER/ligprep -inp ligprep_noepik.inp -NJOBS 1 -JOBNAME MGLUR1_chembl19_set_active_ligprep -HOST localhost:1 -ismi MGLUR1_chembl19_set_active_sc.smi -osd MGLUR1_chembl19_set_active.sdf
