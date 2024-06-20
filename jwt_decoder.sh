#!/bin/bash

#Simple script that takes one variable on the command line, the path to the JWT you want to decode.
#Handy for seeing when your JWT is going to expire so that you can generate a new one. 
#Data decoded varies by the JWT type but for an Enphase Envoy JWT it provides the serial number of the
#envoy it is tied to along the Envoy username that requested it. It also provides the creation and expiration dates 
#(in Unix Epoch Time) which you can convert with an online tool or with my epoch_covert.sh script that is available
#at https://github.com/csmcolo/Enphase-Envoy-JWT-Tools. 

if [ -z "$1" ]; then
        echo 'Description: Decodes Java Web Token (jwt) to show human readable data.'
        echo 'Usage: jwt_convert.sh  <filename of jwt token>'
        exit 1
else

        cat $1 | tr "." "\n" |base64 -d 2> /dev/null | jq 2> /dev/null
fi
exit 0
