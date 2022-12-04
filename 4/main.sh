#!/usr/bin/env bash
set -eo pipefail

overlaps=0
while read -r line; do
	first=$(echo $line | awk -F ',' '{ print $1 }')
	second=$(echo $line | awk -F ',' '{ print $2 }')
	
	first_beginning=$(echo $first | awk -F '-' '{ print $1 }')
	first_end=$(echo $first | awk -F '-' '{ print $2 }')
	
	second_beginning=$(echo $second | awk -F '-' '{ print $1 }')
	second_end=$(echo $second | awk -F '-' '{ print $2 }')

	# find pairs where one fully contains the other - a fully contained pair will have the same sorted order as unsorted when written as a1,b1,a2,b2
	order="$first_beginning\n$second_beginning\n$second_end\n$first_end"
	first_check=$((echo -e $order | sort --numeric-sort | diff -q <(echo -e $order)  -) || true )
	
	# find pairs where one fully contains the other - a fully contained pair will have the same sorted order as unsorted when written as a1,b1,b2,a2
	order="$second_beginning\n$first_beginning\n$first_end\n$second_end"
	second_check=$((echo -e $order | sort --numeric-sort | diff -q <(echo -e $order)  -) || true )

	first_diff_chars=( ${#first_check} - 1 )
	second_diff_chars=( ${#second_check} - 1 )

	if [ $first_diff_chars -eq 0 ] || [ $second_diff_chars -eq 0 ]; then
		((overlaps+=1))
	else
	fi
done < input.txt

echo $overlaps
