#!/bin/bash
function insertAfter # file line newText
{
   local file="$1" line="$2" newText="$3"
   #sed -i -e "/^$line$/a"$'\\\n'"$newText"$'\n' "$file"
   sed -e '0,/^test=/ cAllencat' "$file"
}

rm /etc/cron.d/root_backup_job
cp ./root_backup_job /etc/cron.d
mkdir -p /var/log/backup/
rm -f /usr/bin/backup.sh
ln -s "$(pwd)/backup.sh" /usr/bin



insertAfter backup.sh \
  "BACKUPDIR=" \
  "test=file:///media/allencat/TODS512G/server_backup"
