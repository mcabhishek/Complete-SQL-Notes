# Left Join

> Part of **Complete SQL Notes** (`05-Joins`). [Back to roadmap](../README.md).

## Definition

LEFT JOIN returns all rows from the left table, and the matching rows from
the right table. If there is no match in the right table, the right side
columns appear as NULL.

Also written as: LEFT OUTER JOIN (OUTER is optional in MySQL).

## Why It Is Needed

Use LEFT JOIN when you want to keep every record from the left table even
if there is no related record in the right table. Common uses:
- Find students who have no enrollment records.
- Find departments with no students.
- Find courses with no attendance records.

## Syntax

```sql
SELECT columns
FROM   left_table
LEFT JOIN right_table ON left_table.column = right_table.column;
```

## Syntax Explained

left_table          Every row from this table is always included.
right_table         Only matching rows are included. Non-matching rows get NULL.
ON condition        The column that links the two tables.

## Reference Data

departments:
  1-Computer Science   2-Information Science   3-Electronics

students (all belong to existing departments):
  1-Abhishek(1)  2-Jeevan(1)  3-Likhith(2)  4-Jeevitha(2)  5-Manjunath(3)

enrollments: all 5 students have at least one enrollment record.

To show LEFT JOIN returning NULLs, we use a hypothetical or the departments
vs students relationship where a department could have no students.

## Examples

### Example 1 - All students with their enrollment records (matched)

```sql
SELECT s.name, e.enrollment_id, e.course_id
FROM   students s
LEFT JOIN enrollments e ON s.student_id = e.student_id;
```

**Output:**

```text
+-----------+---------------+-----------+
| name      | enrollment_id | course_id |
+-----------+---------------+-----------+
| Abhishek  |             1 |         1 |
| Abhishek  |             2 |         2 |
| Jeevan    |             3 |         1 |
| Jeevan    |             4 |         4 |
| Likhith   |             5 |         3 |
| Jeevitha  |             6 |         3 |
| Jeevitha  |             7 |         1 |
| Manjunath |             8 |         5 |
+-----------+---------------+-----------+
8 rows in set
```

All students have enrollments, so no NULL appears here.
If a student had no enrollment, their row would show NULL for enrollment_id
and course_id.

### Example 2 - Find students who have NO enrollment (NULL detection)

This query finds students where the right side returns NULL, meaning
no match was found in enrollments.

```sql
SELECT s.name, e.enrollment_id
FROM   students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE  e.enrollment_id IS NULL;
```

**Output:**

```text
Empty set (0 rows)
```

### Example 3 - All departments with their students (some depts may have none)

```sql
SELECT d.dept_name, s.name
FROM   departments d
LEFT JOIN students s ON d.dept_id = s.dept_id;
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

All departments have students here. If Electronics had no students, it would
appear with NULL in the name column.

### Example 4 - All courses with their enrollment count (including unenrolled courses)

```sql
SELECT c.course_name, COUNT(e.enrollment_id) AS enrolled_count
FROM   courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;
```

**Output:**

```text
+------------------------+----------------+
| course_name            | enrolled_count |
+------------------------+----------------+
| Database Management    |              3 |
| Data Structures        |              1 |
| Computer Networks      |              2 |
| Operating Systems      |              1 |
| Digital Electronics    |              1 |
+------------------------+----------------+
5 rows in set
```

Note: COUNT(e.enrollment_id) counts only non-NULL values, so a course with
no enrollments would show 0 instead of NULL.

### Example 5 - All students with their marks (LEFT JOIN to include all students)

```sql
SELECT s.name, e.course_id, m.marks_obtained, m.grade
FROM   students    s
LEFT JOIN enrollments e ON s.student_id    = e.student_id
LEFT JOIN marks       m ON e.enrollment_id = m.enrollment_id;
```

**Output:**

```text
+-----------+-----------+----------------+-------+
| name      | course_id | marks_obtained | grade |
+-----------+-----------+----------------+-------+
| Abhishek  |         1 |          88.00 | A     |
| Abhishek  |         2 |          75.00 | B     |
| Jeevan    |         1 |          92.00 | A+    |
| Jeevan    |         4 |          68.00 | C     |
| Likhith   |         3 |          55.00 | D     |
| Jeevitha  |         3 |          78.00 | B     |
| Jeevitha  |         1 |          95.00 | A+    |
| Manjunath |         5 |          82.00 | A     |
+-----------+-----------+----------------+-------+
8 rows in set
```

### Example 6 - Left table: departments, show courses offered per department

```sql
SELECT d.dept_name, COUNT(c.course_id) AS course_count
FROM   departments d
LEFT JOIN courses c ON d.dept_id = c.dept_id
GROUP BY d.dept_id, d.dept_name;
```

**Output:**

```text
+------------------------+--------------+
| dept_name              | course_count |
+------------------------+--------------+
| Computer Science       |            3 |
| Information Science    |            1 |
| Electronics            |            1 |
+------------------------+--------------+
3 rows in set
```

### Example 7 - Students with attendance, show all even if attendance is missing

```sql
SELECT s.name, c.course_name, a.percentage
FROM   students   s
LEFT JOIN attendance a ON s.student_id = a.student_id
LEFT JOIN courses    c ON a.course_id  = c.course_id
ORDER BY s.name;
```

**Output:**

```text
+-----------+------------------------+------------+
| name      | course_name            | percentage |
+-----------+------------------------+------------+
| Abhishek  | Database Management    |      90.00 |
| Abhishek  | Data Structures        |      80.00 |
| Jeevan    | Database Management    |      80.00 |
| Jeevan    | Operating Systems      |      84.00 |
| Jeevitha  | Computer Networks      |      88.89 |
| Jeevitha  | Database Management    |      95.00 |
| Likhith   | Computer Networks      |      80.00 |
| Manjunath | Digital Electronics    |      70.00 |
+-----------+------------------------+------------+
8 rows in set
```

## How the Query Runs

Query:

```sql
SELECT s.name, e.enrollment_id
FROM   students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE  e.enrollment_id IS NULL;
```

Step 1: Start with ALL rows from students (left table) -- 5 rows.
Step 2: For each student, look for matching rows in enrollments.
        - Abhishek: matches enrollments 1 and 2
        - Jeevan: matches enrollments 3 and 4
        - Likhith: matches enrollment 5
        - Jeevitha: matches enrollments 6 and 7
        - Manjunath: matches enrollment 8
        No student is unmatched, so no NULL rows are produced.
Step 3: WHERE e.enrollment_id IS NULL -- filters to only unmatched rows.
Step 4: Result is empty because every student has at least one enrollment.

## Left join vs inner join

| Result | INNER JOIN | LEFT JOIN |
| --- | --- | --- |
| Unmatched left rows | Excluded | Included (NULLs on right) |
| Unmatched right rows | Excluded | Excluded |
| Use case | Need matching data | Need all left rows |

## Common Mistakes

## Using INNER JOIN when you want to include unmatched rows
   Use LEFT JOIN when the left table rows must always appear.

2. Filtering on the right table in WHERE (converts LEFT JOIN to INNER JOIN)
   Wrong:  LEFT JOIN enrollments e ON ... WHERE e.semester = 3
           (This excludes NULL rows -- same as INNER JOIN)
   Right:  LEFT JOIN enrollments e ON s.student_id = e.student_id
               AND e.semester = 3
           (Filter in the ON clause keeps NULL rows)

3. Using COUNT(*) instead of COUNT(right_column)
   COUNT(*) counts NULL rows too. Use COUNT(e.enrollment_id) to count
   only matched rows.

## Confusing which table is left and which is right
   The table after FROM is always the LEFT table.
   The table after LEFT JOIN is the RIGHT table.

## Chaining LEFT JOINs inconsistently
   If you LEFT JOIN a second table to the result of the first join,
   use LEFT JOIN consistently, not a mix of INNER JOIN and LEFT JOIN.

## Exam and Interview Points

- LEFT JOIN = LEFT OUTER JOIN. Both mean the same thing.
- The left table always contributes all its rows.
- Non-matching right-side columns become NULL.
- IS NULL on the right column detects "no match" rows (anti-join pattern).
- Filtering the right side in WHERE converts LEFT JOIN to INNER JOIN.
- Filter conditions specific to the right table belong in ON, not WHERE.

## Practice Questions

**Q1. Show all students and their enrollment_id. Include students with no enrollments.**

- **Answer:**
```sql
SELECT s.name, e.enrollment_id
FROM   students s
LEFT JOIN enrollments e ON s.student_id = e.student_id;
```
All 5 students appear. In our data, all have enrollments, so no NULLs.

**Q2. Find all departments and how many students belong to each.**

- **Answer:**
```sql
SELECT d.dept_name, COUNT(s.student_id) AS student_count
FROM   departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.dept_name;
```
Output: CS=2, IS=2, Electronics=1

**Q3. Show all students with their average marks. Include students who have no marks.**

- **Answer:**
```sql
SELECT s.name, ROUND(AVG(m.marks_obtained), 2) AS avg_marks
FROM   students    s
LEFT JOIN enrollments e ON s.student_id    = e.student_id
LEFT JOIN marks       m ON e.enrollment_id = m.enrollment_id
GROUP BY s.student_id, s.name;
```

**Q4. List all courses and the number of students enrolled. Show 0 for empty courses.**

- **Answer:**
```sql
SELECT c.course_name, COUNT(e.enrollment_id) AS enrolled
FROM   courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;
```

**Q5. Find courses that have no student enrolled (unenrolled courses).**

- **Answer:**
```sql
SELECT c.course_name
FROM   courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE  e.enrollment_id IS NULL;
```
Result: Empty set (all 5 courses have at least one student in our data).

## Revision Summary

LEFT JOIN           Returns ALL rows from left table, matched rows from right
Unmatched right     Columns appear as NULL
Detect no match     WHERE right_column IS NULL
COUNT carefully     Use COUNT(right_column), not COUNT(*), for unmatched rows
Filter placement    Right-table filters belong in ON clause, not WHERE
OUTER keyword       Optional -- LEFT JOIN = LEFT OUTER JOIN
