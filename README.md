<div align="center">

# Complete SQL Notes — Learn SQL from Zero to Advanced

Beginner-friendly MySQL 8.0+ notes with examples, expected outputs, practice questions, and interview prep.

Start with zero experience. Finish writing joins, subqueries, CTEs, window functions, and routines.

[Start Learning](#start-learning) | [Roadmap](#learning-roadmap) | [Chapters](#chapter-navigation) | [Sample Database](#sample-database) | [Practice](#practice--interview-prep)

</div>

---

## Start Learning

New to SQL? Follow this path:

1. Read [What Is SQL](00-Introduction/What-Is-SQL.md)
2. Read [Database Basics](00-Introduction/Database-Basics.md)
3. Set up the database ([Quick Start](#quick-start))
4. Work through [Chapters](#chapter-navigation) in order
5. Solve practice files, then check answers

## What You Get

- Notes from zero to advanced, all on one sample database
- MySQL 8.0+ syntax with runnable examples
- Expected outputs computed from real sample data
- Practice questions with answers in every note
- SQL practice scripts per module
- Interview points and common mistakes in every note
- Database design: keys, ER model, normalization up to BCNF
- Advanced: CTEs, window functions, views, indexes, procedures, triggers, events

## Sample Database

Five students used in every example: Abhishek, Jeevan, Likhith, Jeevitha, Manjunath.

Tables in database sql_notes:

| Table | Contents |
|---|---|
| Departments | dept_id, dept_name, hod_name |
| Students | student_id, name, age, gender, email, dept_id, enrollment_year |
| Courses | course_id, course_name, credits, dept_id |
| Enrollments | enrollment_id, student_id, course_id, semester, academic_year |
| Marks | mark_id, enrollment_id, marks_obtained, max_marks, grade |
| Attendance | attendance_id, student_id, course_id, total_classes, attended_classes, percentage |

Setup scripts:

- [Create-Database.sql](01-Database-Setup/Create-Database.sql)
- [Create-Tables.sql](01-Database-Setup/Create-Tables.sql)
- [Insert-Sample-Data.sql](01-Database-Setup/Insert-Sample-Data.sql)
- [Reset-Database.sql](01-Database-Setup/Reset-Database.sql)

---

## Quick Start

1. Install MySQL 8.0+ or open MySQL Workbench
2. Run [Create-Database.sql](01-Database-Setup/Create-Database.sql)
3. Run [Create-Tables.sql](01-Database-Setup/Create-Tables.sql)
4. Run [Insert-Sample-Data.sql](01-Database-Setup/Insert-Sample-Data.sql)
5. Open any note under [Chapters](#chapter-navigation)
6. Run examples with USE sql_notes, then try the practice SQL files

---

## Learning Roadmap

<details open>
<summary>Stage 1 — SQL Introduction and Database Basics</summary>

- [What Is SQL](00-Introduction/What-Is-SQL.md)
- [Database Basics](00-Introduction/Database-Basics.md)
- [SQL Command Types](00-Introduction/SQL-Command-Types.md)

</details>

<details open>
<summary>Stage 2 — Database Setup</summary>

- [Create-Database.sql](01-Database-Setup/Create-Database.sql)
- [Create-Tables.sql](01-Database-Setup/Create-Tables.sql)
- [Insert-Sample-Data.sql](01-Database-Setup/Insert-Sample-Data.sql)
- [Reset-Database.sql](01-Database-Setup/Reset-Database.sql)

</details>

<details open>
<summary>Stage 3 — SELECT, WHERE, ORDER BY, LIMIT</summary>

- [SELECT FROM](02-SQL-Basics/SELECT-FROM.md)
- [WHERE Operators](02-SQL-Basics/WHERE-Operators.md)
- [DISTINCT LIMIT](02-SQL-Basics/DISTINCT-LIMIT.md)
- [ORDER BY](02-SQL-Basics/ORDER-BY.md)

</details>

<details>
<summary>Stage 4 — Operators, NULL Handling, Functions (not yet available)</summary>

Not yet available. Planned: LIKE, BETWEEN, IN, NULL, string and date functions.

</details>

<details>
<summary>Stage 5 — Aggregate Functions, GROUP BY, HAVING (not yet available)</summary>

Not yet available. Planned: COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING.

</details>

<details open>
<summary>Stage 6 — Joins and Multi-Table Queries</summary>

- [INNER JOIN](05-Joins/INNER-JOIN.md)
- [LEFT JOIN](05-Joins/LEFT-JOIN.md)
- [RIGHT JOIN](05-Joins/RIGHT-JOIN.md)
- [FULL JOIN Alternatives](05-Joins/FULL-JOIN-Alternatives.md)
- [CROSS JOIN](05-Joins/CROSS-JOIN.md)
- [SELF JOIN](05-Joins/SELF-JOIN.md)
- [Multiple Table Joins](05-Joins/Multiple-Table-Joins.md)
- [Join Practice SQL](05-Joins/Join-Practice.sql)

</details>

<details open>
<summary>Stage 7 — Subqueries and Set Operations</summary>

- [Subqueries](06-Subqueries-And-Set-Operations/Subqueries.md)
- [Correlated Subqueries](06-Subqueries-And-Set-Operations/Correlated-Subqueries.md)
- [EXISTS IN ANY ALL](06-Subqueries-And-Set-Operations/EXISTS-IN-ANY-ALL.md)
- [NOT IN Versus NOT EXISTS](06-Subqueries-And-Set-Operations/NOT-IN-Versus-NOT-EXISTS.md)
- [UNION UNION ALL](06-Subqueries-And-Set-Operations/UNION-UNION-ALL.md)
- [INTERSECT EXCEPT Differences](06-Subqueries-And-Set-Operations/INTERSECT-EXCEPT-Differences.md)
- [Subquery Practice SQL](06-Subqueries-And-Set-Operations/Subquery-Practice.sql)

</details>

<details open>
<summary>Stage 8 — INSERT, UPDATE, DELETE, Transactions</summary>

- [INSERT](07-Data-Modification/INSERT.md)
- [UPDATE](07-Data-Modification/UPDATE.md)
- [DELETE](07-Data-Modification/DELETE.md)
- [INSERT INTO SELECT](07-Data-Modification/INSERT-INTO-SELECT.md)
- [Transactions](07-Data-Modification/Transactions.md)
- [COMMIT ROLLBACK SAVEPOINT](07-Data-Modification/COMMIT-ROLLBACK-SAVEPOINT.md)
- [Safe Data Modification](07-Data-Modification/Safe-Data-Modification.md)
- [Data Modification Practice SQL](07-Data-Modification/Data-Modification-Practice.sql)

</details>

<details open>
<summary>Stage 9 — Keys, Constraints, Relationships, Normalization</summary>

- [Constraints](08-Database-Design/Constraints.md)
- [Primary And Foreign Keys](08-Database-Design/Primary-And-Foreign-Keys.md)
- [Unique Not Null Default Check](08-Database-Design/Unique-Not-Null-Default-Check.md)
- [Relationships](08-Database-Design/Relationships.md)
- [ER Model](08-Database-Design/ER-Model.md)
- [Normalization](08-Database-Design/Normalization.md)
- [First Normal Form 1NF](08-Database-Design/First-Normal-Form-1NF.md)
- [Second Normal Form 2NF](08-Database-Design/Second-Normal-Form-2NF.md)
- [Third Normal Form 3NF](08-Database-Design/Third-Normal-Form-3NF.md)
- [Boyce Codd Normal Form BCNF](08-Database-Design/Boyce-Codd-Normal-Form-BCNF.md)
- [Referential Integrity](08-Database-Design/Referential-Integrity.md)
- [Database Design Practice SQL](08-Database-Design/Database-Design-Practice.sql)

</details>

<details open>
<summary>Stage 10 — CTEs, Window Functions, Views, Indexes, Optimization</summary>

- [Common Table Expressions CTEs](09-Advanced-SQL/Common-Table-Expressions-CTEs.md)
- [Recursive CTEs](09-Advanced-SQL/Recursive-CTEs.md)
- [Window Functions](09-Advanced-SQL/Window-Functions.md)
- [ROW NUMBER RANK DENSE RANK](09-Advanced-SQL/ROW-NUMBER-RANK-DENSE-RANK.md)
- [LAG LEAD](09-Advanced-SQL/LAG-LEAD.md)
- [Running Totals And Moving Averages](09-Advanced-SQL/Running-Totals-And-Moving-Averages.md)
- [Views](09-Advanced-SQL/Views.md)
- [Indexes](09-Advanced-SQL/Indexes.md)
- [Query Optimization](09-Advanced-SQL/Query-Optimization.md)
- [EXPLAIN And Execution Plans](09-Advanced-SQL/EXPLAIN-And-Execution-Plans.md)
- [Stored Procedures](09-Advanced-SQL/Stored-Procedures.md)
- [Stored Functions](09-Advanced-SQL/Stored-Functions.md)
- [Triggers](09-Advanced-SQL/Triggers.md)
- [Events And Scheduled Tasks](09-Advanced-SQL/Events-And-Scheduled-Tasks.md)
- [Advanced SQL Practice SQL](09-Advanced-SQL/Advanced-SQL-Practice.sql)
- [ALTER DROP TRUNCATE](10-Database-Objects/ALTER-DROP-TRUNCATE.md)
- [Temporary Tables](10-Database-Objects/Temporary-Tables.md)
- [Information Schema](10-Database-Objects/Information-Schema.md)
- [Metadata And Database Inspection](10-Database-Objects/Metadata-And-Database-Inspection.md)
- [Database Objects Practice SQL](10-Database-Objects/Database-Objects-Practice.sql)

</details>

---

## Chapter Navigation

All chapters use collapsible groups above. Practice scripts: 05-Joins Join-Practice, 06-Subqueries Subquery-Practice, 07-Data-Modification Data-Modification-Practice, 08-Database-Design Database-Design-Practice, 09-Advanced-SQL Advanced-SQL-Practice, 10-Database-Objects Database-Objects-Practice.

---

## Practice And Interview Prep

Practice files with answers are listed above in each stage. How to practice: read the note, study syntax, run the example, compare output, solve alone, then check the answer.

Interview topics covered: join types and anti-joins, IN versus EXISTS, NOT IN NULL trap, ANY and ALL, UNION versus UNION ALL, INTERSECT and EXCEPT workarounds, transactions and ACID, keys and constraints, normalization to BCNF, CTEs, ranking with ties, LAG and LEAD, views, indexes and leftmost rule, EXPLAIN, procedures versus functions, triggers, events.

Cheat sheet and mini-project are not yet available and are omitted until added.

---

## How To Study

1. Read the explanation. 2. Understand the syntax. 3. Run the example with USE sql_notes. 4. Compare output. 5. Solve practice alone. 6. Review the solution.

Recommended order: Stages 1 to 10 in the roadmap.

---

## Repository Info

Overview: complete MySQL notes from zero to advanced on one college database with 5 students and 6 tables. Technology: MySQL 8.0+, Markdown, SQL scripts. No framework or JavaScript. Objectives: write basic to advanced queries, design normalized tables, use transactions safely, answer exam questions. Contributing: keep the same students and tables, real column names, runnable order, update links for new files. Closing: one note per day, run every query, finish all practice files.
