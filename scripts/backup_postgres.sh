#!/bin/bash

source ~/dbs-backup-script/.env

PGPASSWORD=$POSTGRES_PASSWORD
UPLOAD=~/dbs-backup-script/backups_postgres
DATE=$(date +%Y-%m-%d_%H-%M-%S)

export PGPASSWORD

if [ ! -d "$UPLOAD" ]; then
    mkdir -p "$UPLOAD"
    chmod -R 777 "$UPLOAD"
    echo "Directory backups_postgres created locally."
fi

echo "PostgreSQL backup started..."

pg_dumpall -U "$POSTGRES_USER" -f "$UPLOAD/$DATE.sql"

tar -cvpzf $UPLOAD/postgres_backup_$DATE.tar.gz -C $UPLOAD $DATE.sql

rm -rf $UPLOAD/$DATE.sql

cd ~/dbs-backup-script
echo "Uploading PostgreSQL backup to MEGA Drive..."
npm run upload:postgres

find $UPLOAD -type f -mmin +$((RETENTION_HOURS * 60)) -name 'postgres_backup_*.tar.gz' -delete

unset PGPASSWORD

echo "PostgreSQL backup completed successfully."
