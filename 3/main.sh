#!/usr/bin/env bash
set -eo pipefail

while read -r line; do
	# split lines into first and second halves
	first=$(echo $line | awk '{ half = length($1)/2; print substr($1, 0, half)}')
	second=$(echo $line | awk '{ half = length($1)/2; print substr($1, half + 1)}')
	
	# `fold` each half into a newline-delimited file, sort them for use with comm, find the common characters, and then cut to only the first incidence of each character
	char=$(echo $(comm -12 <(echo $first | fold -w1 | sort) <(echo $second | fold -w1 | sort)) | cut -c1)
	# convert the char to its ASCII value
	value=$(printf '%d' "'$char")
	# convert the ascii value to its priority
	if [[ "$char" =~ [A-Z] ]]; then
		prio=$((value - 38))
	else
		prio=$((value - 96))
	fi

	echo $prio
done < input.txt | awk '{ sum+=$1 ; print sum } END { print sum }'
