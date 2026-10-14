# Self Join

> Part of **Complete SQL Notes** (`05-Joins`). [Back to roadmap](../README.md).

Definition: SELF JOIN joins a table to itself. Use two aliases for same table to compare rows within it.
Why: find classmates (same dept), same year, pairs, hierarchy.
Syntax:
```sql
SELECT a.name, b.name FROM students a JOIN students b ON a.dept_id=b.dept_id WHERE a.student_id < b.student_id;
```
Explanation: a,b are aliases for students. ON matches same dept. `<` avoids self-pair and duplicates.
Data: Abhishek(1,CS,2023),Jeevan(1,CS,2022),Likhith(2,IS,2023),Jeevitha(2,IS,2023),Manjunath(3,Elec,2022).

### Ex1 Classmates (same dept, different student):

```sql
SELECT a.name AS s1, b.name AS s2, a.dept_id FROM students a JOIN students b ON a.dept_id=b.dept_id AND a.student_id<b.student_id;
```
Output: Abhishek-Jeevan(1), Likhith-Jeevitha(2). 2 rows.

### Ex2 Same enrollment year:

```sql
SELECT a.name,b.name,a.enrollment_year FROM students a JOIN students b ON a.enrollment_year=b.enrollment_year AND a.student_id<b.student_id ORDER BY a.name;
```
Output: Abhishek-Likhith(2023), Abhishek-Jeevitha(2023), Likhith-Jeevitha(2023), Jeevan-Manjunath(2022). 4 rows.

### Ex3 Same dept and year (Likhith-Jeevitha only):

```sql
SELECT a.name,b.name FROM students a JOIN students b ON a.dept_id=b.dept_id AND a.enrollment_year=b.enrollment_year AND a.student_id<b.student_id;
```
Output: Likhith-Jeevitha. 1 row.

### Ex4 Different dept pairs (just sample with LIMIT):

```sql
SELECT a.name,b.name FROM students a CROSS JOIN students b WHERE a.student_id<b.student_id AND a.dept_id<>b.dept_id LIMIT 3;
```
Output e.g. Abhishek-Likhith, Abhishek-Jeevitha, Abhishek-Manjunath.

### Ex5 Self LEFT to find unique dept (none here, demo):

```sql
SELECT a.name FROM students a LEFT JOIN students b ON a.dept_id=b.dept_id AND a.student_id<>b.student_id WHERE b.student_id IS NULL;
```
Output: Empty (all have buddy) except Manjunath alone in dept3 -> returns Manjunath. 1 row.
Mistakes: (1) no aliases -> ambiguous error; (2) missing `<>` includes self-pair; (3) missing `<` gives duplicates A-B and B-A; (4) forgetting second condition; (5) SELECT * gives doubled columns.
Exam: must alias; use < for unique pairs; self join = inner join on same table; common Q: classmates.
Practice Q1 Classmates of Abhishek? A: Jeevan. Q2 Same year as Jeevan? A: Manjunath(2022). Q3 Count pairs same dept? A: 2. Q4 Why alias needed? A: to distinguish two copies. Q5 Pairs same year 2023? A: 3 pairs among Abhishek,Likhith,Jeevitha.
Summary: SELF = table x itself + aliases + inequality to dedupe.
