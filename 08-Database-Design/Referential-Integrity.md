Referential Integrity
1. Definition
FK values must match parent or be NULL (ours NOT NULL so must match). Keeps links valid.
2. Why
No orphan enrollment 999; no lost marks; dept delete won't orphan students.
3. Syntax
```sql
FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON UPDATE CASCADE ON DELETE RESTRICT;
SELECT e.* FROM enrollments e LEFT JOIN students s ON e.student_id=s.student_id WHERE s.student_id IS NULL;
```
4. Explained
Actions: RESTRICT block (dept), CASCADE follow (enrollment>marks), SET NULL (if nullable), NO ACTION check later. Compatible types/index required.
5. Examples
Ex1 Orphan check above -> 0 rows (integrity holds). Ex2 1452 insert 999 blocked. Ex3 1451 delete dept 1 blocked. Ex4 CASCADE test chain 104 (delete student removes enrollment). Ex5 UPDATE CASCADE dept_id change follows children. Ex6 Order: insert dept>student>course>enroll>marks; delete reverse.
6. Changes
Checks only; violations error, no half-links.
7. Steps
Orphan query, try bad insert/delete, note action.
8. Mistakes
1 FK_CHECKS=0 routine. 2 Type mismatch. 3 Missing index. 4 Expect SET NULL with NOT NULL. 5 Wrong delete order.
9. Exam
Define RI; actions table; 1451/1452; parent-child order.
10. Practice 5Q
Q1 Orphans? A 0 query above. Q2 Dept delete? A 1451 RESTRICT. Q3 Enroll 999? A 1452. Q4 CASCADE where? A enroll/marks/attendance. Q5 Insert order? A parents first.
11. Revision
FK must match; RESTRICT blocks, CASCADE follows; check orphans =0.

