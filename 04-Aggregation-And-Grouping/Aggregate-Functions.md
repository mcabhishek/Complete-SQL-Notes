# Aggregate Functions

> Part of **Complete SQL Notes** (04-Aggregation-And-Grouping). [Back to roadmap](../README.md).

## Definition

Aggregate functions collapse many rows into one value: count rows,
sum, average, min, max. Without GROUP BY they return a single row.

## Syntax

| COUNT(*) | COUNT(col) | COUNT(DISTINCT col) | |
| --- | --- | --- | --- |
| SUM(col) | AVG(col) | MIN(col) | MAX(col) |

COUNT(*) counts rows. COUNT(col) skips NULLs.
SUM/AVG ignore NULLs. MIN/MAX ignore NULLs.

## Reference Data

marks 8 rows: 88, 75, 92, 68, 55, 78, 95, 82
total 633, avg 79.125, min 55, max 95
students 5 rows, depts 3, courses 5, enrollments 8

## Examples

### Example 1 - COUNT rows

```sql
USE sql_notes;
SELECT COUNT(*) AS total_students FROM students;
```


**Output:**

```text
+----------------+
| total_students |
+----------------+
|              5 |
+----------------+
1 row in set
```


### Example 2 - COUNT column vs COUNT star

```sql
SELECT COUNT(*) AS rows_n, COUNT(email) AS emails FROM students;
```


Output: 5, 5 (no NULL emails, so equal here).

### Example 3 - SUM and AVG marks

```sql
SELECT SUM(marks_obtained) AS total, ROUND(AVG(marks_obtained),2) AS avg_m
FROM marks;
```


Output: total 633.00, avg_m 79.13. 1 row.

### Example 4 - MIN and MAX

```sql
SELECT MIN(marks_obtained) AS low, MAX(marks_obtained) AS high FROM marks;
```


Output: low 55.00, high 95.00.

### Example 5 - COUNT DISTINCT grades

```sql
SELECT COUNT(DISTINCT grade) AS grade_types FROM marks;
```


Output: 5 (A, B, A+, C, D).

### Example 6 - AVG attendance

```sql
SELECT ROUND(AVG(percentage),2) AS avg_att FROM attendance;
```


Output: 83.49. Sum 667.89 over 8 rows.

## How the Query Runs

Query: SELECT AVG(marks_obtained) FROM marks;
Step 1: Read 8 rows. Step 2: Sum 633, divide by 8 = 79.125.

## MySQL vs Other Databases

COUNT/SUM/AVG/MIN/MAX identical in MySQL, PostgreSQL, SQL Server.
All skip NULLs except COUNT(*).

## Common Mistakes

1. COUNT(col) vs COUNT(*): col skips NULLs.
2. AVG of empty set is NULL, not zero.
3. Mixing aggregate with plain column without GROUP BY errors.
4. SUM on text column coerces or errors. Keep numeric.
5. ROUND after AVG: SELECT ROUND(AVG(x),2) not AVG(ROUND(x,2)).

## Practice Questions

**Q1. How many enrollments?**

- **Answer:** SELECT COUNT(*) FROM enrollments; Output: 8.

**Q2. Total and average marks?**

- **Answer:** SELECT SUM(marks_obtained), AVG(marks_obtained) FROM marks;

**Q3. Lowest and highest attendance?**

- **Answer:** SELECT MIN(percentage), MAX(percentage) FROM attendance;

**Q4. Distinct departments in students?**

- **Answer:** SELECT COUNT(DISTINCT dept_id) FROM students; Output: 3.

**Q5. Average age?**

- **Answer:** SELECT AVG(age) FROM students; Output: 20.40.

## Revision Summary

COUNT rows. SUM total. AVG mean. MIN MAX extremes.
DISTINCT inside counts unique. Aggregates ignore NULLs.






