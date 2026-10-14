BCNF
1. Definition
Every determinant (left side of FD) must be a superkey. Stricter than 3NF; fixes overlap-key cases.
2. Why
Rare college case: one HOD per dept but HOD leads one dept: dept->hod and hod->dept, plus (student,course)->hod quirks need clean split.
3. Syntax
```sql
```
4. Explained
3NF allows non-key determinant if dependent is prime; BCNF forbids all non-superkey determinants. If hod->course_id but hod not key -> split.
Simple demo: dept_head(dept_name,hod_name) both unique: either can be key -> already BCNF. Bad would add student_id with hod->dept while PK (student,dept): hod not superkey -> split dept table out (which we have).
5. Examples
Bad teach rows repeat HOD per enrollment; change HOD many rows.
Good: departments(dept_id,hod) 3 rows + enrollments ref. `UPDATE departments SET hod_name='Dr. Z' WHERE dept_id=2; -- 1 row`.
FD check: dept_id->hod (dept_id superkey ok); hod->dept_id (hod unique superkey ok) -> BCNF holds.
Anomalies same as 3NF but overlapping keys covered.
6. Changes
Determinant becomes key.
7. Steps
List FDs, find left not key, split, keys.
8. Mistakes
1 BCNF always needed (3NF enough often). 2 Breaking lossless (keep common key). 3 Splitting with no FD violation. 4 Confuse superkey/candidate. 5 Ignore dependency preservation tradeoff.
9. Exam
BCNF def; vs 3NF (prime attribute exception); example with overlapping keys.
10. Practice 5Q
Q1 BCNF rule? A determinant=superkey. Q2 Vs 3NF? A no prime exception. Q3 Violation? A hod->dept with hod non-key. Q4 Fix? A parent table. Q5 Our depts BCNF? A Yes (dept_id key).
11. Revision
Left side must be key; else split.

