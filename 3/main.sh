#!/usr/bin/env bash
set -eo pipefail

while read -r line1 && read -r line2 && read -r line3; do
	
	# `fold` both of the first two lines into a newline-delimited files sort them for use with comm and find the common characters between the first and second lines
	oneandtwo=$(echo $(comm -12 <(echo $line1 | fold -w1 | sort) <(echo $line2 | fold -w1 | sort)))

	char=$(echo $(comm -12 <(echo $oneandtwo | fold -w1 | sort) <(echo $line3 | fold -w1 | sort)))

	# convert the char to its ASCII value
	value=$(printf '%d' "'$char")
	# convert the ascii value to its priority
	if [[ "$char" =~ [A-Z] ]]; then
		prio=$((value - 38))
	else
		prio=$((value - 96))
	fi

	echo $prio
done < input.txt | awk '{ sum+=$1  } END { print sum }'
