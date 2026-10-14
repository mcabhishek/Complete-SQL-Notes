# UNION UNION All

> Part of **Complete SQL Notes** (`06-Subqueries-And-Set-Operations`). [Back to roadmap](../README.md).

UNION and UNION ALL
Definition: UNION stacks results vertically. UNION removes duplicates, UNION ALL keeps them. Columns must match in count and type.
Why: combine lists (all names, DBMS+CN students).
Syntax:
```sql
SELECT name FROM students WHERE dept_id=1 UNION SELECT name FROM students WHERE enrollment_year=2023;
SELECT name FROM students UNION ALL SELECT course_name FROM courses;
```
Rules: same column count, compatible types, ORDER BY only at end, column names from first SELECT.
Data: CS: Abhishek,Jeevan. 2023: Abhishek,Likhith,Jeevitha.

### Ex1 UNION dedupe:

```sql
SELECT name FROM students WHERE dept_id=1 UNION SELECT name FROM students WHERE enrollment_year=2023;
```
Output Abhishek,Jeevan,Likhith,Jeevitha (4, Abhishek once).

### Ex2 UNION ALL keeps dupe:

```sql
SELECT name FROM students WHERE dept_id=1 UNION ALL SELECT name FROM students WHERE enrollment_year=2023;
```
Output 5 rows (Abhishek twice).

### Ex3 DBMS+CN students:

```sql
SELECT s.name FROM students s JOIN enrollments e ON s.student_id=e.student_id WHERE e.course_id=1 UNION SELECT s.name FROM students s JOIN enrollments e ON s.student_id=e.student_id WHERE e.course_id=3;
```
Output Abhishek,Jeevan,Jeevitha,Likhith (4).

### Ex4 Count via UNION ALL then COUNT DISTINCT vs COUNT:

```sql
SELECT COUNT(*) FROM (SELECT student_id FROM enrollments WHERE course_id=1 UNION ALL SELECT student_id FROM enrollments WHERE course_id=3) t;
```
Output 5 (3+2). With UNION: 4.

### Ex5 Labels + ORDER BY at end:

```sql
SELECT name,'student' AS kind FROM students WHERE student_id<=2 UNION SELECT course_name,'course' FROM courses WHERE course_id<=2 ORDER BY name;
```
Output Data Structures, Database Management, Abhishek, Jeevan sorted.
Mistakes: (1) different column counts (1222 error); (2) ORDER BY mid-UNION; (3) expecting UNION ALL to dedupe; (4) type mismatch; (5) column name from second SELECT ignored.
Exam: UNION=distinct, ALL=faster keeps dupes; same count/types; ORDER BY end; for FULL OUTER simulation use UNION.
Practice Q1 UNION vs ALL? A dedupe vs keep. Q2 DBMS+CN unique? A Ex3 (4). Q3 Why ORDER BY end? A applies to whole. Q4 Count combined? A Ex4. Q5 Mismatched columns? A error, must match.
Summary: UNION stacks+dedupe, ALL stacks+keep, match columns, sort at end.
