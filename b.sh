#!/bin/bash

IP=(5.145.112.0 5.145.115.0 185.24.255.0);

for ip in ${IP[@]}; do
    echo $ip;
    cat $(date '+%Y/%m/%d')/*.txt | grep BI | perl -a -lne 'print "$F[1]\t$F[2]\t$F[3]\t$F[6]";' | grep $ip;
done
