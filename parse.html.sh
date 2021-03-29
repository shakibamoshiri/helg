#!/bin/bash

file=$1;

{
    pup  "thead > tr:nth-child(1) text{}" < $file | tr ' ' '-' | xargs echo
    pup  "tbody > tr:nth-child(1) text{}" < $file | xargs echo | perl -lpe 's/( , ?)/,/g'
    pup  "tbody > tr:nth-child(2) text{}" < $file | xargs echo | perl -lpe 's/( , ?)/,/g'
} | while read line; do
    args=();
    for arg in "$line"; do
        args+=($arg)
    done
    printf "%-15s %-20s %-15s %-10s %-10s %-10s"  "${args[@]:0:6}"
    printf "%-40s"  "${args[@]:6:1}"
    printf "%-10s %s"  "${args[@]:7}"
    echo;

done;

pup  "tfoot > tr:nth-child(1) text{}" < $file | xargs echo
