#!/bin/awk -f

BEGIN {
	OFS = ","
}
{
	if(length(cfile) == 0 || cfile != FILENAME){
		cfile = FILENAME
		maxcounter = counter
		counter = 0
	}
	
	nparts = split(FILENAME, nameb, "_")

	if(nparts < 0 || nparts > 6){
		printf "Input files name does not have recommended syntax."
		exit 1
	}
	run = nameb[3]
	latencies[run] = $2*0.001
	#print run, $1, $2
	percentile = $1

}
END{
	presults(latencies, "percentiles.dat")
}
# function to print results in the end after processing the input files
function presults(metric, filename){
	# Output READ average latency
	#print percentile
	printf "%d", length(latencies) >> filename
	for(run in latencies){
			printf "\t%6.2f", latencies[run] >> filename
	}
	printf "\n" >> filename

}