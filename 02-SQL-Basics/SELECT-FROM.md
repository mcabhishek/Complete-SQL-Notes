SELECT ... FROM
===============


DEFINITION

SELECT retrieves data from a table.
FROM tells SQL which table to look in.

Together SELECT ... FROM is the minimum required to fetch any data.



SYNTAX

    SELECT column1, column2, ...
    FROM   table_name;

To retrieve all columns, use * (asterisk):

    SELECT *
    FROM   table_name;



CLAUSE EXPLANATION

Clause              Required   Purpose
SELECT              Yes        List the columns you want to see
column1, column2    Yes        Comma-separated column names
*                   Option     Means "give me every column"
FROM                Yes        Specifies the source table
table_name          Yes        The table to read from



REFERENCE DATA (students table)

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

Example 1 - Select all columns

```sql
USE sql_notes;
SELECT * FROM students;
```

Output:
+------------+-----------+-----+--------+-----------------------+---------+-----------------+
| student_id | name      | age | gender | email                 | dept_id | enrollment_year |
+------------+-----------+-----+--------+-----------------------+---------+-----------------+
|          1 | Abhishek  |  20 | M      | abhishek@college.edu  |       1 |            2023 |
|          2 | Jeevan    |  21 | M      | jeevan@college.edu    |       1 |            2022 |
|          3 | Likhith   |  20 | M      | likhith@college.edu   |       2 |            2023 |
|          4 | Jeevitha  |  19 | F      | jeevitha@college.edu  |       2 |            2023 |
|          5 | Manjunath |  22 | M      | manjunath@college.edu |       3 |            2022 |
+------------+-----------+-----+--------+-----------------------+---------+-----------------+
5 rows in set



Example 2 - Select specific columns

```sql
SELECT name, age
FROM students;
```

Output:
+-----------+-----+
| name      | age |
+-----------+-----+
| Abhishek  |  20 |
| Jeevan    |  21 |
| Likhith   |  20 |
| Jeevitha  |  19 |
| Manjunath |  22 |
+-----------+-----+
5 rows in set



Example 3 - Select columns in a custom order

```sql
SELECT email, name, student_id
FROM students;
```

Output:
+-----------------------+-----------+------------+
| email                 | name      | student_id |
+-----------------------+-----------+------------+
| abhishek@college.edu  | Abhishek  |          1 |
| jeevan@college.edu    | Jeevan    |          2 |
| likhith@college.edu   | Likhith   |          3 |
| jeevitha@college.edu  | Jeevitha  |          4 |
| manjunath@college.edu | Manjunath |          5 |
+-----------------------+-----------+------------+
5 rows in set



Example 4 - Column alias with AS

AS renames a column in the output. It does not change the actual column name
in the table.

```sql
SELECT name AS student_name, age AS student_age
FROM students;
```

Output:
+--------------+-------------+
| student_name | student_age |
+--------------+-------------+
| Abhishek     |          20 |
| Jeevan       |          21 |
| Likhith      |          20 |
| Jeevitha     |          19 |
| Manjunath    |          22 |
+--------------+-------------+
5 rows in set



Example 5 - Static label in SELECT

```sql
SELECT name, 'sql_notes' AS project
FROM students;
```

Output:
+-----------+-----------+
| name      | project   |
+-----------+-----------+
| Abhishek  | sql_notes |
| Jeevan    | sql_notes |
| Likhith   | sql_notes |
| Jeevitha  | sql_notes |
| Manjunath | sql_notes |
+-----------+-----------+
5 rows in set



Example 6 - Select all from courses

```sql
SELECT * FROM courses;
```

Output:
+-----------+------------------------+---------+---------+
| course_id | course_name            | credits | dept_id |
+-----------+------------------------+---------+---------+
|         1 | Database Management    |       4 |       1 |
|         2 | Data Structures        |       4 |       1 |
|         3 | Computer Networks      |       3 |       2 |
|         4 | Operating Systems      |       3 |       1 |
|         5 | Digital Electronics    |       4 |       3 |
+-----------+------------------------+---------+---------+
5 rows in set



HOW THE QUERY RUNS (STEP BY STEP)

Query:
    SELECT name, enrollment_year
    FROM   students;

Step 1: MySQL reads FROM -- it finds the students table.
Step 2: MySQL scans every row in students.
Step 3: For each row it picks only the columns listed: name and enrollment_year.
Step 4: It returns those values as the result.

Note: MySQL processes FROM before SELECT internally, even though you write
SELECT first.



MYSQL VS. OTHER DATABASES

Feature                   MySQL            PostgreSQL       SQL Server
SELECT without FROM       Allowed          Allowed          Requires FROM
AS keyword for alias      Optional         Required         Optional
Table alias               Supported        Supported        Supported



COMMON MISTAKES

1. Forgetting USE before the query
   Error: No database selected
   Fix:   USE sql_notes; before SELECT.

2. Selecting a column that does not exist
   Error: Unknown column 'phone' in field list
   Fix:   Run DESCRIBE students; to check column names.

3. Trailing comma after the last column
   Wrong:  SELECT name, age,  FROM students;
   Right:  SELECT name, age   FROM students;

4. Swapping table name and column name
   Wrong:  SELECT students FROM name;
   Right:  SELECT name FROM students;



PRACTICE QUESTIONS

Q1. Display only the name and email of all students.

Answer:
```sql
SELECT name, email
FROM students;
```
Output:
+-----------+-----------------------+
| name      | email                 |
+-----------+-----------------------+
| Abhishek  | abhishek@college.edu  |
| Jeevan    | jeevan@college.edu    |
| Likhith   | likhith@college.edu   |
| Jeevitha  | jeevitha@college.edu  |
| Manjunath | manjunath@college.edu |
+-----------+-----------------------+


Q2. Display all columns from the departments table.

Answer:
```sql
SELECT * FROM departments;
```
Output:
+---------+------------------------+------------------+
| dept_id | dept_name              | hod_name         |
+---------+------------------------+------------------+
|       1 | Computer Science       | Dr. Ramesh Kumar |
|       2 | Information Science    | Dr. Priya Nair   |
|       3 | Electronics            | Dr. Suresh Babu  |
+---------+------------------------+------------------+


Q3. Display course_name and credits, alias credits as credit_points.

Answer:
```sql
SELECT course_name, credits AS credit_points
FROM courses;
```
Output:
+---------------------+--------------+
| course_name         | credit_points|
+---------------------+--------------+
| Database Management |            4 |
| Data Structures     |            4 |
| Computer Networks   |            3 |
| Operating Systems   |            3 |
| Digital Electronics |            4 |
+---------------------+--------------+


Q4. Show each student's name with a static label 'sql_notes' aliased as project.

Answer:
```sql
SELECT name, 'sql_notes' AS project
FROM students;
```


Q5. What is wrong with this query? Fix it.
    SELECT * students;

Answer: The FROM keyword is missing.
```sql
SELECT * FROM students;
```



REVISION SUMMARY

SELECT        = Specifies columns to retrieve
FROM          = Specifies the source table
*             = Selects all columns
AS            = Renames a column in the output (alias)
Column order  = Controlled by the order listed in SELECT
Execution     = MySQL processes FROM first, then SELECT
Semicolon     = Required at the end in the MySQL CLI

