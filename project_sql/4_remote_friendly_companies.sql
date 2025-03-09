--Find the number of skills and unique skills required for remote Business Analyst and Data Analyst jobsSELECT
    name AS company_name,
    COUNT (DISTINCT job_postings_fact.job_id) AS job_count, --DISTINCT to remove duplicates from multiple skills
    COUNT (DISTINCT skill_id) AS required_unique_skills, --DISTINCT to count uniques skills duplicates from multiple skills
    ROUND (COUNT (DISTINCT skill_id) * 1.0/NULLIF (COUNT (DISTINCT job_postings_fact.job_id), 0),2) AS avg_unique_skills_per_job,
    COUNT (skill_id) AS required_skills,
    ROUND (COUNT (skill_id) * 1.0/NULLIF (COUNT (DISTINCT job_postings_fact.job_id), 0),2) AS avg_skills_per_job
FROM
    job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_location = 'Anywhere' AND
        (job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%')
GROUP BY company_name
ORDER BY job_count DESC
LIMIT 10;

--average salary for the top 25 companies by num of posts is NULL
