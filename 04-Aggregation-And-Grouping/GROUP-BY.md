# GROUP By

> Part of **Complete SQL Notes** (04-Aggregation-And-Grouping). [Back to roadmap](../README.md).

# Definition

GROUP BY splits rows into groups, then aggregates each group.
One output row per group. Use with COUNT, SUM, AVG, MIN, MAX.

# Syntax

```sql
SELECT group_col, COUNT(*) AS n
FROM table_name
GROUP BY group_col;
```

Every non-aggregated column in SELECT must appear in GROUP BY.
Order: WHERE -> GROUP BY -> HAVING -> ORDER BY -> LIMIT.

# Reference Data

students depts: 1 has 2 (Abhishek, Jeevan), 2 has 2 (Likhith, Jeevitha),
 3 has 1 (Manjunath)
enrollments per student: 1 has 2, 2 has 2, 3 has 1, 4 has 2, 5 has 1
marks per enrollment listed in setup script.

# Examples

# Example 1 - Students per department

```sql
USE sql_notes;
SELECT dept_id, COUNT(*) AS n FROM students GROUP BY dept_id;
```

**Output:**

```text
dept 1 -> 2, dept 2 -> 2, dept 3 -> 1. 3 rows.
```

# Example 2 - Enrollments per student

```sql
SELECT student_id, COUNT(*) AS courses
FROM enrollments GROUP BY student_id;
```

**Output:** 1->2, 2->2, 3->1, 4->2, 5->1. 5 rows.

# Example 3 - Average marks per student

```sql
SELECT e.student_id, ROUND(AVG(m.marks_obtained),2) AS avg_m
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
GROUP BY e.student_id ORDER BY e.student_id;
```

**Output:** 1->81.50, 2->80.00, 3->55.00, 4->86.50, 5->82.00.

# Example 4 - Courses per department

```sql
SELECT dept_id, COUNT(*) AS n FROM courses GROUP BY dept_id;
```

**Output:** dept 1 -> 3 (DBMS, DS, OS), dept 2 -> 1 (CN), dept 3 -> 1 (DE).

# Example 5 - Grade distribution

```sql
SELECT grade, COUNT(*) AS n FROM marks GROUP BY grade ORDER BY n DESC;
```

**Output:** A 2, B 2, A+ 2, C 1, D 1. 5 rows.

# How the Query Runs

Query: SELECT dept_id, COUNT(*) FROM students GROUP BY dept_id;
Step 1: Read 5 rows. Step 2: Bucket by dept_id (1/2/3).
Step 3: COUNT each bucket: 2, 2, 1.

# MySQL vs Other Databases

GROUP BY same everywhere. MySQL historically allowed bare columns
(ONLY_FULL_GROUP_BY off). Keep it ON: every bare column in GROUP BY.
PostgreSQL and SQL Server always enforce this.

# Common Mistakes

1. Bare column not in GROUP BY: SELECT dept_id, name ... GROUP BY dept_id
 fails with ONLY_FULL_GROUP_BY. Fix: add name to GROUP BY or aggregate it.
2. WHERE vs HAVING: WHERE filters rows first, HAVING filters groups after.
3. GROUP BY alias: MySQL allows GROUP BY alias, others need column.
4. COUNT after join counts joined rows, not base rows. Use DISTINCT.
5. Forgetting ORDER BY after GROUP BY gives random group order.

# Practice Questions

**Q1. Count students per enrollment year.**

- **Answer:** SELECT enrollment_year, COUNT(*) FROM students GROUP BY enrollment_year;

**Q2. Average attendance per student.**

- **Answer:** SELECT student_id, AVG(percentage) FROM attendance GROUP BY student_id;

**Q3. Max marks per grade band.**

- **Answer:** SELECT grade, MAX(marks_obtained) FROM marks GROUP BY grade;

**Q4. Total credits per dept.**

- **Answer:** SELECT dept_id, SUM(credits) FROM courses GROUP BY dept_id;

**Q5. Enrollments per course.**

- **Answer:** SELECT course_id, COUNT(*) FROM enrollments GROUP BY course_id;

# Revision Summary

GROUP BY buckets rows. One row per group. Bare columns must be grouped.
WHERE before, HAVING after. Add ORDER BY for stable output.






