#!/bin/bash

PATH_SCRIPT="$(pwd)/$0"
USER=$1
GRIVE_DIR=$2

HOMEMIR=$(getent passwd "$USER" | cut -d: -f6)
PATH_GRIVE_DIR=$HOMEMIR/$GRIVE_DIR

if [ ! -z $USER ] && [ ! -z $GRIVE_DIR ]; then
	echo "Add to /etc/crontab: */5 * * * *  root	bash $PATH_SCRIPT >> /var/log/update_grive.log"
	LIST_DIRS=$(ls $PATH_GRIVE_DIR)
	for GRIVE_DIR in $LIST_DIRS; do
		if [ -f $PATH_GRIVE_DIR/$GRIVE_DIR/.grive ]; then
			echo "Update $GRIVE_DIR..."
			cd $PATH_GRIVE_DIR/$GRIVE_DIR/ && grive
			chown -R $USER:$USER $PATH_GRIVE_DIR/$GRIVE_DIR/
		fi
	done
else
	echo "Example: bash update_grive.sh USER DIR_GRIVE_IN_HOME_USER
	bash update_grive.sh ubuntu grive"
fi

