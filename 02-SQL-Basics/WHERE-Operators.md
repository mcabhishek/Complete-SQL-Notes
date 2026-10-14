WHERE CLAUSE AND OPERATORS
==========================


DEFINITION

The WHERE clause filters rows returned by a query. Without WHERE, SQL returns
every row. With WHERE, only rows that satisfy the condition are returned.

WHERE works with SELECT, UPDATE, and DELETE.



SYNTAX

    SELECT column1, column2
    FROM   table_name
    WHERE  condition;

The condition evaluates to TRUE or FALSE for each row.
Rows where it is TRUE are included. Rows where it is FALSE or NULL are excluded.



COMPARISON OPERATORS

Operator    Meaning                  Example
=           Equal to                 age = 20
!= or <>    Not equal to             gender != 'M'
>           Greater than             age > 20
<           Less than                age < 21
>=          Greater than or equal    marks_obtained >= 80
<=          Less than or equal       credits <= 3


LOGICAL OPERATORS

Operator    Meaning                              Example
AND         Both conditions must be TRUE         age > 19 AND gender = 'M'
OR          At least one condition must be TRUE  dept_id = 1 OR dept_id = 2
NOT         Reverses the condition               NOT gender = 'F'


SPECIAL OPERATORS

Operator              Purpose                   Example
BETWEEN a AND b       Range (inclusive)          age BETWEEN 19 AND 21
IN (...)              Match any value in list    dept_id IN (1, 2)
NOT IN (...)          Exclude values in list     dept_id NOT IN (3)
LIKE                  Pattern matching           name LIKE 'J%'
IS NULL               Check for NULL             email IS NULL
IS NOT NULL           Check for non-NULL         email IS NOT NULL



REFERENCE DATA

students table:
+------------+-----------+-----+--------+-----------------------+---------+-----------------+
| student_id | name      | age | gender | email                 | dept_id | enrollment_year |
+------------+-----------+-----+--------+-----------------------+---------+-----------------+
|          1 | Abhishek  |  20 | M      | abhishek@college.edu  |       1 |            2023 |
|          2 | Jeevan    |  21 | M      | jeevan@college.edu    |       1 |            2022 |
|          3 | Likhith   |  20 | M      | likhith@college.edu   |       2 |            2023 |
|          4 | Jeevitha  |  19 | F      | jeevitha@college.edu  |       2 |            2023 |
|          5 | Manjunath |  22 | M      | manjunath@college.edu |       3 |            2022 |
+------------+-----------+-----+--------+-----------------------+---------+-----------------+



EXAMPLES

Example 1 - Equal to

```sql
SELECT * FROM students WHERE student_id = 4;
```

Output:
+------------+----------+-----+--------+----------------------+---------+-----------------+
| student_id | name     | age | gender | email                | dept_id | enrollment_year |
+------------+----------+-----+--------+----------------------+---------+-----------------+
|          4 | Jeevitha |  19 | F      | jeevitha@college.edu |       2 |            2023 |
+------------+----------+-----+--------+----------------------+---------+-----------------+
1 row in set



Example 2 - Not equal to

```sql
SELECT name, dept_id FROM students WHERE dept_id != 1;
```

Output:
+-----------+---------+
| name      | dept_id |
+-----------+---------+
| Likhith   |       2 |
| Jeevitha  |       2 |
| Manjunath |       3 |
+-----------+---------+
3 rows in set



Example 3 - Greater than

```sql
SELECT name, age FROM students WHERE age > 20;
```

Output:
+-----------+-----+
| name      | age |
+-----------+-----+
| Jeevan    |  21 |
| Manjunath |  22 |
+-----------+-----+
2 rows in set



Example 4 - AND operator

```sql
SELECT name, gender, enrollment_year
FROM students
WHERE gender = 'M' AND enrollment_year = 2023;
```

Output:
+----------+--------+-----------------+
| name     | gender | enrollment_year |
+----------+--------+-----------------+
| Abhishek | M      |            2023 |
| Likhith  | M      |            2023 |
+----------+--------+-----------------+
2 rows in set



Example 5 - OR operator

```sql
SELECT name, dept_id FROM students WHERE dept_id = 1 OR dept_id = 3;
```

Output:
+-----------+---------+
| name      | dept_id |
+-----------+---------+
| Abhishek  |       1 |
| Jeevan    |       1 |
| Manjunath |       3 |
+-----------+---------+
3 rows in set



Example 6 - BETWEEN

BETWEEN 19 AND 21 is the same as age >= 19 AND age <= 21.
Both endpoints are included.

```sql
SELECT name, age FROM students WHERE age BETWEEN 19 AND 21;
```

Output:
+----------+-----+
| name     | age |
+----------+-----+
| Abhishek |  20 |
| Jeevan   |  21 |
| Likhith  |  20 |
| Jeevitha |  19 |
+----------+-----+
4 rows in set



Example 7 - IN

IN is cleaner than writing multiple OR conditions.

```sql
SELECT name, dept_id FROM students WHERE dept_id IN (1, 2);
```

Output:
+----------+---------+
| name     | dept_id |
+----------+---------+
| Abhishek |       1 |
| Jeevan   |       1 |
| Likhith  |       2 |
| Jeevitha |       2 |
+----------+---------+
4 rows in set



Example 8 - NOT IN

```sql
SELECT name, dept_id FROM students WHERE dept_id NOT IN (2);
```

Output:
+-----------+---------+
| name      | dept_id |
+-----------+---------+
| Abhishek  |       1 |
| Jeevan    |       1 |
| Manjunath |       3 |
+-----------+---------+
3 rows in set



Example 9 - LIKE

LIKE wildcards:
  %   matches zero or more characters
  _   matches exactly one character

```sql
SELECT name FROM students WHERE name LIKE 'J%';
```

Output:
+----------+
| name     |
+----------+
| Jeevan   |
| Jeevitha |
+----------+
2 rows in set

```sql
SELECT name FROM students WHERE name LIKE '%th%';
```

Output: Likhith, Jeevitha, Manjunath



Example 10 - IS NULL / IS NOT NULL

```sql
SELECT name FROM students WHERE email IS NULL;
SELECT name FROM students WHERE email IS NOT NULL;
```



Example 11 - Mixing AND and OR with parentheses

```sql
SELECT name
FROM students
WHERE (dept_id = 1 OR dept_id = 2) AND age < 21;
```

Output:
+----------+
| name     |
+----------+
| Abhishek |
| Likhith  |
| Jeevitha |
+----------+
3 rows in set



HOW THE QUERY RUNS (STEP BY STEP)

Query:
    SELECT name, age FROM students WHERE age >= 20 AND dept_id = 1;

Step 1: MySQL reads FROM students.
Step 2: For each row, evaluates age >= 20 AND dept_id = 1:
  - Abhishek  : 20 >= 20 = YES, dept_id = 1 = YES  -> included
  - Jeevan    : 21 >= 20 = YES, dept_id = 1 = YES  -> included
  - Likhith   : 20 >= 20 = YES, dept_id = 2 = NO   -> excluded
  - Jeevitha  : 19 >= 20 = NO                       -> excluded
  - Manjunath : 22 >= 20 = YES, dept_id = 3 = NO   -> excluded
Step 3: Returns only rows where condition is TRUE.
Step 4: Picks only name and age columns.

Output:
+----------+-----+
| name     | age |
+----------+-----+
| Abhishek |  20 |
| Jeevan   |  21 |
+----------+-----+



OPERATOR PRECEDENCE (highest to lowest)

1. ()      parentheses
2. =, !=, <, >, <=, >=, BETWEEN, IN, LIKE, IS NULL
3. NOT
4. AND
5. OR      (lowest)

Always use parentheses when mixing AND and OR to make intent clear.



MYSQL VS. OTHER DATABASES

Feature              MySQL          PostgreSQL       SQL Server
LIKE case-sensitive  No (default)   Yes              No
ILIKE               Not supported  Supported        Not supported
!= and <>           Both work      Both work        Both work



COMMON MISTAKES

1. Using = to check for NULL
   Wrong:  WHERE email = NULL    (never returns results)
   Right:  WHERE email IS NULL

2. Forgetting parentheses with AND and OR
   AND has higher precedence than OR.
   Wrong:  WHERE dept_id = 1 OR dept_id = 2 AND gender = 'F'
           (reads as: dept_id=1 OR (dept_id=2 AND gender='F'))
   Right:  WHERE (dept_id = 1 OR dept_id = 2) AND gender = 'F'

3. Using double quotes for string values
   Wrong:  WHERE name = "Abhishek"
   Right:  WHERE name = 'Abhishek'

4. Reversing BETWEEN bounds
   Wrong:  WHERE age BETWEEN 21 AND 19  (returns 0 rows)
   Right:  WHERE age BETWEEN 19 AND 21

5. Using LIKE without wildcards
   LIKE 'Jeevan' without % behaves exactly like = 'Jeevan'.
   For partial match use:  LIKE 'Jeevan%'



PRACTICE QUESTIONS

Q1. Find all students enrolled in 2022.

Answer:
```sql
SELECT name, enrollment_year FROM students WHERE enrollment_year = 2022;
```
Output: Jeevan (2022), Manjunath (2022)


Q2. Find students whose name ends with 'th'.

Answer:
```sql
SELECT name FROM students WHERE name LIKE '%th';
```
Output: Likhith, Manjunath


Q3. Find students aged between 20 and 22 who are male.

Answer:
```sql
SELECT name, age, gender
FROM students
WHERE age BETWEEN 20 AND 22 AND gender = 'M';
```
Output: Abhishek (20), Jeevan (21), Likhith (20), Manjunath (22)


Q4. List all courses NOT from department 1.

Answer:
```sql
SELECT course_name, dept_id FROM courses WHERE dept_id NOT IN (1);
```
Output: Computer Networks (dept 2), Digital Electronics (dept 3)


Q5. Find all marks where marks_obtained is 80 or more.

Answer:
```sql
SELECT enrollment_id, marks_obtained, grade
FROM marks
WHERE marks_obtained >= 80;
```
Output: enrollment 1 (88, A), enrollment 3 (92, A+),
        enrollment 7 (95, A+), enrollment 8 (82, A)



REVISION SUMMARY

Operator            Use
=                   Exact match
!= or <>            Not equal
>, <, >=, <=        Numeric or date comparison
AND                 All conditions must be true
OR                  At least one condition must be true
NOT                 Reverses condition
BETWEEN a AND b     Range inclusive of both ends
IN (list)           Matches any value in the list
LIKE 'pattern'      Pattern match (% = any chars, _ = one char)
IS NULL             Column has no value
IS NOT NULL         Column has a value

