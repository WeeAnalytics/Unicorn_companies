-- Create a materialized view to see the rank of companies by their valuation and their rank within each sector
CREATE MATERIALIZED VIEW
ranking AS (
SELECT *,
      RANK() OVER (ORDER BY valuation DESC) AS valuation_rank,
      RANK() OVER (PARTITION BY industry ORDER BY valuation DESC) AS valuation_rank_within_industry
FROM unicorn

)

-- Which are the top 10 companies in terms of valuation
SELECT company,valuation
FROM ranking
ORDER BY valuation DESC
LIMIT 10;


-- Find out 
--1. what industries are the top 100 companies in
--2. how many companies are there in each sector 
--3. What is the ave number of years to become a unicorn
SELECT industry,
       COUNT(*) AS number_of_companies,
       ROUND(AVG(EXTRACT(YEAR FROM TO_DATE(date_joined,'MM/DD/YYYY')) - founded_year),2) AS ave_years_to_unicorn
FROM ranking
WHERE valuation_rank < 101
GROUP BY industry
ORDER BY number_of_companies DESC;

-- research and update the founded_year for companies
UPDATE unicorn
SET founded_year = CASE 
    WHEN company = 'Weilong' THEN 1999
    WHEN company = 'Hopin' THEN 2019
    WHEN company = 'Ola Cabs' THEN 2010
    WHEN company = 'Argo AI' THEN 2016
    ELSE founded_year
    END;


--removing any spaces before and after investor_name

UPDATE investors
SET investor_name = TRIM(investor_name)

-- Which investor has the highest total valuation?
SELECT investor_name,
       SUM(valuation) AS total_valuation
FROM ranking
LEFT JOIN investors
ON ranking.company = investors.company
GROUP BY investor_name
ORDER BY total_valuation DESC
LIMIT 10;

--which investor invest in the highest number of unicorn
SELECT 
      investor_name,
       COUNT(DISTINCT ranking.company) AS number_of_companies
FROM investors
LEFT JOIN ranking
ON investors.company = ranking.company
GROUP BY investor_name
ORDER BY number_of_companies DESC
LIMIT 10;

--create a view on valuation_rank
CREATE INDEX
valuation_rank_idx ON ranking(valuation_rank);

--showing the how fast the query is after index is used
EXPLAIN 
SELECT industry,
       COUNT(*) AS number_of_companies,
       ROUND(AVG(EXTRACT(YEAR FROM TO_DATE(date_joined,'MM/DD/YYYY')) - founded_year),2) AS ave_years_to_unicorn
FROM ranking
WHERE valuation_rank < 101
GROUP BY industry
ORDER BY number_of_companies DESC;


