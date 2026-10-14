Stored Functions

1. Definition
A function returns one value and is used inside SQL. Good for grade, average, pass label.

2. Purpose and use cases
Grade from marks. Average per student in SELECT and WHERE. Reuse small logic.

3. Syntax
```sql
DELIMITER //
CREATE FUNCTION fn_grade(p DECIMAL(5,2)) RETURNS VARCHAR(3) DETERMINISTIC
BEGIN
RETURN CASE WHEN p >= 90 THEN 'A+' WHEN p >= 80 THEN 'A' WHEN p >= 70 THEN 'B' WHEN p >= 60 THEN 'C' ELSE 'D' END;
END //
DELIMITER ;
SELECT fn_grade(88);
DROP FUNCTION IF EXISTS fn_grade;
```

4. Explanation of keywords
RETURNS sets type. RETURN gives value. Params are IN only. DETERMINISTIC means same input same output. Functions should avoid transactions and DDL. Binary logging may need trust flag. Procedure versus function: CALL with OUT versus use in expression with RETURN.

5. Examples
Example 1. Grade function
```sql
DELIMITER //
CREATE FUNCTION fn_grade(p DECIMAL(5,2)) RETURNS VARCHAR(3) DETERMINISTIC
BEGIN
RETURN CASE WHEN p >= 90 THEN 'A+' WHEN p >= 80 THEN 'A' WHEN p >= 70 THEN 'B' WHEN p >= 60 THEN 'C' ELSE 'D' END;
END //
DELIMITER ;
SELECT fn_grade(88);
SELECT fn_grade(95);
SELECT fn_grade(55);
```
Expected output
A, A+, D.

Example 2. Student average
```sql
DELIMITER //
CREATE FUNCTION fn_student_avg(p_sid INT) RETURNS DECIMAL(6,2) DETERMINISTIC
BEGIN
DECLARE a DECIMAL(6,2);
SELECT AVG(m.marks_obtained) INTO a
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
WHERE e.student_id = p_sid;
RETURN a;
END //
DELIMITER ;
SELECT name, fn_student_avg(student_id) AS avg_marks FROM students ORDER BY student_id;
```
Expected output
Abhishek 81.50, Jeevan 80.00, Likhith 55.00, Jeevitha 86.50, Manjunath 82.00.

Example 3. Use in WHERE
```sql
SELECT name FROM students WHERE fn_student_avg(student_id) >= 80;
```
Expected output
All except Likhith.

Example 4. Pass fail
```sql
DELIMITER //
CREATE FUNCTION fn_result(p DECIMAL(5,2)) RETURNS VARCHAR(10) DETERMINISTIC
RETURN IF(p >= 40, 'PASS', 'FAIL');
//
DELIMITER ;
SELECT fn_result(55);
```
Expected output
PASS.

Example 5. Cleanup
```sql
DROP FUNCTION IF EXISTS fn_grade;
DROP FUNCTION IF EXISTS fn_student_avg;
DROP FUNCTION IF EXISTS fn_result;
```
Expected effect
Functions removed.

6. Common mistakes
Missing RETURNS or RETURN.
Non deterministic function with binlog error 1418.
Putting DML or transaction inside.
Slow per row use on huge tables.
Name clash with procedure.

7. Performance and safety
Read only functions are safe. Per row cost on big data. Needs privileges. DBA may set trust flag.

8. Practice questions with answers
Q1. Grade for 92.
A1. A+. Tests CASE.
Q2. Average for 4.
A2. 86.50. Tests lookup.
Q3. Names with average 80 plus.
A3. 4 names except Likhith. Tests WHERE use.
Q4. Procedure versus function.
A4. CALL plus OUT versus SELECT plus RETURN.
Q5. Fix for error 1418.
A5. Add DETERMINISTIC or set trust flag.

9. Revision summary
RETURN one value. Use in expression. DETERMINISTIC. No transaction.
