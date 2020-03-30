#!/bin/awk -f

BEGIN {
	OFS = ","
	# Flags that are set to true if the input files match a SCAN or READ op.
	scan_match = 0
	read_match = 0
	#Stores all of the operations average latencies
	#The array keys have the following syntax: OP,size,run
	latencies[""] = 0
	#Stores the global throughput of a run
	#the array keys have the following syntax: size,run
	throughputs[""] = 0
}
$2 ~ /Throughput/ {
	nparts = split(FILENAME, nameb, "_")

	if(nparts < 0 || nparts > 6){
		printf "Input files name does not have recommended syntax."
		exit 1
	}
	size = nameb[4]
	run = nameb[5]

	runs[run] = 1
	sizes[size] = 1

	key = size","run
	throughputs[key] = $3
}
$1 ~ /READ/ && $2 ~ /AverageLatency/ {
	nparts = split(FILENAME, nameb, "_")

	if(nparts < 0 || nparts > 6){
		printf "Input files name does not have recommended syntax."
		exit 1
	}

	size = nameb[4]
	run = nameb[5]

	key = "READ,"size","run
	latencies[key] = $3*0.001
	read_match = 1
}
$1 ~ /SCAN/ && $2 ~ /AverageLatency/ {
	nparts = split(FILENAME, nameb, "_")

	if(nparts < 0 || nparts > 6){
		printf "Input files name does not have recommended syntax."
		exit 1
	}

	size = nameb[4]
	run = nameb[5]

	key = "SCAN,"size","run
	latencies[key] = $3*0.001
	scan_match = 1
}
END{
	if (length(sizes)  == 0 ){
		print "Test if input file matches an YCSB output", FILENAME
		exit 1
	}

	presults("", throughputs, "throughputs.dat")

	if(read_match){
		presults("READ", latencies, "read_latencies.dat")
	}

	if(scan_match){
		presults("SCAN", latencies, "scan_latencies.dat")
	}
}
# function to print results in the end after processing the input files
function presults(operation, metric, filename){
	# Output READ average latency
	for(i in sizes){
		printf "%5d", i >> filename
		for(run in runs){
				key = i","run
				# This is true in case of INSERT, READ, SCAN, DELETE
				# These result of these operations are all stored 
				# in the same latencies array.
				if(length(operation) > 0){
					key = operation","key
				}
				printf "\t%6.2f", metric[key] >> filename
		}
		printf "\n" >> filename
	}
}