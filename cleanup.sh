#!/bin/sh
#set -x

API_URL="https://api.hosting.ionos.com/dns/v1"
API_KEY_HEADER="X-API-Key: $API_KEY"

if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN ]; then
    ZONE_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN)
    rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN

    CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
    # request the created records
    RECORD_GET_RESPONSE=$(curl -s -X GET "$API_URL/zones/$ZONE_ID?recordName=$CREATE_DOMAIN&recordType=TXT" \
                             -H "$API_KEY_HEADER" \
                             -H "Accept: application/json")
    RECORD_IDS=$(echo $RECORD_GET_RESPONSE \
            | python -c "import sys,json;records=json.load(sys.stdin)['records'];print('\n'.join([x['id'] for x in records]))")
fi

# Remove the challenge TXT record from the zone
if [ -n "$ZONE_ID" -a -n "$RECORD_IDS" ]; then
    echo "$RECORD_IDS" \
    | xargs -n1 -I {} curl -s -X DELETE "$API_URL/zones/$ZONE_ID/records/{}" \
            -H "$API_KEY_HEADER"
fi
