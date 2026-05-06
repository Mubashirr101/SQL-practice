-- creating new tables from the original source table

SELECT * FROM job_postings_fact LIMIT 10;

-- creating tables for each month (jan-mar)

SELECT * 
FROM job_postings_fact 
WHERE EXTRACT(MONTH FROM job_posted_date) = 1 -- only january (1 means january)
LIMIT 10;

-- for January

CREATE TABLE jan_jobs AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1 ;

-- for February

CREATE TABLE feb_jobs AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2 ;

-- for March

CREATE TABLE mar_jobs AS 
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3 ;


-- check the tables
SELECT * FROM jan_jobs LIMIT 10;
SELECT * FROM feb_jobs LIMIT 10;
SELECT * FROM mar_jobs LIMIT 10;
