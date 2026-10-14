Transactions
1. Simple Definition
A transaction is a group of SQL statements that succeed together or fail together. All-or-nothing.
2. Why Needed
Enroll student + add marks + add attendance must all save; if marks fail, enrollment must undo. Keeps college data consistent.
3. Basic Syntax
```sql
START TRANSACTION;
INSERT INTO enrollments ...;
INSERT INTO marks ...;
COMMIT;
SET autocommit=0; SHOW VARIABLES LIKE 'autocommit';
```
4. Keywords Explained
START TRANSACTION/BEGIN: boundary start. COMMIT: permanent save. ROLLBACK: undo since start. SAVEPOINT sp1: bookmark. ROLLBACK TO sp1: partial undo. autocommit=1 (default): each stmt commits at once. InnoDB: engine that supports transactions (our tables use it by default).
5. Examples
Ex1 Full enrollment chain (test Likhith+OS, then rollback to keep data clean)
```sql
START TRANSACTION;
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester,academic_year) VALUES (200,3,4,4,'2024-25');
INSERT INTO marks (enrollment_id,marks_obtained,max_marks,grade) VALUES (200,77,100,'B');
INSERT INTO attendance (student_id,course_id,total_classes,attended_classes) VALUES (3,4,40,32);
SELECT * FROM enrollments WHERE enrollment_id=200;
SELECT * FROM marks WHERE enrollment_id=200;
ROLLBACK;
SELECT * FROM enrollments WHERE enrollment_id=200;
```
Ex2 COMMIT keeps change (temp then manual cleanup)
```sql
START TRANSACTION;
INSERT INTO departments (dept_name,hod_name) VALUES ('TestDept','Dr. T');
COMMIT;
SELECT * FROM departments WHERE dept_name='TestDept';
DELETE FROM departments WHERE dept_name='TestDept';
```
Ex3 Partial failure undoes all
```sql
START TRANSACTION;
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester,academic_year) VALUES (201,3,4,4,'2024-25');
INSERT INTO marks (enrollment_id,marks_obtained,max_marks,grade) VALUES (201,999,100,'A');
ROLLBACK;
SELECT * FROM enrollments WHERE enrollment_id=201;
```
Ex4 Autocommit demo
```sql
SELECT @@autocommit;
SET autocommit=0;
INSERT INTO departments (dept_name,hod_name) VALUES ('TempNoCommit','Dr. X');
ROLLBACK;
SET autocommit=1;
```
Ex5 DDL implicit commit warning
```sql
START TRANSACTION;
INSERT INTO departments (dept_name,hod_name) VALUES ('WillStay','Dr. Y');
CREATE TABLE temp_t (id INT);
ROLLBACK;
SELECT * FROM departments WHERE dept_name='WillStay';
DROP TABLE temp_t; DELETE FROM departments WHERE dept_name='WillStay';
```
Ex6 ACID in one line each
Atomicity Ex3 (all/undo). Consistency: CHECK/FK still enforced inside txn. Isolation: two sessions don't see uncommitted rows. Durability: after COMMIT, survives crash.
6. Expected Changes
Before COMMIT others may not see rows; after COMMIT permanent; after ROLLBACK as if never ran (except DDL).
7. Steps
1 START, 2 run chain, 3 SELECT verify, 4 COMMIT/ROLLBACK.
8. Common Mistakes
1 No txn for multi-table chain -> half-saved. 2 Assuming DDL rolls back -> it commits. 3 Leaving txn open locks rows. 4 autocommit=0 forgotten -> later stmts pile up. 5 MyISAM has no txn -> use InnoDB.
9. Exam/Interview
ACID full forms; START vs BEGIN same; COMMIT durable; ROLLBACK only DML; DDL implicit commit; InnoDB required.
10. Practice 5Q+A
Q1 Enroll+marks+attendance atomic? A Ex1. Q2 Prove atomicity? A Ex3. Q3 Autocommit default? A 1. Q4 DDL rollback? A No, Ex5. Q5 COMMIT vs ROLLBACK? A save vs undo.
11. Revision
START..COMMIT/ROLLBACK; InnoDB only; DDL commits; verify before commit.

