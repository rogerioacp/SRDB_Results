#!/usr/bin/env python

"""
Python Script to calculate the confidence interval of an input file generated
by stats.awk

The algorithms used to calculate the confidence interval follows the description of the book The art of computer systems performance analysis by Raj Jain. For more information and a detailed description just follow the book. It's a good read.

"""
import argparse
import csv
import numpy as np
from math import sqrt
from scipy.stats import t, norm

#Output Messages format
RESULT_FORMAT = "{:5d} {:6.2f} {:6.2f} {:6.2f}"

#ERROR Messages
MSG_ERROR_MORE_RUNS = "WARNING! More run are needed to calculate a {:f} confidence interval of with {:d} accuracy.\nA total of {:d} runs were executed but the ideal size is {:f}."
DIFF_RUNS = "Number of expected runs is different from number of runs in file."

def sample_size(mean, std, z, r):
	return 2**((100*z*std)/(r*mean))

"""
Calculates the confidence intervals from the student's t distribution.
"""
def cdfi(values, mean, std, nruns, t):
	lower = mean - (t*std/sqrt(nruns))
	upper = mean + (t*std/sqrt(nruns))
	return (lower, upper)

def main():
	parser = argparse.ArgumentParser(description='Python script to calculate the confidence interval of several independent YCSB runs. Input file provided should be generated by stats.awk or follow the same format. The algorithms used to calculate the confidence interval follows the description of the book The art of computer systems performance analysis by Raj Jain.')
	parser.add_argument('file', metavar='file',  nargs=1,
                   help='Input file to calculate bounds')
	parser.add_argument('confidence', metavar="confidence", type=float, nargs=1,
					help="Confidence interval (e.g.: 0.95) interval")
	parser.add_argument('accuracy', metavar="accuracy", type=int, nargs=1,
					help="Tightness of the confidence interval (parameter r)")
	parser.add_argument('runs', metavar="runs", type=int, nargs=1,
					help="number of expected runs in file")

	args = parser.parse_args()

	filepath = args.file[0]
	confidence = args.confidence[0]

	"""
	Parameter R
	How many standard deviations different from the mean. 
	In this case its more or less 5 ops/sec than the mean.

	This parameter is essential to calculate how many samples have to be observed to have a confidence interval where the standard deviation is more
	or less than 5 op/sec from the mean with an accuracy of r/mean %.
	"""
	accuracy = args.accuracy[0]

	runs = args.runs[0]

	"""
	Quantile of the significance level of a t-variate with n-1 degrees of freedom from the student's t distribution

	"""
	T = t.ppf(confidence, runs-1)

	"""
	Value of the inverse standard normal distribution function for a specified value.
	"""
	Z = norm.ppf(1 - ((1-confidence)/2))

	print "# {:5s} {:6s} {:6s} {:6s}".format("NRows", "Mean", "Lower", "Upper")
	ideal_sample_size = 0
	nruns = 0;
	with open(filepath) as fp:
		csv_reader = csv.reader(fp, delimiter='\t')
		for row in csv_reader:
			nrecords = int(row[0])
			#convert strings to float
			values = list(map(float,row[1:]))
			avg = np.average(values)
			std =  np.std(values)
			ssize = sample_size(avg, std, Z, accuracy)
			ideal_sample_size = max(ssize, ideal_sample_size)
			nruns = len(values)
			if( runs != nruns):
				print DIFF_RUNS
			(lower_bound, upper_bound) = cdfi(values, avg, std, runs, T)
			print RESULT_FORMAT.format(nrecords, avg, lower_bound, upper_bound)

	if(nruns < ideal_sample_size):
		print MSG_ERROR_MORE_RUNS.format(confidence, accuracy, runs, ideal_sample_size)


if __name__ == '__main__':
    main()

