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

sorted_sizes=$(mktemp /tmp/aoc-7.txt)

# set a read and write FD we can use to read and write from the tempfile, but immediately delete the directory entry.
# When we close the FD at the end of the script, this will dealloc the memory actually allocated to the file. 
# https://unix.stackexchange.com/questions/181937/how-create-a-temporary-file-in-shell-script
exec 3>"$sorted_sizes"
exec 4<"$sorted_sizes"
rm "$sorted_sizes"

while read -r line; do
	echo -e "$line"
done < input.txt | awk "$CMD" | sort --reverse --numeric-sort >&3
fs_disk=70000000
need=30000000
used=$(head -n 1 <&4)

tail -n +2 <&4 | awk -v used="$used" -v need="$need" -v fs_disk="$fs_disk" '{ if ( (fs_disk - used + $1) >= need ) print $1 }' | tail -n 1

#remove sorted_sizes fd
exec 3>&-
