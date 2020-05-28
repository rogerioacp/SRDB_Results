#!/usr/bin/env bash
#set -x
#Confidence interval
CONF=0.95
#Accuracy
ACC=5
#Expected number of runs
NRUNS=5
SF=10
OUTPUT="data/oltp.dat"

#The folders must follow the syntax benchmark_system_sf

genConfBound(){
	local results=$1
	local output=$2
	printf "%d" $SF  > results.tmp
	for result in $results/*.summary; do
		thr=$(cat $result | jq --raw-output  '."Throughput (requests/second)"')
		printf "\t%4.2f" $thr >> results.tmp
	done
	./confbounds.py results.tmp $CONF $ACC $NRUNS > $output
	cat $output
	rm results.tmp
}

#values must be sorted before uniq
benchmarks=$(ls oltpbench| awk 'BEGIN{FS="_"}{print $1}'| sort | uniq)
systems=$(ls oltpbench | awk 'BEGIN{FS="_"}{print $2}'| sort | uniq)

# print result header
printf "# Workloads" > $OUTPUT 
for system in ${systems[@]};
do
	printf " %s Min Max" $system >> $OUTPUT 
done

for benchmark in ${benchmarks[@]};
do

	printf "\n%s " $benchmark >> $OUTPUT
	for system in ${systems[@]};
	do
		results=oltpbench/"${benchmark}_${system}"
		output=oltpbench/"${benchmark}_${system}.tmp"
		genConfBound $results $output
		bounds=$(cat $output | tail -n +2 | awk 'BEGIN{FS=" ";OFS=" "}{print $2, $3, $4}')
		rm $output
		printf "%s " $bounds >> $OUTPUT
	done
done
