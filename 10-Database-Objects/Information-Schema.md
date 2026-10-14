INFORMATION SCHEMA

1. Definition
INFORMATION_SCHEMA is a read only metadata database. It lists tables, columns, keys, views, routines, events.

2. Purpose and use cases
List 6 tables. Show student columns. Audit foreign keys and indexes. Find views and routines after cleanup.

3. Syntax
```sql
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'sql_notes';
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sql_notes' AND TABLE_NAME = 'students';
SHOW TABLES;
DESCRIBE students;
SHOW CREATE TABLE students;
```

4. Explanation of keywords
TABLES, COLUMNS, STATISTICS, KEY_COLUMN_USAGE, TABLE_CONSTRAINTS, REFERENTIAL_CONSTRAINTS, VIEWS, ROUTINES, EVENTS. Read only. Always filter by TABLE_SCHEMA. SHOW and DESCRIBE are quick helpers.

5. Examples
Example 1. List tables
```sql
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'sql_notes' ORDER BY TABLE_NAME;
```
Expected output
attendance, courses, departments, enrollments, marks, students. 6 tables.

Example 2. Student columns
```sql
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'sql_notes' AND TABLE_NAME = 'students' ORDER BY ORDINAL_POSITION;
```
Expected output
7 columns from student_id to enrollment_year.

Example 3. Foreign keys
```sql
SELECT TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = 'sql_notes' AND REFERENCED_TABLE_NAME IS NOT NULL;
```
Expected output
8 foreign key rows across students, courses, enrollments, marks, attendance.

Example 4. Indexes
```sql
SELECT TABLE_NAME, INDEX_NAME, COLUMN_NAME FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = 'sql_notes' ORDER BY TABLE_NAME;
```
Expected output
Primary plus unique plus foreign helpers per table.

Example 5. Routines and views
```sql
SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'sql_notes';
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA = 'sql_notes';
```
Expected output
0 after cleanup, since demo routines and views are dropped.

6. Common mistakes
No schema filter so mysql and sys rows appear.
Trying to write to it. It is read only.
Trusting TABLE_ROWS as exact. It is estimate for InnoDB.
Case and quote errors.
Mixing mysql database with INFORMATION_SCHEMA.

7. Performance and safety
Read only and safe. Needs some privileges for full columns.

8. Practice questions with answers
Q1. How many tables.
A1. 6. Tests TABLES filter.
Q2. How many student columns.
A2. 7. Tests COLUMNS order.
Q3. How many foreign keys.
A3. 8. Tests KEY_COLUMN_USAGE.
Q4. Where to see enroll indexes.
A4. STATISTICS. Tests index metadata.
Q5. Views after drop.
A5. 0. Tests VIEWS check.

9. Revision summary
Metadata hub. Filter by schema. TABLES, COLUMNS, KEY usage, STATISTICS.
