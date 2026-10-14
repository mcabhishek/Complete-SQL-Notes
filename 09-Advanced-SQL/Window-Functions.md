# Window Functions

> Part of **Complete SQL Notes** (`09-Advanced-SQL`). [Back to roadmap](../README.md).

Window Functions

## Definition
Window functions calculate across rows but keep every row. Normal aggregate collapses rows. Window keeps rows and adds a new column.

## Purpose and use cases
Rank marks. Rank per course. Compare department average with student average. Make quartiles. Find first and last mark per course.

## Syntax
```sql
SELECT s.name, m.marks_obtained,
RANK() OVER (ORDER BY m.marks_obtained DESC) AS r
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN marks m ON m.enrollment_id = e.enrollment_id;
```

## Explanation of keywords
OVER opens the window. PARTITION BY restarts calculation per group. ORDER BY inside sets rank order. Frame ROWS sets which rows to include. Without full frame, LAST_VALUE gives current row only.

## Examples using the five candidates
Marks in order are 95 Jeevitha DBMS, 92 Jeevan DBMS, 88 Abhishek DBMS, 82 Manjunath DE, 78 Jeevitha CN, 75 Abhishek DS, 68 Jeevan OS, 55 Likhith CN.

### Example 1. Rank all marks

```sql
SELECT s.name, c.course_name, m.marks_obtained,
RANK() OVER (ORDER BY m.marks_obtained DESC) AS r
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY r;
```
Expected output
Ranks 1 to 8 from 95 down to 55.

### Example 2. Rank per course

```sql
SELECT c.course_name, s.name, m.marks_obtained,
RANK() OVER (PARTITION BY e.course_id ORDER BY m.marks_obtained DESC) AS r
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY c.course_name, r;
```
Expected output
DBMS Jeevitha 1, Jeevan 2, Abhishek 3. CN Jeevitha 1, Likhith 2. Other courses rank 1.

### Example 3. Student average with department average

```sql
WITH sm AS (
SELECT s.student_id, s.name, s.dept_id, AVG(m.marks_obtained) AS a
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.name, s.dept_id
)
SELECT name, ROUND(a, 2) AS avg_marks,
ROUND(AVG(a) OVER (PARTITION BY dept_id), 2) AS dept_avg
FROM sm;
```
Expected output
CS 80.75, IS 70.75, Electronics 82.00 beside each student.

### Example 4. Quartiles with NTILE

```sql
SELECT s.name, m.marks_obtained,
NTILE(4) OVER (ORDER BY m.marks_obtained DESC) AS q
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY m.marks_obtained DESC;
```
Expected output
95 and 92 in group 1. 88 and 82 in group 2. 78 and 75 in group 3. 68 and 55 in group 4.

### Example 5. First and last per course

```sql
SELECT DISTINCT e.course_id,
FIRST_VALUE(m.marks_obtained) OVER w AS first_m,
LAST_VALUE(m.marks_obtained) OVER w AS last_m
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
WINDOW w AS (PARTITION BY e.course_id ORDER BY m.marks_obtained DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);
```
Expected output
DBMS 95 and 88. CN 78 and 55. Full frame is needed for correct last value.

## Common mistakes
Missing OVER.
Filtering window alias in WHERE. Use subquery instead.
Using LAST_VALUE without full frame.
Mixing GROUP BY collapse with window keep.
Wrong PARTITION giving global rank instead of per group.

## Performance and safety
Read only. Needs sort. Index on PARTITION and ORDER columns helps. Fine on small data.

## Practice questions with answers

**Q1. Rank all marks highest first.**

A1. Example 1. Tests RANK with ORDER.

**Q2. Rank marks inside each course.**

A2. Example 2. Tests PARTITION BY.

**Q3. Show department average beside student average.**

A3. Example 3. Tests AVG window.

**Q4. Divide marks into 4 groups.**

A4. Example 4. Tests NTILE.

**Q5. Why does LAST_VALUE look wrong.**

A5. Default frame ends at current row. Use full frame.

## Revision summary
OVER plus PARTITION keeps rows. RANK per group. Frame matters for LAST_VALUE.
