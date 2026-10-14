# COMMON Table Expressions Ctes

> Part of **Complete SQL Notes** (`09-Advanced-SQL`). [Back to roadmap](../README.md).

Common Table Expressions CTEs

## Definition
A CTE is a named temporary result made with WITH. It is used one time in the main query. It makes long queries easy to read.

## Purpose and use cases
Use a CTE to find average marks per student and then filter the result. Use it to break a big query into small steps. Use it instead of a nested subquery when readability matters. A CTE does not make a query faster by itself.

## Syntax
```sql
WITH avg_m AS (
SELECT e.student_id, AVG(m.marks_obtained) AS a
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY e.student_id
)
SELECT s.name, ROUND(avg_m.a, 2) AS avg_marks
FROM students s JOIN avg_m ON avg_m.student_id = s.student_id;
```

## Explanation of keywords

WITH starts the CTE. avg_m is the CTE name. AS holds the inner SELECT. The main SELECT comes after and can read the CTE like a table. Multiple CTEs are separated by comma. A CTE works for only one statement.

## Examples using the five candidates
Average marks in our data are Abhishek 81.50, Jeevan 80.00, Likhith 55.00, Jeevitha 86.50, Manjunath 82.00. Overall average is 79.125.

### Example 1. Average per student

```sql
WITH avg_m AS (
SELECT e.student_id, AVG(m.marks_obtained) AS a
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY e.student_id
)
SELECT s.name, ROUND(avg_m.a, 2) AS avg_marks
FROM students s JOIN avg_m ON avg_m.student_id = s.student_id
ORDER BY s.student_id;
```
Expected output
Abhishek 81.50, Jeevan 80.00, Likhith 55.00, Jeevitha 86.50, Manjunath 82.00
Step by step: inner query groups 8 marks into 5 averages. Outer query joins names.

### Example 2. Students above overall average

```sql
WITH avg_m AS (
SELECT e.student_id, AVG(m.marks_obtained) AS a
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY e.student_id
)
SELECT s.name
FROM students s JOIN avg_m ON avg_m.student_id = s.student_id
WHERE avg_m.a > 79.125;
```
Expected output
Abhishek, Jeevan, Jeevitha, Manjunath. Likhith is below.

### Example 3. Two CTEs, toppers with 80 plus

```sql
WITH avg_m AS (
SELECT e.student_id, AVG(m.marks_obtained) AS a
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY e.student_id
),
toppers AS (
SELECT student_id FROM avg_m WHERE a >= 80
)
SELECT s.name FROM students s JOIN toppers ON toppers.student_id = s.student_id;
```
Expected output
Abhishek, Jeevan, Jeevitha, Manjunath.

### Example 4. CTE with course count

```sql
WITH cnt AS (
SELECT student_id, COUNT(*) AS c FROM enrollments GROUP BY student_id
)
SELECT s.name, cnt.c FROM students s JOIN cnt ON cnt.student_id = s.student_id WHERE cnt.c > 1;
```
Expected output
Abhishek 2, Jeevan 2, Jeevitha 2.

### Example 5. CTE used in UPDATE

```sql
START TRANSACTION;
WITH low AS (
SELECT enrollment_id FROM marks WHERE marks_obtained < 60
)
UPDATE marks SET grade = 'D' WHERE enrollment_id IN (SELECT enrollment_id FROM low);
ROLLBACK;
```
Expected effect
Only enrollment 5, Likhith 55, is touched. ROLLBACK restores data.

## Common mistakes
Using the CTE in a second query. It works for one statement only.
Forgetting comma between two CTEs.
Forgetting RECURSIVE for recursive queries.
Thinking CTE always speeds up the query.
Using same column names in chained CTEs without alias.

## Performance and safety
CTEs are read only and safe. MySQL may materialize the CTE. Check with EXPLAIN on large data. Wrap DML with CTE in a transaction during practice.

## Practice questions with answers

**Q1. Show average marks per student.**

A1. Example 1. Tests GROUP BY in CTE.

**Q2. Show students above 79.125.**

A2. Example 2. Tests CTE plus WHERE.

**Q3. Show students with more than 1 enrollment.**

A3. Example 4. Tests COUNT in CTE.

**Q4. What is the difference between CTE and subquery.**

A4. Same result. CTE is at top with a name. Easier to read.

**Q5. Update grade for marks below 60 using a CTE.**

A5. Example 5. Tests WITH plus UPDATE.

## Revision summary

WITH name AS plus main query. Use comma for more CTEs. Scope is one statement. Good for steps and clarity.
