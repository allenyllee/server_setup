#!/bin/bash

MOUNTPOINT=/mnt/docker-srv/gitlab

docker run \
    --detach \
    --hostname 10.1.53.168 \
    --env GITLAB_OMNIBUS_CONFIG=" \
        gitlab_rails['lfs_enabled'] = true; \
        gitlab_rails['gitlab_email_enabled'] = true; \
        gitlab_rails['gitlab_email_from'] = 'SASSD.Admin@liteon.com'; \
        gitlab_rails['gitlab_email_display_name'] = 'Gitlab'; \
        gitlab_rails['gitlab_email_reply_to'] = 'SASSD.Admin@liteon.com'; \
        gitlab_rails['smtp_enable'] = true; \
        gitlab_rails['smtp_address'] = '10.1.15.143'; \
        gitlab_rails['smtp_port'] = 25; \
        gitlab_rails['smtp_domain'] = 'liteon.com'; \
        gitlab_rails['smtp_authentication'] = false; \
        gitlab_rails['smtp_enable_starttls_auto'] = true; \
        gitlab_rails['smtp_tls'] = false; \
        gitlab_rails['smtp_openssl_verify_mode'] = 'peer' \
        " \
    --publish 443:443 --publish 80:80 --publish 44:22 \
    --name gitlab \
    --restart always \
    --volume $MOUNTPOINT/config:/etc/gitlab \
    --volume $MOUNTPOINT/logs:/var/log/gitlab \
    --volume $MOUNTPOINT/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
