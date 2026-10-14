# Explain and Execution Plans

> Part of **Complete SQL Notes** (`09-Advanced-SQL`). [Back to roadmap](../README.md).

EXPLAIN And Execution Plans

## Definition

EXPLAIN shows MySQL plan: order, access type, keys, row estimate. EXPLAIN ANALYZE runs the query and shows actual time. Needs MySQL 8.0.18 plus.

## Purpose and use cases
Check if index is used. Check join order. Learn why tiny tables scan. Compare two query forms safely.

## Syntax
```sql
EXPLAIN SELECT * FROM students WHERE student_id = 1;
EXPLAIN FORMAT=TREE SELECT * FROM students WHERE student_id = 1;
EXPLAIN ANALYZE SELECT * FROM marks WHERE marks_obtained > 85;
```

## Explanation of keywords
id and select_type show step. table shows target. type shows access: ALL scan, const, ref, range. possible_keys and key show index choice. rows is estimate. filtered is percent. Extra shows Using index, Using where, Using filesort. Plans depend on version, stats, indexes, data. Never copy a plan and claim live run.

## Examples

### Example 1. Primary key lookup

```sql
EXPLAIN SELECT * FROM students WHERE student_id = 1;
```
Expected shape
type const, key PRIMARY, rows about 1.

### Example 2. Department filter

```sql
EXPLAIN SELECT name FROM students WHERE dept_id = 1;
```
Expected shape
type ref on department index, rows about 2 for Abhishek and Jeevan.

### Example 3. Join plan

```sql
EXPLAIN SELECT s.name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id = 4;
```
Expected shape
Nested loop through keys, about 2 rows for Jeevitha.

### Example 4. Sargable compare

```sql
EXPLAIN SELECT name FROM students WHERE enrollment_year = 2023;
```
Expected note
More index friendly than YEAR function version.

### Example 5. Actual run

```sql
EXPLAIN ANALYZE SELECT * FROM marks WHERE marks_obtained > 85;
```
Expected output
3 rows 95, 92, 88 plus actual time. Runs the SELECT, so use reads only.

## Common mistakes
Treating rows as exact count.
Ignoring version and stats.
Forcing index too early.
Using ANALYZE on writes.
Pasting fake plan as real.

## Performance and safety

EXPLAIN is safe and does not run. ANALYZE runs, so use SELECT only.

## Practice questions with answers

**Q1. What type for primary lookup.**

A1. const. Tests key access.

**Q2. What key for dept filter.**

A2. Department index ref. Tests join helper.

**Q3. What does filesort mean.**

A3. Sort step needed. Tests Extra.

**Q4. EXPLAIN versus ANALYZE.**

A4. Estimate versus actual. Tests version feature.

**Q5. Is plan portable.**

A5. No. Depends on stats and version.

## Revision summary

EXPLAIN estimate. ANALYZE actual. Read type, key, rows, Extra. Small scan can be fine.
