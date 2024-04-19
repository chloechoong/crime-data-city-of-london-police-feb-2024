SELECT * FROM crime;

-- Drop the irrelvant columns in the crime table
ALTER TABLE crime
DROP COLUMN `Month`,
DROP COLUMN `Reported by`,
DROP COLUMN `Falls within`,
DROP COLUMN `Context`;

SELECT COUNT(*) FROM crime; -- 764 reports made

SELECT DISTINCT(`Last outcome category`), COUNT(`Last outcome category`) AS Count
FROM crime
GROUP BY `Last outcome category`
ORDER BY Count DESC; -- 575 under investigation, 31 without any information added

-- Now looking at the outcome table
SELECT * FROM outcome;

-- Drop the irrelvant columns in the outcome table
ALTER TABLE outcome
DROP COLUMN `Month`,
DROP COLUMN `Reported by`,
DROP COLUMN `Falls within`;

SELECT COUNT(*) FROM outcome; -- 562 reports with outcomes

SELECT DISTINCT(`Outcome type`), COUNT(`Outcome type`) AS Count
FROM outcome 
GROUP BY `Outcome type`
ORDER BY Count DESC; -- 575 under investigation, 31 without any information added

-- Joining tables to link crime reports that require follow-ups
SELECT * FROM crime
LEFT JOIN outcome ON crime.`Crime ID` = outcome.`Crime ID`
WHERE `Last outcome category` = 'Under Investigation' 
OR `Last outcome category` = 'Awaiting court outcome'; -- Many nulls as Outcome type which doesnt give much info

-- create a new table that holds both crime and outcome information for further investigation
CREATE TABLE crime_and_outcome AS
SELECT 
crime.`Crime ID`,
crime.`Location`,
crime.`Longitude`,
crime.`Latitude`,
crime.`LSOA name`,
crime.`Crime type`,
crime.`Last outcome category`,
outcome.`Outcome type`
FROM crime
LEFT JOIN outcome ON crime.`Crime ID` = outcome.`Crime ID`
WHERE outcome.`Outcome type` IS NOT NULL;

-- output the new table
SELECT * 
FROM crime_and_outcome; -- 162 valid and full reports

-- Understanding which crimes are most prominent in Feb
SELECT DISTINCT(`Crime type`), COUNT(`Crime type`) AS Count
FROM crime_and_outcome
GROUP BY `Crime type`
ORDER BY Count DESC; -- Other Theft 

-- Understanding which locations have the highest crimes reported in Feb
SELECT DISTINCT(Location), COUNT(Location) AS Count
FROM crime_and_outcome
GROUP BY Location
ORDER BY Count DESC; -- On or near Bishopgate

-- Understanding which LSOA name have the highest crimes reported in Feb
SELECT DISTINCT(`LSOA name`), COUNT(`LSOA name`) AS Count
FROM crime_and_outcome
GROUP BY `LSOA name`
ORDER BY Count DESC; -- City of London 001F

-- Check which Location in City of London 001F should be deemed a possible hotspot
SELECT `Location`, COUNT(`Location`) AS Count
FROM crime_and_outcome
WHERE `LSOA name` = 'City of London 001F'
GROUP BY `Location`
ORDER BY Count DESC;

-- Count for crimes commited in both City of London 001F and On or near Bishopgate
SELECT `Crime type`, COUNT(`Crime type`) AS Count
FROM crime_and_outcome
WHERE Location = 'On or near Bishopsgate' AND `LSOA name` = 'City of London 001F'
GROUP BY `Crime type`
ORDER BY Count DESC; -- 8 counts of crime here - with most being of a form of theft 


