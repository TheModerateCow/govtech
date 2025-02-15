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
    start_date DATE,
    end_date DATE,
    PRIMARY KEY (sem_no, year)
);

CREATE TABLE course
(
    course_id SERIAL PRIMARY KEY,
    name      VARCHAR(100)
);

CREATE TABLE class
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
    PRIMARY KEY (student_id, teacher_id, sem_no, year),
    FOREIGN KEY (teacher_id, sem_no, year, course_id) REFERENCES class (teacher_id, sem_no, year, course_id),
    FOREIGN KEY (student_id) REFERENCES student (student_id)
);

-- Insert Data (I used chatgpt to generate dummy data)
INSERT INTO student (name) VALUES
('Dame'),
('Adina'),
('Rebecka'),
('Helsa'),
('Isacco'),
('Mickey'),
('Lethia'),
('Babbette'),
('Shelby'),
('Andras');

INSERT INTO teacher (name) VALUES
('Jamima Wait'),
('Dar Sheddan');

INSERT INTO semester (sem_no, year, start_date, end_date) VALUES
(1, 2021, '2021-01-10', '2021-05-15'),
(2, 2021, '2021-08-25', '2021-12-15'),
(1, 2022, '2022-01-10', '2022-05-15'),
(2, 2022, '2022-08-25', '2022-12-15'),
(1, 2023, '2023-01-10', '2023-05-15'),
(2, 2023, '2023-08-25', '2023-12-15'),
(1, 2024, '2024-01-10', '2024-05-15'),
(2, 2024, '2024-08-25', '2024-12-15');

INSERT INTO course (name) VALUES
('Computer Science 101'),
('Mathematics 101'),
('Physics 101'),
('Chemistry 101'),
('Biology 101'),
('History 101'),
('English Literature 101'),
('Economics 101');

-- Teacher 1
INSERT INTO class (teacher_id, sem_no, year, course_id) VALUES
(1, 1, 2021, 1),
(1, 2, 2021, 2),
(1, 1, 2022, 3),
(1, 2, 2022, 4),
(1, 1, 2023, 5),
(1, 2, 2023, 6),
(1, 1, 2024, 7),
(1, 2, 2024, 8);

-- Teacher 2
INSERT INTO class (teacher_id, sem_no, year, course_id) VALUES
(2, 1, 2022, 1),
(2, 2, 2022, 2),
(2, 1, 2023, 3),
(2, 2, 2023, 4),
(2, 1, 2024, 5),
(2, 2, 2024, 6),
(2, 1, 2021, 7),
(2, 2, 2021, 8);

-- Student 1
INSERT INTO grade (student_id, teacher_id, sem_no, year, course_id, grade) VALUES
(1, 1, 1, 2021, 1, 'A'),
(1, 1, 2, 2021, 2, 'B'),
(1, 1, 1, 2022, 3, 'A-'),
(1, 1, 2, 2022, 4, 'B+'),
(1, 1, 1, 2023, 5, 'A'),
(1, 1, 2, 2023, 6, 'A'),
(1, 1, 1, 2024, 7, 'B'),
(1, 1, 2, 2024, 8, 'A');

-- Student 2
INSERT INTO grade (student_id, teacher_id, sem_no, year, course_id, grade) VALUES
(2, 1, 1, 2021, 1, 'B+'),
(2, 1, 2, 2021, 2, 'A'),
(2, 1, 1, 2022, 3, 'B'),
(2, 1, 2, 2022, 4, 'A-'),
(2, 1, 1, 2023, 5, 'A'),
(2, 1, 2, 2023, 6, 'B+'),
(2, 1, 1, 2024, 7, 'A-'),
(2, 1, 2, 2024, 8, 'A');

-- Student 3
INSERT INTO grade (student_id, teacher_id, sem_no, year, course_id, grade) VALUES
(3, 1, 1, 2021, 1, 'B+'),
(3, 1, 2, 2021, 2, 'A'),
(3, 1, 1, 2022, 3, 'B'),
(3, 1, 2, 2022, 4, 'A-'),
(3, 1, 1, 2023, 5, 'A'),
(3, 1, 2, 2023, 6, 'B+'),
(3, 1, 1, 2024, 7, 'A-'),
(3, 1, 2, 2024, 8, 'A');

-- Student 6
INSERT INTO grade (student_id, teacher_id, sem_no, year, course_id, grade) VALUES
(6, 2, 1, 2022, 1, 'A+'),
(6, 2, 2, 2022, 2, 'A+'),
(6, 2, 1, 2023, 3, 'A+'),
(6, 2, 2, 2023, 4, 'A+'),
(6, 2, 1, 2024, 5, 'A'),
(6, 2, 2, 2024, 6, 'A'),
(6, 2, 1, 2021, 7, 'A'),
(6, 2, 2, 2021, 8, 'A');

-- Student 7
INSERT INTO grade (student_id, teacher_id, sem_no, year, course_id, grade) VALUES
(7, 2, 1, 2022, 1, 'B'),
(7, 2, 2, 2022, 2, 'A'),
(7, 2, 1, 2023, 3, 'A-'),
(7, 2, 2, 2023, 4, 'B+'),
(7, 2, 1, 2024, 5, 'A'),
(7, 2, 2, 2024, 6, 'A'),
(7, 2, 1, 2021, 7, 'B'),
(7, 2, 2, 2021, 8, 'A');


