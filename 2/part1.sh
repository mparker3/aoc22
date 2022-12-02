#!/bin/bash
#
set -eo pipefail


inputfile=$1
if [[ ! -f $inputfile ]]; then
	echo "need valid input file"
fi;

points=0
lineno=0
while read line;
do
	score=0
	# give points for what gets played
	((score+=$(echo $line | awk '{ points["X"]=1; points["Y"]=2; points["Z"]=3; score+=points[$2]; print score }')))
	
	# give points for a tie
	((score+=$(echo $line | awk '{ transforms["X"]="A"; transforms["Y"]="B"; transforms["Z"]="C"; ($1 == transforms[$2]) ? score=3 : score=0; print score }')))

	# give points for a win
	((score+=$(echo $line | awk '{ transforms["Y"]="A"; transforms["Z"]="B"; transforms["X"]="C"; ($1 == transforms[$2]) ? score=6 : score=0; print score }')))
	echo $score
done <"$inputfile" | awk '{s+=$1} END {print s}'
