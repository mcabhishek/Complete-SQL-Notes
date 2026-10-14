USE sql_notes;
SET FOREIGN_KEY_CHECKS = 0;
INSERT INTO departments (dept_id, dept_name, hod_name) VALUES
(1, 'Computer Science',    'Dr. Ramesh Kumar'),
(2, 'Information Science', 'Dr. Priya Nair'),
(3, 'Electronics',         'Dr. Suresh Babu');
INSERT INTO students (student_id, name, age, gender, email, dept_id, enrollment_year) VALUES
(1, 'Abhishek',  20, 'M', 'abhishek@college.edu',  1, 2023),
(2, 'Jeevan',    21, 'M', 'jeevan@college.edu',    1, 2022),
(3, 'Likhith',   20, 'M', 'likhith@college.edu',   2, 2023),
(4, 'Jeevitha',  19, 'F', 'jeevitha@college.edu',  2, 2023),
(5, 'Manjunath', 22, 'M', 'manjunath@college.edu', 3, 2022);
INSERT INTO courses (course_id, course_name, credits, dept_id) VALUES
(1, 'Database Management', 4, 1),
(2, 'Data Structures',     4, 1),
(3, 'Computer Networks',   3, 2),
(4, 'Operating Systems',   3, 1),
(5, 'Digital Electronics', 4, 3);
INSERT INTO enrollments (enrollment_id, student_id, course_id, semester, academic_year) VALUES
(1, 1, 1, 3, '2023-24'),
(2, 1, 2, 3, '2023-24'),
(3, 2, 1, 5, '2023-24'),
(4, 2, 4, 5, '2023-24'),
(5, 3, 3, 3, '2023-24'),
(6, 4, 3, 3, '2023-24'),
(7, 4, 1, 3, '2023-24'),
(8, 5, 5, 5, '2023-24');
INSERT INTO marks (mark_id, enrollment_id, marks_obtained, max_marks, grade) VALUES
(1, 1, 88.00, 100, 'A'),
(2, 2, 75.00, 100, 'B'),
(3, 3, 92.00, 100, 'A+'),
(4, 4, 68.00, 100, 'C'),
(5, 5, 55.00, 100, 'D'),
(6, 6, 78.00, 100, 'B'),
(7, 7, 95.00, 100, 'A+'),
(8, 8, 82.00, 100, 'A');
INSERT INTO attendance (attendance_id, student_id, course_id, total_classes, attended_classes) VALUES
(1, 1, 1, 60, 54),
(2, 1, 2, 55, 44),
(3, 2, 1, 60, 48),
(4, 2, 4, 50, 42),
(5, 3, 3, 45, 36),
(6, 4, 3, 45, 40),
(7, 4, 1, 60, 57),
(8, 5, 5, 50, 35);
SET FOREIGN_KEY_CHECKS = 1;
SELECT 'departments' AS table_name, COUNT(*) AS row_count FROM departments
UNION ALL
SELECT 'students',    COUNT(*) FROM students
UNION ALL
SELECT 'courses',     COUNT(*) FROM courses
UNION ALL
SELECT 'enrollments', COUNT(*) FROM enrollments
UNION ALL
SELECT 'marks',       COUNT(*) FROM marks
UNION ALL
SELECT 'attendance',  COUNT(*) FROM attendance;
SELECT * FROM students;
SELECT s.name, d.dept_name
FROM   students s
JOIN   departments d ON s.dept_id = d.dept_id;
SELECT s.name, c.course_name, a.total_classes, a.attended_classes, a.percentage
FROM   attendance a
JOIN   students s ON a.student_id = s.student_id
JOIN   courses  c ON a.course_id  = c.course_id
ORDER  BY s.name, c.course_name;
