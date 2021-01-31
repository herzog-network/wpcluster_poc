#!/bin/bash

# LetsEncrypt renew script
# Usage: echo "0 0 1 * * your_project_path/renew-certs.sh" >> /etc/crontab

# Author: https://omarghader.github.io/haproxy-letsencrypt-docker-certbot-certificates/

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

echo "$(date) About to renew certificates" >> /var/log/letsencrypt-renew.log
/usr/bin/docker run \
       -i \
       --rm \
       --name certbot \
       -v $PWD/letsencrypt:/etc/letsencrypt \
       -v $PWD/webroot:/webroot \
       certbot/certbot \
       renew -w /webroot

echo "$(date) Cat certificates" >> /var/log/letsencrypt-renew.log

function cat-cert() {
  dir="./letsencrypt/live/$1"
  cat "$dir/privkey.pem" "$dir/fullchain.pem" > "./certs/$1.pem"
}

for dir in ./letsencrypt/live/*; do
  if [[ "$dir" != *"README" ]]; then
    cat-cert $(basename "$dir")
  fi
done

echo "$(date) Reload haproxy" >> /var/log/letsencrypt-renew.log
docker service update --force proxy_proxy

echo "$(date) Done" >> /var/log/letsencrypt-renew.log
