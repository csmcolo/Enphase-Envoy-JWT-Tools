# Enphase-Envoy-JWT-Tools
## Bash scripts to generate and manipulate Java Web Tokens for the Enphase Energy Envoy

This is a collection of Bash scripts that I developed so that I could use API calls to get data about my solar production from the Enphase Envoy that came with my Enphase IQ Cobminer. To access the Envoy via the API you need to obtain a Java Web Token (JWT) that you will use to authorize every API call. Finding clear guidance in obtaining a valid JWT isn't easy to come by, even two years since Enphase started requiring them. Some time ago I went to the effort of finding out how to obtain the JWT and then scripting it so that I could run it via a cron job to keep it up to date (the JWTs obtained via the methods I use expire after 1 year). The main script (envoy_generate__token.sh) has been up and running since December without issue. 

While these scripts are obviously aimed at Linux users, there may be information of value for those using other operating systems in them regaring how the token is obtained and how the API calls are structured. Once you have things working, you can query all kinds of useful data that you can then parse/graph/manipulate any way that you want and not be limited to what Enphase offers on their website. I pull data on a 15s cadence with Telegraf into an InfluxDB and then use Grafana for the visualizations, but even if all you want is a CSV of your production values you will need a valid JWT to do so. 

I referenced https://enphase.com/download/iq-gateway-access-using-local-apis-or-local-ui-token-based-authentication-tech-brief for the basic steps in requesting a JWT and the API endpoints that are available. That link is current as of June 2024. If you only plan on getting one JWT a year, you are likely better off following the browser based method in that link rather than using the scripts here. 

The envoy_generate_token.sh and enphase_jwt_decoder.sh scripts require jq to be installed. For Ubuntu its _sudo apt install jq_. For other flavors, try your native package management tool or refer to https://jqlang.github.io/jq/ for further details. 

## Scripts:

### envoy_generate_token.sh
- Generates a new JWT token for the Envoy and validates it works before rotating the old one out.
- Requires a valid username and password to the enphaseenergy.com site.
- Lots of fiddly bits here with email notifications etc.
- Assumes you have ssmtp installed to send emails. If you use sendmail modify those commands as needed. 
### envoy_curl_queries.sh
- Requires a valid JWT for your Envoy.
- Pulls data from all available local API endpoints
- An example of how to use curl to access each endpoint. Use as few or many as you wish in your scripts.
### envoy_jwd_decoder.sh
- Simply takes the path to a JWT as an argument and decodes it to human readable form and sends it to standard out.
- Main items of interest are the envoy serial number, the user name that was used to create it, and the creation and expiration times in Unix Epoch Time. 
- Script also converts the Unix Epoch Time values to Gregoraian and sends them to standard out. 
