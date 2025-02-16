DROP SCHEMA IF EXISTS public CASCADE;

CREATE SCHEMA public;

-- Assumption: 
-- A student will take multiple course over many semesters but will only take 1 course per semester
-- A student will only be assigned to one teacher over the full semester period. So student named tom will be assigned to a teacher name John for the whole school duration
-- It is a good idea to keep track of course names, student names, and teacher names.
-- The database only tracks the month, regards of the exact date.
CREATE TABLE
    teacher (teacher_id SERIAL PRIMARY KEY, name VARCHAR(100));

CREATE TABLE
    student (
        student_id SERIAL PRIMARY KEY,
        name VARCHAR(100),
        teacher_id INT,
        FOREIGN KEY (teacher_id) REFERENCES teacher (teacher_id)
    );

-- Changed date to month, focused on what the question is asking for.
CREATE TABLE
    semester (
        sem_no INT,
        year INT,
        start_month SMALLINT CHECK (start_month BETWEEN 1 AND 12),
        end_month SMALLINT CHECK (end_month BETWEEN 1 AND 12),
        PRIMARY KEY (sem_no, year)
    );

CREATE TABLE
    course (
        student_id INT,
        sem_no INT,
        year INT,
        course_name VARCHAR(100),
        grade VARCHAR(10),
        PRIMARY KEY (student_id, sem_no, year),
        FOREIGN KEY (student_id) REFERENCES student (student_id),
        FOREIGN KEY (sem_no, year) REFERENCES semester (sem_no, year)
    );

-- Insert Data
INSERT INTO
    student (name)
VALUES
    ('Dame', 1),
    ('Adina', 1),
    ('Rebecka', 1),
    ('Helsa', 1),
    ('Isacco', 1),
    ('Mickey', 2),
    ('Lethia', 2),
    ('Babbette', 2),
    ('Shelby', 2),
    ('Andras', 2);

INSERT INTO
    teacher (name)
VALUES
    ('Jamima Wait'),
    ('Dar Sheddan');

INSERT INTO
    semester (sem_no, year, start_month, end_month)
VALUES
    (1, 2021, '08', '11'),
    (2, 2021, '01', '04'),
    (1, 2022, '08', '11'),
    (2, 2022, '01', '04'),
    (1, 2023, '08', '11'),
    (2, 2023, '01', '04'),
    (1, 2024, '08', '11'),
    (2, 2024, '01', '04');

-- Student id of 1
INSERT INTO
    COURSE (student_id, sem_no, year, course_name, grade)
VALUES
    (1, 1, 2021, 'Computer Science 101', 'A+'),
    (1, 2, 2021, 'Computer Science 102', 'A+'),
    (1, 1, 2022, 'Math 101', 'A+'),
    (1, 2, 2022, 'Math 102', 'A+'),
    (1, 1, 2023, 'Science 101', 'A+'),
    (1, 2, 2023, 'Science 102', 'A+'),
    (1, 1, 2024, 'English 101', 'A+'),
    (1, 2, 2024, 'English 102', 'A+');

-- For student_id = 2
INSERT INTO
    course (student_id, sem_no, year, course_name, grade)
VALUES
    (2, 1, 2021, 'Computer Science 101', 'A'),
    (2, 2, 2021, 'Computer Science 102', 'B+'),
    (2, 1, 2022, 'Math 101', 'A-'),
    (2, 2, 2022, 'Math 102', 'B'),
    (2, 1, 2023, 'Science 101', 'B+'),
    (2, 2, 2023, 'Science 102', 'A'),
    (2, 1, 2024, 'English 101', 'A'),
    (2, 2, 2024, 'English 102', 'B+');

-- For student_id = 3
INSERT INTO
    course (student_id, sem_no, year, course_name, grade)
VALUES
    (3, 1, 2021, 'History 101', 'B'),
    (3, 2, 2021, 'History 102', 'B+'),
    (3, 1, 2022, 'Geography 101', 'A-'),
    (3, 2, 2022, 'Geography 102', 'B'),
    (3, 1, 2023, 'Economics 101', 'B+'),
    (3, 2, 2023, 'Economics 102', 'A'),
    (3, 1, 2024, 'Philosophy 101', 'A'),
    (3, 2, 2024, 'Philosophy 102', 'B+');

-- For student_id = 4
INSERT INTO
    course (student_id, sem_no, year, course_name, grade)
VALUES
    (4, 1, 2021, 'Biology 101', 'A'),
    (4, 2, 2021, 'Biology 102', 'A-'),
    (4, 1, 2022, 'Chemistry 101', 'B+'),
    (4, 2, 2022, 'Chemistry 102', 'B'),
    (4, 1, 2023, 'Physics 101', 'A'),
    (4, 2, 2023, 'Physics 102', 'B+'),
    (4, 1, 2024, 'English Literature 101', 'A'),
    (4, 2, 2024, 'English Literature 102', 'A-');

-- For student_id = 5
INSERT INTO
    course (student_id, sem_no, year, course_name, grade)
VALUES
    (5, 1, 2021, 'Art 101', 'B+'),
    (5, 2, 2021, 'Art 102', 'A'),
    (5, 1, 2022, 'Music 101', 'A-'),
    (5, 2, 2022, 'Music 102', 'B'),
    (5, 1, 2023, 'Dance 101', 'B+'),
    (5, 2, 2023, 'Dance 102', 'A'),
    (5, 1, 2024, 'Theatre 101', 'A'),
    (5, 2, 2024, 'Theatre 102', 'B+');

-- For student_id = 6
INSERT INTO
    course (student_id, sem_no, year, course_name, grade)
VALUES
    (6, 1, 2021, 'Economics 101', 'A'),
    (6, 2, 2021, 'Economics 102', 'A-'),
    (6, 1, 2022, 'Statistics 101', 'B'),
    (6, 2, 2022, 'Statistics 102', 'B+'),
    (6, 1, 2023, 'Business 101', 'A'),
    (6, 2, 2023, 'Business 102', 'A'),
    (6, 1, 2024, 'Marketing 101', 'A'),
    (6, 2, 2024, 'Marketing 102', 'A-');

-- For student_id = 7
INSERT INTO
    course (student_id, sem_no, year, course_name, grade)
VALUES
    (7, 1, 2021, 'Computer Science 101', 'B'),
    (7, 2, 2021, 'Computer Science 102', 'B+'),
    (7, 1, 2022, 'Math 101', 'B-'),
    (7, 2, 2022, 'Math 102', 'B'),
    (7, 1, 2023, 'Science 101', 'B+'),
    (7, 2, 2023, 'Science 102', 'B'),
    (7, 1, 2024, 'English 101', 'B+'),
    (7, 2, 2024, 'English 102', 'B');

-- For student_id = 8
INSERT INTO
    course (student_id, sem_no, year, course_name, grade)
VALUES
    (8, 1, 2021, 'History 101', 'A'),
    (8, 2, 2021, 'History 102', 'A-'),
    (8, 1, 2022, 'Geography 101', 'B'),
    (8, 2, 2022, 'Geography 102', 'B+'),
    (8, 1, 2023, 'Economics 101', 'A'),
    (8, 2, 2023, 'Economics 102', 'A-'),
    (8, 1, 2024, 'Philosophy 101', 'B'),
    (8, 2, 2024, 'Philosophy 102', 'B+');