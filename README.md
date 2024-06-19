# Enphase-Envoy-JWT-Tools
Bash scripts to generate and manipulate Java Web Tokens for the Enphase Energy Envoy

This is a collection of Bash scripts that I developed so that I could use API calls to get data about my solar production from my Enphase IQ Combiner, which includes an Enphase Envoy which handles the data. To access the Envoy via the API you need to obtain a Java Web Token (JWT) and use it in your API calls. Finding clear guidance in obtaining a valid JWT isn't very easy to come by even two years past when Enphase started requiring them for secureity purposes. Some time ago I went to the effort of finding out how to obtain the JWT and then scripting it so that I could schedule a cron job to keep it up to date (the JWTs obtained via the methods I use expire after 1 year). 

While these scripts are obviously aimed at Linux users there may be information of value in how the token is obtained and how the API calls are structured for those running other operating syatems. Once you have things working you can query for all kinds of useful data that you can then parse/graph/manipulate any way that you want and not be limited to the what Enphase offers on their website. I pull data on a 15s cadence with Telegraf into an InfluxDB and then use Grafana for the visualizations, but even if all you want is a CSV of your production values you will need a valid JWT to do so. 

Scripts:

1. generate_envoy_token.sh
2. jwd_decoder.sh
4. envoy_curl_queries.sh
3. epoch_convert.sh


