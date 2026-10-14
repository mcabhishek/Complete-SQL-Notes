ORDER BY
========


DEFINITION

ORDER BY sorts the result of a query by one or more columns.

Without ORDER BY, MySQL returns rows in an unspecified order.
With ORDER BY you control exactly how results are arranged.



SYNTAX

    SELECT column1, column2
    FROM   table_name
    WHERE  condition
    ORDER BY column1 [ASC|DESC], column2 [ASC|DESC];

Keyword    Meaning
ASC        Ascending -- smallest to largest, A to Z, oldest to newest
DESC       Descending -- largest to smallest, Z to A, newest to oldest
Default    If neither is written, MySQL uses ASC

ORDER BY always comes after WHERE and before LIMIT.



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

marks table:
+---------+---------------+----------------+-----------+-------+
| mark_id | enrollment_id | marks_obtained | max_marks | grade |
+---------+---------------+----------------+-----------+-------+
|       1 |             1 |          88.00 |       100 | A     |
|       2 |             2 |          75.00 |       100 | B     |
|       3 |             3 |          92.00 |       100 | A+    |
|       4 |             4 |          68.00 |       100 | C     |
|       5 |             5 |          55.00 |       100 | D     |
|       6 |             6 |          78.00 |       100 | B     |
|       7 |             7 |          95.00 |       100 | A+    |
|       8 |             8 |          82.00 |       100 | A     |
+---------+---------------+----------------+-----------+-------+



EXAMPLES

Example 1 - Sort by age, ascending (youngest first)

```sql
SELECT name, age FROM students ORDER BY age ASC;
```

Output:
+-----------+-----+
| name      | age |
+-----------+-----+
| Jeevitha  |  19 |
| Abhishek  |  20 |
| Likhith   |  20 |
| Jeevan    |  21 |
| Manjunath |  22 |
+-----------+-----+
5 rows in set

Note: Abhishek and Likhith are both 20. MySQL may return them in either order
unless a secondary sort column is specified.



Example 2 - Sort by age, descending (oldest first)

```sql
SELECT name, age FROM students ORDER BY age DESC;
```

Output:
+-----------+-----+
| name      | age |
+-----------+-----+
| Manjunath |  22 |
| Jeevan    |  21 |
| Abhishek  |  20 |
| Likhith   |  20 |
| Jeevitha  |  19 |
+-----------+-----+
5 rows in set



Example 3 - Sort alphabetically by name

```sql
SELECT name FROM students ORDER BY name ASC;
```

Output:
+-----------+
| name      |
+-----------+
| Abhishek  |
| Jeevan    |
| Jeevitha  |
| Likhith   |
| Manjunath |
+-----------+
5 rows in set

Explanation: A < J. Between Jeevan and Jeevitha, the 5th character
is 'a' (Jeevan) vs 'i' (Jeevitha). Since 'a' comes before 'i',
Jeevan comes before Jeevitha.



Example 4 - Sort by name, descending (reverse alphabetical)

```sql
SELECT name FROM students ORDER BY name DESC;
```

Output:
+-----------+
| name      |
+-----------+
| Manjunath |
| Likhith   |
| Jeevitha  |
| Jeevan    |
| Abhishek  |
+-----------+
5 rows in set



Example 5 - Sort by two columns

Sort by enrollment_year ascending, then by age descending within the same year.

```sql
SELECT name, enrollment_year, age
FROM students
ORDER BY enrollment_year ASC, age DESC;
```

Output:
+-----------+-----------------+-----+
| name      | enrollment_year | age |
+-----------+-----------------+-----+
| Manjunath |            2022 |  22 |
| Jeevan    |            2022 |  21 |
| Abhishek  |            2023 |  20 |
| Likhith   |            2023 |  20 |
| Jeevitha  |            2023 |  19 |
+-----------+-----------------+-----+
5 rows in set



Example 6 - ORDER BY with WHERE

Get all male students, youngest first.

```sql
SELECT name, gender, age
FROM students
WHERE gender = 'M'
ORDER BY age ASC;
```

Output:
+-----------+--------+-----+
| name      | gender | age |
+-----------+--------+-----+
| Abhishek  | M      |  20 |
| Likhith   | M      |  20 |
| Jeevan    | M      |  21 |
| Manjunath | M      |  22 |
+-----------+--------+-----+
4 rows in set



Example 7 - Top-N pattern (ORDER BY + LIMIT)

Find the student with the highest marks.

```sql
SELECT enrollment_id, marks_obtained, grade
FROM marks
ORDER BY marks_obtained DESC
LIMIT 1;
```

Output:
+---------------+----------------+-------+
| enrollment_id | marks_obtained | grade |
+---------------+----------------+-------+
|             7 |          95.00 | A+    |
+---------------+----------------+-------+
1 row in set

(Enrollment 7 is Jeevitha's Database Management marks -- 95.00)



Example 8 - Top 3 highest marks

```sql
SELECT enrollment_id, marks_obtained, grade
FROM marks
ORDER BY marks_obtained DESC
LIMIT 3;
```

Output:
+---------------+----------------+-------+
| enrollment_id | marks_obtained | grade |
+---------------+----------------+-------+
|             7 |          95.00 | A+    |
|             3 |          92.00 | A+    |
|             1 |          88.00 | A     |
+---------------+----------------+-------+
3 rows in set



Example 9 - ORDER BY column position

Instead of the column name, you can use its position number in the SELECT list.

```sql
SELECT name, age, enrollment_year
FROM students
ORDER BY 2 DESC, 3 ASC;
```

Output:
+-----------+-----+-----------------+
| name      | age | enrollment_year |
+-----------+-----+-----------------+
| Manjunath |  22 |            2022 |
| Jeevan    |  21 |            2022 |
| Abhishek  |  20 |            2023 |
| Likhith   |  20 |            2023 |
| Jeevitha  |  19 |            2023 |
+-----------+-----+-----------------+
5 rows in set

Using position numbers works but column names are clearer to read.



HOW THE QUERY RUNS (STEP BY STEP)

Query:
    SELECT name, age
    FROM   students
    WHERE  dept_id IN (1, 2)
    ORDER BY age DESC, name ASC
    LIMIT 3;

Step 1: FROM students -- read all rows.
Step 2: WHERE dept_id IN (1,2) -- keep Abhishek, Jeevan, Likhith, Jeevitha.
         Manjunath (dept 3) is excluded.
Step 3: ORDER BY age DESC, name ASC:
         - Sort by age descending: 21 -> 20 -> 20 -> 19
         - For tied age 20: sort by name ascending -> Abhishek before Likhith
Step 4: LIMIT 3 -- return first 3 rows.

Output:
+----------+-----+
| name     | age |
+----------+-----+
| Jeevan   |  21 |
| Abhishek |  20 |
| Likhith  |  20 |
+----------+-----+
3 rows in set



NULL VALUES IN SORTING

In MySQL, NULL values appear first in ASC order and last in DESC order.
Our dataset has no NULL values so this is informational only.



MYSQL VS. OTHER DATABASES

Feature              MySQL           PostgreSQL                    SQL Server
Default sort         ASC             ASC                           ASC
NULL in ASC          First           Last                          First
NULLS FIRST/LAST     Not supported   ORDER BY age ASC NULLS LAST   Not supported
ORDER BY alias       Supported       Supported                     Supported
ORDER BY position    Supported       Supported                     Supported



COMMON MISTAKES

1. Expecting consistent order without ORDER BY
   MySQL may return rows in any order without it.
   Always use ORDER BY when the order matters.

2. Applying DESC to the wrong column in multi-column sort
   Wrong:  ORDER BY age, name DESC    (sorts age ASC, name DESC)
   Right:  ORDER BY age DESC, name ASC

3. Putting ORDER BY before WHERE
   Wrong:  SELECT name FROM students ORDER BY age WHERE dept_id = 1;
   Right:  SELECT name FROM students WHERE dept_id = 1 ORDER BY age;

4. Confusing ASC and DESC
   ASC  = A to Z, 1 to 100, 2022 to 2023 (going up)
   DESC = Z to A, 100 to 1, 2023 to 2022 (going down)



PRACTICE QUESTIONS

Q1. List all students sorted alphabetically by name.

Answer:
```sql
SELECT name FROM students ORDER BY name ASC;
```
Output: Abhishek, Jeevan, Jeevitha, Likhith, Manjunath


Q2. List all courses sorted by credits in descending order.

Answer:
```sql
SELECT course_name, credits FROM courses ORDER BY credits DESC;
```
Output:
  Database Management    (4)
  Data Structures        (4)
  Digital Electronics    (4)
  Computer Networks      (3)
  Operating Systems      (3)


Q3. Find the student with the lowest age. Show only name and age.

Answer:
```sql
SELECT name, age FROM students ORDER BY age ASC LIMIT 1;
```
Output: Jeevitha, 19


Q4. List all marks from highest to lowest marks_obtained. Include grade.

Answer:
```sql
SELECT mark_id, marks_obtained, grade FROM marks ORDER BY marks_obtained DESC;
```
Output:
  mark_id 7 -- 95.00 -- A+
  mark_id 3 -- 92.00 -- A+
  mark_id 1 -- 88.00 -- A
  mark_id 8 -- 82.00 -- A
  mark_id 6 -- 78.00 -- B
  mark_id 2 -- 75.00 -- B
  mark_id 4 -- 68.00 -- C
  mark_id 5 -- 55.00 -- D


Q5. Display all students sorted by dept_id ascending, then name alphabetically.
    Show name, dept_id, and enrollment_year.

Answer:
```sql
SELECT name, dept_id, enrollment_year
FROM students
ORDER BY dept_id ASC, name ASC;
```
Output:
+-----------+---------+-----------------+
| name      | dept_id | enrollment_year |
+-----------+---------+-----------------+
| Abhishek  |       1 |            2023 |
| Jeevan    |       1 |            2022 |
| Jeevitha  |       2 |            2023 |
| Likhith   |       2 |            2023 |
| Manjunath |       3 |            2022 |
+-----------+---------+-----------------+



REVISION SUMMARY

ORDER BY              Sorts the result
ASC                   Ascending: smallest to largest, A to Z
DESC                  Descending: largest to smallest, Z to A
Default               ASC when neither keyword is written
Multiple columns      ORDER BY col1 ASC, col2 DESC (each column has its own direction)
Position in query     After WHERE, before LIMIT
NULL in ASC           Appears first in MySQL
Top-N pattern         ORDER BY col DESC LIMIT n
Column position       ORDER BY 2 sorts by the 2nd column in SELECT

