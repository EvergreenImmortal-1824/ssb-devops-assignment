# Troubleshooting Exercise: Incident Note

## Incident Summary (8 lines)
- **Issue / Symptom:** The internal ops web application (`http://127.0.0`) returned an HTTP 500 error displaying `"Database connection error. Check server logs for details."`
- **Checks Performed:** Verified Apache and MySQL service statuses (`sudo service mysql status`), tested HTTP response headers (`curl -I`), and inspected `/var/log/apache2/error.log`.
- **Root Cause:** Invalid database credentials in `/var/www/html/ssb-app/config.php` caused MySQL to reject authentication for `ssb_app_user` (`SQLSTATE[HY000] [1045] Access denied`).
- **Resolution / Fix:** Updated `'db_pass'` in `/var/www/html/ssb-app/config.php` to match the valid credentials for `ssb_app_user` and verified an `HTTP/1.1 200 OK` response.
- **Prevention:** Keep `config.php` excluded from `rsync` deployments (`--exclude='config.php'`), restrict file permissions (`chmod 640`), and run a post-deploy health check script to catch connection failures immediately.

## Command & Log Evidence
```text
\$ sudo tail -n 5 /var/log/apache2/error.log
[php:notice] Database connection failed: SQLSTATE[HY000] [1045] Access denied for user 'ssb_app_user'@'127.0.0.1' (using password: YES)
```
