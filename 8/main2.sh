#!/usr/bin/env bash
set -eo pipefail
transpose='
{
    split($0, chars, "")
    for (i=1; i<=length($0); i++)  {
        a[NR,i] = chars[i]
    }
}
length($0)>p { p = length($0) }
END {    
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=length($0); i++){
            str=str""a[i,j];
        }
        print str
    }
}'


rev_words='{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }'
parse_right=' 
{
    split($0, chars, "")
    vizs=""
    for (i=1; i<length($0); i++)  {
        j=i + 1
        while (j < length($0) && chars[i] > chars[j]) {
            j++
        }
        viz=j-i
        if (i==1) {vizs=viz} else {vizs=vizs " " viz}
    }
    vizs=vizs " " "0"
    print vizs
}'

mult='
BEGIN {
    split(right, rights, " ")
    split(left, lefts, " ")
    split(down, downs, " ")
    split(up, ups, " ")

    prods=""
    for (i=1; i<=length(rights); i++) {
        prod=ups[i] * downs[i] * lefts[i] * rights[i]
        printf("%d\n", prod)
    }
}'

rights=$(cat input.txt | awk "$parse_right")
lefts=$(cat input.txt | rev | awk "$parse_right" | awk "$rev_words")
downs=$(cat input.txt | awk "$transpose" | awk "$parse_right" | rs -T -c' ' -C' ')
ups=$(cat input.txt | awk "$transpose" | rev | awk "$parse_right" | awk "$rev_words" | rs -T -c' ' -C' ')
while read -u 3 -r right && read -u 4 -r left && read -u 5 -r down && read -u 6 -r up; do
    awk -v right="$right" -v up="$up" -v left="$left" -v down="$down" "$mult" 
done 3< <(echo -e "$rights") 4< <(echo -e "$lefts") 5< <(echo -e "$downs") 6< <(echo -e "$ups") | sort -r --numeric-sort | head -n 1
