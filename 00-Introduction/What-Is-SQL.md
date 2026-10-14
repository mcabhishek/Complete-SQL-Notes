WHAT IS SQL?
============


DEFINITION

SQL stands for Structured Query Language. It is a language used to communicate
with relational databases. It lets you create, read, update, and delete data
stored in tables.

SQL is not a programming language like Python or Java. It is a query language
whose only job is to talk to databases.

SQL is pronounced either as "S-Q-L" or "sequel" -- both are accepted.



WHY SQL MATTERS

Use Case              Example
Store data            Save student records for a college
Retrieve data         Get all students who scored above 80%
Modify data           Update a student's email address
Delete data           Remove a withdrawn student's record
Manage access         Allow a teacher to only read marks, not delete them



A SIMPLE EXAMPLE

Imagine a table called students:

  +------------+-----------+-----+
  | student_id | name      | age |
  +------------+-----------+-----+
  |          1 | Abhishek  |  20 |
  |          2 | Jeevan    |  21 |
  |          3 | Likhith   |  20 |
  |          4 | Jeevitha  |  19 |
  |          5 | Manjunath |  22 |
  +------------+-----------+-----+

To fetch all student names you write:

    SELECT name FROM students;

Output:

  +-----------+
  | name      |
  +-----------+
  | Abhishek  |
  | Jeevan    |
  | Likhith   |
  | Jeevitha  |
  | Manjunath |
  +-----------+

That is SQL. One line and you retrieved data from a table.



HISTORY OF SQL

Year    Event
1970    Edgar F. Codd (IBM) published the relational model for databases
1974    IBM developed SEQUEL (Structured English Query Language)
1979    Oracle released the first commercial SQL database
1986    SQL became an ANSI standard
1987    SQL became an ISO standard
Today   Used by MySQL, PostgreSQL, SQL Server, Oracle, SQLite, and more



SQL VS. OTHER LANGUAGES

Feature       SQL                     Python
Type          Query language          Programming language
Purpose       Talk to databases       General computing
Loops         No (uses set ops)       Yes
Readability   English-like            High

SQL is used inside Python, Java, and other languages to talk to a database:

```python
import mysql.connector
conn = mysql.connector.connect(
    host="localhost", user="root", password="root", database="sql_notes"
)
cursor = conn.cursor()
cursor.execute("SELECT name FROM students")
for row in cursor.fetchall():
    print(row)
```



POPULAR SQL DATABASES

Database     Made by          Common Use
MySQL        Oracle           Web apps, LAMP stack
PostgreSQL   Open-source      Advanced features, open-source projects
SQL Server   Microsoft        Enterprise, Windows environments
Oracle DB    Oracle           Large enterprise systems
SQLite       Open-source      Mobile apps, embedded systems

This project uses MySQL 8.0+.



MYSQL VS. OTHER DATABASES

Feature              MySQL 8.0           PostgreSQL       SQL Server
String quotes        Single or double    Single only      Single only
Auto increment       AUTO_INCREMENT      SERIAL           IDENTITY
Limit rows           LIMIT n             LIMIT n          TOP n
Case sensitive?      No (default)        Yes              No



COMMON MISTAKES

1. Forgetting the semicolon
   Every SQL statement must end with ; in the MySQL CLI.

   Wrong:   SELECT name FROM students
   Right:   SELECT name FROM students;

2. Using double quotes for strings
   In MySQL always use single quotes for string values.

   May cause errors:  WHERE name = "Abhishek"
   Correct:           WHERE name = 'Abhishek'

3. Thinking SQL keywords are case-sensitive
   They are not. SELECT, select, and Select all work the same.
   Convention is to write keywords in UPPERCASE.

4. Using == instead of =
   SQL uses a single = for comparison. There is no == in SQL.

   Wrong:  WHERE age == 20
   Right:  WHERE age = 20

5. Forgetting to select the right database
   Always run USE sql_notes; before your queries.



PRACTICE QUESTIONS

Q1. What does SQL stand for?
Answer: Structured Query Language.

Q2. Is SQL a programming language? Explain.
Answer: No. SQL is a query language designed specifically to interact with
relational databases. It cannot perform general tasks like file I/O on its own.

Q3. Which company owns MySQL?
Answer: Oracle Corporation (originally developed by MySQL AB, released as
open-source under GPL).

Q4. Write a SQL query to display all records from the courses table.
Answer:
    SELECT * FROM courses;

Q5. What is the difference between LIMIT in MySQL and TOP in SQL Server?
Answer:
  MySQL:       SELECT * FROM students LIMIT 3;
  SQL Server:  SELECT TOP 3 * FROM students;
  Both limit the number of rows returned but with different syntax.



REVISION SUMMARY

SQL             = Structured Query Language
Purpose         = Communicate with relational databases
Created         = 1974 by IBM, standardized by ANSI in 1986
This project    = MySQL 8.0+
Keywords        = Not case-sensitive
Statements end  = With a semicolon ;
String values   = Use single quotes 'value'

