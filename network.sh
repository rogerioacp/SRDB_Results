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
        tail -n +6 $file | awk -f network.awk > network_${run}.tmp
    done
    awk -f aggstorage.awk network_*.tmp
    ./confbounds.py reads.dat $CONF $ACC $NRUNS > ${system}_reads.dat #data/${system}_reads.dat
    ./confbounds.py writes.dat $CONF $ACC $NRUNS > ${system}_writes.dat #data/${system}_writes.dat

    rm network_*.tmp
    rm reads.dat
    rm writes.dat
}

genDiskFiles "dstat/dforestoram_z4_divoram/OIS_65536_*" forest1
genDiskFiles "dstat/dtforestoram_z4_scan/OIS_10*" forest10 
genDiskFiles "dstat/dtforestoram_z4_scan/OIS_40*" forest40

genDiskFiles "dstat/dtpathoram_z4_singleoram/BASELINE_65536*" path10
#genDiskFiles "dstat/dtpathoram_z4_soramscan/BASELINE_40*" path40
#genDiskFiles "dstat/dtpathoram_z4_singleoramscan/BASELINE_40*" path40

#genDiskFiles "dstatcheck/dforestoram_z4_divoram/OIS_65536*" forest 
#genDiskFiles "dstatcheck/dtpathoram_z4_singleoram/BASELINE_65536*" pathoram





