#!/usr/bin/env bash
set -eo pipefail


CMD=' 
BEGIN { ctr=0; parent="root"; curr="root"}
{
  if ($1 == "$") {
    if ($2 == "cd") {
      if ($3 == "..") {
	curr=parent
	parent=parents[parent]
      } else {
        parent=curr
	curr=(curr "/" $3)
	parents[curr]=parent
      }
    }
  } else {
    parent_in_tree=curr
    while (parent_in_tree != "root") {
      sums[parent_in_tree]+=$1
      parent_in_tree=parents[parent_in_tree]
    }
  }
}
END { for (i in sums) print sums[i] } '

# some preprocessing required here, POSIX standard specifies a newline at the end of a file, so running this _without_ adding that newline causes the last line to be left out. TODO(mparker): fix this
while read line; do
	echo -e $line
done < input.txt | awk "$CMD" | awk '{ if ($1 <= 100000) { sum+=$1 } } END { print sum }'
