#!/bin/bash
# Automated Backup Script
# Usage: ./backup.sh -d <backup_directory> -f <formats> [-r <retention_days>] [--dry-run] [--encrypt]
CONFIG_FILE="backup.conf"
LOG_FILE="backup.log"
RETENTION_DAYS=7
DRY_RUN=false
ENCRYPT=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -d|--destination) DESTINATION="$2"; shift ;;
    -f|--formats) FORMATS="$2"; shift ;;
    -r|--retention) RETENTION_DAYS="$2"; shift ;;
    --dry-run) DRY_RUN=true ;;
    --encrypt) ENCRYPT=true ;;
    -h|--help)
      echo "Usage: $0 -d <backup_dir> -f <extensions> [-r <retention_days>] [--dry-run] [--encrypt]"
      exit 0
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
  shift
done
# Check required parameters
if [[ -z "$DESTINATION" ]] || [[ -z "$FORMATS" ]]; then
  echo "Error: destination and formats are required."
  echo "Usage: $0 -d <backup_dir> -f <extensions> [-r <retention_days>] [--dry-run] [--encrypt]"
  exit 1
fi
# Check if destination directory exists
if [[ ! -d "$DESTINATION" ]]; then
  echo "Destination directory does not exist: $DESTINATION"
  exit 1
fi
# Read source directories from config file
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Config file $CONFIG_FILE not found!"
  exit 1
fi
readarray -t SOURCES < "$CONFIG_FILE"
FILES_TO_BACKUP=()
# Convert comma-separated formats to space-separated array
FORMATS_ARR=(${FORMATS//,/ })
for dir in "${SOURCES[@]}"; do
  for ext in "${FORMATS_ARR[@]}"; do
    if [[ -d "$dir" ]]; then
      found_files=$(find "$dir" -type f -name "*.$ext")
      for file in $found_files; do
        FILES_TO_BACKUP+=("$file")
      done
    else
      echo "Warning: Source directory does not exist: $dir"
    fi
  done
done
if [[ ${#FILES_TO_BACKUP[@]} -eq 0 ]]; then
  echo "No files found to backup."
  exit 0
fi
START_TIME=$(date +%s)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="backup_$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$DESTINATION/$ARCHIVE_NAME"
if [ "$DRY_RUN" = true ]; then
  echo "DRY RUN: The following files would be backed up:"
  printf "%s\n" "${FILES_TO_BACKUP[@]}"
  exit 0
fi
echo "Creating backup archive..."
tar -czf "$ARCHIVE_PATH" "${FILES_TO_BACKUP[@]}"
if [[ $? -ne 0 ]]; then
  echo "Backup failed!"
  exit 1
fi
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
SIZE=$(du -sh "$ARCHIVE_PATH" | cut -f1)
echo "$(date): Backup created: $ARCHIVE_NAME | Size: $SIZE | Duration: ${DURATION}s" >> "$LOG_FILE"
echo "Backup completed: $ARCHIVE_NAME"
echo "Size: $SIZE"
echo "Duration: ${DURATION} seconds"
deleted=$(find "$DESTINATION" -type f -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -print -exec rm {} \;)
if [[ -n "$deleted" ]]; then
  echo "$(date): Deleted old backups:" >> "$LOG_FILE"
  echo "$deleted" >> "$LOG_FILE"
fi
if [ "$ENCRYPT" = true ]; then
  echo "Encrypting backup..."
  gpg -c --batch --yes --passphrase "YourStrongPassword" "$ARCHIVE_PATH"
  if [[ $? -eq 0 ]]; then
    rm "$ARCHIVE_PATH"
    ARCHIVE_PATH="$ARCHIVE_PATH.gpg"
    echo "$(date): Backup encrypted to $ARCHIVE_PATH" >> "$LOG_FILE"
  else
    echo "Encryption failed!"
    exit 1
  fi
fi
EMAIL="ereyhaneh7@gmail.com"

