# Cross Join

> Part of **Complete SQL Notes** (`05-Joins`). [Back to roadmap](../README.md).

Definition: CROSS JOIN pairs every row of table1 with every row of table2 (Cartesian product). No ON needed. Rows = n1 x n2.
Why needed: all combinations, missing-pair check, test data.
Syntax:
```sql
SELECT s.name, d.dept_name FROM students s CROSS JOIN departments d;
```
Data: 5 students (Abhishek,Jeevan,Likhith,Jeevitha,Manjunath), 3 depts, 5 courses.

### Ex1 Count:

```sql
SELECT COUNT(*) AS c FROM students CROSS JOIN departments;
```

**Output:**

```text
```

### Ex2 Sample:

```sql
SELECT s.name,d.dept_name FROM students s CROSS JOIN departments d ORDER BY s.name LIMIT 4;
```
Output: Abhishek-CS, Abhishek-Electronics, Abhishek-IS, Jeevan-CS.

### Ex3 All pairs:

```sql
SELECT s.name,c.course_name FROM students s CROSS JOIN courses c;
```
Output: 25 rows (5x5).

### Ex4 Missing enrollments (CROSS+LEFT anti-join):

```sql
SELECT s.name,c.course_name FROM students s CROSS JOIN courses c
LEFT JOIN enrollments e ON e.student_id=s.student_id AND e.course_id=c.course_id
WHERE e.enrollment_id IS NULL;
```
Output: 17 rows (25-8 real). Eg Abhishek-CN, Abhishek-OS, Abhishek-DE.

### Ex5 CROSS+WHERE = INNER:

```sql
SELECT s.name,d.dept_name FROM students s CROSS JOIN departments d WHERE s.dept_id=d.dept_id;
```
Output: 5 rows matched (Abhishek-CS,Jeevan-CS,Likhith-IS,Jeevitha-IS,Manjunath-Electronics).
Mistakes: (1) missing ON in INNER accidentally makes CROSS (row explosion); (2) CROSS JOIN with ON - use INNER instead; (3) SELECT * on CROSS - list columns; (4) big tables hang - use LIMIT.
Exam points: rows=n1*n2; comma join=a CROSS JOIN; CROSS+LEFT+IS NULL finds gaps; WHERE after CROSS = INNER.
Practice Q1 Count students x courses? A: 25. `SELECT COUNT(*) FROM students CROSS JOIN courses;`
Q2 Likhith x all courses? A: `SELECT c.course_name FROM students s CROSS JOIN courses c WHERE s.name='Likhith';` (5 rows).
Q3 Abhishek x all depts? A: 3 rows.
Q4 Fix explosion? A: add ON to make INNER JOIN.
Q5 Missing pairs concept? A: CROSS builds all, LEFT+IS NULL keeps missing.
Summary: CROSS=no ON, n1*n2 rows, for combos and gap detection.
