INTERSECT EXCEPT in MySQL (Workarounds)
Definition: INTERSECT=common rows, EXCEPT=A minus B. MySQL 8.0 has NEITHER natively. Use INNER JOIN/IN for INTERSECT, LEFT+IS NULL/NOT EXISTS for EXCEPT.
Why: both-courses students, DBMS-not-CN etc.
Syntax (do NOT run INTERSECT in MySQL - error 1064):
```sql
SELECT DISTINCT a.student_id FROM enrollments a JOIN enrollments b ON a.student_id=b.student_id WHERE a.course_id=1 AND b.course_id=3;
SELECT s.name FROM students s JOIN enrollments e ON s.student_id=e.student_id WHERE e.course_id=1 AND NOT EXISTS (SELECT 1 FROM enrollments x WHERE x.student_id=s.student_id AND x.course_id=3);
```
Data: DBMS {Abhishek,Jeevan,Jeevitha}, CN {Likhith,Jeevitha}. Both=Jeevitha. DBMS-only=Abhishek,Jeevan.
Ex1 Both DBMS+CN (INTERSECT):
```sql
SELECT s.name FROM students s WHERE s.student_id IN (SELECT student_id FROM enrollments WHERE course_id=1) AND s.student_id IN (SELECT student_id FROM enrollments WHERE course_id=3);
```
Output Jeevitha.
Ex2 DBMS except CN:
```sql
SELECT s.name FROM students s JOIN enrollments e ON s.student_id=e.student_id WHERE e.course_id=1 AND NOT EXISTS (SELECT 1 FROM enrollments x WHERE x.student_id=s.student_id AND x.course_id=3);
```
Output Abhishek,Jeevan.
Ex3 CN except DBMS: Output Likhith (same pattern course 3 minus 1).
Ex4 2023 except CS (year minus dept):
```sql
SELECT name FROM students WHERE enrollment_year=2023 AND dept_id<>1;
```
Output Likhith,Jeevitha.
Ex5 Duplicates: INTERSECT DISTINCT vs join dupes - use DISTINCT or GROUP BY to mimic.
Mistakes: (1) running INTERSECT/EXCEPT in MySQL (syntax error); (2) EXCEPT arg order matters; (3) forgetting DISTINCT; (4) NULL handling; (5) column mismatch.
Exam: MySQL 8.0 NO INTERSECT/EXCEPT (PG/SQLServer have); rewrite with JOIN/IN/NOT EXISTS; UNION yes but INTERSECT no.
Practice Q1 Both DBMS+CN? A Jeevitha. Q2 DBMS not CN? A Abhishek,Jeevan. Q3 CN not DBMS? A Likhith. Q4 MySQL supports? A No, workaround. Q5 INTERSECT vs UNION? A common vs combined.
Summary: No native ops - IN/JOIN for INTERSECT, NOT EXISTS/LEFT for EXCEPT.

