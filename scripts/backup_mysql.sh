#!/bin/bash

source ~/dbs-backup-script/.env

UPLOAD=~/dbs-backup-script/backups_mysql
DATE=$(date +%Y-%m-%d_%H-%M-%S)

if [ ! -d "$UPLOAD" ]; then
    mkdir -p "$UPLOAD"
    chmod -R 777 "$UPLOAD"
    echo "Directory backups_mysql created locally."
fi

echo "MySQL backup started..."

mysqldump -u "$MYSQL_USER" -p "$MYSQL_PASSWORD" --all-databases > "$UPLOAD/$DATE.sql"

tar -cvpzf $UPLOAD/mysql_backup_$DATE.tar.gz -C $UPLOAD $DATE.sql

rm -rf $UPLOAD/$DATE.sql

cd ~/dbs-backup-script
echo "Uploading MySQL backup to MEGA Drive..."
npm run upload:mysql

find $UPLOAD -type f -mmin +$((RETENTION_HOURS * 60)) -name 'mysql_backup_*.tar.gz' -delete

echo "MySQL backup completed successfully."
