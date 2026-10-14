# Multiple Table JOINS

> Part of **Complete SQL Notes** (`05-Joins`). [Back to roadmap](../README.md).

Multiple Table Joins
1 Title
Joining 3+ tables (students-enrollments-courses-marks).
2 Definition
Chain JOINs: each JOIN adds one table via its FK. Result combines all.
3 Why Needed
Real reports need name+course+marks+dept together. Cannot get from one table.
4 Syntax
```sql
SELECT s.name,c.course_name,m.marks_obtained
FROM students s
JOIN enrollments e ON s.student_id=e.student_id
JOIN courses c ON e.course_id=c.course_id
JOIN marks m ON m.enrollment_id=e.enrollment_id;
```
5 Explanation
s-e link via student_id, e-c via course_id, m-e via enrollment_id. Aliases s,e,c,m. Order: FROM students, then each JOIN.
6-8 Examples (5 candidates, outputs, steps)

### Ex1 Name+course+marks (8 rows):

```sql
SELECT s.name,c.course_name,m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN courses c ON e.course_id=c.course_id JOIN marks m ON m.enrollment_id=e.enrollment_id ORDER BY s.name,m.marks_obtained DESC;
```
Output: Abhishek-DBMS-88, Abhishek-DS-75, Jeevan-DBMS-92, Jeevan-OS-68, Likhith-CN-55, Jeevitha-CN-78, Jeevitha-DBMS-95, Manjunath-DE-82. Steps: s+e=8 rows, +c adds names, +m adds marks (1:1 so still 8).

### Ex2 +dept:

```sql
SELECT s.name,d.dept_name,c.course_name FROM students s JOIN departments d ON s.dept_id=d.dept_id JOIN enrollments e ON e.student_id=s.student_id JOIN courses c ON c.course_id=e.course_id WHERE s.name='Jeevitha';
```
Output: Jeevitha-IS-CN, Jeevitha-IS-DBMS.

### Ex3 Aggregation after join (avg per student):

```sql
SELECT s.name,ROUND(AVG(m.marks_obtained),2) AS avg_m FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN marks m ON m.enrollment_id=e.enrollment_id GROUP BY s.student_id,s.name;
```
Output: Abhishek 81.50, Jeevan 80.00, Likhith 55.00, Jeevitha 86.50, Manjunath 82.00.

### Ex4 WHERE after join (high scorers):

```sql
SELECT s.name,c.course_name,m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN courses c ON e.course_id=c.course_id JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE m.marks_obtained>=85 ORDER BY m.marks_obtained DESC;
```
Output: Jeevitha-DBMS-95, Jeevan-DBMS-92, Abhishek-DBMS-88.

### Ex5 Multiple conditions + attendance:

```sql
SELECT s.name,c.course_name,a.percentage,m.marks_obtained FROM students s JOIN attendance a ON a.student_id=s.student_id JOIN courses c ON c.course_id=a.course_id JOIN enrollments e ON e.student_id=s.student_id AND e.course_id=c.course_id JOIN marks m ON m.enrollment_id=e.enrollment_id ORDER BY s.name;
```
Output 8 rows with pct e.g. Abhishek-DBMS-90.00-88, Jeevitha-DBMS-95.00-95.
9 Five PracticalYou're done condensed; full list above.
10 Mistakes
1 Wrong FK (s.student_id=c.course_id) -> empty/wrong. 2 COUNT(*) counts joined rows not students -> use COUNT(DISTINCT s.student_id). 3 Mixing LEFT+INNER breaks null retention -> use all LEFT. 4 Missing one ON explodes rows. 5 WHERE on nullable table converts LEFT to INNER -> put in ON.
11 Exam Points
Join order left-to-right; aliases required; ON=match, WHERE=filter; GROUP BY after join; COUNT(DISTINCT) for students; one-to-many duplicates expected.
12 Practice (5 Q+A)
Q1 Full report name/dept/course/marks? A: join s-d-e-c-m. Q2 Avg per course? A: `SELECT c.course_name,AVG(m.marks_obtained) FROM courses c JOIN enrollments e ON c.course_id=e.course_id JOIN marks m ON m.enrollment_id=e.enrollment_id GROUP BY c.course_name;` DBMS 91.67, CN 66.50. Q3 Jeevan full details? A: filter WHERE s.name='Jeevan' -> 2 rows. Q4 Count enrollments per student? A: GROUP BY s.name COUNT(*): Abhishek 2,Jeevan 2,Likhith 1,Jeevitha 2,Manjunath 1. Q5 Students with attendance<80 and marks? A: join attendance+marks WHERE percentage<80.
13 Summary
Chain JOINs via FKs; aliases; WHERE filters, GROUP BY aggregates; watch duplicates; COUNT DISTINCT.
