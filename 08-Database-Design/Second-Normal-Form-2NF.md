# SECOND Normal FORM 2NF

> Part of **Complete SQL Notes** (`08-Database-Design`). [Back to roadmap](../README.md).

Second Normal Form (2NF)
## Definition
1NF + no partial dependency: non-key must depend on whole composite key, not part.
## Why
(enrollment_id?) our enrollments PK single so fine; demo composite (student_id,course_id)-> course_name depends only course part -> repeats DBMS 3x.
## Syntax

## Explained
FDs bad: course_id->course_name,credits (partial). Full: (student,course)->semester. Split moves partial to parent.
## Examples
Bad rows: (1,1,DBMS,4,3),(2,1,DBMS,4,5),(4,1,DBMS,4,3) DBMS repeated 3x; rename DBMS updates 3.
Good: courses 1 row DBMS; enrollments 3 rows ref 1. `SELECT c.course_name FROM enrollments e JOIN courses c ON e.course_id=c.course_id WHERE e.student_id=1;`
Anomalies fixed: insert course without student (courses row), update name once, delete enrollment keeps course.
## Changes
Name stored 1x not Nx.
## Steps
1NF?, composite?, FD per part?, split partial to parent, FK.
## Mistakes
1 2NF with single-col PK (auto satisfied). 2 PK choice wrong. 3 Leaving credits in child. 4 Lossy (no FK). 5 Confuse partial vs transitive.
## Exam
Partial def; composite needed for violation; enroll example classic.
10. Practice 5Q
Q1 Partial in enroll_big? A course_name on course_id. Q2 Split? A courses+enrollments. Q3 FD semester? A full (both). Q4 Update anomaly? A 3 DBMS rows. Q5 Our schema 2NF? A Yes (single PKs + parents).
## Revision
Part-key FD -> move to parent table.
