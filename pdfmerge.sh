#!/bin/bash

WAIT_TIMEOUT=300
ROTATE_ODD=0
ROTATE_EVEN=1
REVERSE_EVEN=1

INPUT="/input"
OUTPUT="/output"
ODD_PREFIX="odd"
EVEN_PREFIX="even"
ODD="merge_o.pdf"
EVEN="merge_e.pdf"
MERGED="merged.pdf"


function moveToOutput() {
  local file="$(date +%Y-%m-%d_%H-%M-%S)_$1"
  mv "$1" "$OUTPUT/$file" && \
  printf "done ($file)\n" || exit 1
}


cd "$INPUT"

[[ "$1" == "$ODD" || "$1" == "$EVEN"  ]] && exit

printf "got a file, wait for it to close: $1..."
inotifywait -q -t $WAIT_TIMEOUT -e close "$1" && echo " OK" || echo " TIMEOUT"
sleep 2
if [[ ! -f "$1" ]]; then
  exit 0
fi

if [[ "$1" == "$MERGED" ]]; then
  printf "got merged pfd, move direct to output... "
  moveToOutput "$1" && exit || exit 1
fi

if [[ "$1" == *.jpg || "$1" == *.tiff ]]; then
  printf "got a picture, move direct to output... "
  moveToOutput "$1" && exit || exit 1
fi

if [[ "$1" != *.pdf ]]; then
  echo "not a pdf file, ignoring ($1)" && exit 0
fi

if [[  "$1" != $ODD_PREFIX*.pdf && "$1" != $EVEN_PREFIX*.pdf  ]]; then
  echo "$1"
  printf "detected non mutlipage file, move direct to output... "

  moveToOutput "$1" && exit || exit 1
fi  

if [[ "$1" == $ODD_PREFIX*.pdf ]]; then
  echo "odd file detected"
  mv "$1" "$ODD"
else   
  echo "even file detected"
  mv "$1" "$EVEN"
fi  

if [[ -f "$ODD" && -f "$EVEN" ]]; then
  echo "odd and even file available, merging"  
  
  if [[ $ROTATE_ODD -eq 1 ]]; then
    qpdf "$ODD" --rotate=+180 --replace-input
  fi

  if [[ $ROTATE_EVEN -eq 1 ]]; then
    qpdf "$EVEN" --rotate=+180 --replace-input
  fi
  
  if [[ $REVERSE_EVEN -eq 1 ]]; then
    qpdf --empty --pages "$EVEN" z-1 -- reversed.tmp
    rm "$EVEN"
    EVEN="reversed.tmp"
  fi

  qpdf --collate "$ODD" --pages "$ODD" "$EVEN" -- "$MERGED" && rm -f "$ODD" "$EVEN"
fi

