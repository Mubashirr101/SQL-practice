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

-- 4: CTEs
-- Identify the top 5 skills that are most frequently mentioned in job postings
-- find skill id with highest counts in skills_job_dim & join this result with skills_dim table to get the skill names

WITH top_skills AS (
    SELECT COUNT(job_id) AS topskills,skill_id
    FROM skills_job_dim
    GROUP BY skill_id 
    ORDER BY COUNT(job_id) DESC
)

SELECT skills_dim.skills, top_skills.topskills
FROM skills_dim
LEFT JOIN top_skills ON top_skills.skill_id = skills_dim.skill_id
ORDER BY top_skills.topskills DESC
LIMIT 5;

-- 5: Subquery
-- determin the size category (small,medium,large) for each company by first identifying the no. ofjobs postings they have.
-- use subquery to calculate the total job postings per comany
-- small if <10 postings, medium of postings between 10-50 & large if >50

SELECT * FROM job_postings_fact LIMIT 10;

SELECT 
    company_dim.name , 
    jobsaggset.total_jobs,
    CASE
        WHEN jobsaggset.total_jobs < 10 THEN 'Small'
        WHEN jobsaggset.total_jobs BETWEEN 10 AND 50 THEN 'Medium'
        WHEN jobsaggset.total_jobs > 50 THEN 'Large'
        ELSE 'INVALID'
    END AS size_category
FROM (
    SELECT COUNT(job_id) AS total_jobs, company_id
    FROM job_postings_fact
    GROUP BY company_id
    ORDER BY total_jobs DESC
) AS jobsaggset
LEFT JOIN company_dim ON company_dim.company_id = jobsaggset.company_id;


-- 6: Find the count of number of remote job postings for data analysts per skill
--display the top 5 skills by their demand in remote jobs
-- include skill id,name and count of postings requireing the skill

WITH remote_jobs_skils AS  (
    SELECT 
        COUNT(skills_job_dim.job_id) AS no_of_jobs, 
        skills_job_dim.skill_id
    FROM skills_job_dim
    INNER JOIN job_postings_fact ON job_postings_fact.job_id = skills_job_dim.job_id
    WHERE 
        job_postings_fact.job_work_from_home = True AND
        job_postings_fact.job_title_short = 'Data Analyst'
    GROUP BY skill_id
) 

SELECT 
    remote_jobs_skils.skill_id,
    skills_dim.skills,
    remote_jobs_skils.no_of_jobs
FROM remote_jobs_skils
INNER JOIN skills_dim ON skills_dim.skill_id = remote_jobs_skils.skill_id
ORDER BY remote_jobs_skils.no_of_jobs DESC
LIMIT 5;

-- 7: UNION and UNION ALL
-- get corresponding skill & skill type for each job posting in q1 (jab feb mar)
-- including those with and without any skills
-- looks at the skills and type for each job in q1, having salary ?70k

SELECT
    jan_job_skills.job_id,
    skills_dim.skills,
    skills_dim.type,
    jan_job_skills.salary_year_avg
FROM (
    SELECT
        skills_job_dim.skill_id,
        jan_jobs.job_id,
        jan_jobs.salary_year_avg
    FROM jan_jobs
    LEFT JOIN skills_job_dim ON skills_job_dim.job_id = jan_jobs.job_id
) AS jan_job_skills
LEFT JOIN skills_dim ON skills_dim.skill_id = jan_job_skills.skill_id
WHERE jan_job_skills.salary_year_avg > 70000


UNION ALL

SELECT
    feb_job_skills.job_id,
    skills_dim.skills,
    skills_dim.type,
    feb_job_skills.salary_year_avg
FROM (
    SELECT
        skills_job_dim.skill_id,
        feb_jobs.job_id,
        feb_jobs.salary_year_avg
    FROM feb_jobs
    LEFT JOIN skills_job_dim ON skills_job_dim.job_id = feb_jobs.job_id
) AS feb_job_skills
LEFT JOIN skills_dim ON skills_dim.skill_id = feb_job_skills.skill_id
WHERE feb_job_skills.salary_year_avg > 70000


UNION ALL

SELECT
    mar_job_skills.job_id,
    skills_dim.skills,
    skills_dim.type,
    mar_job_skills.salary_year_avg
FROM (
    SELECT
        skills_job_dim.skill_id,
        mar_jobs.job_id,
        mar_jobs.salary_year_avg
    FROM mar_jobs
    LEFT JOIN skills_job_dim ON skills_job_dim.job_id = mar_jobs.job_id
) AS mar_job_skills
LEFT JOIN skills_dim ON skills_dim.skill_id = mar_job_skills.skill_id
WHERE mar_job_skills.salary_year_avg > 70000
