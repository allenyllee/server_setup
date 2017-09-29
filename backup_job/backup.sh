SOURCEDIR=/
BACKUPDIR=file:///media/allencat/TODS512G/server_backup
FILEDIR=/home/allencat/Project/server_setup/backup_job

INCLUDELIST=$FILEDIR/backup_list.txt
LOGFILE=$FILEDIR/backup.log

FULLBACKUPTIME=1M

function dpremove {
  duplicity remove-all-but-n-full 1 \
            --no-encryption \
            --force \
            --log-file $LOGFILE \
            $BACKUPDIR
}

function dpclean {
  duplicity cleanup \
            --no-encryption \
            --force \
            --log-file $LOGFILE \
            $BACKUPDIR
}

function dpbackup {
  duplicity --no-encryption \
          --full-if-older-than $FULLBACKUPTIME \
          --progress \
          --verbosity 8 \
          --log-file $LOGFILE \
          --include-filelist $INCLUDELIST \
          $SOURCEDIR $BACKUPDIR
}


for (( c=1; c<=2; c++))
do
  echo loop $c

  rm -f $LOGFILE
  dpbackup

  if [ $? -eq 53 ] #dosen't have enough space
  then #remove & clean and try again
    dpremove
    #dpclean
  else
    break
  fi

done


