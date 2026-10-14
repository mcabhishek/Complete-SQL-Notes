# RECURSIVE Ctes

> Part of **Complete SQL Notes** (`09-Advanced-SQL`). [Back to roadmap](../README.md).

Recursive CTEs

## Definition
A recursive CTE calls itself to make a series or walk levels. It has a start row plus a repeating step plus a stop condition.

## Purpose and use cases
Make numbers 1 to 8 for semesters. Make years 2022 to 2024. Show levels 1 to 3. Learn anchor plus recursion plus limit. Our college tables have no manager column, so we use series examples.

## Syntax
```sql
WITH RECURSIVE nums AS (
SELECT 1 AS n
UNION ALL
SELECT n + 1 FROM nums WHERE n < 5
)
SELECT * FROM nums;
```

## Explanation of keywords
RECURSIVE is required. First SELECT is the anchor or start. UNION ALL adds next rows. Second SELECT reads the CTE itself. WHERE sets the stop limit. cte_max_recursion_depth caps loops at 1000 by default.

## Examples

### Example 1. Numbers 1 to 5

```sql
WITH RECURSIVE nums AS (
SELECT 1 AS n
UNION ALL
SELECT n + 1 FROM nums WHERE n < 5
)
SELECT * FROM nums;
```
Expected output
1, 2, 3, 4, 5. Starts at 1 and stops at 5.

### Example 2. Semesters 1 to 8

```sql
WITH RECURSIVE sems AS (
SELECT 1 AS s
UNION ALL
SELECT s + 1 FROM sems WHERE s < 8
)
SELECT * FROM sems;
```
Expected output
1 to 8. Matches semester check 1 to 8.

### Example 3. Years 2022 to 2024

```sql
WITH RECURSIVE yrs AS (
SELECT 2022 AS y
UNION ALL
SELECT y + 1 FROM yrs WHERE y < 2024
)
SELECT * FROM yrs;
```
Expected output
2022, 2023, 2024. Matches our student years.

### Example 4. Levels demo

```sql
WITH RECURSIVE chain AS (
SELECT 'Abhishek' AS s, 1 AS lvl
UNION ALL
SELECT 'Jeevan', lvl + 1 FROM chain WHERE lvl < 3
)
SELECT * FROM chain;
```
Expected output
Abhishek 1, Jeevan 2, Jeevan 3. Shows level growth.

### Example 5. Depth limit

```sql
SET SESSION cte_max_recursion_depth = 5;
WITH RECURSIVE t AS (
SELECT 1 AS n
UNION ALL
SELECT n + 1 FROM t
)
SELECT * FROM t;
```
Expected effect
Stops with limit error near 6. Reset depth to 1000 after test.

## Common mistakes
Missing RECURSIVE keyword.
Missing stop WHERE so it runs to the limit.
Using UNION instead of UNION ALL.
Putting recursion on wrong side.
Testing huge depth without limit.

## Performance and safety
Read only and safe. Keep depth small. Good for series and small trees.

## Practice questions with answers

**Q1. Make semesters 1 to 8.**

A1. Example 2. Tests anchor plus stop.

**Q2. Make years 2022 to 2024.**

A2. Example 3. Tests series.

**Q3. What is anchor member.**

A3. First SELECT that gives start row.

**Q4. Why is WHERE needed.**

A4. It stops recursion.

**Q5. What caps recursion.**

A5. cte_max_recursion_depth, default 1000.

## Revision summary

WITH RECURSIVE plus anchor UNION ALL self plus WHERE stop. Good for series and levels.
