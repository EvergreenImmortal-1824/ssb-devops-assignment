# Backup & Restore Guide

## 1. Automated Backup Script
Run the backup script to dump the MySQL database and archive the deployed application files:
```bash
sudo ./scripts/backup.sh
```

## 2. Manual Backup Commands
- **Database backup (`mysqldump`):**
  ```bash
  mysqldump -h 127.0.0.1 -u ssb_app_user -p --no-tablespaces ssb_ops_db > backups/ssb_ops_db_manual.sql
  ```
- **Application files backup (`tar`):**
  ```bash
  tar -czf backups/ssb_app_files_manual.tar.gz -C /var/www/html ssb-app
  ```

## 3. Restore & Verification Commands
- **Create a test database and restore the SQL dump:**
  ```bash
  sudo mysql -e "CREATE DATABASE IF NOT EXISTS ssb_ops_restore_test;"
  sudo mysql ssb_ops_restore_test < backups/ssb_ops_db_YYYYMMDD_HHMMSS.sql
  ```
- **Verify restored records:**
  ```bash
  sudo mysql -e "USE ssb_ops_restore_test; SELECT * FROM tasks;"
  ```
- **Restore application files to a test directory:**
  ```bash
  mkdir -p /tmp/restore-test
  tar -xzf backups/ssb_app_files_YYYYMMDD_HHMMSS.tar.gz -C /tmp/restore-test
  ```
