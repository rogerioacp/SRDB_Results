#!/usr/bin/env bash



HistogramLogProcessor -start 0 -outputValueUnitRatio 1 -i ycsb/dtforestoram_z4_divoram/OIS_65536_1_run.dat.hdr -o data/histogram_ois

HistogramLogProcessor -start 0 -outputValueUnitRatio 1 -i ycsb/dtpathoram_z4_singleoram/BASELINE_65536_1_run.dat.hdr -o data/histogram_baseline


