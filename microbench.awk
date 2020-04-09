#!/bin/awk -f

BEGIN {
	FS = " "
	OFS = ","
	#Stores all of the operations average latencies
	#The array keys have the following syntax: OP,size,run
	latencies[""] = 0
	maxrun = 0;
}
{
	sys = $1
	size = $2
	run = $5
	latency = $6

	key = sys","size","run
	latencies[key] = latency

	systems[sys] = 1
	sizes[size]  = 1
	if(run > maxrun){
		maxrun = run
	}
}
END{
	for(sys in systems){
		filename = sys".dat"
		for(size in sizes){
			printf "%6d", size >> filename
			for(i = 0; i < maxrun; i++){
					key = sys","size","i
					printf "\t %6.2f", latencies[key] >> filename
			}
			printf "\n" >> filename
		}
	}
}