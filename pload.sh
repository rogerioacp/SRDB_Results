#!/usr/bin/env bash

 
max=$(cat ycsb/nohup.out | grep "real" | wc -l)
echo $max
for ((index=0; index < $max; index+=5))
do
res=$(cat ycsb/nohup.out | grep "real" | tail -n +$index | head -n 5)
echo $res
done