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
