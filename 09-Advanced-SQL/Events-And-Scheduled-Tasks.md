Events And Scheduled Tasks

1. Definition
A MySQL Event runs SQL on time: one time or repeat. Needs event_scheduler ON. Only safe demo tasks are used here.

2. Purpose and use cases
Clean temp demo rows nightly. Refresh small summary table weekly. Learn schedule syntax without touching core 5 students.

3. Syntax
```sql
SHOW VARIABLES LIKE 'event_scheduler';
CREATE EVENT IF NOT EXISTS ev_demo_once ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 HOUR DO SELECT 1;
SHOW EVENTS LIKE 'ev_demo_once';
DROP EVENT IF EXISTS ev_demo_once;
```

4. Explanation of keywords
ON SCHEDULE AT runs once. EVERY 1 DAY repeats. STARTS and ENDS set range. DO holds one statement. BEGIN END block needs DELIMITER for many statements. Needs EVENT privilege. SUPER may be needed to turn scheduler ON. Time zone decides run time. Keep tasks idempotent.

5. Examples
Example 1. Check scheduler
```sql
SHOW VARIABLES LIKE 'event_scheduler';
```
Expected output
ON or OFF. OFF means events will not run until DBA enables.

Example 2. One time demo event
```sql
CREATE EVENT IF NOT EXISTS ev_demo_once ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 HOUR DO SELECT 1;
SHOW EVENTS LIKE 'ev_demo_once';
DROP EVENT IF EXISTS ev_demo_once;
```
Expected effect
Harmless SELECT once, then removed.

Example 3. Daily temp cleanup
```sql
CREATE EVENT IF NOT EXISTS ev_clean_tmp ON SCHEDULE EVERY 1 DAY STARTS CURRENT_TIMESTAMP DO DELETE FROM marks_audit WHERE created_at < NOW() - INTERVAL 30 DAY;
ALTER EVENT ev_clean_tmp DISABLE;
DROP EVENT IF EXISTS ev_clean_tmp;
```
Expected effect
Old audit rows only. Core tables untouched.

Example 4. Weekly summary refresh
```sql
CREATE EVENT IF NOT EXISTS ev_refresh_top ON SCHEDULE EVERY 1 WEEK DO CREATE TABLE IF NOT EXISTS tmp_weekly_top AS SELECT * FROM marks WHERE marks_obtained >= 85;
DROP EVENT IF EXISTS ev_refresh_top;
DROP TABLE IF EXISTS tmp_weekly_top;
```
Expected effect
3 rows 95, 92, 88 in temp summary, then cleaned.

Example 5. Disable and drop
```sql
ALTER EVENT ev_clean_tmp DISABLE;
DROP EVENT IF EXISTS ev_clean_tmp;
```
Expected effect
Event stops and is removed.

6. Common mistakes
Auto deleting core data on schedule.
Scheduler OFF so nothing runs.
No ENDS so it runs forever.
Midnight zone surprise.
Missing EVENT privilege.

7. Performance and safety
Run off peak. Keep SQL fast. Log to table. Test DO part manually first. Never auto delete the 5 students.

8. Practice questions with answers
Q1. How to enable scheduler.
A1. SET GLOBAL needs privilege. Tests config.
Q2. Make one time event.
A2. Example 2. Tests AT syntax.
Q3. Safe daily task.
A3. Temp or audit only. Tests safety.
Q4. How to stop event.
A4. ALTER DISABLE. Tests control.
Q5. Why not core delete.
A5. Hard to undo and risky. Tests judgment.

9. Revision summary
Scheduler plus EVENT. Safe temp tasks. Test manual. Disable and drop.
