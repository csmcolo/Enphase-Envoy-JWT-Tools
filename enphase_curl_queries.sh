#!/bin/bash

#This script requires a valid Java Web Token (JWT) for your Enphase Envoy.
#It creates a header file with the JWT in it and saves it in a file called 'header'
#in the directory that the script was started from. It is inserted into the curl query with 
#the '-H @header' option in the curl query where the information afte the @ is the filename. 

#It queries all available API endpoints on the envoy and returns the data to standard out. 
#You can use one or a combination of these queries as you see fit, I have only included them
#all in this script as a proof of concept. 

#Refer to https://enphase.com/download/iq-gateway-access-using-local-apis-or-local-ui-token-based-authentication-tech-brief
#for further details. Above link valid as of June of 2024. 

jwt_location='/home/envoy/bearerTokenCurrent' #absolute path to current envoy access token
jwt=`cat $jwt_location`
file=`echo "Authorization: Bearer $jwt" > header`

echo ivp meters
curl -s -f -k -H 'Accept: application/json' -H @header -X GET https://envoy.little-to-no.org/ivp/meters
echo ivp meters readings
curl -s -f -k -H 'Accept: application/json' -H @header -X GET https://envoy.little-to-no.org/ivp/meters/readings
echo api v1 production inverters
curl -s -f -k -H 'Accept: application/json' -H @header -X GET https://envoy.little-to-no.org/api/v1/production/inverters
echo ivp livedata status
curl -s -f -k -H 'Accept: application/json' -H @header -X GET https://envoy.little-to-no.org/ivp/livedata/status
echo ivp meters reports consumption
curl -s -f -k -H 'Accept: application/json' -H @header -X GET https://envoy.little-to-no.org/ivp/meters/reports/consumption
echo production.json
curl -s -f -k -H 'Accept: application/json' -H @header -X GET https://envoy.little-to-no.org/production.json

rm header
