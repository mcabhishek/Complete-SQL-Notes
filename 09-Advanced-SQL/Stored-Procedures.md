# Stored Procedures

> Part of **Complete SQL Notes** (`09-Advanced-SQL`). [Back to roadmap](../README.md).

Stored Procedures

## Definition
A stored procedure is a saved program in the database. It can take IN, OUT, INOUT, use IF and loops. Call it with CALL.

## Purpose and use cases
List students by department. Return average through OUT. Safe enroll with rollback on error. Reuse logic.

## Syntax
```sql
DELIMITER //
CREATE PROCEDURE sp_students_by_dept(IN p_dept INT)
BEGIN
SELECT student_id, name FROM students WHERE dept_id = p_dept ORDER BY name;
END //
DELIMITER ;
CALL sp_students_by_dept(1);
DROP PROCEDURE IF EXISTS sp_students_by_dept;
```

## Explanation of keywords
IN is input. OUT returns through user variable like at sign a. INOUT does both. DECLARE makes locals. IF and WHILE control flow. HANDLER catches errors. DELIMITER slash slash is needed in CLI because body has semicolons. Needs CREATE ROUTINE privilege.

## Examples

### Example 1. Students by department

```sql
DELIMITER //
CREATE PROCEDURE sp_students_by_dept(IN p_dept INT)
BEGIN
SELECT student_id, name FROM students WHERE dept_id = p_dept ORDER BY name;
END //
DELIMITER ;
CALL sp_students_by_dept(1);
```
Expected output
Abhishek and Jeevan. Input 2 gives Likhith and Jeevitha.

### Example 2. Average with OUT

```sql
DELIMITER //
CREATE PROCEDURE sp_student_avg(IN p_sid INT, OUT p_avg DECIMAL(6,2))
BEGIN
SELECT AVG(m.marks_obtained) INTO p_avg
FROM enrollments e JOIN marks m ON m.enrollment_id = e.enrollment_id
WHERE e.student_id = p_sid;
END //
DELIMITER ;
CALL sp_student_avg(4, @a);
SELECT @a;
```
Expected output
86.50 for Jeevitha. Input 1 gives 81.50.

### Example 3. Safe enroll with handler

```sql
DELIMITER //
CREATE PROCEDURE sp_enroll(IN p_s INT, IN p_c INT, IN p_sem INT, IN p_yr VARCHAR(10))
BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK;
RESIGNAL;
END;
START TRANSACTION;
INSERT INTO enrollments(student_id, course_id, semester, academic_year) VALUES(p_s, p_c, p_sem, p_yr);
COMMIT;
END //
DELIMITER ;
```
Expected use

CALL sp_enroll with test values like 3, 2, 4, 2024-25, then delete test row.

### Example 4. Loop sum 1 to 5

```sql
DELIMITER //
CREATE PROCEDURE sp_sum5(OUT t INT)
BEGIN
DECLARE i INT DEFAULT 1;
SET t = 0;
WHILE i <= 5 DO
SET t = t + i;
SET i = i + 1;
END WHILE;
END //
DELIMITER ;
CALL sp_sum5(@t);
SELECT @t;
```
Expected output
15.

### Example 5. Cleanup

```sql
DROP PROCEDURE IF EXISTS sp_sum5;
DROP PROCEDURE IF EXISTS sp_student_avg;
DROP PROCEDURE IF EXISTS sp_students_by_dept;
DROP PROCEDURE IF EXISTS sp_enroll;
```
Expected effect
Routines removed. Tables unchanged.

## Common mistakes
Forgetting DELIMITER.
Using OUT without user variable.
No error handler so half write stays.
Writes without transaction.
Name clash with old routine.

## Performance and safety
Wrap writes in transaction plus handler. Test with temp rows. Needs privileges. SHOW CREATE PROCEDURE to review.

## Practice questions with answers

**Q1. List department 2 students.**

A1. CALL sp_students_by_dept(2). Gives Likhith, Jeevitha.

**Q2. Get average for student 1.**

A2. CALL sp_student_avg(1, at sign a). Gives 81.50.

**Q3. IN versus OUT.**

A3. IN goes in. OUT comes out to user variable.

**Q4. What does handler do.**

A4. ROLLBACK plus RESIGNAL on error.

**Q5. Why DELIMITER.**

A5. Body has semicolons. CLI needs new end mark.

## Revision summary

CREATE plus CALL. IN and OUT. Transaction plus handler for writes. DELIMITER in CLI.
