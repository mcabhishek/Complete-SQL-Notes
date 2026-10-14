# BETWEEN and IN Operators

> Part of **Complete SQL Notes** (03-Operators-And-Functions). [Back to roadmap](../README.md).

## Definition

BETWEEN tests if a value falls inside an inclusive range.
IN tests if a value matches any item in a list.

Both are shorthand for longer OR and comparison chains.
BETWEEN replaces >= AND <=. IN replaces = OR = OR =.

## Syntax

```sql
SELECT columns
FROM table_name
WHERE column BETWEEN low_value AND high_value;
```

```sql
SELECT columns
FROM table_name
WHERE column IN (value1, value2, value3);
```

Negations:

```sql
WHERE column NOT BETWEEN low AND high;
WHERE column NOT IN (value1, value2);
```



students:
 1-Abhishek 20 dept 1 2023
 2-Jeevan 21 dept 1 2022
 3-Likhith 20 dept 2 2023
 4-Jeevitha 19 dept 2 2023
 5-Manjunath 22 dept 3 2022

marks_obtained: 88, 75, 92, 68, 55, 78, 95, 82
courses credits: DBMS 4, DS 4, CN 3, OS 3, DE 4

## Examples

### Example 1 - Age between 20 and 21

```sql
USE sql_notes;
SELECT name, age FROM students WHERE age BETWEEN 20 AND 21;
```


**Output:**

```text
+----------+-----+
| name | age |
+----------+-----+
| Abhishek | 20 |
| Jeevan | 21 |
| Likhith | 20 |
+----------+-----+
3 rows in set
```


BETWEEN 20 AND 21 includes both ends. Same as age >= 20 AND age <= 21.

### Example 2 - NOT BETWEEN

```sql
SELECT name, age FROM students WHERE age NOT BETWEEN 20 AND 21;
```


Output: Jeevitha (19), Manjunath (22). 2 rows.
NOT BETWEEN keeps rows outside the range.

### Example 3 - IN list of departments

```sql
SELECT name, dept_id FROM students WHERE dept_id IN (1, 3);
```


**Output:**

```text
+-----------+---------+
| name | dept_id |
+-----------+---------+
| Abhishek | 1 |
| Jeevan | 1 |
| Manjunath | 3 |
+-----------+---------+
3 rows in set
```


Same as dept_id = 1 OR dept_id = 3.

### Example 4 - NOT IN

```sql
SELECT name, dept_id FROM students WHERE dept_id NOT IN (1, 2);
```


Output: Manjunath (dept 3) only. 1 row.

### Example 5 - Marks in a range

```sql
SELECT enrollment_id, marks_obtained, grade
FROM marks
WHERE marks_obtained BETWEEN 70 AND 90;
```


**Output:**

```text
 enrollment 1 -- 88.00 -- A
 enrollment 2 -- 75.00 -- B
 enrollment 6 -- 78.00 -- B
 enrollment 8 -- 82.00 -- A
4 rows. 92, 95 excluded (too high), 68, 55 excluded (too low).
```


### Example 6 - Courses with specific credits

```sql
SELECT course_name, credits FROM courses WHERE credits IN (3);
```


Output: Computer Networks (3), Operating Systems (3). 2 rows.

### Example 7 - BETWEEN with strings (alphabetical range)

```sql
SELECT name FROM students WHERE name BETWEEN 'J' AND 'L';
```


Output: Jeevan, Jeevitha. Likhith starts with L but Likhith > L
so it is excluded. Only names >= J and <= L qualify.
String BETWEEN uses alphabetical order.

## How the Query Runs

Query:

```sql
SELECT name, age FROM students WHERE age BETWEEN 20 AND 21;
```


Step 1: FROM students -- read all 5 rows.
Step 2: Test age BETWEEN 20 AND 21 per row:
 - Abhishek 20 BETWEEN 20 AND 21 = YES -> kept
 - Jeevan 21 BETWEEN 20 AND 21 = YES -> kept
 - Likhith 20 BETWEEN 20 AND 21 = YES -> kept
 - Jeevitha 19 BETWEEN 20 AND 21 = NO -> excluded
 - Manjunath 22 BETWEEN 20 AND 21 = NO -> excluded
Step 3: SELECT name, age -- returns 3 rows.

For IN, MySQL checks equality against each list item until a match.

## MySQL vs Other Databases

| Feature | MySQL | PostgreSQL | SQL Server |
| --- | --- | --- | --- |
| BETWEEN inclusive | Both ends | Both ends | Both ends |
| IN list | Supported | Supported | Supported |
| NOT IN with NULL | 0 rows risk | 0 rows risk | 0 rows risk |
| BETWEEN SYMMETRIC | Not supported | Supported | Not supported |

All three databases include both endpoints in BETWEEN.
All three suffer the NOT IN + NULL trap (see NULL note).

## Common Mistakes

1. Reversing BETWEEN bounds.
   Wrong:  WHERE age BETWEEN 21 AND 20 (returns 0 rows)
   Right:  WHERE age BETWEEN 20 AND 21

2. NOT IN with NULL in the list.
   Wrong:  WHERE dept_id NOT IN (1, NULL) (returns 0 rows, surprise)
   Right:  Use NOT EXISTS or filter NULLs first. Full detail in NULL note.

3. Using BETWEEN for exclusive range.
   BETWEEN always includes ends. For exclusive use > AND <.
   Exclusive 20-21: WHERE age > 20 AND age < 21 (returns 0 rows here).

4. Mixing data types in IN.
   WHERE student_id IN (1, 'a') may coerce or error.
   Keep list types consistent with the column.

5. Empty IN list.
   Wrong:  WHERE dept_id IN () (syntax error)
   Right:  Build list dynamically or use a condition that is always false.

## Practice Questions

**Q1. Find students aged between 19 and 20.**

- **Answer:**
```sql
SELECT name, age FROM students WHERE age BETWEEN 19 AND 20;
```

Output: Abhishek (20), Likhith (20), Jeevitha (19)

**Q2. Find students NOT in dept 1.**

- **Answer:**
```sql
SELECT name, dept_id FROM students WHERE dept_id NOT IN (1);
```

Output: Likhith (2), Jeevitha (2), Manjunath (3)

**Q3. Find marks between 80 and 95 inclusive. Show enrollment and grade.**

- **Answer:**
```sql
SELECT enrollment_id, marks_obtained, grade
FROM marks WHERE marks_obtained BETWEEN 80 AND 95;
```

Output: enr 1 (88 A), enr 3 (92 A+), enr 7 (95 A+), enr 8 (82 A)

**Q4. Find courses with 4 credits using IN.**

- **Answer:**
```sql
SELECT course_name FROM courses WHERE credits IN (4);
```

Output: Database Management, Data Structures, Digital Electronics

**Q5. Find students enrolled in 2022 or 2023 using IN.**

- **Answer:**
```sql
SELECT name, enrollment_year FROM students
WHERE enrollment_year IN (2022, 2023);
```

Output: all 5 students (Jeevan, Manjunath in 2022; rest in 2023).

## Revision Summary

BETWEEN Inclusive range, same as >= AND <=
NOT BETWEEN Outside the range
IN (list) Matches any item, same as OR chain
NOT IN (list) Matches none, beware NULL trap
Order Low value first in BETWEEN
Strings BETWEEN uses alphabetical order






