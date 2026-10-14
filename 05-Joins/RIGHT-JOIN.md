# Right Join

> Part of **Complete SQL Notes** (`05-Joins`). [Back to roadmap](../README.md).

## Definition

RIGHT JOIN returns all rows from the right table, and the matching rows from
the left table. If there is no match in the left table, the left side columns
appear as NULL.

Also written as: RIGHT OUTER JOIN (OUTER is optional).

RIGHT JOIN is the mirror image of LEFT JOIN. In practice, most developers
rewrite RIGHT JOINs as LEFT JOINs by swapping the table order, which is
easier to read.

## Why It Is Needed

Use RIGHT JOIN when the right table must always contribute all its rows,
regardless of whether a match exists in the left table.

Example use cases:
- Show all courses, even ones with no enrolled students (courses is right table).
- Show all departments, even those with no courses assigned.

## Syntax

```sql
SELECT columns
FROM   left_table
RIGHT JOIN right_table ON left_table.column = right_table.column;
```

## Syntax Explained

left_table          Only matching rows from here are included; non-matches = NULL.
right_table         Every row from this table is always included.
ON condition        The column linking the two tables.

## Reference Data

enrollments:

| enr_id | student_id | course_id |  |  |  |
| --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 |  |  |  |
| 2 | 1 | 2 |  |  |  |
| 3 | 2 | 1 |  |  |  |
| 4 | 2 | 4 |  |  |  |
| 5 | 3 | 3 |  |  |  |
| 6 | 4 | 3 |  |  |  |
| 7 | 4 | 1 |  |  |  |
| 8 | 5 | 5 |  |  |  |
| courses: | 1-DBMS | 2-DS | 3-CN | 4-OS | 5-DE |

All five courses have at least one enrollment in our data.

## Examples

### Example 1 - All courses with their enrollments (courses is right table)

```sql
SELECT c.course_name, e.enrollment_id, e.student_id
FROM   enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id
ORDER BY c.course_id;
```

**Output:**

```text
+------------------------+---------------+------------+
| course_name            | enrollment_id | student_id |
+------------------------+---------------+------------+
| Database Management    |             1 |          1 |
| Database Management    |             7 |          4 |
| Database Management    |             3 |          2 |
| Data Structures        |             2 |          1 |
| Computer Networks      |             5 |          3 |
| Computer Networks      |             6 |          4 |
| Operating Systems      |             4 |          2 |
| Digital Electronics    |             8 |          5 |
+------------------------+---------------+------------+
8 rows in set
```

All 5 courses appear. DBMS appears 3 times because 3 students enrolled.

### Example 2 - Find courses with no students enrolled (NULL detection)

```sql
SELECT c.course_name, e.enrollment_id
FROM   enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id
WHERE  e.enrollment_id IS NULL;
```

**Output:**

```text
Empty set (0 rows)
```

### Example 3 - All departments with their courses (departments is right table)

```sql
SELECT d.dept_name, c.course_name
FROM   courses c
RIGHT JOIN departments d ON c.dept_id = d.dept_id
ORDER BY d.dept_id;
```

**Output:**

```text
+------------------------+------------------------+
| dept_name              | course_name            |
+------------------------+------------------------+
| Computer Science       | Database Management    |
| Computer Science       | Data Structures        |
| Computer Science       | Operating Systems      |
| Information Science    | Computer Networks      |
| Electronics            | Digital Electronics    |
+------------------------+------------------------+
5 rows in set
```

### Example 4 - Student names and all courses (RIGHT JOIN ensures all courses appear)

```sql
SELECT s.name, c.course_name
FROM   students s
RIGHT JOIN courses c ON s.student_id IN (
    SELECT student_id FROM enrollments WHERE course_id = c.course_id
);
```

Note: This form is complex. The cleaner way is to use enrollments as a bridge:

```sql
SELECT s.name, c.course_name
FROM   enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id
LEFT  JOIN students s ON e.student_id = s.student_id
ORDER BY c.course_name;
```

**Output:**

```text
+-----------+------------------------+
| name      | course_name            |
+-----------+------------------------+
| Likhith   | Computer Networks      |
| Jeevitha  | Computer Networks      |
| Abhishek  | Data Structures        |
| Abhishek  | Database Management    |
| Jeevan    | Database Management    |
| Jeevitha  | Database Management    |
| Manjunath | Digital Electronics    |
| Jeevan    | Operating Systems      |
+-----------+------------------------+
8 rows in set
```

### Example 5 - RIGHT JOIN rewritten as LEFT JOIN (equivalent)

These two queries return the same result:

```sql
SELECT c.course_name, COUNT(e.enrollment_id) AS students
FROM   enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name;
SELECT c.course_name, COUNT(e.enrollment_id) AS students
FROM   courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;
```

**Output:**

```text
+------------------------+----------+
| course_name            | students |
+------------------------+----------+
| Database Management    |        3 |
| Data Structures        |        1 |
| Computer Networks      |        2 |
| Operating Systems      |        1 |
| Digital Electronics    |        1 |
+------------------------+----------+
5 rows in set
```

## How the Query Runs

Query:

```sql
SELECT c.course_name, e.enrollment_id
FROM   enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id;
```

Step 1: Start with ALL rows from courses (right table) -- 5 rows.
Step 2: For each course, look for matching rows in enrollments.
        - DBMS (1): matches enrollments 1, 3, 7 -> 3 combined rows

| - DS (2): | matches enrollment 2 | -> 1 combined row |
| --- | --- | --- |
| - CN (3): | matches enrollments 5, 6 | -> 2 combined rows |
| - OS (4): | matches enrollment 4 | -> 1 combined row |
| - DE (5): | matches enrollment 8 | -> 1 combined row |

Step 3: Since all courses have enrollments, no NULL rows appear.
Step 4: SELECT picks course_name and enrollment_id.
Result: 8 rows.

## RIGHT JOIN vs LEFT JOIN

They are equivalent when you swap the table positions.

## From a right join b on ...

    is the same as

## From b left join  a on ...

Most style guides prefer LEFT JOIN because it reads more naturally
(left table is the "main" table).

## Common Mistakes

1. Forgetting that RIGHT JOIN keeps the right table's rows, not the left
   The left table gets NULLs for unmatched rows, not the right.

## Mixing RIGHT JOIN with other joins in a confusing order
   Stick to LEFT JOINs and reorganize the query for clarity.

3. Using WHERE on the left table column (converts to INNER JOIN)
   Wrong:  RIGHT JOIN courses c ON ... WHERE e.semester = 3
   Right:  RIGHT JOIN courses c ON e.course_id = c.course_id AND e.semester = 3

## Thinking RIGHT JOIN is rare and unimportant
   It appears in exams. Know that it is the mirror of LEFT JOIN.

## Not accounting for one-to-many duplication
   If DBMS has 3 enrollments, DBMS appears 3 times in the result.

## Exam and Interview Points

## - right join = right outer join.

- The right table always contributes all its rows.
- The left table shows NULL for unmatched rows.
- Every RIGHT JOIN can be rewritten as a LEFT JOIN by swapping tables.
- WHERE right_column IS NULL detects courses/departments with no data.
- RIGHT JOIN is rarely used in production; LEFT JOIN is preferred.

## Practice Questions

**Q1. List all courses and how many students are enrolled in each.**

    Include courses with zero enrollments.

- **Answer:**
```sql
SELECT c.course_name, COUNT(e.enrollment_id) AS enrolled
FROM   enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name;
```

**Q2. Rewrite the query above using LEFT JOIN instead of RIGHT JOIN.**

- **Answer:**
```sql
SELECT c.course_name, COUNT(e.enrollment_id) AS enrolled
FROM   courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;
```

**Q3. Find all departments and show the number of courses they offer.**

- **Answer:**
```sql
SELECT d.dept_name, COUNT(c.course_id) AS courses
FROM   courses c
RIGHT JOIN departments d ON c.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name;
```
Output: CS=3, IS=1, Electronics=1

**Q4. Show all courses along with the student names enrolled. Include courses**

    with no students (show NULL for student name).

- **Answer:**
```sql
SELECT c.course_name, s.name
FROM   enrollments e
RIGHT JOIN courses  c ON e.course_id  = c.course_id
LEFT  JOIN students s ON e.student_id = s.student_id;
```

**Q5. Find courses that have no enrollments using RIGHT JOIN.**

- **Answer:**
```sql
SELECT c.course_name
FROM   enrollments e
RIGHT JOIN courses c ON e.course_id = c.course_id
WHERE  e.enrollment_id IS NULL;
```
Result: Empty set (all courses are enrolled in our data).

## Revision Summary

RIGHT JOIN          Returns ALL rows from right table, matched rows from left
Unmatched left      Columns appear as NULL
Equivalent to       Swap tables and use LEFT JOIN
Detection pattern   WHERE left_column IS NULL
OUTER keyword       Optional -- RIGHT JOIN = RIGHT OUTER JOIN
Preference          Most developers use LEFT JOIN and avoid RIGHT JOIN
