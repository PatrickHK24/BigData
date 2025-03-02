# Introduction
Would would it take to work as a Business/Data Analyst, completely remotely and what would be the reward? To answer this question I dived into job market data and discovered high in-demands skills, top-paying jobs and remote friendly companies.

All SQL queries are here: [project_sql folder](/project_sql/)

# Background

### The Questions I wanted to answer thtough my SQL queries were:

- 1. What is the difference between in office salary vs remote salary for remote data analyst jobs?
- 2. What are the most in-demand skills for remote Business/Data analysts?
- 3. What are the top paying remote junior analyst jobs?
- 6. When to apply for remote analyst jobs?
- 5. Where to apply for remote analyst jobs?

# The analysis

### 2. What are the most in demand skills for remote Business/Data Analysts?

![Top skills](./assets/2_Top_skills.png)
*Bar graph represents in how many remote Business/Data analyst jobs the above skills were mentioned; generated with Excel from SQL result*


### Query used
```sql
WITH skill_table AS (
  SELECT
    job_id,
    skills_job_dim.skill_id,
    skills AS skill_name
  FROM
    skills_job_dim
    LEFT JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
)
SELECT
    skill_name,
    COUNT (job_postings_fact.job_id) AS job_count
FROM
    job_postings_fact
    LEFT JOIN skill_table ON skill_table.job_id = job_postings_fact.job_id
WHERE
    job_location = 'Anywhere'
    AND (job_title_short ILIKE '%data_analyst%'
    OR job_title_short ILIKE '%business_analyst%')
GROUP BY
    skill_name
ORDER BY
    job_count DESC
LIMIT 6;
```

### 5. Where to apply for remote analyst jobs?
In order to maximize the chances of finding a remote analyst jobs, I decided to rank every job platform available in the database by the number of analyst remote jobs published.

#### *Top 6 Job Platforms for Remote Data Analyst & Business Analyst Roles (2023)*

| Job Platform       | Job Published Count |
|--------------------|---------------------|
| LinkedIn           | 9689                |
| Indeed             | 1791                |
| ZipRecruiter       | 1153                |
| Recruit.net        | 597                 |
| Jobgether          | 540                 |
| Snagajob           | 374                 |

### Query used
```sql
SELECT
    job_via AS job_platform,
    COUNT(job_id) AS job_published_count
FROM
    job_postings_fact
WHERE
    job_location = 'Anywhere' AND
        (job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%')
GROUP BY
    job_platform
ORDER BY
    job_published_count DESC
LIMIT 6;
```

**Note: The following analysis are based on the the output of the query displayed above.**

Once I narrowed down the platforms with the most remote analyst jobs, I decided to classify them based on the average salary.

Although LinkedIn and Jobgether have the highest yearly average salary, the sample upon which this average is based is very low.
- Average salary was only mentioned in 1.6% (154) of job postings on LinkedIn, respectively in 1.9% (10) on Jobgether.

***Therefore, yearly average salary should not be used as a metric of comparison.***

![Salary info](./assets/6_Average_salary_info.png)

*Bar graph represents the average of yearly salary for the remote Business/Data analyst jobs in the listed job platforms, while the line graph represents how often salary information was available in the job description; generated with Excel from SQL result*

### Query used
```sql
SELECT
    SELECT
    job_via AS job_platform,
    COUNT(job_id) AS job_published_count,
    ROUND(AVG(salary_year_avg),0) AS average_salary,
    SUM(CASE WHEN salary_year_avg IS NOT NULL THEN 1 ELSE 0 END) AS jobs_with_salary, -- Count the number of jobs with info
    SUM(CASE WHEN salary_year_avg IS NULL THEN 1 ELSE 0 END) AS jobs_without_salary, -- Count the number of jobs without info
    ROUND((SUM(CASE WHEN salary_year_avg IS NOT NULL THEN 1 ELSE 0 END)*100.0/COUNT(job_id)),1) AS salary_info_ratio -- calculate the ratio of jobs with salary info as a percentage
FROM
    job_postings_fact
WHERE
    job_location = 'Anywhere'
    AND (job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%')
GROUP BY
    job_platform
ORDER BY
    job_published_count DESC
LIMIT 6;
```
Location salary

As salary is not a clear indication, I decided turn my attention to another indicator of job remuneration quality, namely the provvision of job health insurance.
- Snagajob is the platform with the highest relative percentage of health insurance mention as part of the compensation package; with 1 out of 2 job descriptions mentioning health insurance.
- LinkedIn is the platform with the overall highest number of vacancies that remunerate employees with health insurance.
- ZipRecruiter is second both in terms of relative and overall health insurance mentioning. 

![Salary info](./assets/6_Health_insurance_mention.png)
*Bar graph represents how frequenctly health insurance was mentioned in job descriptions of remote Business/Data analyst roles in the listed job platforms. Whole numbers inside the bars are the number of job posted that mention health insurance; generated with Excel from SQL result*

### Query used
```sql
SELECT
    job_via AS job_platform,
    COUNT(job_id) AS job_published_count,
    SUM (CASE WHEN job_health_insurance IS TRUE THEN 1 ELSE 0 END) AS jobs_with_health_insurance,-- Count the number of jobs with health insurance
    SUM (CASE WHEN job_health_insurance IS FALSE THEN 1 ELSE 0 END) AS jobs_without_health_insurance-- Count the number of jobs without health insurance
FROM
    job_postings_fact
WHERE
    job_location = 'Anywhere'
    AND (job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%')
GROUP BY
    job_platform
ORDER BY
    job_published_count DESC
LIMIT 6;
```
### When to apply for remote analyst jobs?
Based on the platforms with the highest number of remote Businss/Data analyst vacancies posted in 2023, the next question is to answer is when are most positions published.

***Most vacancies were posted between October and January on LinkedIn, with summer being the "slowest" period.***
![LinkedIn month posting](./assets/5_LinkedIn_month.png)
*Line graph represents when were remote Business/Data Analyst vacancies listed in 2023 on LinkedIn; generated with Excel from SQL result*


***ZipRecruiter and Indeed both show a peak in vacancies posting in January, with June representing a second peak for Indeed solely. The end of 2023 was the "slowest" period.***
![LinkedIn month posting](./assets/5_Indeed_ZipRecruiter_month.png)
*Line graph represents when were remote Business/Data Analyst vacancies listed in 2023 on Indeed and ZipRecruiter; generated with Excel from SQL result*

### Query used
```sql
SELECT
    job_via AS job_platform,
    TO_CHAR(job_posted_date, 'FMMonth') AS job_posted_month,
    COUNT(*) AS job_count
FROM
    job_postings_fact
WHERE
    job_via IN ('via Indeed', 'via LinkedIn', 'via ZipRecruiter') AND
    job_location = 'Anywhere' AND
                    (job_title_short ILIKE '%data_analyst%' OR job_title_short ILIKE '%business_analyst%')
GROUP BY job_platform, job_posted_month
```

# The tools I used

- **SQL:** Querying the database and extracting critical insights.
- **PostgreSQL:** Database management system
- **Visual Studio Code:** Managing database and executing SQL queries.
- **Excel:** Charting and SQL query results visualisation
- **Git & GitHub:** Sharing my SQL scripts and analysis.

# What I learned
This was my frist SQL project. Completing it allow to acquire solid skills to navigate ahad

# Conclusions
