#!/bin/bash

MOUNTPOINT=/mnt/docker-srv/gitlab

docker run \
    --detach \
    --hostname 10.1.53.168 \
    --env GITLAB_OMNIBUS_CONFIG=" \
        gitlab_rails['lfs_enabled'] = true; \
        gitlab_rails['gitlab_email_enabled'] = true; \
        gitlab_rails['gitlab_email_from'] = 'sassd.admin@liteon.com'; \
        gitlab_rails['gitlab_email_display_name'] = 'Gitlab'; \
        gitlab_rails['gitlab_email_reply_to'] = 'sassd.admin@liteon.com'; \
        gitlab_rails['smtp_enable'] = true; \
        gitlab_rails['smtp_address'] = 'smtp.gmail.com'; \
        gitlab_rails['smtp_port'] = 587; \
        gitlab_rails['smtp_user_name'] = 'username@gmail.com'; \
        gitlab_rails['smtp_password'] = 'userpasswd'; \
        gitlab_rails['smtp_domain'] = 'gmail.com'; \
        gitlab_rails['smtp_authentication'] = 'login'; \
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
