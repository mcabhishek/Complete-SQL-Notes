ROW NUMBER RANK DENSE RANK

1. Definition
ROW_NUMBER gives unique numbers 1 to N. RANK gives same rank for ties and skips next numbers. DENSE_RANK gives same rank for ties with no skip.

2. Purpose and use cases
Pick top 1 per course. Find second highest mark. Show tie effect. Remove duplicates with ROW_NUMBER equals 1.

3. Syntax
```sql
SELECT m.marks_obtained,
ROW_NUMBER() OVER (ORDER BY m.marks_obtained DESC) AS rn,
RANK() OVER (ORDER BY m.marks_obtained DESC) AS r,
DENSE_RANK() OVER (ORDER BY m.marks_obtained DESC) AS d
FROM marks m;
```

4. Explanation of keywords
All need OVER plus ORDER BY. PARTITION BY restarts per group. Ties share RANK and DENSE_RANK. ROW_NUMBER stays unique.

5. Examples
Our marks 95, 92, 88, 82, 78, 75, 68, 55 have no ties, so all three give 1 to 8.

Example 1. All three together
```sql
SELECT m.marks_obtained,
ROW_NUMBER() OVER (ORDER BY m.marks_obtained DESC) AS rn,
RANK() OVER (ORDER BY m.marks_obtained DESC) AS r,
DENSE_RANK() OVER (ORDER BY m.marks_obtained DESC) AS d
FROM marks m
ORDER BY m.marks_obtained DESC;
```
Expected output
95 gets 1 1 1. 92 gets 2 2 2. Same down to 55.

Example 2. Tie effect on credits
```sql
SELECT course_name, credits,
RANK() OVER (ORDER BY credits DESC) AS r,
DENSE_RANK() OVER (ORDER BY credits DESC) AS d,
ROW_NUMBER() OVER (ORDER BY credits DESC) AS rn
FROM courses
ORDER BY credits DESC;
```
Expected output
Three 4 credit courses get RANK 1 1 1, next RANK is 4. DENSE next is 2. Shows gap versus no gap.

Example 3. Topper per course
```sql
WITH r AS (
SELECT e.course_id, s.name, m.marks_obtained,
ROW_NUMBER() OVER (PARTITION BY e.course_id ORDER BY m.marks_obtained DESC) AS rn
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
)
SELECT * FROM r WHERE rn = 1;
```
Expected output
DBMS Jeevitha 95. DS Abhishek 75. CN Jeevitha 78. OS Jeevan 68. DE Manjunath 82.

Example 4. Second highest overall
```sql
WITH r AS (
SELECT marks_obtained,
ROW_NUMBER() OVER (ORDER BY marks_obtained DESC) AS rn
FROM marks
)
SELECT * FROM r WHERE rn = 2;
```
Expected output
92, Jeevan DBMS.

Example 5. Second per course
```sql
WITH r AS (
SELECT e.course_id, m.marks_obtained,
ROW_NUMBER() OVER (PARTITION BY e.course_id ORDER BY m.marks_obtained DESC) AS rn
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
)
SELECT * FROM r WHERE rn = 2;
```
Expected output
DBMS 92. CN 55. Other courses have only one row.

6. Common mistakes
Using WHERE rn equals 1 directly. Needs subquery.
Non stable order for ties. Add id to ORDER BY.
Surprised by RANK gaps.
Missing PARTITION for per group.
Using RANK for dedupe. Use ROW_NUMBER.

7. Performance and safety
Read only. Use stable ORDER BY for repeatable results.

8. Practice questions with answers
Q1. Rank all marks.
A1. Example 1. Tests three functions.
Q2. Show tie gap with credits.
A2. Example 2. Tests RANK versus DENSE.
Q3. Show topper per course.
A3. Example 3. Tests PARTITION plus filter.
Q4. Show second highest mark.
A4. Example 4 gives 92. Tests subquery filter.
Q5. Show second mark in DBMS.
A5. Example 5 gives 92. Tests per group second.

9. Revision summary
ROW_NUMBER unique. RANK with gaps. DENSE_RANK no gaps. Filter through subquery.
