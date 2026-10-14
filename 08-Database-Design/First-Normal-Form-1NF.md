First Normal Form (1NF)
1. Definition
1NF: atomic cells, no lists/repeats, PK per row.
2. Why
`phones='98,99'` can't call one; `course1,course2` cols break on 3rd course.
3. Syntax
```sql
CREATE TABLE student_phones (student_id INT, phone VARCHAR(15), PRIMARY KEY (student_id,phone), FOREIGN KEY (student_id) REFERENCES students(student_id));
```
4. Explained
Atomic: one value per cell. Repeating group: columns or csv. Fix: new row per value (or child table).
5. Examples
Bad: students_ext(id,name,phones '98,99', courses 'DBMS,DS'). Problems: find 99 needs LIKE, count hard.
Good: students(1,Abhishek...)+student_phones(1,'98...'),(1,'99...')+enrollments per course (Abhishek e1,e2). `SELECT * FROM enrollments WHERE student_id=1; -- 2 rows clean`.
Demo temp: CREATE tmp, insert atomic rows, COUNT, DROP.
More: attendance per (student,course) atomic, not per-month columns.
6. Changes
1 row with list -> N rows; queries exact match.
7. Steps
Find comma/multi cols, new table/rows, PK, FK back.
8. Mistakes
1 LIKE on csv. 2 course1..N columns. 3 No PK after split. 4 Space-trim issues. 5 JSON for simple list overkill exam.
9. Exam
Atomic rule; repeating group fix; PK needed.
10. Practice 5Q
Q1 Is csv 1NF? A No. Q2 Fix phones? A child table above. Q3 Abhishek courses 1NF? A 2 enrollment rows. Q4 PK phones? A (student_id,phone). Q5 LIKE risk? A false matches.
11. Revision
One value/cell, rows not columns for repeats.

