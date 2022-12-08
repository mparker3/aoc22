#!/usr/bin/env bash
set -eo pipefail

visible_coords=$(mktemp /tmp/aoc-8.txt)
exec 3>"$visible_coords"
exec 4<"$visible_coords"
rm "$visible_coords"

horiz_parse=' {
  split($0, chars, "")
  max_from_left = -1
  max_from_right = -1
  for (i=1; i <= length($0); i++) {
    if (chars[i] > max_from_left) {
      max_from_left = chars[i]
      printf("%d, %d\n", NR, i)
    }
    if (chars[length($0) - (i - 1)] > max_from_right) {
      max_from_right = chars[length($0) - (i - 1)]
      printf("%d, %d\n", NR, length($0) - (i - 1))
    }
  }
}'

cat input.txt | awk "$horiz_parse" >&3

# originally tried to do this with `rs`, but gave up and stole this from from https://stackoverflow.com/questions/1729824/an-efficient-way-to-transpose-a-file-in-bash instead

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

vert_parse=' {
  split($0, chars, "")
  max_from_left = -1
  max_from_right = -1
  for (i=1; i <= length($0); i++) {
    if (chars[i] > max_from_left) {
      max_from_left = chars[i]
      printf("%d, %d\n", i, NR)
    }
    if (chars[length($0) - (i - 1)] > max_from_right) {
      max_from_right = chars[length($0) - (i - 1)]
      printf("%d, %d\n", length($0) - (i - 1), NR)
    }
  }
}'

cat input.txt | awk "$transpose" | awk "$vert_parse" >&3

sort <&4 | uniq | wc -l 
#
#remove visible_coords fd
exec 3>&-
#
