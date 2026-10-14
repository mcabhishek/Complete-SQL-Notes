# LIKE Pattern Matching

> Part of **Complete SQL Notes** (03-Operators-And-Functions). [Back to roadmap](../README.md).

## Definition

LIKE searches text using wildcards. It finds rows where a string
matches a pattern instead of requiring an exact = match.

Use LIKE when you know part of a value: names starting with J,
emails ending with college.edu, courses containing Data.

| Wildcard | Meaning | Example | Matches |
| --- | --- | --- | --- |
| % | Zero or more characters | J% | Jeevan, Jeevitha |
| _ | Exactly one character | Jeeva_ | Jeevan |
| \% | Literal percent sign | 100\% | 100% |
| \_ | Literal underscore | a\_b | a_b |

## Syntax

```sql
SELECT columns
FROM table_name
WHERE column LIKE pattern;
```


Add ESCAPE when you search for % or _ literally:

```sql
SELECT * FROM t WHERE col LIKE 'a\_b' ESCAPE '\';
```


## Reference Data

students: 1-Abhishek 2-Jeevan 3-Likhith 4-Jeevitha 5-Manjunath
courses: 1-Database Management 2-Data Structures 3-Computer Networks
 4-Operating Systems 5-Digital Electronics
emails all end with @college.edu.

## Examples

### Example 1 - Names starting with J

```sql
USE sql_notes;
SELECT name FROM students WHERE name LIKE 'J%';
```


**Output:**

```text
+----------+
| name |
+----------+
| Jeevan |
| Jeevitha |
+----------+
2 rows in set
```


J% means J followed by anything. Abhishek, Likhith, Manjunath excluded.

### Example 2 - Names starting with Jeev

```sql
SELECT name FROM students WHERE name LIKE 'Jeev%';
```


Output: Jeevan, Jeevitha (both share prefix Jeev).
Likhith excluded because it starts with L.

### Example 3 - Names ending with th

```sql
SELECT name FROM students WHERE name LIKE '%th';
```


**Output:**

```text
+-----------+
| name |
+-----------+
| Likhith |
| Manjunath |
+-----------+
2 rows in set
```


%th means anything ending in th.

### Example 4 - Exactly 6-letter names with _

```sql
SELECT name FROM students WHERE name LIKE '______';
```


Output: Jeevan (6), Jeevitha is 8 so excluded, Likhith is 7 excluded.
Only Jeevan matches 6 underscores. Abhishek is 8, Manjunath is 9.

### Example 5 - Courses containing Data

```sql
SELECT course_name FROM courses WHERE course_name LIKE '%Data%';
```


**Output:**

```text
+---------------------+
| course_name |
+---------------------+
| Database Management |
| Data Structures |
+---------------------+
2 rows in set
```


% on both sides means anywhere inside.

### Example 6 - NOT LIKE

```sql
SELECT name FROM students WHERE name NOT LIKE 'J%';
```


Output: Abhishek, Likhith, Manjunath (3 rows).
NOT LIKE keeps rows that do not match.

### Example 7 - LIKE with ESCAPE (literal underscore)

```sql
SELECT 'a_b' LIKE 'a/_b' ESCAPE '/' AS is_match;
```


**Output:**

```text
+----------+
| is_match |
+----------+
| 1 |
+----------+
1 row in set
```


Without ESCAPE, _ means any single character. With ESCAPE /,
/_ means a literal underscore, so the result is 1 (TRUE).

## How the Query Runs

Query:

```sql
SELECT name FROM students WHERE name LIKE 'J%';
```


Step 1: FROM students -- read all 5 rows.
Step 2: For each row test name LIKE 'J%':
 - Abhishek : starts with A = NO -> excluded
 - Jeevan : starts with J = YES -> kept
 - Likhith : starts with L = NO -> excluded
 - Jeevitha : starts with J = YES -> kept
 - Manjunath: starts with M = NO -> excluded
Step 3: SELECT name -- returns Jeevan, Jeevitha.

## MySQL vs Other Databases

| Feature | MySQL | PostgreSQL | SQL Server |
| --- | --- | --- | --- |
| Case in LIKE | Case-insensitive | Case-sensitive | Case-insensitive |
| ILIKE | Not supported | Supported | Not supported |
| ESCAPE clause | Supported | Supported | Supported |

MySQL default collation is case-insensitive (utf8mb4_0900_ai_ci).
PostgreSQL needs ILIKE for case-insensitive match. SQL Server is collation dependent.

In MySQL, jeevan LIKE J% matches because default collation ignores case.
In PostgreSQL it would not match unless you use ILIKE.

## Common Mistakes

1. Using LIKE without wildcards.
   LIKE 'Jeevan' without % behaves exactly like = Jeevan.
   For partial match use: LIKE 'Jeev%'.

2. Forgetting % on both sides.
   Wrong:  WHERE course_name LIKE 'Data' (only exact match)
   Right:  WHERE course_name LIKE '%Data%'

3. Confusing _ and %.
   % = any length, _ = exactly one character.
   J__ matches 3-letter J names only, not Jeevan.

4. Case surprise across databases.
   Code tested on MySQL may behave differently on PostgreSQL.
   Fix: use LOWER(name) LIKE 'j%' for portable case-insensitive search.

5. Leading % is slow on large tables.
   %th cannot use a normal index. Avoid if performance matters.

## Practice Questions

**Q1. Find students whose name starts with A.**

- **Answer:**
```sql
SELECT name FROM students WHERE name LIKE 'A%';
```


**Output:**

```text
+----------+
| name     |
+----------+
| Abhishek |
+----------+
1 row in set
```


**Q2. Find courses with Systems in the name.**

- **Answer:**
```sql
SELECT course_name FROM courses WHERE course_name LIKE '%Systems%';
```

Output: Operating Systems

**Q3. Find students with exactly 7 letters in name.**

- **Answer:**
```sql
SELECT name FROM students WHERE name LIKE '_______';
```

Output: Likhith (7). Jeevitha is 8, Abhishek is 8.

**Q4. List emails ending with college.edu.**

- **Answer:**
```sql
SELECT name, email FROM students WHERE email LIKE '%@college.edu';
```

Output: all 5 students (all share that domain).

**Q5. Find names where second letter is e.**

- **Answer:**
```sql
SELECT name FROM students WHERE name LIKE '_e%';
```

Output: Jeevan, Jeevitha. Abhishek second letter b excluded.

## Revision Summary

LIKE Pattern match for text
% Zero or more characters
_ Exactly one character
NOT LIKE Rows that do not match
ESCAPE \ Search for literal % or _
Case in MySQL Insensitive by default
Leading % Correct but slow on big tables






