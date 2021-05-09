#!/bin/sh
#set -x

# install curl
apk add curl

API_URL="https://api.hosting.ionos.com/dns/v1"
API_KEY_HEADER="X-API-Key: $API_KEY"

# Strip only the top domain to get the zone id
ZONE_NAME=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
# When already the TLD then use it
if [ -z "$ZONE_NAME" ]; then
  ZONE_NAME="$CERTBOT_DOMAIN"
fi

# Get the Ionos zone id
ZONE_RESPONSE=$(curl -s -X GET "$API_URL/zones" \
                     -H "$API_KEY_HEADER" \
                     -H "Accept: application/json")
ZONE_ID=$(echo $ZONE_RESPONSE \
     | python -c "import sys,json;response=json.load(sys.stdin);print(next((x for x in response if x['name']=='$ZONE_NAME'))['id'])")

# Create TXT record
CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
RECORD_CREATE_RESPONSE=$(curl -s -X POST "$API_URL/zones/$ZONE_ID/records" \
                              -H "$API_KEY_HEADER" \
                              -H "Content-Type: application/json" \
                              --data '[{"name": "'"$CREATE_DOMAIN"'", "type": "TXT", "content": "'"$CERTBOT_VALIDATION"'", "ttl": 3600, "prio": 100, "disabled": false}]')

# Save info for cleanup
echo $ZONE_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN

# Sleep to make sure the change has time to propagate over to DNS
sleep 25
