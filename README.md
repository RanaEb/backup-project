# Linux Backup Script

This project is a Bash script to automate backups on a Linux system.  
It allows you to back up specific directories, filter files by extension, and save compressed backups.  
The script supports dry-run mode, logging, configuration file, and optional encryption.

---

## 📁 Directories to Backup

The script is currently configured to back up the following directories:

- `/home/reyhaneheb/directory1`
- `/home/reyhaneheb/NewFolder1`
- `/home/reyhaneheb/NewFolder2`
- `/home/reyhaneheb/os_lab`

You can modify the list in `backup.conf`.

---

## ⚙️ Configuration (`backup.conf`)

You can specify backup settings in the `backup.conf` file.  
Here is a sample configuration:

```bash
SOURCE_DIRS="/home/reyhaneheb/directory1 /home/reyhaneheb/NewFolder1 /home/reyhaneheb/NewFolder2 /home/reyhaneheb/os_lab"
DEST_DIR="/home/reyhaneheb/backups"
FILE_TYPES="txt,pdf,docx"
ENCRYPTION_ENABLED=false
RETENTION_DAYS=7
## ⏰ Scheduling Automatic Backups with Cron

You can automate daily or weekly backups using a cron job.

### 📌 Steps:

1. Open the crontab editor:

```bash
crontab -e
Add the following line to run the script daily at 2 AM:
0 2 * * * /home/reyhaneheb/backup-project/backup.sh -d /home/reyhaneheb/backups -f txt,pdf -r 7 --encrypt
Save and close the editor
