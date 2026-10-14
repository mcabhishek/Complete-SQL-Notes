# Alter Drop Truncate

> Part of **Complete SQL Notes** (`10-Database-Objects`). [Back to roadmap](../README.md).

## Definition

ALTER changes an object. DROP removes an object. TRUNCATE empties a table fast. DDL auto commits and is not like normal rollback.

## Purpose and use cases
Add a city column for test. Change column size. Drop temp tables. Clear staging tables fast.

## Syntax
```sql
ALTER TABLE students ADD COLUMN city VARCHAR(50) NULL;
ALTER TABLE students MODIFY COLUMN city VARCHAR(80);
ALTER TABLE students DROP COLUMN city;
DROP TABLE IF EXISTS tmp_x;
TRUNCATE TABLE tmp_x;
```

## Explanation of keywords
ADD COLUMN adds. MODIFY changes type. DROP COLUMN removes. DROP TABLE removes full table. TRUNCATE removes all rows fast and resets auto increment. DELETE versus TRUNCATE versus DROP: filtered and undoable, all rows fast commit, object gone.

## Examples

### Example 1. Add and drop city, safe and reversible

```sql
ALTER TABLE students ADD COLUMN city VARCHAR(50) NULL;
DESCRIBE students;
UPDATE students SET city = 'Bengaluru' WHERE student_id = 1;
SELECT student_id, name, city FROM students WHERE student_id = 1;
ALTER TABLE students DROP COLUMN city;
```
Expected output
Abhishek shows Bengaluru, then column removed. Core data safe.

### Example 2. Modify temp table

```sql
CREATE TEMPORARY TABLE tmp_a (id INT, v VARCHAR(10));
ALTER TABLE tmp_a MODIFY COLUMN v VARCHAR(50);
DESCRIBE tmp_a;
DROP TEMPORARY TABLE tmp_a;
```
Expected effect
Column size changed in temp only.

### Example 3. TRUNCATE temp marks copy

```sql
CREATE TEMPORARY TABLE tmp_t AS SELECT * FROM marks;
SELECT COUNT(*) FROM tmp_t;
TRUNCATE TABLE tmp_t;
SELECT COUNT(*) FROM tmp_t;
DROP TEMPORARY TABLE tmp_t;
```
Expected output
8 then 0. Real marks untouched.

### Example 4. Drop temp table

```sql
CREATE TEMPORARY TABLE tmp_d (id INT);
DROP TEMPORARY TABLE tmp_d;
```
Expected effect
Temp gone.

### Example 5. Add and drop a check

```sql
ALTER TABLE courses ADD CONSTRAINT chk_tmp CHECK (credits >= 1);
ALTER TABLE courses DROP CHECK chk_tmp;
```
Expected effect
Rule added then removed. No data change.

## Common mistakes

TRUNCATE on core table. All data gone with commit.

DROP without IF EXISTS.

Shrinking column and cutting values.
Dropping column that has foreign key.
Expecting rollback for DDL.

## Performance and safety
DDL locks briefly. Backup first. Test on temp. Never TRUNCATE or DROP core tables in notes.

## Practice questions with answers

**Q1. Add city column.**

A1. Example 1. Tests ADD plus DROP.

**Q2. TRUNCATE versus DELETE.**

A2. All fast commit versus filtered undo. Tests choice.

**Q3. Does TRUNCATE reset auto increment.**

A3. Yes. Tests effect.

**Q4. Safe drop.**

A4. IF EXISTS on temp. Tests guard.

**Q5. Does ROLLBACK undo DDL.**

A5. No. Tests commit rule.

## Revision summary

ALTER modifies. TRUNCATE empties with commit. DROP removes. Test on temp.
