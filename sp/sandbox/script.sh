#!/bin/bash

if [ $# -ne 1 ] 
then
    echo "The correct exectution is: $0 path_name"
    echo "Please provide EXCATLY one argument"
    exit 1
fi

lines=$(ls -lh $1 | wc -l)

echo "There is $((lines-1)) objects in the $1 directory"
