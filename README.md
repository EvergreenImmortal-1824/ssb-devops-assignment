# SSB Digital | Junior DevOps / Web Operations Take-Home Assignment

A practical LAMP/Web Operations implementation featuring a Core PHP & MySQL task-tracking application, automated `rsync` deployment, `mysqldump` backup/restore workflows, health checks, and incident troubleshooting documentation.

## Repository Structure
```text
ssb-devops-assignment/
├── app/                # Core PHP source code and config.example.php
├── database/           # SQL schema, sample data, and phpMyAdmin export/import files
├── scripts/            # deploy.sh, backup.sh, and healthcheck.sh
├── docs/               # SQL query explanations, backup guide, and incident note
├── screenshots/        # Visual verification of setup, phpMyAdmin, rsync, backup/restore & logs
├── .gitignore
└── README.md
```

## 1. Prerequisites & LAMP Setup (WSL / Ubuntu)
- **Environment:** Ubuntu on WSL2 with Apache2, MySQL 8, PHP 8 (`php-mysql`), and phpMyAdmin.
- **Install & Start Services:**
  ```bash
  sudo apt update && sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql phpmyadmin
  sudo service mysql start
  sudo service apache2 start
  ```
- **Verify Ports & Logs:**
  - Ports check: `sudo ss -tulpn | grep -E 'apache2|mysqld'` (Apache on `:80`, MySQL on `:3306`)
  - Apache/PHP Error Log: `/var/log/apache2/error.log`
  - Apache Access Log: `/var/log/apache2/access.log`
  - MySQL Error Log: `/var/log/mysql/error.log`

## 2. Database & Application Setup
1. **Create Database, Non-Root User & Sample Table:**
   ```bash
   sudo mysql < database/schema.sql
   ```
   *(Creates `ssb_ops_db`, restricted user `ssb_app_user`, and table `tasks` with sample rows.)*
2. **Configure Application Secrets Locally:**
   ```bash
   cp app/config.example.php app/config.php
   # Update db_pass in app/config.php (excluded from Git via .gitignore)
   ```

## 3. Deployment (`rsync`)
1. **Preview changes safely (`--dry-run`):**
   ```bash
   sudo ./scripts/deploy.sh --dry-run
   ```
2. **Deploy to `/var/www/html/ssb-app/` with safe permissions (`755` dirs / `644` files):**
   ```bash
   sudo ./scripts/deploy.sh
   ```
   *Excludes `.git/`, `.env`, `config.php`, `logs/`, and `backups/`, transferring only modified files.*
3. **Run Health Check:**
   ```bash
   ./scripts/healthcheck.sh
   ```

## 4. Backup & Restore
- **Create Database (`mysqldump`) & Application (`tar`) Backups:**
  ```bash
  sudo ./scripts/backup.sh
  ```
- **Restore to Test Database & Verify:**
  ```bash
  sudo mysql -e "CREATE DATABASE IF NOT EXISTS ssb_ops_restore_test;"
  sudo mysql ssb_ops_restore_test < backups/ssb_ops_db_YYYYMMDD_HHMMSS.sql
  sudo mysql -e "USE ssb_ops_restore_test; SELECT * FROM tasks;"
  ```
  *(Full commands documented in `docs/backup-restore.md`.)*

## 5. SQL Queries & Troubleshooting Notes
- **Basic SQL Queries (`SELECT`, `INSERT`, `UPDATE`, `DELETE`):** Documented in [`docs/sql-queries.md`](docs/sql-queries.md).
- **Troubleshooting Incident Note:** Simulated DB credential mismatch (`SQLSTATE[HY000] Access denied`), diagnosed via `/var/log/apache2/error.log`, resolved, and documented in [`docs/troubleshooting-incident.md`](docs/troubleshooting-incident.md).

## 6. Evidence Checklist
All verification screenshots are saved inside the [`screenshots/`](screenshots/) directory:
- [x] Apache/PHP health & working PHP application (`http://127.0.0`)
- [x] phpMyAdmin database/table view, SQL export, and SQL import
- [x] `rsync --dry-run` and incremental changed-file deployment output
- [x] `mysqldump` backup creation and verified restore into `ssb_ops_restore_test`
- [x] Apache error log evidence for troubleshooting exercise
