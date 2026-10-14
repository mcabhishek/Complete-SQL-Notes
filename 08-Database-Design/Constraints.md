Constraints
1. Definition
Constraints are rules on tables that reject bad data. PK, FK, UNIQUE, NOT NULL, DEFAULT, CHECK.
2. Why
Stop duplicate email, invalid age 200, orphan enrollment 999, negative marks.
3. Syntax
```sql
CREATE TABLE t (id INT PRIMARY KEY, email VARCHAR(150) UNIQUE NOT NULL, age INT CHECK (age BETWEEN 15 AND 30), dept_id INT, FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT);
ALTER TABLE students ADD CONSTRAINT chk_age2 CHECK (age>=15); ALTER TABLE students DROP CHECK chk_age2;
```
4. Explained
PRIMARY KEY: unique+not null, one per table. FOREIGN KEY: must exist in parent. UNIQUE: no dupes (email, dept_name). NOT NULL: required. DEFAULT: auto value. CHECK: condition (MySQL 8 enforces). Naming: pk_/fk_/uq_/chk_.
5. Examples (our schema)
Ex1 PK students student_id auto. Ex2 FK students.dept_id->departments RESTRICT (blocks dept 1 delete 1451). Ex3 UQ email (dup abhishek@ fails 1062). Ex4 CHECK age 15-30 (50 fails 3819). Ex5 UQ enroll triple (dup 1,1,'2023-24' fails). Ex6 DEFAULT max_marks 100, enrollment_year cur year.
Try (rollback): `START TRANSACTION; INSERT INTO students(name,email,dept_id) VALUES('X','abhishek@college.edu',1); -- 1062` ROLLBACK.
6. Changes
Valid passes +1 row; invalid errors, 0 rows.
7. Steps
DESCRIBE, try valid, try invalid, read error code.
8. Mistakes
1 No column list. 2 Expect CHECK in old MySQL ignored (8 enforces). 3 Nullable FK confusion (ours NOT NULL). 4 FK type mismatch. 5 DROP CHECK wrong name.
9. Exam
1062 dupe, 1451 child blocks parent delete, 1452 parent missing, 3819 check; one PK; FK needs index/compatible key.
10. Practice 5Q
Q1 PK students? A student_id. Q2 FKs enrollments? A student_id,course_id CASCADE. Q3 Email rule? A UNIQUE. Q4 Age rule? A 15-30. Q5 Add CHECK credits 1-6? A ALTER ADD CONSTRAINT.
11. Revision
Constraints = guards; codes 1062/1451/1452/3819; name them.

