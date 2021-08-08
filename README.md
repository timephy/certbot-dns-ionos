# certbot-dns-ionos

Automate Let's Encrypt Wildcard Certificate creation with Ionos DNS Rest API.

Copy of https://dev.to/devlix-blog/automate-let-s-encrypt-automate-let-s-encrypt-wildcard-certificate-creation-with-ionos-dns-rest-api-o23

## How to install

```bash
# if you install it elsewhere, remember to change paths in below examples
cd ~
git clone https://github.com/timephy/certbot-dns-ionos
```

## How to use

First enable and create an API key under https://developer.hosting.ionos.de

### certbot certonly

```bash
MAIL=<your_mail>
API_KEY=<publicprefix>.<secret>
DOMAIN=<your_domain>

docker run -i --rm \
  -v "/opt/letsencrypt/cert:/etc/letsencrypt" \
  -v "~/certbot-dns-ionos:/tmp/scripts" \
  -e "API_KEY=$API_KEY" \
  certbot/certbot \
  certonly \
  --keep-until-expiring \
  --preferred-challenges dns \
  --non-interactive \
  --agree-tos \
  --manual \
  --manual-auth-hook /tmp/scripts/authenticate.sh \
  --manual-cleanup-hook /tmp/scripts/cleanup.sh \
  -m $MAIL \
  -d $DOMAIN,*.$DOMAIN
```

or for multiple certificates:

```bash
MAIL=<your_mail>
API_KEY=<publicprefix>.<secret>

for DOMAIN in <your_domain1> <your_domain2> <your_domain3>
do
  docker run -i --rm \
    -v "/opt/letsencrypt/cert:/etc/letsencrypt" \
    -v "~/certbot-dns-ionos:/tmp/scripts" \
    -e "API_KEY=$API_KEY" \
    certbot/certbot \
    certonly \
    --keep-until-expiring \
    --preferred-challenges dns \
    --non-interactive \
    --agree-tos \
    --manual \
    --manual-auth-hook /tmp/scripts/authenticate.sh \
    --manual-cleanup-hook /tmp/scripts/cleanup.sh \
    -m $MAIL \
    -d $DOMAIN,*.$DOMAIN
done
```


### certbot renew

No `-d $DOMAIN` to renew all domains. 

```bash
MAIL=<your_mail>
API_KEY=<publicprefix>.<secret>

docker run -i --rm \
  -v "/opt/letsencrypt/cert:/etc/letsencrypt" \
  -v "~/certbot-dns-ionos:/tmp/scripts" \
  -e "API_KEY=$API_KEY" \
  certbot/certbot \
  renew \
  --keep-until-expiring \
  --preferred-challenges dns \
  --non-interactive \
  --agree-tos \
  --manual \
  --manual-auth-hook /tmp/scripts/authenticate.sh \
  --manual-cleanup-hook /tmp/scripts/cleanup.sh \
  -m $MAIL
```
