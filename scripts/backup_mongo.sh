#!/bin/bash

source ~/dbs-backup-script/.env

URI=mongodb://$MONGO_USER:$MONGO_PASSWORD@localhost:27017
UPLOAD=~/dbs-backup-script/backups_mongo
DATE=$(date +%Y-%m-%d_%H-%M-%S)

echo "MongoDB backup started..."

mongodump --uri="$URI" --out="$UPLOAD/$DATE"

tar -cvpzf $UPLOAD/mongo_backup_$DATE.tar.gz -C $UPLOAD $DATE

rm -rf $UPLOAD/$DATE

cd ~/dbs-backup-script
echo "Uploading MongoDB backup to MEGA Drive..."
npm run upload:mongo

find $UPLOAD -type f -mmin +$((RETENTION_HOURS * 60)) -name 'mongo_backup_*.tar.gz' -delete

echo "MongoDB backup completed successfully."
