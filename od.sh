#!/bin/bash

# create separate directory for the whole year
# mkdir -p  2021/{01..12}/{01..30}

# move (mv) the files of everyday to its own directory
perl -le '/(?<=^2021)-(\d\d)-(\d\d)/ && `mv $_ "2021/$1/$2"` for <*>'
