Safe Data Modification
1. Simple Definition
Habits that prevent data loss: preview, txn, PK filter, backup, limit.
2. Why Needed
One missing WHERE wipes 5 students; FK errors confuse; DDL cannot undo.
3. Basic Syntax (safe template)
```sql
SELECT * FROM t WHERE cond;
START TRANSACTION;
UPDATE/DELETE ... WHERE PK=...;
SELECT * FROM t WHERE PK=...; SELECT ROW_COUNT();
```
4. Keywords Explained
Preview SELECT: same WHERE. ROW_COUNT(): affected n. LIMIT 1: extra guard. Safe-updates mode: `SET SQL_SAFE_UPDATES=1` forces WHERE with key. Backup: CREATE TABLE bak AS SELECT. DELETE vs TRUNCATE vs DROP: DELETE=DML undoable row-wise, TRUNCATE=DDL clears all fast commits, DROP=removes table.
5. Examples
Ex1 Safe UPDATE template (Abhishek age, rollback)
```sql
SELECT * FROM students WHERE student_id=1;
START TRANSACTION;
UPDATE students SET age=21 WHERE student_id=1;
SELECT * FROM students WHERE student_id=1; ROLLBACK;
```
Ex2 Dangerous vs safe
```sql
```
Ex3 Safe DELETE with count
```sql
SELECT * FROM enrollments WHERE academic_year='2099-00';
START TRANSACTION;
DELETE FROM enrollments WHERE academic_year='2099-00'; SELECT ROW_COUNT();
ROLLBACK;
```
Ex4 Backup before bulk
```sql
CREATE TABLE marks_bak AS SELECT * FROM marks;
START TRANSACTION; UPDATE marks SET grade='A' WHERE marks_obtained>=85; SELECT * FROM marks_bak LIMIT 2; ROLLBACK; DROP TABLE marks_bak;
```
Ex5 Safe mode
```sql
SET SQL_SAFE_UPDATES=1;
SET SQL_SAFE_UPDATES=0;
```
Ex6 FK-safe order
Parents first on INSERT (dept>student>enrollment>marks); children first on DELETE (marks>enrollment>student>dept). Never disable FK routinely.
6. Expected Changes
Safe path: 0-1 rows, verified, reversible. Unsafe: 5-8 rows, hard to restore.
7. Steps
Preview, backup if bulk, txn, PK WHERE, verify, commit/rollback.
8. Common Mistakes
1 No preview. 2 No txn. 3 Name-only WHERE. 4 TRUNCATE thinking undoable. 5 SET FOREIGN_KEY_CHECKS=0 routinely.
9. Exam/Interview
DELETE undoable/TRUNCATE not; safe-updates 1175; ROW_COUNT; backup pattern; FK order.
10. Practice 5Q+A
Q1 Preview query? A SELECT same WHERE. Q2 Guard all-row update? A PK + safe-updates. Q3 DELETE vs TRUNCATE vs DROP? A row-DML/fast-DDL/table-DDL. Q4 Backup marks? A Ex4. Q5 FK order? A parents-first insert.
11. Revision
Preview-txn-PK-verify-commit; backup bulk; never routine FK off.

