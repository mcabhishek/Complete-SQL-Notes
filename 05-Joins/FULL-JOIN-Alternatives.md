# FULL JOIN Alternatives

> Part of **Complete SQL Notes** (`05-Joins`). [Back to roadmap](../README.md).

## Definition

A FULL OUTER JOIN returns all rows from both tables. Where a match exists,
the columns from both tables are filled in. Where no match exists, the
unmatched side columns appear as NULL.

Result = rows from LEFT JOIN + rows from RIGHT JOIN (without duplicates).

## Why It Is Needed

Use FULL OUTER JOIN when you need to see ALL records from both tables,
including unmatched ones from either side.

Examples:
- See all students AND all courses, showing which ones pair up and which do not.
- See all departments AND all students, including students with no department
  assignment (if allowed) and departments with no students.

## MySQL Limitation

MySQL 8.0 does NOT support FULL OUTER JOIN syntax directly.

Running this will cause an error:

```sql
SELECT s.name, c.course_name
FROM   students s
FULL OUTER JOIN courses c ON s.student_id = c.course_id;
```

MySQL equivalent must be built using UNION of a LEFT JOIN and a RIGHT JOIN.

## MySQL Equivalent Syntax

```sql
SELECT columns
FROM   table1
LEFT JOIN table2 ON table1.col = table2.col
```

    UNION

```sql
SELECT columns
FROM   table1
RIGHT JOIN table2 ON table1.col = table2.col;
```

UNION removes duplicate rows automatically.
If you want to keep duplicates, use UNION ALL (but this is rarely correct
for a FULL OUTER JOIN simulation).

## Reference Data

| students: | 1-Abhishek | 2-Jeevan | 3-Likhith | 4-Jeevitha | 5-Manjunath |
| --- | --- | --- | --- | --- | --- |
| courses: | 1-DBMS | 2-DS | 3-CN | 4-OS | 5-DE |

In our data:
- All 5 students have at least one enrollment.
- All 5 courses have at least one enrollment.
- So a FULL OUTER JOIN on students and courses via enrollments would show
  all combinations with no NULLs.

To clearly demonstrate FULL OUTER JOIN behavior, examples below show it
between tables that could have unmatched rows (departments and courses
if any department had no courses, or vice versa).

## Examples

### Example 1 - FULL OUTER JOIN simulation: all students and all courses

This shows every student alongside every course they are enrolled in, plus:
- Students with no enrollment (NULL on course side)
- Courses with no enrollment (NULL on student side)

```sql
SELECT s.name, c.course_name
FROM   students s
LEFT JOIN enrollments e1 ON s.student_id = e1.student_id
LEFT JOIN courses     c  ON e1.course_id = c.course_id
UNION
SELECT s.name, c.course_name
FROM   students s
RIGHT JOIN enrollments e2 ON s.student_id = e2.student_id
RIGHT JOIN courses     c  ON e2.course_id = c.course_id;
```

**Output:**

```text
+-----------+------------------------+
| name      | course_name            |
+-----------+------------------------+
| Abhishek  | Database Management    |
| Abhishek  | Data Structures        |
| Jeevan    | Database Management    |
| Jeevan    | Operating Systems      |
| Likhith   | Computer Networks      |
| Jeevitha  | Computer Networks      |
| Jeevitha  | Database Management    |
| Manjunath | Digital Electronics    |
+-----------+------------------------+
8 rows in set
```

### Example 2 - Cleaner FULL OUTER JOIN simulation: departments and students

```sql
SELECT d.dept_name, s.name
FROM   departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
UNION
SELECT d.dept_name, s.name
FROM   departments d
RIGHT JOIN students s ON d.dept_id = s.dept_id;
```

**Output:**

```text
+------------------------+-----------+
| dept_name              | name      |
+------------------------+-----------+
| Computer Science       | Abhishek  |
| Computer Science       | Jeevan    |
| Information Science    | Likhith   |
| Information Science    | Jeevitha  |
| Electronics            | Manjunath |
+------------------------+-----------+
5 rows in set
```

No NULLs because every student belongs to a department and every department
has students. If a new department had no students, its row would appear with
NULL in the name column.

### Example 3 - FULL OUTER JOIN with NULL detection (both sides)

Shows unmatched rows from either side.

```sql
SELECT s.name        AS student_name,
       c.course_name AS enrolled_course
FROM   students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses     c ON e.course_id  = c.course_id
UNION
SELECT s.name, c.course_name
FROM   courses c
LEFT JOIN enrollments e ON c.course_id  = e.course_id
LEFT JOIN students    s ON e.student_id = s.student_id
ORDER BY student_name;
```

**Output:**

```text
+--------------+------------------------+
| student_name | enrolled_course        |
+--------------+------------------------+
| Abhishek     | Database Management    |
| Abhishek     | Data Structures        |
| Jeevan       | Database Management    |
| Jeevan       | Operating Systems      |
| Jeevitha     | Computer Networks      |
| Jeevitha     | Database Management    |
| Likhith      | Computer Networks      |
| Manjunath    | Digital Electronics    |
+--------------+------------------------+
8 rows in set
```

### Example 4 - Avoiding duplicates with UNION (not UNION ALL)

UNION automatically removes duplicate rows.
UNION ALL keeps all rows, including duplicates.

In a FULL OUTER JOIN simulation, always use UNION (not UNION ALL) unless
you specifically need duplicates.

```sql
SELECT dept_name FROM departments LEFT JOIN students s ON departments.dept_id = s.dept_id
UNION
SELECT dept_name FROM departments RIGHT JOIN students s ON departments.dept_id = s.dept_id;
SELECT dept_name FROM departments LEFT JOIN students s ON departments.dept_id = s.dept_id
UNION ALL
SELECT dept_name FROM departments RIGHT JOIN students s ON departments.dept_id = s.dept_id;
```

### Example 5 - FULL OUTER JOIN with only unmatched rows (anti-join on both sides)

```sql
SELECT s.name AS unmatched_student, NULL AS unmatched_course
FROM   students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE  e.enrollment_id IS NULL
UNION
SELECT NULL, c.course_name
FROM   courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE  e.enrollment_id IS NULL;
```

**Output:**

```text
Empty set (0 rows)
```

## How the Query Runs

Query (FULL OUTER JOIN simulation):

SELECT d.dept_name, s.name
FROM   departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
UNION

```sql
SELECT d.dept_name, s.name
FROM   departments d
RIGHT JOIN students s ON d.dept_id = s.dept_id;
```

Step 1: Run the LEFT JOIN part.
        - Returns all 3 departments, each with their students.
        - Result: 5 rows (all students matched).
Step 2: Run the RIGHT JOIN part.
        - Returns all students, each with their department.
        - Result: 5 rows (all students matched to their dept).
Step 3: UNION combines the two result sets and removes duplicates.
        - Since both halves produce identical rows in this data, the final
          result is 5 rows (same as either half).
Step 4: Final output: 5 rows showing all departments and students.

## Postgresql and sql server comparison

Database          FULL OUTER JOIN syntax
MySQL 8.0         NOT supported -- use LEFT JOIN UNION RIGHT JOIN
PostgreSQL        FULL OUTER JOIN supported natively
SQL Server        FULL OUTER JOIN supported natively

PostgreSQL / SQL Server syntax:
```sql
SELECT s.name, c.course_name
FROM   students s
FULL OUTER JOIN courses c ON s.student_id = c.course_id;
```

## Common Mistakes

## Trying to write FULL OUTER JOIN directly in MySQL
   MySQL does not support it. Use the UNION approach.

## Using UNION ALL instead of UNION in the simulation
   UNION ALL keeps duplicate rows. This gives incorrect FULL OUTER JOIN behavior.
   Always use UNION to remove duplicates.

## Mismatched column count in UNION parts
   Both SELECT statements in the UNION must have the same number of columns.
   Wrong:  SELECT name FROM ... UNION SELECT dept_name, course_name FROM ...;

## Different data types in UNION columns
   The column data types in both SELECT statements must be compatible.

## Applying ORDER BY to only one part of the UNION
   Place ORDER BY at the very end, after the second SELECT.
   Wrong:  SELECT ... ORDER BY name UNION SELECT ...;
   Right:  SELECT ... UNION SELECT ... ORDER BY name;

## Exam and Interview Points

- MySQL 8.0 does NOT support FULL OUTER JOIN syntax.
- Simulate it with: LEFT JOIN UNION RIGHT JOIN.
- UNION removes duplicate rows; UNION ALL keeps them.
- Both SELECT parts of a UNION must have the same number and compatible columns.
- In exams: write the UNION simulation when asked for FULL OUTER JOIN in MySQL.
- In interviews: mention the limitation and demonstrate the workaround.

## Practice Questions

**Q1. Write a MySQL-compatible FULL OUTER JOIN to show all departments and**

    all students (even if a department has no students or a student has
    no department).

- **Answer:**
```sql
SELECT d.dept_name, s.name
FROM   departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
UNION
SELECT d.dept_name, s.name
FROM   departments d
RIGHT JOIN students s ON d.dept_id = s.dept_id;
```

**Q2. Why does MySQL not support FULL OUTER JOIN directly?**

- **Answer:**
MySQL 8.0 did not implement FULL OUTER JOIN syntax. It is a known limitation.
The UNION-based workaround achieves the same result.

**Q3. What is the difference between UNION and UNION ALL in the FULL OUTER JOIN**

    simulation?

- **Answer:**
UNION removes duplicate rows that appear in both the LEFT JOIN result and the
RIGHT JOIN result. UNION ALL keeps all rows, potentially causing duplicates
where both sides matched. Use UNION for correct FULL OUTER JOIN behavior.

**Q4. Write a query to find all students who have no marks AND all courses that**

    have no marks (unmatched rows on both sides).

- **Answer:**
```sql
SELECT s.name AS item, 'No marks (student)' AS reason
FROM   students s
LEFT JOIN enrollments e ON s.student_id    = e.student_id
LEFT JOIN marks       m ON e.enrollment_id = m.enrollment_id
WHERE  m.mark_id IS NULL
UNION
SELECT c.course_name, 'No marks (course)'
FROM   courses c
LEFT JOIN enrollments e ON c.course_id     = e.course_id
LEFT JOIN marks       m ON e.enrollment_id = m.enrollment_id
WHERE  m.mark_id IS NULL;
```
Result: Empty set (all have marks in our data).

**Q5. Which databases support FULL OUTER JOIN natively, and which do not?**

- **Answer:**
Supported: PostgreSQL, SQL Server, Oracle.
Not supported (MySQL 8.0): Must use LEFT JOIN UNION RIGHT JOIN.

## Revision Summary

FULL OUTER JOIN     Returns all rows from both tables; NULL fills unmatched side
MySQL support       NOT available -- simulate with LEFT JOIN UNION RIGHT JOIN
UNION               Removes duplicate rows (use this for simulation)
UNION ALL           Keeps duplicates (incorrect for FULL OUTER simulation)
Same column count   Both parts of UNION must select the same number of columns
NULL detection      WHERE left_col IS NULL or WHERE right_col IS NULL
