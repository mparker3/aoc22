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

	# order the pairs. 
	if [ $first_beginning -gt $second_beginning ]; then
		swapvar=$second_beginning
		second_beginning=$first_beginning
		first_beginning=$swapvar

		swapvar=$second_end
		second_end=$first_end
		first_end=$swapvar
	fi

	
	# count it and short-circuit if the ending of the first pair is equal to the beginning of the second since that's an overlap but a diff vs sorted order will pick that up
	if [ $first_end -eq $second_beginning ]; then
		(( overlaps+=1 ))
		continue
	fi

	# find pairs where one fully contains the other - a fully contained pair will have the same sorted order as unsorted when written as a1,b1,a2,b2
	order="$first_beginning\n$first_end\n$second_beginning\n$second_end"
	check=$((echo -e $order | sort --numeric-sort | diff -q <(echo -e $order)  -) || true )
	diff_chars=( ${#check} - 1 )

	if [ $diff_chars -ne 0 ]; then
		((overlaps+=1))
	fi
done < input.txt

echo $overlaps
