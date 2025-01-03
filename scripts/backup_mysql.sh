#!/bin/bash

source ~/mega-dbs-backup-script/.env

UPLOAD=~/mega-dbs-backup-script/backups_mysql
DATE=$(date +%Y-%m-%d_%H-%M-%S)

if [ ! -d "$UPLOAD" ]; then
    mkdir -p "$UPLOAD"
    chmod -R 777 "$UPLOAD"
    echo "Directory backups_mysql created locally."
fi

echo "MySQL backup started..."

#mysqldump -u "$MYSQL_USER" -p "$MYSQL_PASSWORD" --all-databases > "$UPLOAD/$DATE.sql"
docker exec -t mysql sh -c "mysqldump -u '$MYSQL_USER' --password='$MYSQL_PASSWORD' --all-databases > /home/'$DATE'.sql"
#docker exec -e MYSQL_USER="$MYSQL_USER" -e MYSQL_PASSWORD="$MYSQL_PASSWORD" -e DATE="$DATE" -t mysql sh -c 'mysqldump -u "$MYSQL_USER" --password="$MYSQL_PASSWORD" --all-databases > "/home/$DATE.sql"'

tar -cvpzf $UPLOAD/mysql_backup_$DATE.tar.gz -C $UPLOAD $DATE.sql

rm -rf $UPLOAD/$DATE.sql

cd ~/mega-dbs-backup-script
echo "Uploading MySQL backup to MEGA Drive..."
pnpm run upload:mysql

find $UPLOAD -type f -mmin +$((RETENTION_HOURS * 60)) -name 'mysql_backup_*.tar.gz' -delete

echo "MySQL backup completed successfully."
