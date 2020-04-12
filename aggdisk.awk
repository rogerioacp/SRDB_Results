BEGIN{
	OFS = " "
	FS = " "
	maxsec = 0;
}
{
	seconds = $1
	read = $2
	write = $3

	key=FILENAME","seconds
	reads[key] = $2
	writes[key] = $3

	if(seconds > maxsec){
		maxsec = seconds
	}
	files[FILENAME]=1
}
END{
	pop(reads, "reads.dat")
	pop(writes, "writes.dat")
}
function pop(array, filename){

	for(i = 10; i < maxsec; i+=10){
		printf "%4d ",i >> filename
		for(file in files){
			key = file","i 
			printf "\t%5d ", array[key] >> filename
		}
		printf "\n" >>filename
	}
}
