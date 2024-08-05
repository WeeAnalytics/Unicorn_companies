-- create a table for Unicorn Companies
CREATE TABLE unicorn (
 
    company         	VARCHAR,
    valuation       	NUMERIC,
    date_joined	        TIMESTAMP,
    country         	VARCHAR,
    city    	        VARCHAR,
    industry    	    VARCHAR,
    founded_year    	NUMERIC,
    total_raised    	NUMERIC,
    financial_stage	    VARCHAR,
    investors_count 	NUMERIC,
    deal_terms      	NUMERIC,
    portfolio_exits 	NUMERIC

 );

 
-- checking table after dataload

SELECT *
FROM unicorn;

-- create a table for Unicorn Companies
CREATE TABLE investors (
 
    investors         	VARCHAR,
    company         	VARCHAR
 );

 
--checking table after dataload
SELECT *
FROM investors;