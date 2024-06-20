#!/bin/bash

#Script to generate a new Java Web Token (JWT) for the Enphase envoy such as
#included in the Envoy IQ Combiners. 

#A JWT specifict to your Envoy's serial number is required to make local API calls 
#to gather usage and performance data. 

#You need to have a working log-in for https://enlighten.enphaseenergy.com for this 
#to work and the enphase_user and enphase_password variables are the login credentials
#for that site. I am uncertain if it needs to be an 'installer' login or not, its been a few
#years since I did this. I believe if your current login doesn't work, you can open a
#call/tickt with Enphase and ask them to change your account to a type that has access. YMMV

#As the JWT is required and expires in 1 year you need to run it at least that often
#to ensure anything you are doing that uses it continues to function. 

#The process requires that you first log in to https://enlighten.enphaseenergy.com to get a 
#session ID and then use that along with the serial number of your envoy to generate the JWT. 

#This script also verifies the new JWT by making an API query and validating the output. If the 
#validation fails it sends a failure email. If it does succed it sends the resulting API
#output along with the JWT created date, expiration date and fingerprint via email so that you can
#be sure it worked if you are running it via cron. 

#VARIABLES
now=`date +%m-%d-%y-%H_%M_%S`
working_path='' #path where all the temp files are saved during execution
enphase_user='' #enphase website user name
enphase_password='' #enphase website password
envoy_serial='' #serial number of your Envoy
envoy_ip='' #IP address or FQDN of your Envoy
notification_email='' #email address to send success/failure notifications to
source_email='' #email address to send success/failure notifications from
header=$working_path/header.$now #temp file to hold the token for later use in a verification api call

#Log in and get session ID

session_id=$(curl -s -X POST https://enlighten.enphaseenergy.com/login/login.json? -F "user[email]=$enphase_user" -F "user[password]=$enphase_password" | jq -r ".session_id")

#Generate Token using session ID and serial number

web_token=$(curl -s -X POST https://entrez.enphaseenergy.com/tokens -H "Content-Type: application/json" -d "{\"session_id\": \"$session_id\", \"serial_num\": \"$envoy_serial\", \"username\": \"$enphase_user\"}")

#Write new JWT to temp file

echo $web_token > $working_path/envoy_token.$now

#Decode JWT and output to temp file

echo $web_token | tr "." "\n" |base64 -d 2> /dev/null | jq 2> /dev/null > decoded.$now

#Parse decoded JWT for times and fingerprint

generationTime=`cat decoded.$now | grep iat | cut -d: -f2 | sed 's/,//g'`
expirationTime=`cat decoded.$now | grep exp | cut -d: -f2 | sed 's/,//g'`
fingerprint=`cat decoded.$now | grep jti | cut -d: -f2 | sed 's/,//g' | sed 's/\"//g'`

#Convert epoch dates to gregorian

generationTime=`date -d "@$generationTime" +"%m-%d-%Y %T %z"`
expirationTime=`date -d "@$expirationTime" +"%m-%d-%Y %T %z"`

#Test new JWT

bearer_token=`cat $working_path/envoy_token.$now`
echo "Authorization: Bearer $bearer_token" > $header
verification=`curl -s -f -k -H 'Accept: application/json' -H @$header -X GET https://$envoy_ip/production.json`

#Verify token returns valid data

if test -z $verification; then

   #Set up email to notify of falure
     echo "To: $notification_email" > /tmp/token-email.$now
     echo "From: $source_email" >> /tmp/token-email.$now
     echo "Subject: Token Generation Failed!" >> /tmp/token-email.$now
     echo "Token generation failed. Please log in and run the script manually after ensuring internet connectivity." >> /tmp/token-email.$now

   #Send email

     `ssmtp $notification_email < /tmp/token-email.$now`

   #clean up

     rm /tmp/token-email.$now
     rm $header
     rm decoded.$now
     rm $working_path/envoy_token.$now

     exit 0

else

#Rotate JWT files

cp $path/bearerTokenCurrent $path/bearerTokenOld
cp $path/envoy_token.$now $path/bearerTokenCurrent

#Set up email to notify of successful token creation

echo "To: $notification_email" > /tmp/token-email.$now
echo "From: $source_email" >> /tmp/token-email.$now
echo "Subject: A New JWT Token for Envoy has been generated" >> /tmp/token-email.$now
echo "A new envoy token has been generated!" >> /tmp/token-email.$now
echo "Generation time: $generationTime" >> /tmp/token-email.$now
echo "Expiration Time: $expirationTime" >> /tmp/token-email.$now
echo "JWT Fingerprint: $fingerprint" >>/tmp/token-email.$now
echo "Verification output: " >>/tmp/token-email.$now
echo $verification >>/tmp/token-email.$now

#Send email

`ssmtp $notification_email < /tmp/token-email.$now`

#clean up
rm /tmp/token-email.$now
rm $header
rm decoded.$now
rm $working_path/envoy_token.$now

exit 0

fi

