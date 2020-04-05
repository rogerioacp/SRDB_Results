BEGIN{
	OFS = ""
	FS = ","
	seconds = 0
}
{
	read[seconds] = ($7*0.001)
	write[seconds] = ($8*0.001)
	seconds +=1
}
END{

	for(i = 0; i < seconds; i++){
		readacc = readacc + read[i]
		writeacc = writeacc + write[i]
		if(i%10==0){ 
			printf "%4d %8d %8d\n", i, readacc/10, writeacc/10
			readacc=0
			writeacc=0
		}
	}
}