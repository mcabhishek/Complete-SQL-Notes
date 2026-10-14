Metadata And Database Inspection

1. Definition
Inspection means checking tables, columns, engine, counts before writing queries. Uses SHOW, DESCRIBE, COUNT.

2. Purpose and use cases
Verify 5 students and 8 marks. Check columns before INSERT. Confirm keys. Debug unknown column errors.

3. Syntax
```sql
SHOW TABLES;
DESCRIBE students;
SHOW CREATE TABLE enrollments;
SHOW INDEX FROM enrollments;
SELECT COUNT(*) FROM students;
SHOW TABLE STATUS LIKE 'students';
```

4. Explanation of keywords
SHOW TABLES lists objects. FULL adds type view or base. DESCRIBE shows columns. CREATE shows full DDL with keys. INDEX shows keys. COUNT gives exact rows. STATUS shows engine and estimate. Always USE sql_notes first.

5. Examples
Example 1. Verify counts
```sql
SHOW TABLES;
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM marks;
```
Expected output
6 tables. Students 5: Abhishek to Manjunath. Marks 8.

Example 2. Student columns
```sql
DESCRIBE students;
```
Expected output
7 rows. student_id PRI auto. email UNI. dept_id MUL.

Example 3. Enrollment DDL
```sql
SHOW CREATE TABLE enrollments;
```
Expected output
Shows unique triple plus 2 CASCADE foreign keys.

Example 4. Enrollment indexes
```sql
SHOW INDEX FROM enrollments;
```
Expected output
PRIMARY plus unique plus foreign helpers.

Example 5. Engine check
```sql
SHOW TABLE STATUS LIKE 'students';
```
Expected output
Engine InnoDB, safe for transactions.

6. Common mistakes
No USE so wrong database.
Trusting row estimate as exact.
Skipping check then error 1054 unknown column.
Ignoring engine. MyISAM has no transactions.
Mixing view and table.

7. Performance and safety
All read only and safe. Run before writes.

8. Practice questions with answers
Q1. How many tables.
A1. 6. Tests SHOW.
Q2. How many students.
A2. 5. Tests COUNT.
Q3. Email key type.
A3. UNI. Tests DESCRIBE.
Q4. Enrollment foreign keys.
A4. 2 CASCADE. Tests CREATE.
Q5. Engine.
A5. InnoDB. Tests STATUS.

9. Revision summary
SHOW plus DESCRIBE plus CREATE plus COUNT before tasks. Confirm InnoDB.
