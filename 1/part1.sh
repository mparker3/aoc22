#!/bin/bash
#
set -eo pipefail

inputfile=$1
if [[ ! -f $inputfile ]]; then
	echo "need valid input file"
fi;

sums=()
curr_sum=0
while read line;
do
	if [[ -z $line ]];
	then
	  sums+=($curr_sum)
	  curr_sum=0
	else
	  ((curr_sum+=$line))
	fi
done <"$inputfile"
# add whatever the last element is, because there won't be a final newln
sums+=($curr_sum)
printf "%d\n" "${sums[@]}" | sort | tail -n 3 | awk '{s+=$1} END {print s}'


