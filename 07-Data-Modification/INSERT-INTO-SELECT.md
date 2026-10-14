# INSERT Into SELECT

> Part of **Complete SQL Notes** (`07-Data-Modification`). [Back to roadmap](../README.md).

## Simple Definition
Copy rows from one query directly into a table. No manual VALUES.
## Why Needed
Backup toppers, archive old enrollments, seed test tables, copy attendance snapshot.
## Basic Syntax
```sql
INSERT INTO target_table (col1, col2) SELECT col1, col2 FROM source_table WHERE cond;
CREATE TABLE backup AS SELECT ...;
```
## Keywords Explained
Column list must match SELECT order/count/types. SELECT runs first, then inserts. IGNORE/ON DUPLICATE handle clashes. Must satisfy NOT NULL/UNIQUE/FK.
## Examples

### Ex1 Backup table (DDL+copy)

```sql
DROP TABLE IF EXISTS toppers_backup;
CREATE TABLE toppers_backup AS SELECT s.name, c.course_name, m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN courses c ON e.course_id=c.course_id JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE m.marks_obtained>=85;
SELECT * FROM toppers_backup;
DROP TABLE toppers_backup;
```

### Ex2 Archive enrollments copy

```sql
DROP TABLE IF EXISTS enroll_archive;
CREATE TABLE enroll_archive LIKE enrollments;
INSERT INTO enroll_archive (student_id,course_id,semester,academic_year) SELECT student_id,course_id,semester,academic_year FROM enrollments WHERE academic_year='2023-24';
SELECT COUNT(*) FROM enroll_archive;
DROP TABLE enroll_archive;
```

### Ex3 Insert new course from existing row pattern

```sql
START TRANSACTION;
INSERT INTO courses (course_name,credits,dept_id) SELECT CONCAT(course_name,' - Lab'),2,dept_id FROM courses WHERE course_id=1;
SELECT * FROM courses WHERE course_name='Database Management - Lab';
ROLLBACK;
```

### Ex4 Copy attendance snapshot with constant

```sql
DROP TABLE IF EXISTS att_snap;
CREATE TABLE att_snap AS SELECT student_id,course_id,percentage,'2023-24' AS snap_year FROM attendance;
SELECT COUNT(*) FROM att_snap;
DROP TABLE att_snap;
```

### Ex5 Duplicate-safe insert

```sql
INSERT IGNORE INTO departments (dept_id,dept_name,hod_name) SELECT 1,'Computer Science','X';
```

### Ex6 INSERT...SELECT with JOIN (honor list)

```sql
DROP TABLE IF EXISTS honor_list;
CREATE TABLE honor_list AS SELECT s.student_id,s.name,AVG(m.marks_obtained) AS avg_m FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN marks m ON m.enrollment_id=e.enrollment_id GROUP BY s.student_id,s.name HAVING AVG(m.marks_obtained)>=80;
SELECT * FROM honor_list;
DROP TABLE honor_list;
```
## Expected Changes
Target +N rows; SELECT verifies. Mismatch -> error, nothing inserted.
## Steps
1 Match columns, 2 SELECT alone first, 3 INSERT...SELECT, 4 verify count.
## Common Mistakes
1 Count mismatch -> 1136 error. 2 Types mismatch. 3 Duplicates without IGNORE. 4 FK fail on copy. 5 Forgetting temp cleanup.
## Exam/Interview
No VALUES needed; column order matters; CREATE AS quick backup; IGNORE vs strict; useful for archiving/migration.
10. Practice 5Q+A
Q1 Backup toppers? A Ex1 (3 rows). Q2 Archive 2023-24? A Ex2 (8). Q3 Lab course copy? A Ex3. Q4 Honor avg>=80? A Ex6 (4 rows). Q5 Duplicate dept IGNORE? A 0 rows, kept.
## Revision
Test SELECT first, match columns, verify count, drop temp tables.
