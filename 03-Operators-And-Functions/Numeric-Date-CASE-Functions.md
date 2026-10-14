# Numeric Date CASE Functions

> Part of **Complete SQL Notes** (03-Operators-And-Functions). [Back to roadmap](../README.md).

# Definition

Numeric functions do math and rounding. Date functions read and
shift dates. CASE adds if-then logic to any query.

# Syntax

| ROUND(x, d) | CEIL(x) | FLOOR(x) | ABS(x) | MOD(a, b) | POW(a, b) |
| --- | --- | --- | --- | --- | --- |
| CURDATE() | NOW() | YEAR(d) | MONTH(d) | DAY(d) | |
| DATEDIFF(a, b) | DATE_ADD(d, INTERVAL n UNIT) | DATE_FORMAT(d, fmt) | | | |

 CASE WHEN cond THEN val ELSE other END

# Reference Data

marks: 88, 75, 92, 68, 55, 78, 95, 82 (avg 79.125)
enrollment_year: 2023, 2022, 2023, 2023, 2022
attendance percentage stored: 90.00, 80.00, 80.00, 84.00, 80.00,

# 89, 95.00, 70.00

# Examples

# Example 1 - ROUND average marks

sql
USE sql_notes;
SELECT ROUND(AVG(marks_obtained), 2) AS avg_m FROM marks;


Output: 79.13 (exact avg 79.125 rounded to 2 decimals). 1 row.

# Example 2 - CEIL and FLOOR on attendance

sql
SELECT percentage, CEIL(percentage) AS up, FLOOR(percentage) AS down
FROM attendance WHERE attendance_id IN (6, 7);


Output: 88.89 -> 89/88. 95.00 -> 95/95. 2 rows.

# Example 3 - Grade label with CASE

sql
SELECT marks_obtained,
 CASE WHEN marks_obtained >= 90 THEN A+
 WHEN marks_obtained >= 80 THEN A
 WHEN marks_obtained >= 70 THEN B
 ELSE C-or-below END AS band
FROM marks ORDER BY marks_obtained DESC LIMIT 3;


Output: 95 A+, 92 A+, 88 A.

# Example 4 - YEAR and CURDATE

sql
SELECT name, enrollment_year, YEAR(CURDATE()) AS this_year FROM students;


Output: each name with 2023/2022 plus current year. 5 rows.

# Example 5 - DATE_ADD and DATEDIFF

sql
SELECT DATE_ADD(2023-01-01, INTERVAL 6 MONTH) AS half_year;
SELECT DATEDIFF(2023-07-01, 2023-01-01) AS days_diff;


Output: 2023-07-01. days_diff 181.

# How the Query Runs

Query: SELECT ROUND(AVG(marks_obtained),2) FROM marks;
Step 1: AVG over 8 rows = 79.125. Step 2: ROUND to 79.13.

# MySQL vs Other Databases

ROUND/CEIL/FLOOR/ABS/MOD same everywhere.
DATE_FORMAT is MySQL. PostgreSQL uses TO_CHAR. SQL Server uses FORMAT.
DATEDIFF order differs: MySQL DATEDIFF(a,b) = a-b in days.

# Common Mistakes

1. ROUND without decimals: ROUND(79.125) = 79. Add ,2 for 79.13.
2. Integer division surprise: 5/2 = 2.5 in MySQL, use DIV for integer.
3. CASE missing ELSE gives NULL for unmatched rows.
4. DATE_ADD wrong unit: INTERVAL 6 MONTHS fails, use MONTH singular.

# Practice Questions

**Q1. Average attendance rounded to 1 decimal.**

- **Answer:** SELECT ROUND(AVG(percentage),1) FROM attendance;

**Q2. Label marks pass/fail at 40.**

- **Answer:** SELECT marks_obtained, CASE WHEN marks_obtained>=40 THEN PASS ELSE FAIL END FROM marks;

**Q3. Years since each enrollment.**

- **Answer:** SELECT name, YEAR(CURDATE())-enrollment_year AS yrs FROM students;

**Q4. FLOOR of each percentage.**

- **Answer:** SELECT percentage, FLOOR(percentage) FROM attendance;

**Q5. ABS difference from 80.**

- **Answer:** SELECT marks_obtained, ABS(marks_obtained-80) FROM marks;

# Revision Summary

ROUND CEIL FLOOR ABS MOD math. YEAR NOW DATEDIFF dates.
CASE WHEN logic. DATE unit singular. Portable math, dialect dates.






