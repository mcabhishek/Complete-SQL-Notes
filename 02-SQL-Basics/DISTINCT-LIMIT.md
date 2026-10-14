DISTINCT AND LIMIT
==================


PART 1 - DISTINCT

DEFINITION

DISTINCT removes duplicate rows from the result. When a column has repeated
values, DISTINCT ensures each unique value appears only once.

DISTINCT applies to the combination of all listed columns, not just the first.


SYNTAX

    SELECT DISTINCT column1, column2, ...
    FROM   table_name;



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

Example 1 - DISTINCT on age (age 20 appears twice -- collapsed to one)

```sql
SELECT DISTINCT age FROM students;
```

Output:
+-----+
| age |
+-----+
|  20 |
|  21 |
|  19 |
|  22 |
+-----+
4 rows in set

Without DISTINCT:  SELECT age FROM students  returns  20, 21, 20, 19, 22 (5 rows)
With DISTINCT:     returns 20, 21, 19, 22 (4 rows, 20 shown once)



Example 2 - DISTINCT on gender

```sql
SELECT DISTINCT gender FROM students;
```

Output:
+--------+
| gender |
+--------+
| M      |
| F      |
+--------+
2 rows in set



Example 3 - DISTINCT on dept_id

```sql
SELECT DISTINCT dept_id FROM students;
```

Output:
+---------+
| dept_id |
+---------+
|       1 |
|       2 |
|       3 |
+---------+
3 rows in set



Example 4 - DISTINCT on two columns (unique combinations)

```sql
SELECT DISTINCT gender, enrollment_year FROM students;
```

MySQL checks each (gender, enrollment_year) pair:
  (M, 2023) Abhishek
  (M, 2022) Jeevan
  (M, 2023) Likhith   <- same as Abhishek, removed
  (F, 2023) Jeevitha
  (M, 2022) Manjunath <- same as Jeevan, removed

Output:
+--------+-----------------+
| gender | enrollment_year |
+--------+-----------------+
| M      |            2023 |
| M      |            2022 |
| F      |            2023 |
+--------+-----------------+
3 rows in set



Example 5 - DISTINCT with WHERE

```sql
SELECT DISTINCT age FROM students WHERE dept_id = 1;
```

Output:
+-----+
| age |
+-----+
|  20 |
|  21 |
+-----+
2 rows in set



Example 6 - DISTINCT on attendance percentages

Attendance table has 80.00 for three different records (Abhishek-DS,
Jeevan-DBMS, Likhith-CN). DISTINCT returns it only once.

```sql
SELECT DISTINCT percentage FROM attendance;
```

Output:
+------------+
| percentage |
+------------+
|      90.00 |
|      80.00 |
|      84.00 |
|      88.89 |
|      95.00 |
|      70.00 |
+------------+
6 rows in set



PART 2 - LIMIT

DEFINITION

LIMIT restricts the number of rows returned by a query. It is useful for:
- Previewing a large table
- Pagination (showing 10 results per page)
- Finding the top-N records (combined with ORDER BY)


SYNTAX

    SELECT column1 FROM table_name LIMIT N;

    SELECT column1 FROM table_name LIMIT N OFFSET M;

    SELECT column1 FROM table_name LIMIT M, N;



EXAMPLES

Example 7 - LIMIT to get first 3 students

```sql
SELECT name, age FROM students LIMIT 3;
```

Output:
+----------+-----+
| name     | age |
+----------+-----+
| Abhishek |  20 |
| Jeevan   |  21 |
| Likhith  |  20 |
+----------+-----+
3 rows in set



Example 8 - LIMIT with OFFSET for pagination

Page 1 (rows 1-2):

```sql
SELECT name FROM students LIMIT 2 OFFSET 0;
```
Output: Abhishek, Jeevan

Page 2 (rows 3-4):

```sql
SELECT name FROM students LIMIT 2 OFFSET 2;
```
Output: Likhith, Jeevitha

Page 3 (row 5):

```sql
SELECT name FROM students LIMIT 2 OFFSET 4;
```
Output: Manjunath (only 1 row left)



Example 9 - LIMIT with WHERE

```sql
SELECT name, dept_id FROM students WHERE dept_id = 2 LIMIT 2;
```

Output:
+----------+---------+
| name     | dept_id |
+----------+---------+
| Likhith  |       2 |
| Jeevitha |       2 |
+----------+---------+
2 rows in set



Example 10 - DISTINCT and LIMIT together

```sql
SELECT DISTINCT age FROM students LIMIT 2;
```

Output:
+-----+
| age |
+-----+
|  20 |
|  21 |
+-----+
2 rows in set



HOW THE QUERY RUNS (STEP BY STEP)

Query:
    SELECT DISTINCT gender FROM students LIMIT 1;

Step 1: FROM students -- read all 5 rows.
Step 2: SELECT gender -- extract column: M, M, M, F, M.
Step 3: DISTINCT -- remove duplicates: M, F (2 unique values).
Step 4: LIMIT 1 -- return only the first value.
Output: M



MYSQL VS. OTHER DATABASES

Feature          MySQL                  PostgreSQL              SQL Server
Limit rows       LIMIT n                LIMIT n                 TOP n
Offset rows      LIMIT n OFFSET m       LIMIT n OFFSET m        OFFSET m ROWS FETCH NEXT n ROWS ONLY
Shorthand        LIMIT m, n             Not supported           Not supported

Note: In SQL Server, OFFSET ... FETCH requires an ORDER BY clause.



COMMON MISTAKES

1. DISTINCT with SELECT * usually has no effect
   If student_id is included, every row is already unique, so DISTINCT
   changes nothing.

2. Confusing LIMIT M, N shorthand
   LIMIT 2, 3 means: skip 2 rows, return 3 rows.
   It does NOT mean "return rows 2 and 3".

3. Using LIMIT without ORDER BY for consistent results
   Without ORDER BY, MySQL can return rows in any order.
   Unreliable:  SELECT name FROM students LIMIT 3;
   Reliable:    SELECT name FROM students ORDER BY age ASC LIMIT 3;

4. Writing DISTINCT in the wrong place
   Wrong:  SELECT age DISTINCT FROM students;
   Right:  SELECT DISTINCT age FROM students;



PRACTICE QUESTIONS

Q1. Find all distinct enrollment_year values from students.

Answer:
```sql
SELECT DISTINCT enrollment_year FROM students;
```
Output: 2023, 2022


Q2. Display only the first 2 records from the marks table.

Answer:
```sql
SELECT * FROM marks LIMIT 2;
```
Output: mark_id 1 (88.00, A) and mark_id 2 (75.00, B)


Q3. Show distinct grade values from the marks table.

Answer:
```sql
SELECT DISTINCT grade FROM marks;
```
Output: A, B, A+, C, D


Q4. Retrieve the 3rd and 4th students using OFFSET.

Answer:
```sql
SELECT name FROM students LIMIT 2 OFFSET 2;
```
Output: Likhith, Jeevitha


Q5. How many unique departments are in the students table? Write the query.

Answer:
```sql
SELECT DISTINCT dept_id FROM students;
```
Output: 1, 2, 3 -- there are 3 unique departments.



REVISION SUMMARY

DISTINCT              Removes duplicate rows from result
Applies to            Combination of all listed columns
LIMIT n               Returns first n rows
LIMIT n OFFSET m      Skips m rows then returns n rows
LIMIT m, n            MySQL shorthand: skip m, return n
Evaluation order      FROM -> WHERE -> DISTINCT -> LIMIT
Without ORDER BY      LIMIT results may not be consistent

