UNIQUE NOT NULL DEFAULT CHECK
1. Definition
UNIQUE no dupes, NOT NULL required, DEFAULT auto value, CHECK condition.
2. Why
Unique email/dept, required name/dept, default 100 marks, age 15-30.
3. Syntax
```sql
email VARCHAR(150) UNIQUE, name VARCHAR(100) NOT NULL, max_marks INT DEFAULT 100, age INT CHECK (age BETWEEN 15 AND 30), enrollment_year YEAR DEFAULT (YEAR(CURDATE()));
```
4. Explained
UNIQUE allows multiple NULLs in MySQL but ours emails filled. NOT NULL rejects missing. DEFAULT fills omitted (YEAR(CURDATE()), 100). CHECK enforced 8.0.16+ (3819 on fail).
5. Examples
Ex1 UQ: dup email 1062. Ex2 NOT NULL: `INSERT INTO students(name,dept_id) VALUES...` missing email ok (nullable) but missing name fails. Ex3 DEFAULT: omit max_marks ->100. Ex4 CHECK age 50 ->3819. Ex5 CHECK marks 999>max ->3819. Ex6 ALTER: `ALTER TABLE courses ADD CONSTRAINT chk_cr CHECK (credits BETWEEN 1 AND 6);`
6. Changes
Pass +1; fail 0 + error.
7. Steps
DESCRIBE to see Null/Default; test omit column.
8. Mistakes
1 Omit NOT NULL col without default ->1364. 2 Assume DEFAULT '' for NOT NULL. 3 Old MySQL CHECK parsed ignored. 4 UQ case-sensitivity per collation. 5 CHECK on generated percentage (can't update directly).
9. Exam
UNIQUE vs PK (nulls/many); DEFAULT expressions allowed 8.0.13+; SHOW CREATE TABLE to see checks.
10. Practice 5Q
Q1 UQ cols? A email, dept_name, uq_enroll, uq_marks, uq_att. Q2 NOT NULL students? A name, dept_id, enrollment_year. Q3 DEFAULT marks? A 100. Q4 Age insert 40? A 3819 fail. Q5 Omitted year? A current year.
11. Revision
UQ unique, NN required, DEF auto, CHECK rule.

