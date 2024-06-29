
-- SQL Data cleaning Project

-- Steps of Data cleaning
-- 1. Remove Duplicates
-- 2. standardize data
-- 3. Null values or blank values 
-- 4. Remove any columns



SELECT * 
FROM layoffs.layoffs;

create table layoffs_staging
like layoffs;

insert layoffs_staging
select *
from layoffs;


select *
from layoffs_staging;

-- 1. Remove Duplicates

select * ,
row_number() over(
Partition by company,location, industry, total_laid_off, percentage_laid_off, `Date`, stage, funds_raised_millions) as row_numb
from layoffs_staging;

with duplicates_CTE as 
(select * ,
row_number() over(
Partition by company,location, industry, total_laid_off, percentage_laid_off, `Date`, stage, funds_raised_millions) as row_numb
from layoffs_staging
)
select * 
from duplicates_CTE
where row_numb > 1;

select * 
from layoffs_staging
where company = 'Casper';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_numb` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * 
from layoffs_staging2;

Insert into layoffs_staging2
select * ,
row_number() over(
Partition by company,location, industry, total_laid_off, percentage_laid_off, `Date`, stage, funds_raised_millions) as row_numb
from layoffs_staging;

select * 
from layoffs_staging2
where row_numb > 1;


delete 
from layoffs_staging2
where row_numb = 2;

-- Standardaring data

-- checking Industry column
 
select company, TRIM(company)
from layoffs_staging2;

update layoffs_staging2
set company = TRIM(company);

select distinct industry
from layoffs_staging2;

select *
from layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

-- checking Location column 

select distinct location
from layoffs_staging2
order by 1;

select *
from layoffs_staging2
where location like 'DÃ¼sseldorf'
or location like 'FlorianÃ³polis'
or location like 'MalmÃ¶'; 

-- after checking location and country found that there is problem in the speling of location like  "DÃ¼sseldorf, FlorianÃ³polis , MalmÃ¶ " 
-- which should be "Düsseldorf, Florianópolis ,Malmö"

UPDATE layoffs_staging2
SET location = (CASE
    WHEN location LIKE 'DÃ¼sseldorf%' THEN 'Düsseldorf'
    WHEN location LIKE 'FlorianÃ³polis%' THEN 'Florianópolis'
    WHEN location LIKE 'MalmÃ¶%' THEN 'Malmö'
    ELSE location
END);

-- checking Country column 

select distinct country, trim( trailing '.' from country)
from layoffs_staging2
order by 1; 

update layoffs_staging2
set country = trim( trailing '.' from country)
where country like 'United States%';


select `date`, 
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2 ;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date; 

-- Dealing Null or blanks values 

select distinct *
from layoffs_staging2
where location is null
or Location = '';

select distinct *
from layoffs_staging2
where country is null
or country = '';

-- checking industry 

select *
from layoffs_staging2
where industry is null
or industry = '';

-- looks like we have 4 (Airbnb, Bally's Interactive, Carvana & Juul) company that have blank or null value in industry column.
-- lets search each one by one company

select distinct t1.company, t1.industry , t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '' )
and t2.industry is not null;

update layoffs_staging2
set industry = null
where industry = '';

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

-- checking total_laid_off & percentage_laid_off

select distinct *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null ; 

-- looks like there is a lot of null in both total_laid_off & percentage_laid_off. these are pretty useless and we cant do anything with this data. 
-- lets delete these wich have both null value in both total_laid_off & percentage_laid_off

delete 
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null ; 

-- 4. Remove any columns
-- checking if there is any unnessary column 

select distinct *
from layoffs_staging2;

-- looks like we dont need row_numb any more, so lets drop the column 

alter table layoffs_staging2
drop column row_numb;