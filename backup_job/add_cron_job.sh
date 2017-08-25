#!/bin/bash
function replaceLine # file line newText
{
   local file="$1" line="$2" newText="$3"
   #
   # match lines starting with PATTERN and replace whole line with NEWLINE
   # 
   # /^PATTERN/ cNEWLINE 
   # 
   # 'c' is line replacement modifier
   #
   # if you want to use bash's doller varible($varible), you should use single quote '' to quote other regex part,
   # leave $varible outside of single quote and quote it with double quote "".
   #
   # sed option
   # -e Add the commands in SCRIPT to the set of commands to be run while processing the input. 
   # -i flag to make the changes in-place
   sed -i -e '/^'"$line"'/ c'"$newText" "$file"
}

rm /etc/cron.d/root_backup_job
cp ./root_backup_job /etc/cron.d
mkdir -p /var/log/backup/
rm -f /usr/bin/backup.sh
ln -s "$(pwd)/backup.sh" /usr/bin

replaceLine backup.sh \
"BACKUPDIR=" \
"BACKUPDIR=""file:///media/allencat/TODS512G/server_backup"

replaceLine backup.sh \
"FILEDIR=" \
"FILEDIR=""$(pwd)"


