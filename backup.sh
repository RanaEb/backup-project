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
