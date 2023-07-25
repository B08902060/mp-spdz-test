#!/bin/sh
t=$(ls |grep "TT")
if [ "$t" = "" ]
then
    echo "1"
else
    echo "2"
fi