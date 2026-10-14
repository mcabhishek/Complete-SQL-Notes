EXISTS IN ANY ALL
Definition: IN=list match, EXISTS=row-exists check, ANY=matches one, ALL=matches every. All handle multi-row subqueries.
Why: enrollment checks, above one/above all comparisons.
Syntax:
```sql
SELECT name FROM students WHERE student_id IN (SELECT student_id FROM enrollments WHERE course_id=1);
SELECT name FROM students s WHERE EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id=s.student_id);
SELECT name FROM students WHERE student_id = ANY (SELECT student_id FROM enrollments WHERE course_id=1);
SELECT marks_obtained FROM marks WHERE marks_obtained > ALL (SELECT marks_obtained FROM marks WHERE enrollment_id IN (5,4));
```
Explanation: IN true if equals any list value. EXISTS true if subquery returns >=1 row (SELECT 1 dummy). ANY true if comparison holds for at least one. ALL true if holds for every value.
Data: marks 88,75,92,68,55,78,95,82. DBMS ids 1,2,4.
Ex1 IN DBMS:
```sql
SELECT name FROM students WHERE student_id IN (SELECT student_id FROM enrollments WHERE course_id=1);
```
Output Abhishek,Jeevan,Jeevitha.
Ex2 EXISTS enrolled:
```sql
SELECT s.name FROM students s WHERE EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id=s.student_id);
```
Output all 5.
Ex3 NOT EXISTS none:
```sql
SELECT s.name FROM students s WHERE NOT EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id=s.student_id);
```
Output empty.
Ex4 ANY >75 in CN (55,78): values >55 -> 7 of 8 except 55 itself:
```sql
SELECT s.name,m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE m.marks_obtained > ANY (SELECT m2.marks_obtained FROM marks m2 JOIN enrollments e2 ON m2.enrollment_id=e2.enrollment_id WHERE e2.course_id=3);
```
Output 7 rows (all except Likhith-55).
Ex5 ALL > both CN values means >78:
```sql
SELECT s.name,m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE m.marks_obtained > ALL (SELECT m2.marks_obtained FROM marks m2 JOIN enrollments e2 ON m2.enrollment_id=e2.enrollment_id WHERE e2.course_id=3);
```
Output Abhishek-88,Jeevan-92,Jeevitha-95,Manjunath-82. 4 rows.
Ex6 =ANY equals IN; <>ALL equals NOT IN (beware NULL).
Mistakes: (1) NOT IN with NULL -> empty (use NOT EXISTS); (2) = with multi-row -> use IN/ANY; (3) EXISTS with SELECT * wasteful (use 1); (4) ANY/ALL with NULL yields UNKNOWN; (5) forgetting correlation in EXISTS.
Exam: IN vs EXISTS (EXISTS faster, stops early, NULL-safe); =ANY=IN; <>ALL=NOT IN; >ANY means >min; >ALL means >max.
Practice Q1 DBMS via IN? A Ex1. Q2 Enrolled via EXISTS? A Ex2. Q3 >ANY CN? A 7 rows. Q4 >ALL CN? A 4 rows (>78). Q5 IN vs EXISTS? A: IN compares values, EXISTS checks presence; EXISTS NULL-safe.
Summary: IN list, EXISTS presence, ANY one, ALL every; >ANY=>min, >ALL=>max.

