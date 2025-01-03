#!/bin/bash

source ~/mega-dbs-backup-script/.env

PGPASSWORD=$POSTGRES_PASSWORD
UPLOAD=~/mega-dbs-backup-script/backups_postgres
DATE=$(date +%Y-%m-%d_%H-%M-%S)

export PGPASSWORD

if [ ! -d "$UPLOAD" ]; then
    mkdir -p "$UPLOAD"
    chmod -R 777 "$UPLOAD"
    echo "Directory backups_postgres created locally."
fi

echo "PostgreSQL backup started..."

#pg_dumpall -U "$POSTGRES_USER" -f "$UPLOAD/$DATE.sql" --no-role-passwords
docker exec -t postgres pg_dumpall -U "$POSTGRES_USER" -f "/home/$DATE.sql" --no-role-passwords

tar -cvpzf $UPLOAD/postgres_backup_$DATE.tar.gz -C $UPLOAD $DATE.sql

rm -rf $UPLOAD/$DATE.sql

cd ~/mega-dbs-backup-script
echo "Uploading PostgreSQL backup to MEGA Drive..."
pnpm run upload:postgres

find $UPLOAD -type f -mmin +$((RETENTION_HOURS * 60)) -name 'postgres_backup_*.tar.gz' -delete

unset PGPASSWORD

echo "PostgreSQL backup completed successfully."
