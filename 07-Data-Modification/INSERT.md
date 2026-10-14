# Insert

> Part of **Complete SQL Notes** (`07-Data-Modification`). [Back to roadmap](../README.md).

## Simple Definition

INSERT adds new rows to a table. One row or many rows at once.

## Why Needed
Add new student, course, enrollment, marks, attendance without rebuilding tables.
## Basic Syntax
```sql
INSERT INTO table_name (col1, col2) VALUES (val1, val2);
INSERT INTO table_name (col1, col2) VALUES (a1,a2),(b1,b2);
```
## Keywords Explained
INTO: target table. Column list: which columns you supply (always list them). VALUES: the data. Omit AUTO_INCREMENT PK to auto-generate. DEFAULT: use column default. NULL: only if column allows it.
5. Examples (college DB, USE sql_notes)

### Ex1 One department

```sql
INSERT INTO departments (dept_name, hod_name) VALUES ('Civil','Dr. Test HOD');
```
Verify: `SELECT * FROM departments WHERE dept_name='Civil';`

### Ex2 Multi-row courses

```sql
INSERT INTO courses (course_name, credits, dept_id) VALUES ('Python Lab',2,1),('Web Lab',2,1);
```

### Ex3 Student with explicit columns (safe test row id 100+)

```sql
INSERT INTO students (student_id,name,age,gender,email,dept_id,enrollment_year) VALUES (101,'TestStu',20,'M','teststu@college.edu',1,2024);
```
Verify: `SELECT student_id,name FROM students WHERE student_id=101;` Cleanup: `DELETE FROM students WHERE student_id=101;`

### Ex4 NULL and DEFAULT

```sql
INSERT INTO students (name,age,gender,email,dept_id,enrollment_year) VALUES ('DemoNull',NULL,'M','demonull@college.edu',1,DEFAULT);
```

### Ex5 Safe enrollment (valid FKs, unique combo)

```sql
INSERT INTO enrollments (student_id,course_id,semester,academic_year) VALUES (3,2,4,'2024-25');
```

### Ex6 Rejected FK

```sql
INSERT INTO enrollments (student_id,course_id,semester,academic_year) VALUES (999,1,3,'2023-24');
```
## Expected Changes
Row counts +1 (or +N). SELECT shows new row. Failed INSERT changes nothing.
## Steps
1 Pick table, 2 list columns, 3 check parents exist, 4 INSERT, 5 SELECT verify.
## Common Mistakes
1 No column list -> breaks if schema changes. Fix: always list columns. 2 Duplicate PK/email -> 1062 error. Fix: omit auto id, use unique email. 3 Wrong dept_id -> 1452. Fix: SELECT dept first. 4 Wrong order (child before parent). Fix: departments>students/courses>enrollments>marks. 5 Too many/few values vs columns. Fix: count match.
## Exam/Interview
Column list required practice; AUTO_INCREMENT omit; FK checked on INSERT; UNIQUE (email, dept_name, uq_enroll); DEFAULT only if defined; multi-row faster than N singles.
10. Practice 5Q+A
Q1 Add Electronics course? A: `INSERT INTO courses(course_name,credits,dept_id) VALUES('VLSI',4,3);` Q2 Add test student? A Ex3. Q3 Why 1452? A parent missing. Q4 Insert 2 depts at once? A multi VALUES. Q5 Verify insert? A SELECT by PK/email.
## Revision

```sql
INSERT+column list+VALUES; parents first; verify SELECT; duplicates/FK errors protect data.
```
