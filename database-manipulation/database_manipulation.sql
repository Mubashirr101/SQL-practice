-- verifying all data loaded properly
SELECT * FROM job_postings_fact LIMIT 100;

-- casting a string as a date dtype
SELECT '2023-02-18'::DATE;

-- more examples for casting
SELECT 
    '2023-02-18'::DATE,
    '123'::INTEGER,
    '3.14'::REAL,
    'true'::BOOLEAN;

------------------------------------------

SELECT job_title_short AS title, job_location AS location, job_posted_date AS date
FROM job_postings_fact;

-- Now we need only date so we convert the TIMESTAMP into DATE
SELECT job_title_short AS title, job_location AS location, job_posted_date::DATE AS date
FROM job_postings_fact;

-- using AT TIME ZONE in the timestamp to first declare it as UTC, then convert to IST
SELECT job_title_short AS title, job_location AS location, 
job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'IST' AS date
FROM job_postings_fact LIMIT 5;

-- EXTRACT , month from the timestamp

SELECT job_title_short AS title, job_location AS location, job_posted_date AS date,
EXTRACT (MONTH FROM job_posted_date) AS column_month
FROM job_postings_fact LIMIT 10;

-- trend analysis, how job posting trend from month to month

SELECT 
    COUNT(job_id), -- no. of entries(ids) 
    EXTRACT (MONTH FROM job_posted_date) AS column_month
FROM 
    job_postings_fact
GROUP BY 
    column_month -- shows no. of job_id per month

;

-- only for data analysts

SELECT 
    COUNT(job_id) AS no_of_jobs, -- no. of entries(ids) 
    EXTRACT (MONTH FROM job_posted_date) AS column_month
FROM 
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
GROUP BY 
    column_month -- shows no. of job_id per month
ORDER BY
    no_of_jobs DESC -- highest to lowest amount of jobs posted
;