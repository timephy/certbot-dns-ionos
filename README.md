# certbot-dns-ionos

Automate Let's Encrypt Wildcard Certificate creation with Ionos DNS Rest API.

Copy of https://dev.to/devlix-blog/automate-let-s-encrypt-automate-let-s-encrypt-wildcard-certificate-creation-with-ionos-dns-rest-api-o23

## How to install

```bash
cd ~
git clone https://github.com/timephy/certbot-dns-ionos
```

## How to use

First enable and create an API key under https://developer.hosting.ionos.de

### certbot certonly

```bash
docker run -i --rm \
  -v /opt/letsencrypt/cert:/etc/letsencrypt \
  -v ~/certbot-dns-ionos:/tmp/scripts \
  -e "API_KEY=<publicprefix>.<secret>" \
  certbot/certbot \
  certonly \
  --keep-until-expiring \
  --preferred-challenges dns \
  --non-interactive \
  --agree-tos \
  --manual \
  --manual-auth-hook /tmp/scripts/authenticate.sh \
  --manual-cleanup-hook /tmp/scripts/cleanup.sh \
  -m <email-address> \
  -d *.<your.domain>
```

### certbot renew

```bash
docker run -i --rm \
  -v /opt/letsencrypt/cert:/etc/letsencrypt \
  -v ~/certbot-dns-ionos:/tmp/scripts \
  -e "API_KEY=<publicprefix>.<secret>" \
  certbot/certbot \
  renew \
  --keep-until-expiring \
  --preferred-challenges dns \
  --non-interactive \
  --agree-tos \
  --manual \
  --manual-auth-hook /tmp/scripts/authenticate.sh \
  --manual-cleanup-hook /tmp/scripts/cleanup.sh \
  -m <email-address> \
  -d *.<your.domain>
```
