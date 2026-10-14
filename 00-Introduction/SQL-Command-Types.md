# SQL Command Types

> Part of **Complete SQL Notes** (`00-Introduction`). [Back to roadmap](../README.md).

## Overview

SQL commands are grouped into five categories based on what they do.

| Category | Full Name | Purpose |
| --- | --- | --- |
| DDL | Data Definition Language | Define and change database structure |
| DML | Data Manipulation Language | Insert, update, delete data |
| DQL | Data Query Language | Retrieve data |
| DCL | Data Control Language | Manage access and permissions |

TCL         Transaction Control Language Manage transactions

Note: Some textbooks merge DQL into DML since SELECT retrieves data.
For learning purposes, DQL is kept separate here.

## Ddl - data definition language

DDL commands define, change, or remove the structure of database objects
such as databases, tables, and indexes.

DDL changes are auto-committed in MySQL. You cannot ROLLBACK after DDL.

Command     Purpose

CREATE      Create a database, table, view, or index

ALTER       Modify an existing table (add, remove, or change columns)

DROP        Permanently delete a database or table

TRUNCATE    Delete all rows from a table (faster than DELETE, no rollback)

RENAME      Rename a table

Examples:

```sql
CREATE DATABASE sql_notes;
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name       VARCHAR(100) NOT NULL
);
ALTER TABLE students ADD COLUMN phone VARCHAR(15);
ALTER TABLE students DROP COLUMN phone;
TRUNCATE TABLE attendance;
DROP TABLE attendance;
RENAME TABLE attendance TO student_attendance;
```

## Dml - data manipulation language

DML commands add, modify, or remove data inside tables.
DML changes can be rolled back if they are inside a transaction.

Command     Purpose

INSERT      Add new rows to a table

UPDATE      Modify existing rows

DELETE      Remove specific rows

REPLACE     Insert a row, or replace it if the primary key already exists

Examples:

```sql
INSERT INTO students (name, age, gender, email, dept_id, enrollment_year)
VALUES ('Abhishek', 20, 'M', 'abhishek@college.edu', 1, 2023);
UPDATE students SET age = 22 WHERE name = 'Jeevan';
DELETE FROM students WHERE name = 'Manjunath';
REPLACE INTO students (student_id, name, age, gender, email, dept_id, enrollment_year)
VALUES (5, 'Manjunath', 23, 'M', 'manjunath@college.edu', 3, 2022);
```

## Dql - data query language

DQL retrieves data from tables. There is only one command: SELECT.

SELECT is the most used SQL command. It has many optional clauses:

```sql
SELECT column1, column2
FROM   table_name
WHERE  condition
GROUP BY column
HAVING group_condition
ORDER BY column ASC|DESC
LIMIT  n;
```

Examples:

```sql
SELECT * FROM students;
SELECT name, age FROM students;
SELECT name FROM students WHERE dept_id = 1;
```

## Dcl - data control language

DCL commands control who can access or modify the database.
Used mainly by Database Administrators (DBAs).

Command     Purpose
GRANT       Give a user specific permissions
REVOKE      Remove permissions from a user

Examples:

```sql
CREATE USER 'teacher'@'localhost' IDENTIFIED BY 'pass123';
GRANT SELECT ON sql_notes.* TO 'teacher'@'localhost';
REVOKE SELECT ON sql_notes.* FROM 'teacher'@'localhost';
```

## Tcl - transaction control language

TCL commands manage transactions. A transaction is a group of SQL statements
that must all succeed or all fail together.

Command             Purpose

COMMIT              Permanently save all changes in the current transaction

ROLLBACK            Undo all changes since the last COMMIT or SAVEPOINT

```sql
SAVEPOINT           Create a named checkpoint inside a transaction
```

RELEASE SAVEPOINT   Remove a named savepoint

```sql
SET AUTOCOMMIT      Enable or disable automatic commit
```

Why transactions matter:

  If you transfer money from account A to account B and the system crashes
  after debiting A but before crediting B, money is lost. A transaction
  prevents this by treating both steps as one unit.

```sql
START TRANSACTION;
UPDATE accounts SET balance = balance - 5000 WHERE account = 'A';
UPDATE accounts SET balance = balance + 5000 WHERE account = 'B';
COMMIT;
```

Using SAVEPOINT:

```sql
START TRANSACTION;
INSERT INTO students (name, age, gender, email, dept_id)
VALUES ('TestStudent', 20, 'M', 'test@college.edu', 1);
SAVEPOINT before_marks;
INSERT INTO marks (enrollment_id, marks_obtained, max_marks, grade)
VALUES (99, 50, 100, 'C');
ROLLBACK TO before_marks;
COMMIT;
```

## Command summary

| Command | Category | Auto-Commit | Can Rollback |
| --- | --- | --- | --- |
| CREATE | DDL | Yes | No |
| ALTER | DDL | Yes | No |
| DROP | DDL | Yes | No |
| TRUNCATE | DDL | Yes | No |
| INSERT | DML | No* | Yes |
| UPDATE | DML | No* | Yes |
| DELETE | DML | No* | Yes |
| SELECT | DQL | -- | -- |
| GRANT | DCL | Yes | No |
| REVOKE | DCL | Yes | No |
| COMMIT | TCL | -- | -- |
| ROLLBACK | TCL | -- | -- |

* MySQL has AUTOCOMMIT ON by default, so each DML runs as its own
  transaction unless you use START TRANSACTION explicitly.

## MySQL vs Other Databases

| Feature | MySQL 8.0 | PostgreSQL | SQL Server |
| --- | --- | --- | --- |
| TRUNCATE rollback | Not possible | Possible in a transaction | Possible in a transaction |
| REPLACE command | Yes | No (use INSERT ON CONFLICT) | No |
| RENAME TABLE | Yes | ALTER TABLE ... RENAME TO | sp_rename |

## Common Mistakes

## Using DROP when you meant TRUNCATE

TRUNCATE removes all rows but keeps the table structure.

DROP removes the entire table. You would need to recreate it.

## Expecting ROLLBACK to work after DML with AUTOCOMMIT ON
   In MySQL, AUTOCOMMIT is ON by default. Once DML runs it is committed.
   Wrap it in START TRANSACTION ... COMMIT to be able to roll back.

## Using DELETE instead of TRUNCATE for bulk cleanup

```sql
DELETE FROM students; removes rows one by one and logs each deletion.
```

```sql
TRUNCATE TABLE students; is much faster and resets AUTO_INCREMENT.
```

## Confusing ALTER and UPDATE

ALTER changes the table structure (adds or removes columns).

UPDATE changes data inside the table.

## Trying to ROLLBACK a DDL command
   DDL is auto-committed in MySQL. DROP TABLE cannot be undone.

## Practice Questions

**Q1. Classify each: INSERT, CREATE TABLE, SELECT, GRANT, ROLLBACK.**

- **Answer:**

INSERT       = DML

```sql
CREATE TABLE = DDL
```

SELECT       = DQL

## Grant        = dcl

## Rollback     = tcl

**Q2. What is the difference between DELETE and TRUNCATE?**

- **Answer:**

DELETE removes specific rows (supports WHERE). It is slow and can be rolled back.

TRUNCATE removes all rows at once. It is fast, resets AUTO_INCREMENT,

  and cannot be rolled back in MySQL.

**Q3. A teacher should only view student marks, not change them. Which command?**

- **Answer:**
    GRANT SELECT ON sql_notes.marks TO 'teacher'@'localhost';
  To remove:
    REVOKE SELECT ON sql_notes.marks FROM 'teacher'@'localhost';

**Q4. You accidentally update Jeevitha's marks to 0. How do you undo it?**

- **Answer:**

## Start transaction;

```sql
SAVEPOINT before_jeevitha;
```

```sql
UPDATE marks SET marks_obtained = 0 WHERE mark_id = 7;
```

```sql
ROLLBACK TO before_jeevitha;
COMMIT;
```

**Q5. What happens if you run DROP TABLE students by mistake? Can you recover?**

- **Answer:**

```sql
DROP TABLE is DDL and auto-committed. You cannot ROLLBACK it.
```

  Recovery is only possible if you have a backup (mysqldump) or if
  binary logging is enabled.

## Revision Summary

| Category | Key Commands | Auto-Commit | Rollback |
| --- | --- | --- | --- |
| DDL | CREATE, ALTER, DROP, TRUNCATE | Yes | No |
| DML | INSERT, UPDATE, DELETE, REPLACE | No* | Yes |
| DQL | SELECT | -- | -- |
| DCL | GRANT, REVOKE | Yes | No |
| TCL | COMMIT, ROLLBACK, SAVEPOINT | -- | -- |
