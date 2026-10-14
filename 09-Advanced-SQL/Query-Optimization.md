Query Optimization

1. Definition
Optimization means less work: fewer columns, fewer rows, indexed paths, clean filters.

2. Purpose and use cases
Fast reports now and scalable later. Good answers in viva. Safe test habits.

3. Syntax
Good pattern
```sql
SELECT student_id, name FROM students WHERE student_id = 1;
```
Bad pattern
```sql
SELECT * FROM students WHERE YEAR(enrollment_year) = 2023;
```
Good pattern
```sql
SELECT student_id, name FROM students WHERE enrollment_year = 2023 AND dept_id = 1 LIMIT 10;
```

4. Explanation of keywords
Explicit columns beat star. Early WHERE cuts rows. Sargable means index can be used. No function on indexed column. JOIN on primary and foreign keys. LIMIT for tests. Compare forms with EXPLAIN.

5. Examples
Example 1. Explicit columns
```sql
SELECT student_id, name FROM students WHERE dept_id = 1;
```
Expected output
Abhishek and Jeevan. Less data than star.

Example 2. Sargable year filter
```sql
SELECT name FROM students WHERE enrollment_year = 2023;
```
Expected output
Abhishek, Likhith, Jeevitha. Better than YEAR function version.

Example 3. Key join
```sql
SELECT s.name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id = 4;
```
Expected output
Jeevitha 2 rows. Uses primary and foreign keys.

Example 4. EXISTS for check
```sql
SELECT s.name FROM students s
WHERE EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id = s.student_id);
```
Expected output
All 5. Stops early and is NULL safe.

Example 5. UNION versus UNION ALL
```sql
SELECT student_id FROM enrollments WHERE course_id = 1
UNION
SELECT student_id FROM enrollments WHERE course_id = 3;
```
Expected output
4 unique students. Use UNION for dedupe, ALL for speed when dupes are fine.

6. Common mistakes
SELECT star everywhere.
Function on indexed column.
No LIMIT while exploring.
OR across columns. UNION is often better.
Tuning without EXPLAIN.

7. Performance and safety
Read only rewrites are safe. Test on copy. Tiny tables scan and that is normal.

8. Practice questions with answers
Q1. Star versus list.
A1. List wins. Tests less IO.
Q2. Fix year filter.
A2. Use plain equals 2023. Tests sargable.
Q3. Best join columns.
A3. Primary plus foreign keys. Tests Example 3.
Q4. EXISTS versus IN.
A4. EXISTS stops early. Tests check speed.
Q5. UNION versus ALL.
A5. Dedupe versus speed. Tests choice.

9. Revision summary
Fewer columns and rows. Sargable filters. Key joins. LIMIT. Verify with EXPLAIN.
