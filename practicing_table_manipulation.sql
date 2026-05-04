
-- Creating the database

CREATE DATABASE sql_course;

-- creating a table

CREATE TABLE job_applied(
    job_id INT ,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(225),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(225),
    status VARCHAR(50)
);

-- view the table
SELECT * FROM job_applied;

--inserting data into the table

INSERT INTO job_applied (job_id,
                        application_sent_date,
                        custom_resume,
                        resume_file_name,
                        cover_letter_sent,
                        cover_letter_file_name,
                        status) 
VALUES
    (1, '2023-01-01', true, 'resume01.pdf', true, 'coverletter_01.pdf', 'submitted'),
    (2, '2023-01-02', true, 'resume01.pdf', true, 'coverletter_02.pdf', 'interviewing'),
    (3, '2023-01-03', false, 'resume01.pdf', true, 'coverletter_03.pdf', 'hired'),
    (4, '2023-01-04', true, 'resume01.pdf', false, 'coverletter_04.pdf', 'rejected'),
    (5, '2023-01-05', true, 'resume01.pdf', true, 'coverletter_05.pdf', 'ghosted');


-- ALTER TABLE
-- adding a column

ALTER TABLE job_applied
ADD contact VARCHAR(50);

-- UPDATE to modify existing data (rows) within a table
-- adding contact names to all the rows
UPDATE job_applied
SET contact = 'Mubashir Shaikh'
WHERE job_id = 1;
UPDATE job_applied
SET contact = 'John Cena'
WHERE job_id = 2;
UPDATE job_applied
SET contact = 'Nathan Dsilva'
WHERE job_id = 3;
UPDATE job_applied
SET contact = 'Stacy Miranda'
WHERE job_id = 4;
UPDATE job_applied
SET contact = 'Dinesh Pichai'
WHERE job_id = 5;

-- renaming a col (contact -> contact_name)
-- RENAME COLUMN
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

-- changing datatype of a column 
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

-- droppging/deleting a column

ALTER TABLE job_applied
DROP COLUMN contact_name;

-- deleting table
-- be careful , not reversible
DROP TABLE job_applied;