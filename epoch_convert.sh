#!/bin/bash

#Simple script that takes one Unix epoch date as an argument and converts it to Gregorian date and time

re='^[0-9]+$'

if [ -z "$1" ]; then
        echo 'Description: Converts Unix epoch dates to US style time and date'
        echo 'Usage: epoch_convert.sh <unix epoch date>'
        exit 1
else

if ! [[ $1 =~ $re ]] ; then
        echo 'Description: Converts Unix epoch dates to US style time and date'
        echo "error: Not a number" >&2;
        echo 'Usage: epoch_convert.sh <unix epoch date>'
        exit 1
else
        Gdate=`date -d "@$1" +"%m-%d-%Y %T %z"`
        echo $Gdate
fi
fi
exit 0
