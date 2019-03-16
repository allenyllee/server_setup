#!/usr/bin/env bash

source ./setup_services.sh ~/Projects ~/Projects_SSD

# if it shows error "Refresh token invalid, use --logout to authorize the client again"
# just remove "/config/refresh_token"

docker-compose stop OneDrive
docker-compose rm -f OneDrive
docker-compose up -d OneDrive

