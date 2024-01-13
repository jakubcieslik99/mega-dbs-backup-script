## Databases Backup Script ⚙️

📌 Bash script and Node.js TypeScript job that creates dumps of MongoDB, MySQL and PostgreSQL databases on Linux environment,
packs them and uploads to MEGA Drive cloud.

![GitHub top language](https://img.shields.io/github/languages/top/jakubcieslik99/dbs-backup-script)
![GitHub repo size](https://img.shields.io/github/repo-size/jakubcieslik99/dbs-backup-script)

## Initial requirements

It is recommended to run this backup script for all the given databases, on Linux environment, as a cron job.

The recommended location for the script, that will work out of the box is `/home/{user}` directory on Linux environment.

The script that backups all three databases is located in `/scripts` directory and called `backup.sh`.

You also have to provide proper environment variables in `.env` file.

All information about environment variables can be found in the `Environment Variables` section.

## Run script manually

- Clone repository

```bash
  git clone https://github.com/jakubcieslik99/dbs-backup-script.git
```

ℹ️ Instructions for running script manually:

- Navigate to the `backup.sh` directory

```bash
  cd dbs-backup-script/scripts
```

- Run the script manually

```bash
  ./backup.sh
```

## Run script as a cron job

ℹ️ Instructions for running script as a cron job:

- Copy all files to the server home directory

- Add an entry to the crontab file (e.g. silent mode, 5 AM every day)

```bash
  crontab -e
```

`0 5 * * * /full/path/to/dbs-backup-script/scripts/backup.sh >/dev/null 2>&1`

- Save and exit the crontab file

## Environment Variables

⚙️ To run the script, you will need to add the following environment variables to your .env file

- `MONGO_USER`

- `MONGO_PASSWORD`

- `MYSQL_USER`

- `MYSQL_PASSWORD`

- `POSTGRES_USER`

- `POSTGRES_PASSWORD`

- `PROJECT_NAME`

- `RETENTION_HOURS`

- `MEGA_EMAIL`

- `MEGA_PASSWORD`

- `MEGA_USER_AGENT`

( ℹ️ - sample .env config file is provided in the script directory under the name `.env.sample` )

## Feedback

If you have any feedback, please reach out to me at ✉️ contact@jakubcieslik.com

## Authors

- [@jakubcieslik99](https://www.github.com/jakubcieslik99)
