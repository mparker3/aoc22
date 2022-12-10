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
  tail_x=0
  tail_y=0
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
    head_x+=mov_x
    head_y+=mov_y
    delta_x=head_x-tail_x 
    delta_y=head_y-tail_y 

    if (tail_oob(delta_x, delta_y)) {
        tailmove_x=(delta_x==0) ? 0 : ((delta_x<0) ? -1 : 1)
        tailmove_y=(delta_y==0) ? 0 : ((delta_y<0) ? -1 : 1)
        tail_x+=tailmove_x
        tail_y+=tailmove_y
    }
    printf("%d, %d\n", tail_x, tail_y)
  }

}'

awk "$move" < input.txt | sort | uniq | wc -l
