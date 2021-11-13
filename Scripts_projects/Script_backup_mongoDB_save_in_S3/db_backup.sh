#!/bin/bash

#-----------------------------------------------------
#
# Script which backups databases from mongo_db in different ways
# Saved backups in AWS S3
# Delete backups from local storage
# Can be run from local instance or remote instance
#
#-------------------------------------------------------

DIR=`date +%d-%m-%y`
DEST=~/db_backups/$DIR
mkdir $DEST
MONGO_HOST='localhost'  # Address of db
MONGO_PORT='27017'  # Port which use db
AUTH_ENABLED=0  # Use "1" if you need autentificate with username and password
# MONGO_USER='...'   # Use user credentiall
# MONGO_PASSWD='...'  # Use user credentiall
# DATABASE_NAMES='ALL'  # You can backups all dbs
# DATABASE_NAMES='db_1 db_2 db_3 db_4 db_5'  # You can backups specific dbs

# Get list of all databases for
dbs=$(mongo --quiet <<EOF
show dbs
quit()
EOF
)
i=1
for db in ${dbs[*]}
do
    i=$(($i+1))
    if (($i % 2)); then
        echo "$db" >> dbs.txt
    fi
done

# Parsing result of getting databases using REGEXP. In result we get list with all dbs named db_*
DATABASE_NAMES=$(grep db_[0-9]* dbs.txt)

# Delete temporary dbs.txt file
rm dbs.txt

BACKUP_RETAIN_DAYS=1

# If we use credentials for db we get AUTH_PARAM
AUTH_PARAM=""
if [ ${AUTH_ENABLED} -eq 1 ]; then
  AUTH_PARAM=" --username ${MONGO_USER} --password ${MONGO_PASSWD} "
fi

if [ "${DATABASE_NAMES}" = "ALL" ]; then
  # echo "You have choose to backup all databases"
  mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} ${AUTH_PARAM} --archive=${DEST}/${DIR}.archive
else
  # echo "Running backup for selected databases"
  for DB_NAME in ${DATABASE_NAMES}
    do
      mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${DB_NAME} ${AUTH_PARAM} --archive=${DEST}/${DB_NAME}_${DIR}.archive
    done
fi

# Error Handling to get information about success or not backuping proces and save it in logs and errors files
if [ $? -eq 0 ]
then
  echo "`date` Successfully dumped dbs" >> /home/ubuntu/db_backups/log.txt
else
  echo "`date` Could not dump dbs" >> /home/ubuntu/db_backups/error.txt
fi
######## Remove backups older than {BACKUP_RETAIN_DAYS} days  ########

DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`
if [ ! -z ${DB_BACKUP_PATH} ]; then
      cd ${DB_BACKUP_PATH}
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
            rm -rf ${DBDELDATE}
      fi
fi

######################### Sync with AWS #############################

aws s3 sync ~/db_backups s3://mongo-dima-ls-back-up

# Error Handling to get information about success or not sync proces
if [ $? -eq 0 ]
then
  echo "`date` Successfully synced with AWS storage" >> /home/ubuntu/db_backups/log.txt
else
  echo "`date` Could not sync with AWS storage" >> /home/ubuntu/db_backups/error.txt
fi

######################### End of script ##############################
