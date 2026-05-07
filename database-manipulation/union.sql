-- geting jobs and companies from jan & feb, all unique rows, and no duplicates
SELECT 
    job_title_short,
    company_id,
    job_location
FROM jan_jobs

UNION

SELECT 
    job_title_short,
    company_id,
    job_location
FROM feb_jobs

-- return all rows, even duplicates (much more used as it returns all the data stored)
SELECT 
    job_title_short,
    company_id,
    job_location
FROM jan_jobs

UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
FROM feb_jobs

-- so in UNION we get 107202 values & in UNION ALL we get 156826 values