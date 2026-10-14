# Subqueries

> Part of **Complete SQL Notes** (`06-Subqueries-And-Set-Operations`). [Back to roadmap](../README.md).

Subqueries
1 Title: Subqueries (Inner Queries)
2 Definition: A subquery is a SELECT inside another SELECT/INSERT/UPDATE/DELETE. Inner runs first, outer uses its result.
3 Why: Compare student vs average, second-highest, above-average, no-join filtering.
4 Syntax:
```sql
SELECT name FROM students WHERE student_id IN (SELECT student_id FROM enrollments WHERE course_id=1);
SELECT (SELECT AVG(marks_obtained) FROM marks) AS avg_m;
SELECT * FROM (SELECT student_id,COUNT(*) c FROM enrollments GROUP BY student_id) t WHERE c>1;
```
5 Explanation: IN-subquery returns list; scalar returns one value; FROM-subquery (derived table) needs alias t. Inner in () runs first.
6 Reference: 5 students, 8 enrollments/marks. Total marks 633 avg 79.125. Avgs: Abhishek 81.50,Jeevan 80.00,Likhith 55.00,Jeevitha 86.50,Manjunath 82.00.
7 Examples (5+ with outputs+steps):

### Ex1 Scalar avg:

```sql
SELECT AVG(marks_obtained) AS avg_m FROM marks;
```
Output 79.125. Step: aggregates 8 rows.

### Ex2 Above-average marks (WHERE subquery):

```sql
SELECT s.name,c.course_name,m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN courses c ON e.course_id=c.course_id JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE m.marks_obtained > (SELECT AVG(marks_obtained) FROM marks);
```
Output 4 rows: Jeevitha-DBMS-95, Jeevan-DBMS-92, Abhishek-DBMS-88, Manjunath-DE-82.

### Ex3 DBMS students via IN:

```sql
SELECT name FROM students WHERE student_id IN (SELECT student_id FROM enrollments WHERE course_id=1);
```
Output Abhishek,Jeevan,Jeevitha.

### Ex4 Second-highest mark:

```sql
SELECT DISTINCT marks_obtained FROM marks ORDER BY marks_obtained DESC LIMIT 1 OFFSET 1;
```
Output 92.00. Step: sorted 95,92,... offset skips 95.

### Ex5 Derived table multi-enrolled:

```sql
SELECT s.name,t.c FROM students s JOIN (SELECT student_id,COUNT(*) c FROM enrollments GROUP BY student_id) t ON t.student_id=s.student_id WHERE t.c>1;
```
Output Abhishek 2,Jeevan 2,Jeevitha 2.

### Ex6 SELECT-subquery avg per row:

```sql
SELECT name,(SELECT ROUND(AVG(m.marks_obtained),2) FROM enrollments e JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE e.student_id=s.student_id) AS avg_m FROM students s;
```

**Output:**

```text
9 Practical: covered Ex1-6.
10 Mistakes: (1) multi-row without IN (`= (SELECT...)` errors 1242) use IN; (2) no alias for derived table (1248); (3) NULL in NOT IN kills rows (use NOT EXISTS); (4) missing () ; (5) SELECT * in scalar.
11 Exam: scalar=1 val; single-row with = > <; multi-row with IN/ANY/ALL; FROM needs alias; LIMIT in subquery needs wrapping in older versions but OK in 8.0 with IN.
12 Practice 5Q:
Q1 Above avg students? A Ex2. Q2 Second highest? A Ex4 (92 Jeevan-DBMS). Q3 Multi-course via subquery? A Ex5. Q4 No enrollment? A: `SELECT name FROM students WHERE student_id NOT IN (SELECT student_id FROM enrollments);` empty. Q5 Avg in SELECT? A Ex6.
13 Summary: Inner->outer; scalar/row/table; IN for lists; alias derived; beware NULL.
```
