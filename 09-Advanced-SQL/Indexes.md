# Indexes

> Part of **Complete SQL Notes** (`09-Advanced-SQL`). [Back to roadmap](../README.md).

Indexes

## Definition
An index is a sorted lookup on columns. It speeds WHERE, JOIN, and ORDER BY. Primary key and unique keys are indexed by default.

## Purpose and use cases
Fast lookup by student id. Fast join on department id and course id. Fast filter on marks. Cost is slower writes and extra space.

## Syntax
```sql
CREATE INDEX idx_students_dept ON students(dept_id);
SHOW INDEX FROM students;
DROP INDEX idx_students_dept ON students;
```

## Explanation of keywords

CREATE INDEX makes it. Column list sets order. Composite index has two or more columns. Leftmost rule: index on A plus B helps A and A plus B, not B alone. High selectivity columns help most.

## Examples
Our tables already index primary keys, unique email, and foreign keys.

### Example 1. Show existing indexes

```sql
SHOW INDEX FROM enrollments;
```
Expected output
PRIMARY plus unique enrollment triple plus foreign key helpers.

### Example 2. Demo index on marks then drop

```sql
CREATE INDEX idx_marks_obt ON marks(marks_obtained);
SHOW INDEX FROM marks;
DROP INDEX idx_marks_obt ON marks;
```
Expected use
Helps filter marks above 85, which gives 95, 92, 88.

### Example 3. Composite for course plus semester

```sql
CREATE INDEX idx_enr_course_sem ON enrollments(course_id, semester);
DROP INDEX idx_enr_course_sem ON enrollments;
```
Expected use
Helps course 1 plus semester 3, enrollments 1 and 7. Helps course 1 alone. Not semester alone.

### Example 4. ORDER BY helper

```sql
SELECT student_id, name FROM students ORDER BY dept_id;
```
Expected note
Index on dept_id can avoid sort. Small tables may still scan.

### Example 5. Poor index case

```sql
SELECT * FROM students WHERE gender = 'M';
```
Expected note
4 of 5 are M. Low selectivity. Full scan is normal. Skip index.

## Common mistakes
Indexing every column.
Wrong column order in composite.
Function on indexed column. Use plain range instead.
Expecting index use on tiny tables.
Duplicate indexes.

## Performance and safety

CREATE and DROP INDEX are safe metadata changes. Measure with EXPLAIN. Drop demo indexes after test. Too many indexes slow INSERT, UPDATE, DELETE.

## Practice questions with answers

**Q1. Which keys are auto indexed.**

A1. Primary, unique, foreign helpers. Tests defaults.

**Q2. Index for marks filter.**

A2. Example 2. Tests single column.

**Q3. Index for course plus semester.**

A3. Example 3. Tests composite.

**Q4. What is leftmost rule.**

A4. A plus B helps A, not B alone. Tests order.

**Q5. When to skip index.**

A5. Low selectivity like gender. Tests judgment.

## Revision summary
Index speeds reads and slows writes. Order matters. Leftmost rule. Check EXPLAIN.
