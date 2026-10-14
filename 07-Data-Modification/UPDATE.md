# Update

> Part of **Complete SQL Notes** (`07-Data-Modification`). [Back to roadmap](../README.md).

## Simple Definition

```sql
UPDATE changes existing rows. With WHERE it changes some rows; without WHERE it changes every row.
```

## Why Needed
Fix email, correct marks, bump semester, update attendance after classes.
## Basic Syntax
```sql
UPDATE table_name SET col1=val1 WHERE condition;
UPDATE table_name SET col1=val1, col2=val2 WHERE condition;
UPDATE s JOIN departments d ON s.dept_id=d.dept_id SET s.age=21 WHERE s.name='Likhith';
```
## Keywords Explained

UPDATE: target. SET: new values (comma for many). WHERE: which rows (PK like student_id=3 safest). JOIN+SET: MySQL allows UPDATE with JOIN. Subquery in WHERE/SET allowed.

## Examples

### Ex1 One column, one student (preview first)

```sql
SELECT student_id,name,age FROM students WHERE name='Likhith';
UPDATE students SET age=21 WHERE student_id=3;
SELECT student_id,name,age FROM students WHERE student_id=3;
```

### Ex2 Multi-column (test row only)

```sql
START TRANSACTION;
INSERT INTO students (student_id,name,age,gender,email,dept_id,enrollment_year) VALUES (102,'UpdTest',20,'M','updtest@college.edu',1,2024);
UPDATE students SET age=21, email='updtest2@college.edu' WHERE student_id=102;
SELECT * FROM students WHERE student_id=102;
ROLLBACK;
```

### Ex3 Marks for one course

```sql
SELECT * FROM marks WHERE enrollment_id=5;
START TRANSACTION;
UPDATE marks SET marks_obtained=60.00, grade='C' WHERE enrollment_id=5;
SELECT * FROM marks WHERE enrollment_id=5;
ROLLBACK;
```

### Ex4 UPDATE with subquery (Jeevitha DBMS +2 bonus, capped 100)

```sql
START TRANSACTION;
UPDATE marks SET marks_obtained=LEAST(marks_obtained+2,100) WHERE enrollment_id IN (SELECT enrollment_id FROM enrollments WHERE student_id=4 AND course_id=1);
ROLLBACK;
```

### Ex5 UPDATE with JOIN (CS students age+0 demo: set same value safely)

```sql
START TRANSACTION;
UPDATE students s JOIN departments d ON s.dept_id=d.dept_id SET s.enrollment_year=2023 WHERE d.dept_name='Computer Science' AND s.student_id=1;
SELECT * FROM students WHERE student_id=1;
ROLLBACK;
```

### Ex6 DANGER demo (never run on real data)


## Expected Changes
`Rows matched: 1 Changed: 1`. SELECT after shows new value. ROLLBACK restores.
## Steps
1 SELECT preview with same WHERE, 2 START TRANSACTION, 3 UPDATE, 4 SELECT verify, 5 COMMIT or ROLLBACK.
## Common Mistakes
1 Missing WHERE -> all rows. Fix: always preview. 2 Wrong WHERE (name only, duplicates). Fix: use PK. 3 Violates CHECK (age 50). Fix: respect 15-30. 4 Duplicate email. Fix: unique check first. 5 Updates generated column percentage directly -> error. Fix: update attended/total only.
## Exam/Interview
WHERE decides scope; test with SELECT; transactions make UPDATE reversible (InnoDB); JOIN update is MySQL extension; subquery update allowed; ROW_COUNT() tells affected.
10. Practice 5Q+A
Q1 Likhith age 21? A Ex1. Q2 Marks enr 5 to 60? A Ex3 (in txn). Q3 Bonus +2 Jeevitha DBMS? A Ex4. Q4 All CS year? A Ex5 pattern. Q5 What does no-WHERE do? A updates all 5 - dangerous.
## Revision
Preview SELECT, PK in WHERE, txn wrap, verify, then commit. No WHERE = all rows.
