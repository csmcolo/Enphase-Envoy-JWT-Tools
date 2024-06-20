#!/bin/bash

#Simple script that takes one variable on the command line, the path to the JWT you want to decode.
#Handy for seeing when your JWT is going to expire so that you can generate a new one. 
#Data decoded varies by the JWT type but for an Enphase Envoy JWT it provides the serial number of the
#envoy it is tied to along the Envoy username that requested it. It also provides the creation and expiration dates 
#(in Unix Epoch Time) which you can convert with an online tool or with my epoch_covert.sh script that is available
#at https://github.com/csmcolo/Enphase-Envoy-JWT-Tools. 

###############################################################################
# Requires jq which can be installed on Ubuntu with sudo apt install jq       #
# For other systems please refer to https://jqlang.github.io/jq/ for guidance #
###############################################################################


#!/bin/bash

now=`date +%m-%d-%y-%H_%M_%S`
working_path='' #path where all the temp files are saved during execution

if [ -z "$1" ]; then
        echo 'Description: Decodes Java Web Token (jwt) to show human readable data.'
        echo 'Usage: jwt_convert.sh  <filename of jwt token>'
        exit 1
else
cat $1 | tr "." "\n" |base64 -d 2> /dev/null | jq -r 2> /dev/null > $working_path/temp_token.$now


#Parse decoded JWT for times

generationTime=`cat $working_path/temp_token.$now | grep iat | cut -d: -f2 | sed 's/,//g'`
expirationTime=`cat $working_path/temp_token.$now | grep exp | cut -d: -f2 | sed 's/,//g'`

#Convert epoch dates to gregorian

generationTime=`date -d "@$generationTime" +"%m-%d-%Y %T %z"`
expirationTime=`date -d "@$expirationTime" +"%m-%d-%Y %T %z"`
fingerprint=`cat decoded.$now | grep jti | cut -d: -f2 | sed 's/,//g' | sed 's/\"//g'`


echo "Complete Decoded JWT Output"
cat $working_path/temp_token.$now
echo ''
echo 'JWT Creation Date'
echo $generationTime
echo ''
echo 'JWT Expiration Date'
echo $expirationTime

rm $working_path/temp_token.$now

fi
exit 0
