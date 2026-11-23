#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../app" && pwd)/"
TARGET_DIR="/var/www/html/ssb-app/"
DRY_RUN=""

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN="--dry-run"
    echo "[INFO] Running in DRY-RUN mode (no files will be modified)."
fi

# 1. Pre-flight validation
if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "[ERROR] Source directory not found: $SOURCE_DIR" >&2
    exit 1
fi

if [[ ! -f "${SOURCE_DIR}index.php" ]]; then
    echo "[ERROR] Required file index.php missing in $SOURCE_DIR" >&2
    exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "[ERROR] Target deployment directory does not exist: $TARGET_DIR" >&2
    exit 1
fi

if [[ ! -f "${TARGET_DIR}config.php" && ! -f "${SOURCE_DIR}config.php" ]]; then
    echo "[ERROR] No config.php found in target or source. Aborting deployment." >&2
    exit 1
fi

# 2. Run rsync with exclusions
echo "[INFO] Syncing $SOURCE_DIR -> $TARGET_DIR ..."
rsync -av --itemize-changes $DRY_RUN \
    --exclude='.git/' \
    --exclude='.env' \
    --exclude='config.php' \
    --exclude='*.log' \
    --exclude='logs/' \
    --exclude='backups/' \
    "$SOURCE_DIR" "$TARGET_DIR"

# 3. Apply sensible ownership and permissions (skip during dry-run)
if [[ -z "$DRY_RUN" ]]; then
    chown -R www-data:www-data "$TARGET_DIR"
    find "$TARGET_DIR" -type d -exec chmod 755 {} \;
    find "$TARGET_DIR" -type f -exec chmod 644 {} \;
    if [[ -f "${TARGET_DIR}config.php" ]]; then
        chmod 640 "${TARGET_DIR}config.php"
    fi
    echo "[SUCCESS] Deployment completed and permissions verified."
else
    echo "[SUCCESS] Dry-run completed successfully."
fi

