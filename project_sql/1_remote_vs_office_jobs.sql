---Find average salary for remote and non-remote Business/Data Analyst jobs
SELECT
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Non-Remote'
    END AS location,
    COUNT(job_id) AS job_published_count,
    ROUND(AVG(salary_year_avg),0) AS average_salary,
    MAX (salary_year_avg) AS max_salary,
    MIN (salary_year_avg) AS min_salary,
    SUM(CASE WHEN salary_year_avg IS NOT NULL THEN 1 ELSE 0 END) AS jobs_with_salary, -- Count the number of jobs with info
    SUM(CASE WHEN salary_year_avg IS NULL THEN 1 ELSE 0 END) AS jobs_without_salary, -- Count the number of jobs without info
    ROUND((SUM(CASE WHEN salary_year_avg IS NOT NULL THEN 1 ELSE 0 END)*100.0/COUNT(job_id)),1) AS salary_info_ratio -- calculate the ratio of jobs with salary info as a percentage
FROM
    job_postings_fact
WHERE
    job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%'
GROUP BY
    location;


---Find average skills required for remote and non-remote Business/Data Analyst jobs
SELECT
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Non-Remote'
    END AS location,
    COUNT (DISTINCT job_postings_fact.job_id) AS job_count, --DISTINCT to remove duplicates from multiple skills
    COUNT (skill_id) AS required_skills,
    ROUND (COUNT (skill_id) * 1.0/NULLIF (COUNT (DISTINCT job_postings_fact.job_id), 0),2) AS avg_skills_per_job
FROM
    job_postings_fact
    LEFT JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%'
GROUP BY
    location;


---Find contract types for remote and non-remote Business/Data Analyst jobs
SELECT
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Non-Remote'
    END AS location,
    COUNT (job_id) AS job_count,
    COUNT (CASE WHEN job_schedule_type ILIKE '%full%time' THEN job_id END) AS full_time_count,
    COUNT (CASE WHEN job_schedule_type IS NULL THEN job_id END) AS unknown_count,
    COUNT (CASE WHEN job_schedule_type IS NOT NULL AND job_schedule_type NOT ILIKE '%full%time' THEN job_id END) AS not_full_time_count,
    COUNT (CASE WHEN job_schedule_type ILIKE '%full%time' THEN job_id END)/NULLIF(COUNT (CASE WHEN job_schedule_type IS NOT NULL AND job_schedule_type NOT ILIKE '%full%time' THEN job_id END), 0) AS full_time_non_full_time_ratio
FROM
    job_postings_fact
WHERE
    job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%'
GROUP BY
    location;


---Find average required degrees for remote and non-remote Business/Data Analyst jobs
SELECT
    CASE
        WHEN job_location = 'Anywhere' THEN 'Remote'
        ELSE 'Non-Remote'
    END AS location,
    ROUND(COUNT(CASE WHEN job_no_degree_mention IS FALSE THEN job_id END) * 1.0 / COUNT(job_id), 2) AS degree_ratio
FROM
    job_postings_fact
WHERE
    job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%'
GROUP BY
    location;



-- NOT PART OF README
-- Find the where most remote Business Analyst and Data Analyst are posted
SELECT
    search_location AS location,
    COUNT(job_id) AS job_published_count
FROM
    job_postings_fact
WHERE
    job_location = 'Anywhere'
    AND (job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%')
GROUP BY
    search_location
ORDER BY
    job_published_count DESC
