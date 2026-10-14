DELETE
1. Simple Definition
DELETE removes rows. With WHERE removes some; without WHERE removes all rows (table stays, data gone).
2. Why Needed
Remove test enrollment, wrong marks row, duplicate attendance entry.
3. Basic Syntax
```sql
DELETE FROM table_name WHERE condition;
DELETE FROM enrollments WHERE enrollment_id=99;
DELETE s FROM students s JOIN enrollments e ON s.student_id=e.student_id WHERE e.enrollment_id=99;
```
4. Keywords Explained
DELETE FROM: target. WHERE: which rows (PK safest). Subquery: `WHERE id IN (SELECT...)`. FK: parent delete blocked by RESTRICT, cascades with CASCADE. TRUNCATE/DROP differ (see Safe file).
5. Examples (core 5 never deleted; test rows only)
Ex1 Safe test-row cycle
```sql
START TRANSACTION;
INSERT INTO students (student_id,name,age,gender,email,dept_id,enrollment_year) VALUES (103,'DelTest',20,'M','deltest@college.edu',1,2024);
SELECT * FROM students WHERE student_id=103;
DELETE FROM students WHERE student_id=103;
SELECT * FROM students WHERE student_id=103;
ROLLBACK;
```
Ex2 Delete test enrollment
```sql
START TRANSACTION;
INSERT INTO enrollments (student_id,course_id,semester,academic_year) VALUES (3,2,4,'2024-25');
SELECT * FROM enrollments WHERE student_id=3 AND course_id=2 AND academic_year='2024-25';
DELETE FROM enrollments WHERE student_id=3 AND course_id=2 AND academic_year='2024-25';
ROLLBACK;
```
Ex3 Subquery delete (marks of test enrollment)
```sql
START TRANSACTION;
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester,academic_year) VALUES (100,3,4,4,'2024-25');
INSERT INTO marks (enrollment_id,marks_obtained,max_marks,grade) VALUES (100,70,100,'B');
DELETE FROM marks WHERE enrollment_id IN (SELECT enrollment_id FROM enrollments WHERE enrollment_id=100);
DELETE FROM enrollments WHERE enrollment_id=100;
ROLLBACK;
```
Ex4 FK block demo
```sql
DELETE FROM departments WHERE dept_id=1;
```
Ex5 CASCADE demo on test chain
```sql
START TRANSACTION;
INSERT INTO students (student_id,name,gender,email,dept_id,enrollment_year) VALUES (104,'CasTest','M','castest@college.edu',1,2024);
INSERT INTO enrollments (enrollment_id,student_id,course_id,semester,academic_year) VALUES (101,104,2,3,'2024-25');
DELETE FROM students WHERE student_id=104;
SELECT * FROM enrollments WHERE enrollment_id=101;
ROLLBACK;
```
Ex6 Multi-row with condition (test only)
```sql
START TRANSACTION;
DELETE FROM enrollments WHERE academic_year='2099-00';
SELECT ROW_COUNT();
ROLLBACK;
```
6. Expected Changes
Row disappears; SELECT empty; FK error changes nothing. CASCADE removes children.
7. Steps
1 SELECT preview, 2 txn, 3 DELETE, 4 verify + check children, 5 COMMIT/ROLLBACK.
8. Common Mistakes
1 No WHERE deletes all. Fix: preview. 2 Deleting parent with children -> 1451. Fix: delete children first or don't. 3 Disabling FK checks routinely -> corrupt data. Don't. 4 Confusing DELETE/TRUNCATE/DROP. 5 No txn on bulk delete.
9. Exam/Interview
DELETE is DML, logged, rollback-able, needs WHERE; RESTRICT blocks, CASCADE auto-deletes; TRUNCATE DDL implicit commit; 1451 vs 1452.
10. Practice 5Q+A
Q1 Delete test student 103? A Ex1. Q2 Delete Likhith test enrollment? A Ex2. Q3 Why dept 1 fails? A RESTRICT children exist. Q4 CASCADE proof? A Ex5. Q5 Preview before delete? A SELECT same WHERE + txn.
11. Revision
PK in WHERE, txn wrap, expect 1451 on parents, never touch core 5 without ROLLBACK demo.

