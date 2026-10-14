# String Functions

> Part of **Complete SQL Notes** (03-Operators-And-Functions). [Back to roadmap](../README.md).

# Definition

String functions transform or inspect text: change case, join,
slice, measure length, clean spaces, replace parts.

# Syntax

 UPPER(col) LOWER(col) LENGTH(col) CHAR_LENGTH(col)
 CONCAT(a, b) CONCAT_WS(sep, a, b)

| SUBSTRING(col, start, len) | LEFT(col, n) | RIGHT(col, n) |
| --- | --- | --- |
| TRIM(col) | REPLACE(col, from Svensson, to Svensson) | INSTR(col, sub) |

# Reference Data

students: Abhishek, Jeevan, Likhith, Jeevitha, Manjunath
courses: Database Management, Data Structures, Computer Networks,
 Operating Systems, Digital Electronics

# Examples

# Example 1 - UPPER and LOWER

sql
USE sql_notes;
SELECT name, UPPER(name) AS up, LOWER(name) AS low FROM students;


Output: ABHISHEK/abhishek, JEEVAN/jeevan, LIKHITH/likhith,
 JEEVITHA/jeevitha, MANJUNATH/manjunath. 5 rows.

# Example 2 - CONCAT email label

sql
SELECT CONCAT(name, <, email, >) AS label FROM students;


Output: Abhishek <abhishek@college.edu>, ... 5 rows.

# Example 3 - SUBSTRING first 4 letters

sql
SELECT name, SUBSTRING(name, 1, 4) AS short FROM students;


Output: Abhi, Jeev, Likh, Jeev, Manj.

# Example 4 - LENGTH vs CHAR_LENGTH

sql
SELECT name, LENGTH(name) AS bytes, CHAR_LENGTH(name) AS chars FROM students;


Output: Abhishek 8/8, Jeevan 6/6, Likhith 7/7, Jeevitha 8/8, Manjunath 9/9.
Same here (ASCII). They differ for multi-byte characters.

# Example 5 - TRIM spaces

sql
SELECT TRIM( Abhishek ) AS clean;


Output: Abhishek (spaces removed both sides).

# Example 6 - REPLACE domain

sql
SELECT REPLACE(email, @college.edu, @mail.edu) AS m FROM students LIMIT 2;


Output: abhishek@mail.edu, jeevan@mail.edu.

# How the Query Runs

Query: SELECT UPPER(name) FROM students;
Step 1: FROM students -- 5 rows. Step 2: UPPER each name.
Step 3: Return 5 upper-case values.

# MySQL vs Other Databases

UPPER/LOWER/SUBSTRING/TRIM/REPLACE same in MySQL, PostgreSQL, SQL Server.
CONCAT_WS and IFNULL are MySQL flavored. Use COALESCE for portable NULL.

# Common Mistakes

1. SUBSTRING starts at 1, not 0. SUBSTRING(name,0,4) is off by one.
2. CONCAT with NULL gives NULL. Fix: CONCAT_WS or COALESCE.
3. LENGTH counts bytes. Use CHAR_LENGTH for character count.
4. LIKE case differs by DB. Use LOWER(col) LIKE for portable search.

# Practice Questions

**Q1. Show name and email in lower case.**

- **Answer:** SELECT LOWER(name), LOWER(email) FROM students;

**Q2. First 3 letters of each course.**

- **Answer:** SELECT course_name, SUBSTRING(course_name,1,3) FROM courses;

**Q3. Build name-dept label.**

- **Answer:** SELECT CONCAT(name,-,dept_id) FROM students;

**Q4. Length of each name.**

- **Answer:** SELECT name, CHAR_LENGTH(name) FROM students;

**Q5. Replace college.edu with univ.edu.**

- **Answer:** SELECT REPLACE(email,@college.edu,@univ.edu) FROM students;

# Revision Summary

UPPER LOWER case. CONCAT join. SUBSTRING slice from 1.
LENGTH bytes, CHAR_LENGTH chars. TRIM clean. REPLACE swap.






