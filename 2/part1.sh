#!/usr/bin/env bash
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
	# give points for the necessary outcome
	((score+=$(echo $line | awk '{ points["X"]=0; points["Y"]=3; points["Z"]=6; score+=points[$2]; print score }')))
	
	case $(echo $line | awk '{ print $1 }') in
	"A")
		# give points for what must be played
		((score+=$(echo $line | awk '{ points["X"]=3; points["Y"]=1; points["Z"]=2; score+=points[$2]; print score }')))
		;;
	"B")
		# give points for what must be played
		((score+=$(echo $line | awk '{ points["X"]=1; points["Y"]=2; points["Z"]=3; score+=points[$2]; print score }')))
		;;
	"C")
		# give points for what must be played
		((score+=$(echo $line | awk '{ points["X"]=2; points["Y"]=3; points["Z"]=1; score+=points[$2]; print score }')))
		;;
	esac	
	echo $score
	((lineno+=1))
done <"$inputfile" | awk '{s+=$1} END {print s}'
