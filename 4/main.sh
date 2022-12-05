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


	# find pairs where one partially contains the other - if ordered and a partial contain exists, the sort of the listed pairs will be different from the listed pairs
	order="$first_beginning\n$first_end\n$second_beginning\n$second_end"
	check=$((echo -e $order | sort --numeric-sort | diff -q <(echo -e $order)  -) || true )
	diff_chars=( ${#check} - 1 )

	# also count it if the middle two are the same, if they are, that is an overlap not caught by the above
	if [ $diff_chars -ne 0 ] || [ $first_end -eq $second_beginning ] ; then
		((overlaps+=1))
	fi
done < input.txt

echo $overlaps
