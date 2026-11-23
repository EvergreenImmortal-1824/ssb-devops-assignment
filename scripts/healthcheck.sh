#!/usr/bin/env bash
set -euo pipefail

APP_URL="http://127.0.0"

echo "[CHECK] Testing Apache HTTP response at $APP_URL..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")
if [[ "$HTTP_CODE" != "200" ]]; then
    echo "[FAIL] Expected HTTP 200 from Apache, got $HTTP_CODE" >&2
    exit 1
fi
echo "[OK] Apache returned HTTP $HTTP_CODE."

echo "[CHECK] Testing MySQL service availability..."
if ! sudo mysqladmin ping --silent; then
    echo "[FAIL] MySQL is not responding." >&2
    exit 1
fi
echo "[OK] MySQL is alive and responding."

