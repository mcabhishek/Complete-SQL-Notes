USE sql_notes;
SET FOREIGN_KEY_CHECKS = 0;
CREATE TABLE IF NOT EXISTS departments (
    dept_id   INT          NOT NULL AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    hod_name  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (dept_id),
    CONSTRAINT uq_dept_name   UNIQUE (dept_name)
);
CREATE TABLE IF NOT EXISTS students (
    student_id      INT          NOT NULL AUTO_INCREMENT,
    name            VARCHAR(100) NOT NULL,
    age             INT,
    gender          CHAR(1),
    email           VARCHAR(150),
    dept_id         INT          NOT NULL,
    enrollment_year YEAR         NOT NULL DEFAULT (YEAR(CURDATE())),
    CONSTRAINT pk_students   PRIMARY KEY (student_id),
    CONSTRAINT uq_email      UNIQUE (email),
    CONSTRAINT chk_age       CHECK (age BETWEEN 15 AND 30),
    CONSTRAINT chk_gender    CHECK (gender IN ('M', 'F', 'O')),
    CONSTRAINT fk_stu_dept   FOREIGN KEY (dept_id)
                             REFERENCES departments(dept_id)
                             ON UPDATE CASCADE
                             ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS courses (
    course_id   INT          NOT NULL AUTO_INCREMENT,
    course_name VARCHAR(150) NOT NULL,
    credits     INT          NOT NULL,
    dept_id     INT          NOT NULL,
    CONSTRAINT pk_courses     PRIMARY KEY (course_id),
    CONSTRAINT chk_credits    CHECK (credits BETWEEN 1 AND 6),
    CONSTRAINT fk_crs_dept    FOREIGN KEY (dept_id)
                              REFERENCES departments(dept_id)
                              ON UPDATE CASCADE
                              ON DELETE RESTRICT
);
CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT         NOT NULL AUTO_INCREMENT,
    student_id    INT         NOT NULL,
    course_id     INT         NOT NULL,
    semester      INT         NOT NULL,
    academic_year VARCHAR(10) NOT NULL,
    CONSTRAINT pk_enrollments  PRIMARY KEY (enrollment_id),
    CONSTRAINT uq_enroll       UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT chk_semester    CHECK (semester BETWEEN 1 AND 8),
    CONSTRAINT fk_enr_student  FOREIGN KEY (student_id)
                               REFERENCES students(student_id)
                               ON UPDATE CASCADE
                               ON DELETE CASCADE,
    CONSTRAINT fk_enr_course   FOREIGN KEY (course_id)
                               REFERENCES courses(course_id)
                               ON UPDATE CASCADE
                               ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS marks (
    mark_id        INT          NOT NULL AUTO_INCREMENT,
    enrollment_id  INT          NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    max_marks      INT          NOT NULL DEFAULT 100,
    grade          VARCHAR(3),
    CONSTRAINT pk_marks         PRIMARY KEY (mark_id),
    CONSTRAINT uq_marks_enroll  UNIQUE (enrollment_id),
    CONSTRAINT chk_marks_range  CHECK (marks_obtained >= 0 AND marks_obtained <= max_marks),
    CONSTRAINT fk_marks_enroll  FOREIGN KEY (enrollment_id)
                                REFERENCES enrollments(enrollment_id)
                                ON UPDATE CASCADE
                                ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS attendance (
    attendance_id    INT          NOT NULL AUTO_INCREMENT,
    student_id       INT          NOT NULL,
    course_id        INT          NOT NULL,
    total_classes    INT          NOT NULL,
    attended_classes INT          NOT NULL,
    percentage       DECIMAL(5,2) GENERATED ALWAYS AS
                         (ROUND((attended_classes / total_classes) * 100, 2)) STORED,
    CONSTRAINT pk_attendance   PRIMARY KEY (attendance_id),
    CONSTRAINT uq_att_stu_crs  UNIQUE (student_id, course_id),
    CONSTRAINT chk_att_classes CHECK (attended_classes <= total_classes AND total_classes > 0),
    CONSTRAINT fk_att_student  FOREIGN KEY (student_id)
                               REFERENCES students(student_id)
                               ON UPDATE CASCADE
                               ON DELETE CASCADE,
    CONSTRAINT fk_att_course   FOREIGN KEY (course_id)
                               REFERENCES courses(course_id)
                               ON UPDATE CASCADE
                               ON DELETE CASCADE
);
SET FOREIGN_KEY_CHECKS = 1;
SHOW TABLES;
