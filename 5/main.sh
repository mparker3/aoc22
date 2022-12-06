#!/usr/bin/env bash
set -eo pipefail

# read initial state into boardstate
boardstate=()
instructions=()
board_state_loaded=""
# this is a loadbearing -r
while IFS= read -r line; do
	if [ ! -z "$line" ]; then
		if [ ! -z $board_state_loaded ]; then
			instructions+=("$line")
		else
			boardstate+=("$line")
		fi
	else
		# this shouldn't be how you handle conditionals, but something was broken and I didn't want to figure out what
		board_state_loaded="a"
	fi
done < input.txt

nums=${boardstate[${#boardstate[@]}-1]}
# go across the line and check for generic
for (( i=0; i<${#nums}; i++ )); do
	maybe_idx="${nums:$i:1}"
	# go down the column and assemble the stack
	if [[ "$maybe_idx" = *[0-9]* ]]; then
		stack=""
		for line in "${boardstate[@]::${#boardstate[@]}-1}"; do
			curr="${line:$i:1}"
			if [ "$curr" != " " ]; then
				stack+=$curr
			fi
		done
		stacks+=("$stack")
	fi
done

for instr in "${instructions[@]}"; do
	read -a values <<< $(echo "$instr")
	cnt=(${values[1]})
	# something about `cut`?
	plusone=$(( $cnt + 1))
	src=$(( ${values[3]} - 1))
	dest=$(( ${values[5]} - 1))

	rev_part=$(echo -e "${stacks[$src]}" | head -c ${cnt} | rev)

	stacks[$dest]="$rev_part""${stacks[$dest]}"
	stacks[$src]="$(echo ${stacks[$src]} | cut -c ${plusone}-)"
done
echo "${stacks[@]}"
