# TEMPORARY Tables

> Part of **Complete SQL Notes** (`10-Database-Objects`). [Back to roadmap](../README.md).

Temporary Tables

## Definition
A TEMPORARY TABLE lives only in your session. It is removed when you disconnect. It is a private workspace.

## Purpose and use cases
Stage top marks. Test DELETE safely. Use many times unlike CTE which is one time. Join with index.

## Syntax
```sql
CREATE TEMPORARY TABLE tmp_top AS SELECT * FROM marks WHERE marks_obtained >= 85;
SELECT COUNT(*) FROM tmp_top;
DROP TEMPORARY TABLE tmp_top;
```

## Explanation of keywords
TEMPORARY marks session scope. AS SELECT fills data. You can add PRIMARY KEY and index. CTE versus temp: CTE one statement no index, temp many statements plus index. Same temp name in two sessions stays separate.

## Examples

### Example 1. Top marks stage

```sql
CREATE TEMPORARY TABLE tmp_top AS SELECT * FROM marks WHERE marks_obtained >= 85;
SELECT COUNT(*) FROM tmp_top;
SELECT * FROM tmp_top ORDER BY marks_obtained DESC;
DROP TEMPORARY TABLE tmp_top;
```
Expected output
3 rows: 95, 92, 88.

### Example 2. Indexed average temp

```sql
CREATE TEMPORARY TABLE tmp_avg (student_id INT PRIMARY KEY, a DECIMAL(6,2));
INSERT INTO tmp_avg SELECT e.student_id, AVG(m.marks_obtained) FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id GROUP BY e.student_id;
SELECT s.name, tmp_avg.a FROM students s JOIN tmp_avg ON tmp_avg.student_id = s.student_id ORDER BY tmp_avg.a DESC;
DROP TEMPORARY TABLE tmp_avg;
```
Expected output
Jeevitha 86.50 first, Likhith 55.00 last.

### Example 3. Safe delete test

```sql
CREATE TEMPORARY TABLE tmp_s AS SELECT * FROM students;
DELETE FROM tmp_s WHERE student_id = 5;
SELECT COUNT(*) FROM tmp_s;
DROP TEMPORARY TABLE tmp_s;
SELECT COUNT(*) FROM students;
```
Expected output
Temp has 4, real students still 5. Manjunath safe.

### Example 4. Temp plus TRUNCATE

```sql
CREATE TEMPORARY TABLE tmp_m AS SELECT * FROM marks;
TRUNCATE TABLE tmp_m;
SELECT COUNT(*) FROM tmp_m;
DROP TEMPORARY TABLE tmp_m;
```
Expected output
0 in temp. Real marks safe.

### Example 5. Scope note

Two sessions can use same temp name without clash. Each sees only its own copy.

## Common mistakes
Forgetting DROP, though auto clean happens.
Same name as real table causing confusion.
Expecting share across sessions.
Foreign key from real to temp.
Huge temp filling memory.

## Performance and safety
Safe by design because real tables untouched. Add key for joins. Drop after use.

## Practice questions with answers

**Q1. Stage marks 85 plus.**

A1. Example 1 gives 3. Tests AS SELECT.

**Q2. Average temp with key.**

A2. Example 2. Tests INSERT plus JOIN.

**Q3. Safe delete count.**

A3. Temp 4, real 5. Tests isolation.

**Q4. CTE versus temp.**

A4. One use no index versus multi use plus index.

**Q5. Scope.**

A5. Session only, auto drop.

## Revision summary
Session private stage. Indexed multi use. Drop after. Safest test bed.
