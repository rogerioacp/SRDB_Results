#!/usr/bin/env bash

OUTPUT_DIR=percentiles

#Confidence interval
CONF=0.95
#Accuracy
ACC=5
#Expected number of runs
NRUNS=5


genPercentiles(){
	local inputf=$1
	for file in ycsb/$inputf ; do
		local dest=$(echo $file | awk 'BEGIN{FS="/"}{print $3}')
		#remove file suffix
		local dlength=${#dest}-8
		local system=$(echo $dest | awk 'BEGIN{FS="_"}{print $1}')
		local output=$OUTPUT_DIR/${dest:0:$dlength}
		echo "Processing $dest to $output"
		
		HistogramLogProcessor -csv -start 0 -outputValueUnitRatio 1 -i $file -o $output.tmp
		tail -n +4 $output.tmp | awk 'BEGIN{FS=",";OFS=" "}{print $1, $9}' > $output.dat
		rm $output.tmp $output.tmp.hgrm

	done
	echo "system is $system"
	awk -f latstats.awk $OUTPUT_DIR/$system* 
	./confbounds.py percentiles.dat $CONF $ACC $NRUNS > data/"${system}_percentiles".dat
	rm percentiles.dat
}

genPercentiles dtforestoram_z4_divoram/OIS_65536_*.hdr
genPercentiles dtpathoram_z4_singleoram/BASELINE_65536_*.hdr

gnuplot latpercentile.gp



