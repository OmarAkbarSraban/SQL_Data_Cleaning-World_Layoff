-- SQL Data Cleaning Project

-- Steps of Data Cleaning
-- 1. Remove Duplicates
-- 2. Standardize Data
-- 3. Handle Null Values or Blank Values
-- 4. Remove Unnecessary Columns

-- Select all records from layoffs table
SELECT * 
FROM layoffs.layoffs;

-- Create a staging table with the same structure as the layoffs table
CREATE TABLE layoffs_staging
LIKE layoffs;

-- Insert all records into the staging table
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

-- Select all records from the staging table
SELECT *
FROM layoffs_staging;

-- 1. Remove Duplicates

-- Generate row numbers for duplicate identification
SELECT * ,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `Date`, stage, funds_raised_millions
) AS row_numb
FROM layoffs_staging;

-- Common Table Expression (CTE) to identify duplicates
WITH duplicates_CTE AS 
(
    SELECT * ,
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `Date`, stage, funds_raised_millions
    ) AS row_numb
    FROM layoffs_staging
)
SELECT * 
FROM duplicates_CTE
WHERE row_numb > 1;

-- Check for specific duplicates
SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';

-- Create a new staging table with an additional row_numb column
CREATE TABLE layoffs_staging2 (
  company TEXT,
  location TEXT,
  industry TEXT,
  total_laid_off INT DEFAULT NULL,
  percentage_laid_off TEXT,
  date TEXT,
  stage TEXT,
  country TEXT,
  funds_raised_millions INT DEFAULT NULL,
  row_numb INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Select all records from the new staging table
SELECT * 
FROM layoffs_staging2;

-- Insert records with row numbers into the new staging table
INSERT INTO layoffs_staging2
SELECT * ,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `Date`, stage, funds_raised_millions
) AS row_numb
FROM layoffs_staging;

-- Select duplicates from the new staging table
SELECT * 
FROM layoffs_staging2
WHERE row_numb > 1;

-- Delete duplicates from the new staging table
DELETE 
FROM layoffs_staging2
WHERE row_numb = 2;

-- 2. Standardizing Data

-- Check and trim whitespace from the company column
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Check distinct values in the industry column
SELECT DISTINCT industry
FROM layoffs_staging2;

-- Standardize industry names
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Check distinct values in the location column
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- Identify and correct location spelling errors
SELECT *
FROM layoffs_staging2
WHERE location LIKE 'DÃ¼sseldorf'
OR location LIKE 'FlorianÃ³polis'
OR location LIKE 'MalmÃ¶';

-- Update incorrect location names
UPDATE layoffs_staging2
SET location = CASE
    WHEN location LIKE 'DÃ¼sseldorf%' THEN 'Düsseldorf'
    WHEN location LIKE 'FlorianÃ³polis%' THEN 'Florianópolis'
    WHEN location LIKE 'MalmÃ¶%' THEN 'Malmö'
    ELSE location
END;

-- Check distinct values in the country column
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Convert date strings to date format
SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. Handling Null or Blank Values

-- Check for null or blank values in the location column
SELECT DISTINCT *
FROM layoffs_staging2
WHERE location IS NULL
OR location = '';

-- Check for null or blank values in the country column
SELECT DISTINCT *
FROM layoffs_staging2
WHERE country IS NULL
OR country = '';

-- Check for null or blank values in the industry column
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Update blank values in the industry column to NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Populate industry values where missing based on other records
SELECT DISTINCT t1.company, t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '' )
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- Check for null values in total_laid_off and percentage_laid_off columns
SELECT DISTINCT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete records with null values in both total_laid_off and percentage_laid_off columns
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4. Removing Unnecessary Columns

-- Check the final structure of the table
SELECT DISTINCT *
FROM layoffs_staging2;

-- Drop the row_numb column as it is no longer needed
ALTER TABLE layoffs_staging2
DROP COLUMN row_numb;
