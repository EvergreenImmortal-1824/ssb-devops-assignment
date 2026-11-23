#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/var/www/html/ssb-app"
CONFIG_FILE="${APP_DIR}/config.php"
BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE}")/.." && pwd)/backups"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

# 1. Validate required files and commands
for cmd in mysqldump tar php; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "[ERROR] Required command not found: $cmd" >&2
        exit 1
    fi
done

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "[ERROR] Config file not found at $CONFIG_FILE" >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# 2. Extract DB credentials cleanly from config.php
DB_HOST=$(php -r "\$c = require '$CONFIG_FILE'; echo \$c['db_host'];")
DB_NAME=$(php -r "\$c = require '$CONFIG_FILE'; echo \$c['db_name'];")
DB_USER=$(php -r "\$c = require '$CONFIG_FILE'; echo \$c['db_user'];")
DB_PASS=$(php -r "\$c = require '$CONFIG_FILE'; echo \$c['db_pass'];")

DB_BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql"
APP_BACKUP_FILE="${BACKUP_DIR}/ssb_app_files_${TIMESTAMP}.tar.gz"

# 3. Create MySQL database backup using mysqldump
echo "[INFO] Backing up database '$DB_NAME'..."
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" --no-tablespaces "$DB_NAME" > "$DB_BACKUP_FILE"

# 4. Create application files backup (excluding config.php or keeping full archive)
echo "[INFO] Backing up application files from '$APP_DIR'..."
tar -czf "$APP_BACKUP_FILE" -C /var/www/html ssb-app

echo "[SUCCESS] Backups created:"
ls -lh "$DB_BACKUP_FILE" "$APP_BACKUP_FILE"
