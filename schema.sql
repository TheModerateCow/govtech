DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TABLE student
(
    student_id SERIAL PRIMARY KEY,
    name       VARCHAR(100)
);

CREATE TABLE teacher
(
    teacher_id SERIAL PRIMARY KEY,
    name       VARCHAR(100)
);

CREATE TABLE semester
(
    sem_no INT,
    year   INT,
    PRIMARY KEY (sem_no, year)
);

-- Create the Course Table
CREATE TABLE course
(
    course_id SERIAL PRIMARY KEY,
    name      VARCHAR(100)
);

-- Create the ATTEND Table
CREATE TABLE attend
(
    teacher_id INT,
    sem_no     INT,
    year       INT,
    course_id  INT,
    PRIMARY KEY (teacher_id, sem_no, year, course_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher (teacher_id),
    FOREIGN KEY (sem_no, year) REFERENCES semester (sem_no, year),
    FOREIGN KEY (course_id) REFERENCES course (course_id)
);

CREATE TABLE grade
(
    student_id INT,
    teacher_id INT,
    sem_no     INT,
    year       INT,
    course_id  INT,
    grade      VARCHAR(10),
    PRIMARY KEY (teacher_id, sem_no, year, course_id, student_id),
    FOREIGN KEY (teacher_id, sem_no, year, course_id) REFERENCES attend (teacher_id, sem_no, year, course_id),
    FOREIGN KEY (student_id) REFERENCES student (student_id)
)
