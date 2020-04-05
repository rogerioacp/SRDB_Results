#!/usr/bin/env bash

#Confidence interval
CONF=0.95
#Accuracy
ACC=5
#Expected number of runs
NRUNS=5

genDiskFiles(){
    local target=$1
    local system=$2

    for file in $target ; do
        local run=$(echo $file | awk 'BEGIN{FS="_"}{print $5}')
        tail -n +6 $file | awk -f storage.awk > disk_${run}.tmp
    done
    awk -f aggstorage.awk disk_*.tmp
    ./confbounds.py reads.dat $CONF $ACC $NRUNS > data/${system}_reads.dat
    ./confbounds.py writes.dat $CONF $ACC $NRUNS > data/${system}_writes.dat

    rm disk_*.tmp
    rm reads.dat
    rm writes.dat
}

genDiskFiles "dstat/dforestoram_z4_divoram/OIS_65536*" forest 
genDiskFiles "dstat/dtpathoram_z4_singleoram/BASELINE_65536*" pathoram





