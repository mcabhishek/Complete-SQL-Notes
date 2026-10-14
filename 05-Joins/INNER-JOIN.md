# Inner Join

> Part of **Complete SQL Notes** (`05-Joins`). [Back to roadmap](../README.md).

## Definition

INNER JOIN returns only the rows where there is a matching value in both tables.
Rows that do not match in either table are excluded from the result.

## Why It Is Needed

Tables store related data separately. To read student names alongside their
course names, you must join the students table with the enrollments table and
then with the courses table. INNER JOIN is the most common way to do this.

## Syntax

```sql
SELECT columns
FROM   table1
INNER JOIN table2 ON table1.column = table2.column;
```

```sql
SELECT columns
FROM   table1
JOIN   table2 ON table1.column = table2.column;
```

## Syntax Explained

table1              The left (first) table.
table2              The right (second) table.
ON condition        The join condition -- usually a foreign key = primary key.
INNER JOIN          Returns only rows where the ON condition is TRUE in both tables.

## Reference Data

students:
  1-Abhishek(dept 1)  2-Jeevan(dept 1)  3-Likhith(dept 2)
  4-Jeevitha(dept 2)  5-Manjunath(dept 3)

enrollments:

| enr_id | student_id | course_id | sem | year |  |  |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 1 | 1 | 3 | 2023-24 | Abhishek | -> DBMS |
| 2 | 1 | 2 | 3 | 2023-24 | Abhishek | -> DS |
| 3 | 2 | 1 | 5 | 2023-24 | Jeevan | -> DBMS |
| 4 | 2 | 4 | 5 | 2023-24 | Jeevan | -> OS |
| 5 | 3 | 3 | 3 | 2023-24 | Likhith | -> CN |
| 6 | 4 | 3 | 3 | 2023-24 | Jeevitha | -> CN |
| 7 | 4 | 1 | 3 | 2023-24 | Jeevitha | -> DBMS |
| 8 | 5 | 5 | 5 | 2023-24 | Manjunath -> DE |  |

courses:
  1-Database Management  2-Data Structures  3-Computer Networks
  4-Operating Systems    5-Digital Electronics

## Examples

### Example 1 - Students with their enrollment records

```sql
SELECT s.student_id, s.name, e.enrollment_id, e.course_id, e.semester
FROM   students s
INNER JOIN enrollments e ON s.student_id = e.student_id;
```

**Output:**

```text
+------------+-----------+---------------+-----------+----------+
| student_id | name      | enrollment_id | course_id | semester |
+------------+-----------+---------------+-----------+----------+
|          1 | Abhishek  |             1 |         1 |        3 |
|          1 | Abhishek  |             2 |         2 |        3 |
|          2 | Jeevan    |             3 |         1 |        5 |
|          2 | Jeevan    |             4 |         4 |        5 |
|          3 | Likhith   |             5 |         3 |        3 |
|          4 | Jeevitha  |             6 |         3 |        3 |
|          4 | Jeevitha  |             7 |         1 |        3 |
|          5 | Manjunath |             8 |         5 |        5 |
+------------+-----------+---------------+-----------+----------+
8 rows in set
```

Abhishek appears twice because he is enrolled in 2 courses.
Jeevitha appears twice for the same reason.

### Example 2 - Student name with their course name

```sql
SELECT s.name, c.course_name
FROM   students s
JOIN   enrollments e ON s.student_id = e.student_id
JOIN   courses     c ON e.course_id  = c.course_id;
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

### Example 3 - Students with their marks and grades

```sql
SELECT s.name, c.course_name, m.marks_obtained, m.grade
FROM   students    s
JOIN   enrollments e ON s.student_id   = e.student_id
JOIN   courses     c ON e.course_id    = c.course_id
JOIN   marks       m ON e.enrollment_id = m.enrollment_id;
```

**Output:**

```text
+-----------+------------------------+----------------+-------+
| name      | course_name            | marks_obtained | grade |
+-----------+------------------------+----------------+-------+
| Abhishek  | Database Management    |          88.00 | A     |
| Abhishek  | Data Structures        |          75.00 | B     |
| Jeevan    | Database Management    |          92.00 | A+    |
| Jeevan    | Operating Systems      |          68.00 | C     |
| Likhith   | Computer Networks      |          55.00 | D     |
| Jeevitha  | Computer Networks      |          78.00 | B     |
| Jeevitha  | Database Management    |          95.00 | A+    |
| Manjunath | Digital Electronics    |          82.00 | A     |
+-----------+------------------------+----------------+-------+
8 rows in set
```

### Example 4 - Students and their department name

```sql
SELECT s.name, d.dept_name
FROM   students    s
JOIN   departments d ON s.dept_id = d.dept_id;
```

**Output:**

```text
+-----------+------------------------+
| name      | dept_name              |
+-----------+------------------------+
| Abhishek  | Computer Science       |
| Jeevan    | Computer Science       |
| Likhith   | Information Science    |
| Jeevitha  | Information Science    |
| Manjunath | Electronics            |
+-----------+------------------------+
5 rows in set
```

### Example 5 - Only students who scored an A+ grade

```sql
SELECT s.name, c.course_name, m.grade
FROM   students    s
JOIN   enrollments e ON s.student_id    = e.student_id
JOIN   courses     c ON e.course_id     = c.course_id
JOIN   marks       m ON e.enrollment_id = m.enrollment_id
WHERE  m.grade = 'A+';
```

**Output:**

```text
+----------+---------------------+-------+
| name     | course_name         | grade |
+----------+---------------------+-------+
| Jeevan   | Database Management | A+    |
| Jeevitha | Database Management | A+    |
+----------+---------------------+-------+
2 rows in set
```

### Example 6 - Count of courses each student is enrolled in

```sql
SELECT s.name, COUNT(e.enrollment_id) AS courses_enrolled
FROM   students    s
JOIN   enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name;
```

**Output:**

```text
+-----------+------------------+
| name      | courses_enrolled |
+-----------+------------------+
| Abhishek  |                2 |
| Jeevan    |                2 |
| Likhith   |                1 |
| Jeevitha  |                2 |
| Manjunath |                1 |
+-----------+------------------+
5 rows in set
```

### Example 7 - Average marks per student

```sql
SELECT s.name, ROUND(AVG(m.marks_obtained), 2) AS avg_marks
FROM   students    s
JOIN   enrollments e ON s.student_id    = e.student_id
JOIN   marks       m ON e.enrollment_id = m.enrollment_id
GROUP BY s.student_id, s.name
ORDER BY avg_marks DESC;
```

**Output:**

```text
+-----------+-----------+
| name      | avg_marks |
+-----------+-----------+
| Jeevitha  |     86.50 |
| Jeevan    |     80.00 |
| Abhishek  |     81.50 |
| Manjunath |     82.00 |
| Likhith   |     55.00 |
+-----------+-----------+
```

Wait - let me recalculate:
Abhishek: (88 + 75) / 2 = 81.50
Jeevan: (92 + 68) / 2 = 80.00
Likhith: 55 / 1 = 55.00
Jeevitha: (78 + 95) / 2 = 86.50
Manjunath: 82 / 1 = 82.00

**Output:**

```text
+-----------+-----------+
| name      | avg_marks |
+-----------+-----------+
| Jeevitha  |     86.50 |
| Manjunath |     82.00 |
| Abhishek  |     81.50 |
| Jeevan    |     80.00 |
| Likhith   |     55.00 |
+-----------+-----------+
5 rows in set
```

## How the Query Runs

Query:

```sql
SELECT s.name, c.course_name
FROM   students s
JOIN   enrollments e ON s.student_id = e.student_id
JOIN   courses     c ON e.course_id  = c.course_id;
```

Step 1: MySQL starts with the students table (5 rows).
Step 2: For each student row, it looks for matching rows in enrollments
        where enrollments.student_id = students.student_id.
        - Abhishek matches enrollments 1 and 2 -> 2 combined rows
        - Jeevan matches enrollments 3 and 4   -> 2 combined rows
        - Likhith matches enrollment 5          -> 1 combined row
        - Jeevitha matches enrollments 6 and 7  -> 2 combined rows
        - Manjunath matches enrollment 8        -> 1 combined row
        Total after first join: 8 rows
Step 3: For each of those 8 rows, MySQL matches enrollments.course_id
        to courses.course_id and adds the course name.
Step 4: SELECT picks s.name and c.course_name from each combined row.
Result: 8 rows.

## Table aliases

Using short aliases makes queries easier to read.

    s  = students
    e  = enrollments
    c  = courses
    d  = departments
    m  = marks
    a  = attendance

Always define the alias right after the table name:
FROM students s
JOIN enrollments e ON s.student_id = e.student_id

## MySQL vs Other Databases

| Feature | MySQL | PostgreSQL | SQL Server |
| --- | --- | --- | --- |
| JOIN alone | = INNER JOIN | = INNER JOIN | = INNER JOIN |
| ON vs USING | Both work | Both work | Both work |
| NATURAL JOIN | Supported | Supported | Not supported |

USING shorthand (when both tables have the same column name):
JOIN enrollments USING (student_id)

## Common Mistakes

## Missing the ON condition
   Wrong:  FROM students JOIN enrollments;
           (produces a CROSS JOIN -- every student matched with every enrollment)
   Right:  FROM students JOIN enrollments ON students.student_id = enrollments.student_id;

## Ambiguous column names without table alias
   Wrong:  SELECT student_id, name FROM students JOIN enrollments ON ...;
           (MySQL may complain: Column 'student_id' is ambiguous)
   Right:  SELECT s.student_id, s.name FROM students s JOIN enrollments e ON ...;

## Expecting INNER JOIN to return NULL rows
   INNER JOIN never returns rows with unmatched data.
   Use LEFT JOIN if you need unmatched rows.

## Counting incorrectly when joining one-to-many
   COUNT(*) after a join counts combined rows, not unique students.
   Use COUNT(DISTINCT s.student_id) to count unique students.

## Joining on the wrong column
   Wrong:  ON s.student_id = c.course_id
   Right:  ON e.course_id = c.course_id

## Exam and Interview Points

- INNER JOIN is the default join type. The word INNER is optional.
- INNER JOIN returns only matched rows. Unmatched rows are dropped.
- One-to-many relationships cause the "left side" row to repeat.
  (Abhishek appears twice because he has 2 enrollments.)
- Always use table aliases when joining multiple tables.
- Use GROUP BY with COUNT or AVG after joins to aggregate data.
- ON specifies the join condition; WHERE further filters the result.

## Practice Questions

**Q1. List all students with their department name.**

- **Answer:**
```sql
SELECT s.name, d.dept_name
FROM   students s
JOIN   departments d ON s.dept_id = d.dept_id;
```
Output: Shows all 5 students with Computer Science, Information Science, or Electronics.

**Q2. Show each student's name and the courses they are enrolled in.**

- **Answer:**
```sql
SELECT s.name, c.course_name
FROM   students    s
JOIN   enrollments e ON s.student_id = e.student_id
JOIN   courses     c ON e.course_id  = c.course_id
ORDER BY s.name;
```

**Q3. Find students who are enrolled in 'Database Management'.**

- **Answer:**
```sql
SELECT s.name
FROM   students    s
JOIN   enrollments e ON s.student_id = e.student_id
JOIN   courses     c ON e.course_id  = c.course_id
WHERE  c.course_name = 'Database Management';
```
Output: Abhishek, Jeevan, Jeevitha

**Q4. Show each student's name, course, and attendance percentage.**

- **Answer:**
```sql
SELECT s.name, c.course_name, a.percentage
FROM   students    s
JOIN   attendance  a ON s.student_id = a.student_id
JOIN   courses     c ON a.course_id  = c.course_id
ORDER BY s.name;
```

**Q5. Find the number of students enrolled in each course.**

- **Answer:**
```sql
SELECT c.course_name, COUNT(e.enrollment_id) AS total_students
FROM   courses     c
JOIN   enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_students DESC;
```

**Output:**

```text
Database Management  -> 3 (Abhishek, Jeevan, Jeevitha)
Computer Networks    -> 2 (Likhith, Jeevitha)
Data Structures      -> 1
Operating Systems    -> 1
Digital Electronics  -> 1
```

## Revision Summary

INNER JOIN          Returns only matched rows from both tables
Unmatched rows      Excluded (dropped from result)
Minimum syntax      JOIN table ON condition
ON clause           Defines which columns must match
One-to-many         Left table rows repeat for each matching right row
Aliases             Use short names like s, e, c, d, m for readability
Filter after join   Use WHERE to further restrict joined results
Aggregate after     Use GROUP BY + COUNT/AVG after joining
