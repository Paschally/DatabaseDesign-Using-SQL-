# DatabaseDesign-Using-SQL-
 Designing a Marketing Database for a Bank using MySQL

 This project involves creating a comprehensive database to store and manage customer information for a bank’s marketing campaigns. 
 The project utilizes SQL for importing, loading, and creating tables for the database.

Using my data cleaning and database design skills, I will also author a script that sets up tables in a MySQL database for bank marketing campaigns!
They have supplied you with a csv file called `”bank_marketing.csv”` 
and it is required that the new database will have three tables - 'client, campaign, banking'


CREATE DATABASE IF NOT EXISTS marketing;

USE marketing;

CREATE TABLE IF NOT EXISTS bank (
	client_id INT,                   -- id of client
 	age	 INT,                        -- age of client
    job	VARCHAR(45),               -- client's job
    marital VARCHAR(45),           -- clients marital status
	education VARCHAR(45),           -- client's level of education
	credit_default VARCHAR(45),      -- Is client in credit default
	housing VARCHAR(45),             -- Does client have an existing mortgage
	loan VARCHAR(45),                -- Does client have an existing loan
    contact VARCHAR(45),           -- Does client have telephone or mobile phone
    montth VARCHAR(45),
    dayy	INT,
    duration INT,                  -- Last contact duration in seconds
    campaign INT,                  -- number of contact attempts to the client in the current campaign
	pdays	INT,                       -- number of days  since contact in previous campaign 9999=not previously contacted)
    previous INT,                  -- number of contact attempts to the client in the previous campaign
	poutcome VARCHAR(45),            -- outcome of the previous campaign
    emp_var_rate DECIMAL(5,2),     -- employment variation rate
    cons_price_idx DECIMAL(8,4),   -- consumer price index
	cons_conf_idx DECIMAL(5,2),      -- consumer confidence index
	euribor3m DECIMAL(8,4),          -- euro interbank offered rate (three months indicator)
	nr_employed	INT,                 -- number of employees
    y VARCHAR(45)                  -- outcome of the current campaign
    );

CREATE VIEW banking_vw AS
	select *,
    CASE
        WHEN montth = 'jan' THEN '01'
        WHEN montth = 'feb' THEN '02'
        WHEN montth = 'mar' THEN '03'
        WHEN montth = 'apr' THEN '04'
        WHEN montth = 'may' THEN '05'
        WHEN montth = 'jun' THEN '06'
        WHEN montth = 'jul' THEN '07'
        WHEN montth = 'aug' THEN '08'
        WHEN montth = 'sep' THEN '09'
        WHEN montth = 'oct' THEN '10'
        WHEN montth = 'nov' THEN '11'
        WHEN montth = 'dec' THEN '12'
        ELSE montth  -- If not 'Jan', 'Feb', ..., 'Dec', return the original value
    END AS month_numeric
	from bank;

CREATE TABLE client (
	id INT PRIMARY KEY,
 	age	 INT,
    job	VARCHAR(45),
    marital_staus VARCHAR(45),
	education VARCHAR(45),
	credit_default VARCHAR(45),
	housing VARCHAR(45),
	loan VARCHAR(45)
    );

INSERT INTO client (id,age,job,marital_staus,education,credit_default,housing,loan)
	SELECT
    client_id,
    age,
    job,
    marital,
    education,
    credit_default,
    housing,
    loan
    FROM bank;

DROP TABLE campaign;
CREATE TABLE IF NOT EXISTS campaign (
	id SERIAL PRIMARY KEY,
    client_id INT,
    freq_of_contact INT,
    duration_of_contact  INT,
	num_days_since_previous_contact INT,
    freq_contact_previous_campaign INT,
	previous_campaign_outcome VARCHAR(45),
	current_campaign_outcome VARCHAR(45),
	last_contact_date VARCHAR(45),
    FOREIGN KEY  (client_id) REFERENCES client (id));

INSERT INTO campaign ( client_id, freq_of_contact, duration_of_contact, 
						num_days_since_previous_contact ,freq_contact_previous_campaign, 
                        previous_campaign_outcome, current_campaign_outcome, last_contact_date)
	SELECT
    client_id,
    campaign,
    duration,
	pdays,
    previous,
	poutcome, 
    y,
    CAST(CONCAT('2022','-',month_numeric,'-',dayy) AS DATE) last_contact_date
    FROM banking_vw;
    
CREATE TABLE IF NOT EXISTS banking (
    client_id INT,
    emp_var_rate DECIMAL(5,2),
    cons_price_idx DECIMAL(8,4),
	cons_conf_idx DECIMAL(5,2),
	eurobond_three_months DECIMAL(8,4),
	number_employed	INT,
    FOREIGN KEY  (client_id) REFERENCES client (id));

INSERT INTO banking (client_id, emp_var_rate, cons_price_idx, cons_conf_idx, eurobond_three_months, number_employed)
	SELECT
    client_id, 
    emp_var_rate, 
    cons_conf_idx,
    euribor3m, 
    nr_employed
    FROM bank;
