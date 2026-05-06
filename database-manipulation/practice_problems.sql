-- 1 : query to find the avg sal both yearly and hourly for job postings that were posted after june 1,2023. 
-- Group the results by job schedule type

SELECT * FROM job_postings_fact LIMIT 100;

SELECT 
    job_schedule_type,
    AVG(salary_year_avg) AS yearly_Sal, 
    AVG(salary_hour_avg) AS hourly_Sal
FROM 
    job_postings_fact
WHERE 
    job_posted_date::DATE > '2023-06-01'::DATE
GROUP BY 
    job_schedule_type;

-- 2: query to count the number of job postings for each month in 2023, adjusting the date to be
-- in america/ny time zone before extracting the month, assume they are stored in utc
-- group and order by month

SELECT 
    COUNT(job_id) AS no_of_jobs,
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT') AS posting_month
FROM 
    job_postings_fact
GROUP BY
    posting_month
ORDER BY
    posting_month;

-- 3: CASE EXPRESSIONS
-- categorize the salaries from each job posting to see if it fit a desired sal range
-- put sal in diff buckets, define high low and mid sals as per own conditions
-- only data analyst roles, highest to lowest

SELECT avg(salary_year_avg) FROM job_postings_fact WHERE job_title_short = 'Data Analyst';

SELECT 
    COUNT(job_id) AS no_of_jobs,
    CASE
        WHEN salary_year_avg > '200000' THEN 'HIGH'
        WHEN salary_year_avg < '70000' THEN 'LOW'
        ELSE 'MID'
    END AS sal_bucket
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst'
GROUP BY sal_bucket
ORDER BY no_of_jobs DESC;