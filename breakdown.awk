#!/bin/awk -f

BEGIN {
	OFS = ","
	# Flags that are set to true if the input files match a SCAN or READ op.
	results[""] = 0
	nresults[""] = 0
}
# function to print results in the end after processing the input files
function cumavergage(key, value){
	if(length(nresults[key])==0){
		nresults[key] = 0
		results[key] = 0
	}
	nres = nresults[key]
	results[key] = ((results[key]*nres) + value)/(nres+1)
	nresults[key] = nresults[key] + 1
	if(results[key] < 0){
		print "overflow", key
		exit 1
	
	}
}
$6 ~ /OFILE_WRITE/ || $6 ~ /OFILE_READ/ || $6 ~ /STASH/{
	op = $6
	file = $7
	value = $8
	key = file","op

	if(value > 0){
		cumavergage(key, $8)
		files[file] = 1
		ops[op]=1
	}

}
$6 ~/PRF/{
	op = $6
	value = $7
	key = op

	if(value > 0){
		cumavergage(key, $7)
		files[file] = 1
		ops[op]=1
	}


}
END{
	total = results["PRF"]
	#Calculate the total time relevant for the breakdown
	for(file in files){
		stash = 0
		ofile = 0
		if(length(file)==0){
			continue
		}
		for(op in ops){
			result = file","op
			if(op ~ /STASH/){
				stash = stash + results[result]
			}
			if(op ~ /OFILE_WRITE/ || op ~ /OFILE_READ/){
				ofile = ofile + results[result]
			}
		}
		fres[file",""stash"] = stash
		fres[file",""ofile"] = ofile
		total = total + stash + ofile
	}
	# calculate the percentage of each operation for each file
	for(res in fres){
		nparts = split(res, auxs, ",")
		file = auxs[1]
		op = auxs[2]
		value = fres[res]
		printf "%-30s %10s %2.3f%%\n", file, op, (value/total)*100

	}
	printf "PRF %2.3f%%\n", (results["PRF"]/total)*100


}