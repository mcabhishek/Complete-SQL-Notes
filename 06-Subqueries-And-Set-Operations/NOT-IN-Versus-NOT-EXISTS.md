NOT IN vs NOT EXISTS
Definition: Both find missing rows, but NOT IN fails if list has NULL (whole result empty). NOT EXISTS is NULL-safe.
Why: find unenrolled students/courses safely.
Syntax:
```sql
SELECT name FROM students WHERE student_id NOT IN (SELECT student_id FROM enrollments);
SELECT s.name FROM students s WHERE NOT EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id=s.student_id);
```
Explanation: NOT IN: x<>v1 AND x<>v2... If any v is NULL, x<>NULL=UNKNOWN -> row filtered. NOT EXISTS: true if correlated subquery returns 0 rows; NULL never matches = so safe.
Data: all 5 enrolled so both return empty. Demo NULL trap:
```sql
SELECT name FROM students WHERE student_id NOT IN (1,2,NULL);
```
Output empty (even 3,4,5 excluded) because 3<>NULL is UNKNOWN.
Ex1 NOT IN enrolled (empty):
```sql
SELECT name FROM students WHERE student_id NOT IN (SELECT student_id FROM enrollments);
```
Output empty.
Ex2 NOT EXISTS (empty, safe):
```sql
SELECT s.name FROM students s WHERE NOT EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id=s.student_id);
```
Output empty.
Ex3 LEFT anti-join same:
```sql
SELECT s.name FROM students s LEFT JOIN enrollments e ON s.student_id=e.student_id WHERE e.enrollment_id IS NULL;
```
Output empty.
Ex4 NULL trap demo: `SELECT 'Abhishek' WHERE 1 NOT IN (2,NULL);` -> empty (UNKNOWN). With NOT EXISTS equivalent returns row.
Ex5 Safe pattern: `WHERE col NOT IN (SELECT col FROM t WHERE col IS NOT NULL)` OR prefer NOT EXISTS.
Mistakes: (1) NOT IN on nullable FK; (2) thinking empty subquery vs NULL same; (3) using <>ALL with NULL same bug; (4) forgetting IS NOT NULL fix; (5) assuming NOT IN faster (NOT EXISTS usually faster).
Exam: always mention NULL trap; fix = add IS NOT NULL or use NOT EXISTS/LEFT+IS NULL; interview favorite Q.
Practice Q1 Unenrolled via NOT IN? A Ex1. Q2 Same via NOT EXISTS? A Ex2. Q3 Why `NOT IN (1,NULL)` empty? A NULL makes UNKNOWN. Q4 Fix? A add `WHERE col IS NOT NULL` or use NOT EXISTS. Q5 Courses with no enrollment? A: `SELECT c.course_name FROM courses c WHERE NOT EXISTS (SELECT 1 FROM enrollments e WHERE e.course_id=c.course_id);` empty.
Summary: NOT IN NULL-unsafe, NOT EXISTS safe - prefer NOT EXISTS.

