# Triggers

> Part of **Complete SQL Notes** (`09-Advanced-SQL`). [Back to roadmap](../README.md).

Triggers

## Definition
A trigger runs by itself on INSERT, UPDATE, or DELETE. BEFORE can check and change NEW. AFTER is for audit.

## Purpose and use cases
Block negative marks. Auto set grade. Log new marks. Protect core departments.

## Syntax
```sql
DELIMITER //
CREATE TRIGGER trg_marks_no_neg BEFORE UPDATE ON marks FOR EACH ROW
BEGIN
IF NEW.marks_obtained < 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'marks cannot be negative';
END IF;
END //
DELIMITER ;
DROP TRIGGER IF EXISTS trg_marks_no_neg;
```

## Explanation of keywords
BEFORE validates and can set NEW. AFTER cannot change NEW. INSERT has NEW only. DELETE has OLD only. UPDATE has both. SIGNAL rejects with message. One trigger per table plus time plus event, so combine logic. Needs TRIGGER privilege. Avoid hidden heavy writes.

## Examples

### Example 1. Audit new marks

```sql
DROP TABLE IF EXISTS marks_audit;
CREATE TABLE marks_audit (id INT AUTO_INCREMENT PRIMARY KEY, enrollment_id INT, marks_obtained DECIMAL(5,2), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
DELIMITER //
CREATE TRIGGER trg_marks_audit AFTER INSERT ON marks FOR EACH ROW
BEGIN
INSERT INTO marks_audit(enrollment_id, marks_obtained) VALUES(NEW.enrollment_id, NEW.marks_obtained);
END //
DELIMITER ;
```
Expected use
Test with temp enrollment plus mark in transaction, check audit, then ROLLBACK.

### Example 2. Auto grade on insert

```sql
DELIMITER //
CREATE TRIGGER trg_marks_grade BEFORE INSERT ON marks FOR EACH ROW
BEGIN
IF NEW.marks_obtained >= 90 THEN
SET NEW.grade = 'A+';
END IF;
END //
DELIMITER ;
```
Expected effect
High marks get A+ by itself.

### Example 3. Block negative on update

```sql
DELIMITER //
CREATE TRIGGER trg_marks_no_neg BEFORE UPDATE ON marks FOR EACH ROW
BEGIN
IF NEW.marks_obtained < 0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'marks cannot be negative';
END IF;
END //
DELIMITER ;
```
Expected effect
Update to -5 fails with error.

### Example 4. Protect core departments

```sql
DELIMITER //
CREATE TRIGGER trg_dept_no_del BEFORE DELETE ON departments FOR EACH ROW
BEGIN
IF OLD.dept_id IN (1, 2, 3) THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'core dept protected';
END IF;
END //
DELIMITER ;
```
Expected effect
Delete of dept 1, 2, 3 is blocked.

### Example 5. Cleanup

```sql
DROP TRIGGER IF EXISTS trg_marks_audit;
DROP TRIGGER IF EXISTS trg_marks_grade;
DROP TRIGGER IF EXISTS trg_marks_no_neg;
DROP TRIGGER IF EXISTS trg_dept_no_del;
DROP TABLE IF EXISTS marks_audit;
```
Expected effect
Triggers and audit table removed.

## Common mistakes
Changing NEW in AFTER.
Using OLD in INSERT.
Making many triggers for same point.
Hidden writes that confuse app.
No transaction test.

## Performance and safety
Triggers add write cost. Keep fast. Audit table grows. Test with ROLLBACK demo. Document well.

## Practice questions with answers

**Q1. Which trigger for audit.**

A1. AFTER INSERT. Tests Example 1.

**Q2. Which trigger for auto grade.**

A2. BEFORE INSERT. Tests Example 2.

**Q3. How to block bad value.**

A3. SIGNAL 45000. Tests Example 3.

**Q4. OLD versus NEW.**

A4. OLD is before image. NEW is after image.

**Q5. How to protect departments.**

A5. BEFORE DELETE with SIGNAL. Tests Example 4.

## Revision summary
BEFORE checks. AFTER audits. OLD and NEW. SIGNAL rejects. Keep simple and removable.
