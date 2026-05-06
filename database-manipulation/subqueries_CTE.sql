-- subquery syntax example (creating a temp january jobs table)

SELECT *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

-- CTEs (Common Expresssion Tables), used to make a temporary result set , ready to reference from

WITH janny_jobs AS (
    SELECT *
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)

SELECT * FROM janny_jobs;

--Using subqueries to show list of companies offering jobs without asking for any degree

SELECT 
    company_id,
    job_no_degree_mention
FROM 
    job_postings_fact
WHERE
    job_no_degree_mention = true;

-- now also get the company name which are in the nodegreeneeded category, thiss needs subquery
SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT 
        company_id
    FROM 
        job_postings_fact
    WHERE
        job_no_degree_mention = true
);

-- Using CTE find the companies that have the most job openings, get total no. of openeings per company_id and with company name


WITH company_job_count AS (
    SELECT company_id,COUNT(*) AS no_of_openings FROM job_postings_fact GROUP BY company_id
)

SELECT company_dim.name AS company_name, company_job_count.no_of_openings
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY no_of_openings DESC;

