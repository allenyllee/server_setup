sudo docker run --detach \
    --hostname 10.1.53.168 \
    --env GITLAB_OMNIBUS_CONFIG="gitlab_rails['lfs_enabled'] = true;" \ #enable lfs support
    --publish 443:443 --publish 80:80 --publish 44:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
