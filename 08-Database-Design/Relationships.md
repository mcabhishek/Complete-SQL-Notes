# Relationships

> Part of **Complete SQL Notes** (`08-Database-Design`). [Back to roadmap](../README.md).

Relationships
## Definition
1-1 one row to one, 1-M one to many, M-N many to many via junction.
## Why
Dept has many students; student takes many courses via enrollments.
3. Syntax (FK side holds key)

## Explained
1-M: FK on many side. 1-1: FK+UNIQUE. M-N: junction with two FKs + composite UQ. Cardinality: one dept * students; optionality: student must have dept (NOT NULL).
## Examples

### Ex1 Dept-CS students: `SELECT * FROM students WHERE dept_id=1; -- Abhishek,Jeevan (1-M)`. Ex2 Student-enrollments: Abhishek 2 rows. Ex3 Course-enrollments: DBMS 3 rows. Ex4 M-N: Abhishek<>DBMS,DS via enrollments 1,2. Ex5 1-1: enrollment 1<>mark 1 (88). Ex6 Attendance M-N snapshot: (1,1) 90%.

## Changes
No data change; queries join accordingly.
## Steps
Find FK, count children per parent, name type.
## Mistakes
1 M-N without junction (csv ids). 2 1-1 without UNIQUE. 3 Wrong side FK. 4 Optional vs mandatory null. 5 Deleting 1-side with RESTRICT surprise.
## Exam
Junction resolves M-N; FK on many; UQ makes 1-1; cardinality symbols.
10. Practice 5Q
Q1 Dept-students? A 1-M. Q2 Students-courses? A M-N via enrollments. Q3 Enroll-marks? A 1-1. Q4 Junction cols? A student_id,course_id. Q5 Attendance link? A student+course FKs.
## Revision
1-M FK many side; M-N junction; 1-1 FK+UQ.
