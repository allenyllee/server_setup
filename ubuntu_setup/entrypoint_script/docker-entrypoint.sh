#!/bin/sh

DRIVE_PATH=/mnt/google-drive

umask 000

if [ -e ~/.gdfuse/default/already_config ]; then
	echo "existing google-drive-ocamlfuse config found"
	echo "mounting at ${DRIVE_PATH}"
	#google-drive-ocamlfuse "${DRIVE_PATH}" -o nonempty
	google-drive-ocamlfuse /mnt/google-drive -o nonempty,allow_other
	echo $(id)
	tail -f /dev/null & wait
else
	echo "default config not found"
	google-drive-ocamlfuse -f -headless \
		-id "$CLIENT_ID.apps.googleusercontent.com" -secret "$CLIENT_SECRET"
fi


