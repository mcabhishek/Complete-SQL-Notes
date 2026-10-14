DATABASE BASICS
===============


WHAT IS A DATABASE?

A database is an organized collection of data stored electronically. It lets you
store, access, and manage information easily.

Think of it like a filing cabinet:
- Each drawer is a table
- Each folder is a row (one student, one course)
- Each label on the folder is a column (name, age, email)

A college uses a database instead of Excel sheets or paper registers because:
- It prevents duplicate records
- It enforces rules (marks must be between 0 and 100)
- Many users can access it at the same time
- It finds any record in milliseconds



DATABASE VS. SPREADSHEET

Feature             Spreadsheet (Excel)       Database (MySQL)
Data size           Millions of rows (slow)   Billions of rows (fast)
Multiple users      Limited                   Yes, concurrent access
Relationships       Manual (VLOOKUP)          Built-in (Foreign Keys)
Data integrity      Weak                      Strong (constraints)
Security            File-level only           User roles, permissions
Query language      Formulas                  SQL



WHAT IS A RELATIONAL DATABASE?

A relational database stores data in tables that are linked to each other
using keys. In the sql_notes database the tables are connected like this:

  departments  -<  students  -<  enrollments  >-  courses
                                      |
                                    marks
  students  -<  attendance  >-  courses

One department has many students.
One student can enroll in many courses (through the enrollments table).
Each enrollment has one marks record.
Each student has attendance records per course.



KEY TERMS

Table
  A set of rows and columns. The basic unit of storage in a database.

Row (also called Record or Tuple)
  One horizontal entry in a table. Each row represents one thing (one student).

Column (also called Field or Attribute)
  One vertical entry. Represents one property (name, age, email).

Primary Key (PK)
  A column that uniquely identifies each row. No two rows can have the same
  primary key. It cannot be empty (NULL).

  Example:
    student_id = 1  means Abhishek  (no other student can have id 1)
    student_id = 2  means Jeevan

Foreign Key (FK)
  A column in one table that points to the primary key of another table.
  It creates the link between two tables.

  Example:
    students.dept_id  points to  departments.dept_id

  This means every student must belong to a department that exists in the
  departments table.

Unique Constraint
  Ensures every value in a column is different. Unlike a primary key, it
  allows one NULL.

  Example:
    email must be unique -- two students cannot share the same email.

Check Constraint
  A rule that the data must follow before it is saved.

  Examples:
    age must be between 15 and 30
    marks_obtained cannot be more than max_marks

Default Value
  A value automatically used when no value is provided during INSERT.

  Example:
    enrollment_year uses the current year if you do not supply one.

NULL
  Means the value is missing or unknown. It is not zero and not an empty string.

  email = NULL   means we do not know the email
  email = ''     means the email is blank (empty string) -- different meaning



THE sql_notes SCHEMA

Table: departments
  dept_id    INT           Primary Key, Auto Increment
  dept_name  VARCHAR(100)  Not Null, Unique
  hod_name   VARCHAR(100)  Not Null

Table: students
  student_id      INT           Primary Key, Auto Increment
  name            VARCHAR(100)  Not Null
  age             INT           Must be between 15 and 30
  gender          CHAR(1)       Must be M, F, or O
  email           VARCHAR(150)  Unique
  dept_id         INT           Foreign Key to departments
  enrollment_year YEAR          Default = current year

Table: courses
  course_id   INT           Primary Key, Auto Increment
  course_name VARCHAR(150)  Not Null
  credits     INT           Must be between 1 and 6
  dept_id     INT           Foreign Key to departments

Table: enrollments
  enrollment_id INT          Primary Key, Auto Increment
  student_id    INT          Foreign Key to students
  course_id     INT          Foreign Key to courses
  semester      INT          Must be between 1 and 8
  academic_year VARCHAR(10)  Not Null

Table: marks
  mark_id        INT           Primary Key, Auto Increment
  enrollment_id  INT           Foreign Key to enrollments
  marks_obtained DECIMAL(5,2)  Must be 0 or more
  max_marks      INT           Default = 100
  grade          VARCHAR(3)

Table: attendance
  attendance_id    INT           Primary Key, Auto Increment
  student_id       INT           Foreign Key to students
  course_id        INT           Foreign Key to courses
  total_classes    INT           Not Null
  attended_classes INT           Not Null
  percentage       DECIMAL(5,2)  Auto-calculated by MySQL



TYPES OF DATABASES

Type              Description                          Examples
Relational        Data in tables with links            MySQL, PostgreSQL, Oracle
NoSQL             Flexible structure                   MongoDB, Redis
In-memory         Data stored in RAM, very fast        Redis, Memcached
Time-series       Designed for time-stamped data       InfluxDB

This project uses a Relational Database (MySQL).



COMMON MISTAKES

1. Confusing NULL with 0 or empty string
   - NULL means the value does not exist
   - 0 means the value is zero
   - '' means the value is an empty string

2. Thinking Primary Key and Unique are the same
   - Primary Key: cannot be NULL, only one per table
   - Unique: can have one NULL, a table can have multiple unique columns

3. Inserting into a table before the referenced table exists
   - You must insert into departments before inserting students that
     reference a department.

4. Thinking column order matters for queries -- it does not.
   SELECT name, age and SELECT age, name are both valid.

5. Mixing up rows and columns
   - Rows go across (horizontal)
   - Columns go down (vertical)



PRACTICE QUESTIONS

Q1. What is the difference between a primary key and a foreign key?

Answer:
  A primary key uniquely identifies each row in its own table (no nulls,
  no duplicates). A foreign key is a column in one table that points to the
  primary key in another table, linking the two tables together.

Q2. In the sql_notes schema, which table links students and courses?

Answer:
  The enrollments table. It has: enrollment_id, student_id, course_id,
  semester, and academic_year.

Q3. Why is email declared UNIQUE in the students table?

Answer:
  No two students should have the same email. The UNIQUE constraint
  prevents duplicate emails from being saved.

Q4. What does CHECK (age BETWEEN 15 AND 30) do?

Answer:
  It rejects any INSERT or UPDATE that sets age to a value outside
  the range 15 to 30. MySQL will return an error for invalid values.

Q5. Which columns identify Jeevitha's attendance for a specific course?

Answer:
  student_id (= 4 for Jeevitha) and course_id together identify her
  attendance record for that specific course.



REVISION SUMMARY

Term              Meaning
Database          Organized collection of structured data
Table             Rows and columns -- basic storage unit
Row               One record (one student, one course)
Column            One property (name, age, email)
Primary Key       Unique identifier for each row in a table
Foreign Key       Links a column to the PK of another table
UNIQUE            All values in the column must be different
CHECK             Column values must satisfy a condition
DEFAULT           Value used when no value is provided
NULL              Missing or unknown value
RDBMS             Relational Database Management System

