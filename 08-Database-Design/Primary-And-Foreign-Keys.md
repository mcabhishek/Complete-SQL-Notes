# PRIMARY and FOREIGN KEYS

> Part of **Complete SQL Notes** (`08-Database-Design`). [Back to roadmap](../README.md).

Primary and Foreign Keys
## Definition
PK uniquely identifies each row, never NULL. FK links child to parent PK, enforces existence.
## Why
Find Abhishek by id 1; prevent enrollment for student 999; cascade updates.
## Syntax
```sql
CONSTRAINT pk_students PRIMARY KEY (student_id),
CONSTRAINT fk_stu_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE enrollments ADD CONSTRAINT fk_x FOREIGN KEY (student_id) REFERENCES students(student_id);
```
## Explained
PK: one, NOT NULL, auto preferred (surrogate). FK: child col -> parent PK/UQ, types match. Actions: RESTRICT block, CASCADE auto, SET NULL (if nullable). Parent-child: departments>students>enrollments>marks.
## Examples

### Ex1 PK lookup: `SELECT * FROM students WHERE student_id=1; -- Abhishek`. Ex2 FK valid: enrollment (3,2) ok. Ex3 FK invalid 999 ->1452. Ex4 RESTRICT: delete dept 1 ->1451. Ex5 CASCADE: delete student 104 test cascades enrollment. Ex6 Composite: uq_enroll(student_id,course_id,year) candidate key.

## Changes
PK/FK don't change data; violations error.
## Steps
Parents first insert; children first delete; DESCRIBE to see MUL.
## Mistakes
1 Natural PK (email) changes -> use surrogate id. 2 FK without index parent. 3 Type mismatch INT vs BIGINT. 4 Expect FK to auto-create parent. 5 Routine FK_CHECKS=0.
## Exam
PK unique+not null; FK -> PK/UQ; candidate/alternate/composite/surrogate defs; CASCADE vs RESTRICT.
10. Practice 5Q
Q1 PK marks? A mark_id (+uq enrollment_id). Q2 FK attendance? A student_id,course_id CASCADE. Q3 Delete dept 3? A blocked (Manjunath+VLSI? actually Manjunath+DE). Q4 Surrogate vs natural? A id vs email. Q5 Composite where? A uq_enroll triple.
## Revision
PK identifies, FK references; RESTRICT keeps, CASCADE follows.
