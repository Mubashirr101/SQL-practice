
-- lets reclassify wheres the job is located at

SELECT 
    job_title_short,
    job_location
FROM job_postings_fact 
LIMIT 10;

-- imagine we in new york, so we label it as local and 'anywhere' as remote
-- and rest as 'Onsite'

SELECT 
    job_title_short,
    job_location,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact ;

-- now analysing how many jobs are in the 3 category

SELECT 
    COUNT(job_id) AS no_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact 
GROUP BY location_category
ORDER BY no_of_jobs DESC
;

-- lets specify only for data analyst jobs

SELECT 
    COUNT(job_id) AS no_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact 
WHERE
    job_title_short = 'Data Analyst'
GROUP BY location_category
ORDER BY no_of_jobs DESC;