#!/bin/bash
rm /etc/cron.d/root_backup_job
cp ./root_backup_job /etc/cron.d
mkdir -p /var/log/backup/
