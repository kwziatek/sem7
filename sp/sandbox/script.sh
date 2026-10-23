#!/bin/bash

path=logfiles/

rm $path/*
cp /var/log/*.log $path

counter=1

for file in $path*
do
    if command -v *tar*
    then
        echo "Zip $file is being deleted"
        rm $file
    else
        echo "File is being replaced"
        mv $file $path$counter.log
        echo $file
        ((counter++))
    fi

done

for file in $path*
do
    echo $file

done
