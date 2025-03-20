## Databases Backup Script to MEGA drive ⚙️

📌 Bash script and Node.js TypeScript job that creates dumps of MongoDB, MySQL and PostgreSQL databases in a Linux
environment, packs them and uploads to MEGA Drive cloud.

![GitHub top language](https://img.shields.io/github/languages/top/jakubcieslik99/mega-dbs-backup-script)
![GitHub repo size](https://img.shields.io/github/repo-size/jakubcieslik99/mega-dbs-backup-script)

## Initial requirements

It is recommended to run this backup script for all the given databases, in a Linux environment, as a cron job.

The recommended location for the script, that will work out of the box is `/home/{user}` directory in a Linux environment.

The script that backups all three databases is located in `/scripts` directory and called `backup.sh`.

You also have to provide proper environment variables in `.env` file and use pnpm package manager.

All information about environment variables can be found in the `Environment Variables` section.

## Run script manually

- Clone repository

```bash
  git clone https://github.com/jakubcieslik99/mega-dbs-backup-script.git
```

ℹ️ Instructions for running script manually:

- Navigate to the `backup.sh` directory

```bash
  cd mega-dbs-backup-script/scripts
```

- Run the script manually

```bash
  sudo chmod +x mega-dbs-backup-script/*.*
  sudo chmod +x mega-dbs-backup-script/scripts/*.*
```

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

`0 5 * * * /full/path/to/mega-dbs-backup-script/scripts/backup.sh >/dev/null 2>&1`

- Save and exit the crontab file

## Environment Variables

⚙️ To run the script, you will need to add the following environment variables to your .env file

Vars:

- `MONGO_USER`

- `MYSQL_USER`

- `POSTGRES_USER`

- `PROJECT_NAME`
- `RETENTION_HOURS`
- `MEGA_EMAIL`
- `MEGA_USER_AGENT`

Secrets:

- `MONGO_PASSWORD`
- `MYSQL_PASSWORD`
- `POSTGRES_PASSWORD`
- `MEGA_PASSWORD`

( ℹ️ - sample .env config file is provided in the script directory under the name `.env.sample` )

## Feedback

If you have any feedback, please reach out to me at ✉️ contact@jakubcieslik.com

## Authors

- [@jakubcieslik99](https://www.github.com/jakubcieslik99)
