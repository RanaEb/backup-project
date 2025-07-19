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
