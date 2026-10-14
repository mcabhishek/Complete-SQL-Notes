Views

1. Definition
A view is a saved SELECT with a name. You query it like a table. A normal MySQL view stores the query, not the data.

2. Purpose and use cases
Simplify student plus department plus average report. Reuse topper query. Hide extra columns. Give limited access.

3. Syntax
```sql
CREATE OR REPLACE VIEW v_student_avg AS
SELECT s.student_id, s.name, d.dept_name, ROUND(AVG(m.marks_obtained), 2) AS avg_marks
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
JOIN enrollments e ON s.student_id = e.student_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.name, d.dept_name;
```

4. Explanation of keywords
CREATE VIEW makes it. OR REPLACE updates it. SELECT after FROM view reads it. DROP VIEW removes it. View versus table: no storage, always fresh. View versus CTE: CTE is one query, view is saved. Simple single table views can update. GROUP BY and JOIN views are read only.

5. Examples
There is no CGPA column in schema. Average marks is used as CGPA proxy.

Example 1. Student average view
```sql
CREATE OR REPLACE VIEW v_student_avg AS
SELECT s.student_id, s.name, d.dept_name, ROUND(AVG(m.marks_obtained), 2) AS avg_marks
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
JOIN enrollments e ON s.student_id = e.student_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY s.student_id, s.name, d.dept_name;
SELECT * FROM v_student_avg ORDER BY avg_marks DESC;
```
Expected output
Jeevitha 86.50. Manjunath 82.00. Abhishek 81.50. Jeevan 80.00. Likhith 55.00.

Example 2. Course topper view
```sql
CREATE OR REPLACE VIEW v_course_top AS
SELECT c.course_name, s.name, m.marks_obtained
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN marks m ON m.enrollment_id = e.enrollment_id
WHERE (e.course_id, m.marks_obtained) IN (
SELECT e2.course_id, MAX(m2.marks_obtained)
FROM enrollments e2 JOIN marks m2 ON m2.enrollment_id = e2.enrollment_id
GROUP BY e2.course_id
);
SELECT * FROM v_course_top;
```
Expected output
5 rows. DBMS Jeevitha 95 and others per course.

Example 3. Simple CS students view
```sql
CREATE OR REPLACE VIEW v_cs_students AS
SELECT student_id, name, email FROM students WHERE dept_id = 1;
SELECT * FROM v_cs_students;
```
Expected output
Abhishek and Jeevan.

Example 4. Update through simple view
```sql
START TRANSACTION;
UPDATE v_cs_students SET email = 'abhishek@college.edu' WHERE student_id = 1;
SELECT * FROM v_cs_students WHERE student_id = 1;
ROLLBACK;
```
Expected effect
Same value restored by ROLLBACK. Only single table simple views allow this.

Example 5. Drop views
```sql
DROP VIEW IF EXISTS v_cs_students;
DROP VIEW IF EXISTS v_student_avg;
DROP VIEW IF EXISTS v_course_top;
```
Expected effect
Views gone. Base tables unchanged.

6. Common mistakes
Updating a GROUP BY or JOIN view.
Thinking view stores a copy.
Adding index on view directly. Index base tables.
Name clash with table.
Using SELECT star in view. List columns.

7. Performance and safety
View uses base table speed. Good for access control. Drops are safe because data stays.

8. Practice questions with answers
Q1. Make average view and list toppers.
A1. Example 1. Tests GROUP BY view.
Q2. Make course topper view.
A2. Example 2. Tests IN subquery view.
Q3. Query a view.
A3. SELECT star FROM view. Tests read.
Q4. Which view is updatable.
A4. Simple single table Example 3. Tests updatable rule.
Q5. Remove a view.
A5. DROP VIEW. Tests cleanup.

9. Revision summary
CREATE VIEW saves SELECT. CTE is short term, view is saved. Simple views update. Not materialized.
