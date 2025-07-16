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
