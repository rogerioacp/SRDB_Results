#!/usr/bin/env bash

#Confidence interval
CONF=0.95
#Accuracy
ACC=5
#Expected number of runs
NRUNS=5
#INPUTF="microbench/results"
INPUTF="microbench/ndresults"
#OUTPUTF="data/microbenchmarks.dat"
OUTPUTF="data/micrbenchud.dat"

awk -f microbench.awk $INPUTF/stats.csv

for file in *.dat ; do
    flength=${#file}-4
    name=${file:0:$flength}

    ./confbounds.py $file $CONF $ACC $NRUNS | sort -k 1 -g > micro_${name}.dat

    rm $file
done

#cat micro_randomreadbenchfd.dat | tail -n +2 | awk '{print $1,$2,$3,$4}' > read_forest.tmp
#cat micro_randomreadbenchd.dat | tail -n +2| awk '{print $2,$3,$4}' > read_pathoram.tmp


cat micro_randomwritebenchfd.dat | tail -n +2 | awk '{print $1,$2,$3,$4}' > write_forest.tmp
cat micro_randomwritebenchd.dat | tail -n +2| awk '{print $2,$3,$4}' > write_pathoram.tmp

#reads=$(paste -d ' ' read_forest.tmp read_pathoram.tmp)
writes=$(paste -d ' ' write_forest.tmp write_pathoram.tmp)

echo "# size forestoram lowbound highbound PathORAM lowbound highbound" > $OUTPUTF
#echo "$reads"  >> $OUTPUTF
echo "$writes" >> $OUTPUTF
rm *.tmp
rm *.dat

gnuplot microplot.gp