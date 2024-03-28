#!/bin/bash

$SCHRODINGER/ligprep -inp ligprep_noepik.inp -NJOBS 5 -JOBNAME ACM2_chembl19_set_decoy_ligprep -HOST localhost:5 -ismi ACM2_chembl19_set_decoy_sc.smi -osd ACM2_chembl19_set_decoy.sdf
