#!/usr/bin/env bash
set -eo pipefail

move='

function abs(v) {if (v < 0) {return -1 * v} return v}

function tail_oob(delta_x, delta_y){
  return (abs(delta_x) > 1 || abs(delta_y) > 1)
}

BEGIN {
  head_x=0
  head_y=0
  len_rope=9
}

{
  dir=$1
  mag=$2
  if (dir=="U") {
    mov_x=0
    mov_y=1
  } else if (dir=="D") {
    mov_x=0
    mov_y=-1
  } else if (dir=="R") {
    mov_x=1
    mov_y=0
  } else {
    mov_x=-1
    mov_y=0
  }
  printf("%d, %d\n", tail_x, tail_y)
  for(i=0; i<mag; i++) {
    x_coords[0]+=mov_x
    y_coords[0]+=mov_y
    for (j=1; j<=len_rope; j++) {
      delta_x=x_coords[j-1]-x_coords[j]
      delta_y=y_coords[j-1]-y_coords[j]

      if (tail_oob(delta_x, delta_y)) {
        tailmove_x=(delta_x==0) ? 0 : ((delta_x<0) ? -1 : 1)
        tailmove_y=(delta_y==0) ? 0 : ((delta_y<0) ? -1 : 1)
        x_coords[j]+=tailmove_x
        y_coords[j]+=tailmove_y
      }
    }
    printf("%d, %d\n", x_coords[len_rope], y_coords[len_rope])
  }

}'

awk "$move" < input.txt | sort | uniq | wc -l
