# Basic SQL Queries & Explanations

## 1. SELECT (Read records)
```sql
SELECT id, title, owner, status FROM tasks WHERE status = 'Pending';
```
**What it does:** Retrieves the `id`, `title`, `owner`, and `status` columns from the `tasks` table for all rows where the status is currently `'Pending'`.

## 2. INSERT (Create a new record)
```sql
INSERT INTO tasks (title, owner, status)
VALUES ('Audit Apache access logs', 'Security Ops', 'Pending');
```
**What it does:** Adds a new row into the `tasks` table with the specified task title, owner, and initial status (`id` and `created_at` are filled automatically).

## 3. UPDATE (Modify an existing record)
```sql
UPDATE tasks
SET status = 'Completed'
WHERE title = 'Audit Apache access logs';
```
**What it does:** Changes the `status` column to `'Completed'` for the matching task row. Using a `WHERE` clause ensures only the intended row is updated rather than the entire table.

## 4. DELETE (Remove a record)
```sql
DELETE FROM tasks
WHERE title = 'Audit Apache access logs';
```
