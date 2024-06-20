# Enphase-Envoy-JWT-Tools
## Bash scripts to generate and manipulate Java Web Tokens for the Enphase Energy Envoy

This is a collection of Bash scripts that I developed so that I could use API calls to get data about my solar production from my Enphase IQ Combiner, which includes an Enphase Envoy which handles the data. To access the Envoy via the API you need to obtain a Java Web Token (JWT) and use it in your API calls. Finding clear guidance in obtaining a valid JWT isn't very easy to come by even two years past when Enphase started requiring them for security purposes. Some time ago I went to the effort of finding out how to obtain the JWT and then scripting it so that I could schedule a cron job to keep it up to date (the JWTs obtained via the methods I use expire after 1 year). 

While these scripts are obviously aimed at Linux users there may be information of value in how the token is obtained and how the API calls are structured for those running other operating systems. Once you have things working you can query all kinds of useful data that you can then parse/graph/manipulate any way that you want and not be limited to what Enphase offers on their website. I pull data on a 15s cadence with Telegraf into an InfluxDB and then use Grafana for the visualizations, but even if all you want is a CSV of your production values you will need a valid JWT to do so. 

I referenced https://enphase.com/download/iq-gateway-access-using-local-apis-or-local-ui-token-based-authentication-tech-brief for the basic steps in requesting a JWT and the API endpoints that are available. That link is current as of June 2024. 

## Scripts:

### generate_envoy_token.sh
- Generates a new JWT token for the Envoy and validates it works before rotating the old one out.
- Requires a valid username and password to the enphaseenergy.com site.
- Lots of fiddly bits here with email notifications etc.
- Assumes you have ssmtp installed to send emails. If you use sendmail modify those commands as needed. 
### envoy_curl_queries.sh
- Requires a valid JWT for your Envoy.
- Pulls data from all available local API endpoints
- An example of how to use curl to access each endpoint. Use as few or many as you wish in your scripts.
### jwd_decoder.sh
- Simply takes the path to a JWT as an argument and decodes it to human readable form.
- Gives creation and expiration dates in Unix Epoch Time.
- Use epoch_convert.sh or an online resource to convert to human readable format. 
### epoch_convert.sh
- Takes a single argument of a Unix timestamp and converts it to human readable format.
- Useful for determining when your JWT will expire
