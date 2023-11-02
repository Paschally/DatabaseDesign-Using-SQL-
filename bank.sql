CREATE DATABASE IF NOT EXISTS marketing;

USE marketing;

CREATE TABLE IF NOT EXISTS bank (
	client_id INT,
 	age	 INT,
    job	VARCHAR(45),
    marital VARCHAR(45),
	education VARCHAR(45),
	credit_default VARCHAR(45),
	housing VARCHAR(45),
	loan VARCHAR(45),
    contact VARCHAR(45),
    montth VARCHAR(45),
    dayy	INT,
    duration INT,
    campaign INT,
	pdays	INT,
    previous INT,
	poutcome VARCHAR(45), 
    emp_var_rate DECIMAL(5,2),
    cons_price_idx DECIMAL(8,4),
	cons_conf_idx DECIMAL(5,2),
	euribor3m DECIMAL(8,4),
	nr_employed	INT,
    y VARCHAR(45)
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