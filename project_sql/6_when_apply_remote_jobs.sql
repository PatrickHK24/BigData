--- Find when jobs where posted on top remote job platfor

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

