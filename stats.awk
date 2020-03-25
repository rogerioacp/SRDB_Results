#!/bin/awk -f

BEGIN {
	OFS = ","
	latencies[""] = 0
	throughputs[""] = 0
}
$2 ~ /Throughput/ {
	nparts = split(FILENAME, nameb, "_")
	if(nparts < 0 || nparts > 6){
		exit 1
		printf "Input files name does not have recommended syntax."
	}
	#add if condition to validate npars
	size = nameb[4]
	run = nameb[5]
	runs[run] = 1
	sizes[size] = 1
	key = size","run
	throughpts[key] = $3
}
$1 ~ /READ/ && $2 ~ /AverageLatency/ {
	nparts = split(FILENAME, nameb, "_")

	if(nparts < 0 || nparts > 6){
		exit 1
		printf "Input files name does not have recommended syntax."
	}
	#print FILENAME, $3
	#add if condition to validate npars
	size = nameb[4]
	run = nameb[5]
	key = size","run
	latencies[key] = $3

}
END{
	if (length(sizes)  == 0 ){
		print "Test if input file matches an YCSB output"
		exit 1
	}
	for(i in sizes){
		printf "%5d", i >> "throughputs.dat"
		for(run in runs){
				key = i","run
				printf "\t%6.2f", throughpts[key] >> "throughputs.dat"
		}
		printf "\n" >> "throughputs.dat"
	}

	for(i in sizes){
		printf "%5d", i >> "latencies.dat"
		for(run in runs){
				key = i","run
				printf "\t%6.2f", latencies[key] >> "latencies.dat"
		}
		printf "\n" >> "latencies.dat"
	}
}