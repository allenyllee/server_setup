#!/bin/bash

#
# Create your mail accounts
#
mkdir -p config
touch config/postfix-accounts.cf
docker run --rm \
  -e MAIL_USER=allencat@localhost \
  -e MAIL_PASS=allencat \
  -ti tvial/docker-mailserver:latest \
  /bin/sh -c 'echo "$MAIL_USER|$(doveadm pw -s SHA512-CRYPT -u $MAIL_USER -p $MAIL_PASS)"' >> config/postfix-accounts.cf

#
# Generate DKIM keys
#
docker run --rm \
  -v "$(pwd)/config":/tmp/docker-mailserver \
  -ti tvial/docker-mailserver:latest generate-dkim-config
