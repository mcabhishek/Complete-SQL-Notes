Third Normal Form (3NF)
1. Definition
2NF + no transitive: non-key must not depend via another non-key. student->dept_id->hod/dept_name chain must split.
2. Why
Store (Abhishek,1,CS,Dr.Ramesh) per student repeats HOD; change HOD updates 2 CS rows.
3. Syntax
```sql
```
4. Explained
FDs: student_id->dept_id; dept_id->dept_name,hod. Transitive student->hod via dept. Move dept attrs to departments.
5. Examples
Bad: Abhishek(1,CS,Ramesh), Jeevan(1,CS,Ramesh) HOD twice; Likhith/Jeevitha IS twice.
Good: departments 3 rows; students ref dept_id. Rename HOD: `UPDATE departments SET hod_name='Dr. New' WHERE dept_id=1; -- 1 row not 2`.
Anomalies: insert dept no student ok; delete last CS student keeps dept; update once.
Proof: `SELECT s.name,d.dept_name,d.hod_name FROM students s JOIN departments d ON s.dept_id=d.dept_id WHERE s.student_id=1;`
6. Changes
HOD 1x per dept.
7. Steps
2NF?, non-key->non-key?, move to parent, FK.
8. Mistakes
1 Keep dept_name in students. 2 3NF vs 2NF mix. 3 Derived percentage stored (keep generated). 4 Split without FK. 5 Over-split city->state lookup unneeded small.
9. Exam
Transitive def; student-dept-HOD classic; anomalies solved.
10. Practice 5Q
Q1 Transitive? A student->dept->hod. Q2 Split? A departments+students. Q3 HOD update rows? A 1. Q4 Insert empty dept? A yes parent. Q5 Our schema 3NF? A Yes.
11. Revision
Non-key via non-key -> parent table.

