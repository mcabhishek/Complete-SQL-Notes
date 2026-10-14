# NULL Handling

> Part of **Complete SQL Notes** (03-Operators-And-Functions). [Back to roadmap](../README.md).

# Definition

NULL means no value. It is not zero, not empty string, not FALSE.
It means unknown or missing.

Any comparison with NULL gives NULL, not TRUE or FALSE.
So rows with NULL fail WHERE unless you test with IS NULL.

# Syntax

sql
SELECT columns FROM table_name WHERE column IS NULL;


sql
SELECT columns FROM table_name WHERE column IS NOT NULL;


Helpers:

 COALESCE(col1, col2, fallback) -- first non-NULL value
 IFNULL(col, fallback) -- MySQL shorthand for 2 args
 NULLIF(a, b) -- NULL if a = b, else a

# Reference Data

students emails all filled in sample:
 1-Abhishek 2-Jeevan 3-Likhith 4-Jeevitha 5-Manjunath

3-valued logic (WHERE keeps only TRUE):
 TRUE AND NULL = NULL (out) TRUE OR NULL = TRUE (kept)
 FALSE AND NULL = FALSE (out) FALSE OR NULL = NULL (out)
 NOT NULL = NULL (out)

# Examples

# Example 1 - IS NULL finds missing values

sql
USE sql_notes;
SELECT name, email FROM students WHERE email IS NULL;


Output: Empty set (0 rows). All 5 students have emails.

# Example 2 - IS NOT NULL keeps filled values

sql
SELECT name, email FROM students WHERE email IS NOT NULL;


Output: all 5 students. 5 rows in set.

# Example 3 - = NULL never works

sql
SELECT name FROM students WHERE email = NULL;


Output: Empty set always. email = NULL is NULL, WHERE keeps only TRUE.
Right way: WHERE email IS NULL.

# Example 4 - COALESCE replaces NULL with fallback

sql
SELECT name, COALESCE(email, no-email@college.edu) AS contact
FROM students;


Output: same 5 emails. With a NULL email it shows the fallback.

# Example 5 - IFNULL (MySQL only)

sql
SELECT name, IFNULL(email, missing) AS contact FROM students;


Output: all 5 real emails. Portable version is COALESCE.

# Example 6 - NULLIF avoids divide-by-zero

sql
SELECT attendance_id, attended_classes / NULLIF(total_classes, 0) AS ratio
FROM attendance;


Output: ratios (no zero totals in sample). Zero total gives NULL, not error.

# Example 7 - NOT IN + NULL trap

sql
SELECT name FROM students WHERE dept_id NOT IN (1, NULL);


Output: Empty set -- surprise! dept_id != NULL is NULL for every row.
Fix: WHERE dept_id NOT IN (1) or use NOT EXISTS.

# How the Query Runs

Query: SELECT name FROM students WHERE email IS NULL;
Step 1: FROM students -- read 5 rows.
Step 2: Test email IS NULL: all filled = NO -> all excluded.
Step 3: Empty set.

# MySQL vs Other Databases

| Feature | MySQL | PostgreSQL | SQL Server |
| --- | --- | --- | --- |
| IS NULL | Supported | Supported | Supported |
| COALESCE | Supported | Supported | Supported |
| IFNULL | Supported | Use COALESCE | Use ISNULL() |
| NULLIF | Supported | Supported | Supported |

COUNT(col) skips NULL in all three. COUNT(*) counts every row.

# Common Mistakes

1. Using = NULL. Wrong: WHERE email = NULL. Right: WHERE email IS NULL.
2. Using != NULL. Wrong: WHERE email != NULL. Right: WHERE email IS NOT NULL.
3. NOT IN with NULL returns 0 rows. Fix: remove NULLs or use NOT EXISTS.
4. COUNT(column) skips NULLs. COUNT(*) counts rows.
5. CONCAT(a, NULL) is NULL. Fix: COALESCE(col,) or CONCAT_WS.

# Practice Questions

**Q1. Find students with no email.**

- **Answer:** SELECT name FROM students WHERE email IS NULL; Output: Empty set.

**Q2. Count total rows vs rows with email.**

- **Answer:** SELECT COUNT(*) AS total_rows, COUNT(email) AS with_email FROM students;

**Output:**

text


**Q3. Show contact with fallback.**

- **Answer:** SELECT name, COALESCE(email,no-email@college.edu) AS contact FROM students;

**Q4. Why does NOT IN (1, NULL) return 0 rows? Fix it.**

- **Answer:** Compare to NULL is never TRUE. Fix: WHERE dept_id NOT IN (1);

**Q5. Safely divide attended by total even if total is 0.**

- **Answer:** SELECT attended_classes / NULLIF(total_classes,0) AS ratio FROM attendance;

# Revision Summary

NULL = missing. Use IS NULL, IS NOT NULL. COALESCE portable fallback.
IFNULL MySQL only. NULLIF avoids zero-divide. NOT IN + NULL = 0 rows.






