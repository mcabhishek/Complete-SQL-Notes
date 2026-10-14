# Commit Rollback Savepoint

> Part of **Complete SQL Notes** (`07-Data-Modification`). [Back to roadmap](../README.md).

## Simple Definition

COMMIT saves, ROLLBACK undoes all, SAVEPOINT bookmarks inside txn for partial undo.

## Why Needed
Try risky update, keep good part, undo bad part without losing everything.
## Basic Syntax
```sql
START TRANSACTION;
UPDATE ...; SAVEPOINT sp1;
UPDATE ...; ROLLBACK TO sp1;
COMMIT;
RELEASE SAVEPOINT sp1;
```
## Keywords Explained

SAVEPOINT name: marker. ROLLBACK TO: rewind to marker (txn stays open). RELEASE: delete marker. COMMIT after partial rollback saves remainder. Transaction boundary: START to COMMIT/ROLLBACK.

## Examples

### Ex1 Savepoint partial rollback (test dept names)

```sql
START TRANSACTION;
INSERT INTO departments (dept_name,hod_name) VALUES ('SpTest1','H1');
SAVEPOINT sp1;
INSERT INTO departments (dept_name,hod_name) VALUES ('SpTest2','H2');
SELECT * FROM departments WHERE dept_name LIKE 'SpTest%';
ROLLBACK TO sp1;
SELECT * FROM departments WHERE dept_name LIKE 'SpTest%';
COMMIT;
SELECT * FROM departments WHERE dept_name='SpTest1';
DELETE FROM departments WHERE dept_name='SpTest1';
```

### Ex2 Two marks updates, keep first

```sql
START TRANSACTION;
UPDATE marks SET grade='A' WHERE enrollment_id=2;
SAVEPOINT g1;
UPDATE marks SET marks_obtained=999 WHERE enrollment_id=2;
ROLLBACK TO g1;
SELECT enrollment_id,marks_obtained,grade FROM marks WHERE enrollment_id=2;
ROLLBACK;
```

### Ex3 RELEASE + COMMIT

```sql
START TRANSACTION;
INSERT INTO departments (dept_name,hod_name) VALUES ('RelTest','H');
SAVEPOINT r1; RELEASE SAVEPOINT r1;
COMMIT;
DELETE FROM departments WHERE dept_name='RelTest';
```

### Ex4 ROLLBACK without txn = nothing

```sql
ROLLBACK;
```

### Ex5 Error handling pattern

```sql
START TRANSACTION;
```

### Ex6 Boundaries

```sql
START TRANSACTION; SELECT * FROM students WHERE student_id=1; COMMIT;
```
## Expected Changes
After TO: rows after marker gone, before marker pending. After COMMIT: pending permanent.
## Steps
1 START, 2 work, 3 SAVEPOINT, 4 risky, 5 TO if bad, 6 COMMIT good.
## Common Mistakes
1 ROLLBACK TO then forgetting final COMMIT/ROLLBACK -> txn hangs. 2 Same savepoint name reuse confusion. 3 Expecting savepoint across COMMIT (cleared). 4 DDL between savepoints commits all. 5 No txn then TO -> error 1305.
## Exam/Interview

```sql
SAVEPOINT only inside txn; TO keeps txn alive; COMMIT ends all; RELEASE optional; nested markers allowed.
```

10. Practice 5Q+A
Q1 Keep first insert only? A Ex1. Q2 Undo second update? A Ex2. Q3 RELEASE use? A Ex3. Q4 ROLLBACK vs TO? A all vs to marker. Q5 After COMMIT savepoint? A gone.
## Revision
START-SAVE-TO-COMMIT; TO = partial undo; end with COMMIT/ROLLBACK.
