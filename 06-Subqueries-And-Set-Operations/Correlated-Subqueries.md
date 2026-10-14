# Correlated Subqueries

> Part of **Complete SQL Notes** (`06-Subqueries-And-Set-Operations`). [Back to roadmap](../README.md).

Correlated Subqueries
1 Title: Correlated Subqueries (row-by-row)
2 Definition: Inner query references outer query column, so it runs once per outer row. Normal subquery runs once; correlated runs N times.
3 Why: Per-student vs own avg, highest per course, above own average, exists checks.
4 Syntax:
```sql
SELECT s.name FROM students s WHERE EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id=s.student_id);
SELECT s.name,m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE m.marks_obtained > (SELECT AVG(m2.marks_obtained) FROM enrollments e2 JOIN marks m2 ON m2.enrollment_id=e2.enrollment_id WHERE e2.student_id=s.student_id);
```
5 Explanation: e.student_id=s.student_id links inner to outer. For each s, MySQL filters inner to that student then aggregates.
6 Data: avgs Abhishek 81.50 (88,75), Jeevan 80.00 (92,68), Likhith 55, Jeevitha 86.50 (78,95), Manjunath 82.
7 Examples:

### Ex1 Highest per course (correlated MAX):

```sql
SELECT s.name,c.course_name,m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN courses c ON e.course_id=c.course_id JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE m.marks_obtained=(SELECT MAX(m2.marks_obtained) FROM enrollments e2 JOIN marks m2 ON m2.enrollment_id=e2.enrollment_id WHERE e2.course_id=e.course_id);
```
Output: DBMS Jeevitha 95, DS Abhishek 75, CN Jeevitha 78, OS Jeevan 68, DE Manjunath 82.

### Ex2 Above own avg:

```sql
SELECT s.name,c.course_name,m.marks_obtained FROM students s JOIN enrollments e ON s.student_id=e.student_id JOIN courses c ON e.course_id=c.course_id JOIN marks m ON m.enrollment_id=e.enrollment_id WHERE m.marks_obtained > (SELECT AVG(m2.marks_obtained) FROM enrollments e2 JOIN marks m2 ON m2.enrollment_id=e2.enrollment_id WHERE e2.student_id=s.student_id);
```
Output: Abhishek-DBMS-88 (>81.5), Jeevan-DBMS-92 (>80), Jeevitha-DBMS-95 (>86.5). 3 rows.

### Ex3 Enrolled check (EXISTS correlated):

```sql
SELECT s.name FROM students s WHERE EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id=s.student_id);
```

**Output:**

```text
```

### Ex4 Not enrolled:

```sql
SELECT s.name FROM students s WHERE NOT EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id=s.student_id);
```

**Output:**

```text
```

### Ex5 Above overall avg via correlated count demo + dept topper:

```sql
SELECT s.name,(SELECT COUNT(*) FROM enrollments e WHERE e.student_id=s.student_id) AS n FROM students s;
```
Output Abhishek 2,Jeevan 2,Likhith 1,Jeevitha 2,Manjunath 1.

### Ex6 Nested vs correlated: uncorrelated avg runs once; correlated per-row runs 5 times - slower but per-group logic.

10 Mistakes: (1) missing outer alias -> unknown column; (2) using correlated where JOIN faster; (3) = with multi-row inner; (4) forgetting correlation makes it uncorrelated; (5) slow on big tables - prefer JOIN+GROUP.
11 Exam: correlated = references outer, runs per row; EXISTS stops at first match; used for top-N-per-group; can rewrite with JOIN.
12 Practice 5Q:
Q1 Top per course? A Ex1. Q2 Above own avg? A Ex2 (3 rows). Q3 Has enrollment? A Ex3. Q4 Count per student via subquery? A Ex5. Q5 Correlated vs normal? A: normal once, correlated per row.
13 Summary: inner uses outer col; per-row; good for per-group max/avg; EXISTS pattern; slower - index FKs.
