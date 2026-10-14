Running Totals And Moving Averages

1. Definition
Running total is cumulative SUM up to current row. Moving average is AVG of nearby rows using a frame.

2. Purpose and use cases
Show total marks growing by enrollment order. Show 3 row smooth average. Show per course running total.

3. Syntax
```sql
SELECT e.enrollment_id, m.marks_obtained,
SUM(m.marks_obtained) OVER (ORDER BY e.enrollment_id ROWS UNBOUNDED PRECEDING) AS run_tot
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY e.enrollment_id;
```

4. Explanation of keywords
ORDER BY sets sequence. ROWS UNBOUNDED PRECEDING means start to current row. BETWEEN 1 PRECEDING AND 1 FOLLOWING means neighbor plus current plus next. Without ORDER BY the total repeats on all rows.

5. Examples
Marks by enrollment 1 to 8 are 88, 75, 92, 68, 55, 78, 95, 82. Total is 633.

Example 1. Running total
```sql
SELECT e.enrollment_id, m.marks_obtained,
SUM(m.marks_obtained) OVER (ORDER BY e.enrollment_id ROWS UNBOUNDED PRECEDING) AS run_tot
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY e.enrollment_id;
```
Expected output
88, 163, 255, 323, 378, 456, 551, 633.

Example 2. Running average
```sql
SELECT e.enrollment_id,
AVG(m.marks_obtained) OVER (ORDER BY e.enrollment_id ROWS UNBOUNDED PRECEDING) AS run_avg
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY e.enrollment_id;
```
Expected output
Last row is 79.125, the overall average.

Example 3. Three row moving average
```sql
SELECT e.enrollment_id, m.marks_obtained,
ROUND(AVG(m.marks_obtained) OVER (ORDER BY e.enrollment_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 2) AS mov3
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY e.enrollment_id;
```
Expected output
Row1 81.50. Row2 85.00. Row3 78.33. Row4 71.67. Row5 67.00. Row6 76.00. Row7 85.00. Row8 88.50.

Example 4. Running total per course
```sql
SELECT e.course_id, e.enrollment_id, m.marks_obtained,
SUM(m.marks_obtained) OVER (PARTITION BY e.course_id ORDER BY e.enrollment_id) AS run_c
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY e.course_id, e.enrollment_id;
```
Expected output
DBMS rows give 88, 180, 275. CN gives 55, 133.

Example 5. ROWS versus RANGE
```sql
SELECT e.enrollment_id, m.marks_obtained,
SUM(m.marks_obtained) OVER (ORDER BY e.enrollment_id ROWS UNBOUNDED PRECEDING) AS by_rows
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
ORDER BY e.enrollment_id;
```
Expected note
ROWS counts physical rows. RANGE groups same ORDER values. Same here because ids are unique.

6. Common mistakes
Missing ORDER BY so total repeats.
Wrong frame for moving average.
Expecting full window at edges. Edges use fewer rows.
Rounding issues.
Very large frames on big tables.

7. Performance and safety
Read only. Needs sort. Fine on small data.

8. Practice questions with answers
Q1. Show running total ending at 633.
A1. Example 1. Tests UNBOUNDED PRECEDING.
Q2. What is moving average for enrollment 2.
A2. 85.00. Tests 3 row frame.
Q3. Show DBMS running total.
A3. 88, 180, 275. Tests PARTITION.
Q4. Why are edge averages from 2 rows.
A4. No neighbor on one side.
Q5. ROWS versus RANGE.
A5. Rows count. Range groups equal values.

9. Revision summary
SUM or AVG OVER plus ORDER plus frame. UNBOUNDED for cumulative. BETWEEN for moving.
