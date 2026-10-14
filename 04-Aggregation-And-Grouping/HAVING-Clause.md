# Having Clause

> Part of **Complete SQL Notes** (04-Aggregation-And-Grouping). [Back to roadmap](../README.md).

# Definition

HAVING filters groups after GROUP BY. WHERE filters rows before
grouping. HAVING can use aggregates like COUNT(*) > 1 or AVG(x) > 80.

# Syntax

sql
SELECT group_col, COUNT(*) AS n
FROM table_name
GROUP BY group_col


# Having count(*) > 1;

Full order:
 WHERE -> GROUP BY -> HAVING -> ORDER BY -> LIMIT.

# Reference Data

enrollments per student: 1->2, 2->2, 3->1, 4->2, 5->1
student avgs: 1->81.50, 2->80.00, 3->55.00, 4->86.50, 5->82.00
course counts: DBMS 3, CN 2, DS 1, OS 1, DE 1

# Examples

# Example 1 - Students with more than 1 enrollment

sql
USE sql_notes;
SELECT student_id, COUNT(*) AS n
FROM enrollments GROUP BY student_id HAVING COUNT(*) > 1;


Output: 1->2, 2->2, 4->2. 3 rows. Students 3 and 5 excluded.

# Example 2 - Students averaging 80 plus

sql
SELECT e.student_id, ROUND(AVG(m.marks_obtained),2) AS avg_m
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY e.student_id HAVING AVG(m.marks_obtained) >= 80;


Output: 1 (81.50), 2 (80.00), 4 (86.50), 5 (82.00). Likhith 55 out.

# Example 3 - Courses with 2 plus students

sql
SELECT course_id, COUNT(*) AS n
FROM enrollments GROUP BY course_id HAVING COUNT(*) >= 2;


Output: course 1 (DBMS) 3, course 3 (CN) 2.

# Example 4 - WHERE plus HAVING together

sql
SELECT e.student_id, COUNT(*) AS n
FROM enrollments e WHERE e.semester = 3
GROUP BY e.student_id HAVING COUNT(*) > 1;


Output: student 1 (2 rows in sem 3), student 4 (2 rows in sem 3).
WHERE keeps sem 3 first, then HAVING keeps groups with 2 rows.

# Example 5 - HAVING without GROUP BY edge

sql
SELECT COUNT(*) AS n FROM students HAVING COUNT(*) > 10;


Output: Empty set. Whole table is one group of 5, 5 > 10 false.

# How the Query Runs

Query: GROUP BY student_id HAVING COUNT(*) > 1;
Step 1: WHERE filters rows. Step 2: GROUP BY buckets.
Step 3: Aggregates per bucket. Step 4: HAVING keeps buckets passing.
Step 5: ORDER BY and LIMIT apply last.

# MySQL vs Other Databases

HAVING identical in all three. MySQL allows HAVING alias
(HAVING n > 1). PostgreSQL and SQL Server need full expression.

# Common Mistakes

1. HAVING without GROUP BY confusion. It treats table as one group.
2. Using WHERE on aggregate: WHERE COUNT(*)>1 fails. Use HAVING.
3. Using HAVING on row filter: HAVING age>20 without GROUP BY is
 wrong style. Use WHERE age>20.
4. Alias portability: HAVING n>1 works in MySQL only.
5. Wrong order: HAVING before GROUP BY is syntax error.

# Practice Questions

**Q1. Depts with 2 plus students.**

- **Answer:** SELECT dept_id, COUNT(*) FROM students GROUP BY dept_id HAVING COUNT(*)>=2;

**Q2. Grades appearing twice or more.**

- **Answer:** SELECT grade, COUNT(*) FROM marks GROUP BY grade HAVING COUNT(*)>=2;

**Q3. Students with avg below 80.**

- **Answer:** JOIN enrollments+marks GROUP BY student HAVING AVG(marks)<80; Output: Likhith.

**Q4. Why does WHERE AVG(x)>80 fail? Fix it.**

- **Answer:** Aggregates need HAVING after GROUP BY, not WHERE.

**Q5. Semesters with 3 plus enrollments.**

- **Answer:** SELECT semester, COUNT(*) FROM enrollments GROUP BY semester HAVING COUNT(*)>=3;

# Revision Summary

WHERE rows first. GROUP BY buckets. HAVING groups after.
HAVING uses aggregates. Alias in HAVING is MySQL only.






