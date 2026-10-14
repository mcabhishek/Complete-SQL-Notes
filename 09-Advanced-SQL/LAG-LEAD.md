# Lag Lead

> Part of **Complete SQL Notes** (`09-Advanced-SQL`). [Back to roadmap](../README.md).

## Definition
LAG reads the previous row. LEAD reads the next row in an ordered window. Edge rows give NULL unless a default is given.

## Purpose and use cases
Compare each mark with previous mark. Find gap to next mark. Show previous course result per student.

## Syntax
```sql
SELECT m.marks_obtained,
LAG(m.marks_obtained) OVER (ORDER BY m.marks_obtained DESC) AS prev_m,
LEAD(m.marks_obtained) OVER (ORDER BY m.marks_obtained DESC) AS next_m
FROM marks m;
```

## Explanation of keywords
Offset default is 1. Third argument is default value. PARTITION BY restarts per student or course. ORDER BY decides what is previous and next.

## Examples
Marks high to low are 95, 92, 88, 82, 78, 75, 68, 55.

### Example 1. Previous mark and difference

```sql
SELECT m.marks_obtained,
LAG(m.marks_obtained) OVER (ORDER BY m.marks_obtained DESC) AS prev_m,
m.marks_obtained - LAG(m.marks_obtained) OVER (ORDER BY m.marks_obtained DESC) AS diff_m
FROM marks m
ORDER BY m.marks_obtained DESC;
```
Expected output
95 NULL NULL. 92 95 -3. 88 92 -4. 82 88 -6. 78 82 -4. 75 78 -3. 68 75 -7. 55 68 -13.

### Example 2. Next mark

```sql
SELECT m.marks_obtained,
LEAD(m.marks_obtained) OVER (ORDER BY m.marks_obtained DESC) AS next_m
FROM marks m
ORDER BY m.marks_obtained DESC;
```
Expected output
95 to 92. 92 to 88. Down to 55 to NULL.

### Example 3. Previous mark per student

```sql
SELECT s.name, c.course_name, m.marks_obtained,
LAG(m.marks_obtained) OVER (PARTITION BY s.student_id ORDER BY m.marks_obtained DESC) AS prev_m
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY s.name, m.marks_obtained DESC;
```
Expected output
Abhishek 88 NULL then 75 88. Jeevitha 95 NULL then 78 95.

### Example 4. Default zero at edge

```sql
SELECT m.marks_obtained,
LAG(m.marks_obtained, 1, 0) OVER (ORDER BY m.marks_obtained DESC) AS prev0
FROM marks m
ORDER BY m.marks_obtained DESC
LIMIT 2;
```
Expected output
95 to 0. 92 to 95.

### Example 5. Growth flag

```sql
WITH t AS (
SELECT m.marks_obtained,
LAG(m.marks_obtained) OVER (ORDER BY m.marks_obtained) AS p
FROM marks m
)
SELECT marks_obtained, p,
CASE WHEN marks_obtained > p THEN 'up' ELSE 'first' END AS flag
FROM t
ORDER BY marks_obtained;
```
Expected output
55 first. Rest up.

## Common mistakes
No ORDER BY so previous is unclear.
Ignoring NULL at edges.
Wrong PARTITION giving global instead of per student.
Filtering LAG alias in WHERE directly.
Large offset giving NULL.

## Performance and safety
Read only. Needs sort. Fine on small data.

## Practice questions with answers

**Q1. Show previous mark for each mark.**

A1. Example 1. Tests LAG.

**Q2. Show next mark.**

A2. Example 2. Tests LEAD.

**Q3. Show previous mark per student.**

A3. Example 3. Tests PARTITION.

**Q4. Replace edge NULL with 0.**

A4. Example 4. Tests default.

**Q5. Find difference from previous.**

A5. marks minus LAG. Tests math on window.

## Revision summary
LAG is previous. LEAD is next. ORDER plus PARTITION decide rows. Handle edge NULL.
