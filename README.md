# Data Cleaning Project

## Overview
This project focuses on cleaning a dataset related to world layoffs. The project follows a structured approach to ensure data quality and integrity. This README.md file provides a comprehensive guide on the steps followed in this SQL-based data cleaning project.

## Dataset
- **Source**: [Layoffs 2022](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- **Description**: The dataset contains information about layoffs across various companies and industries in 2022.
  
## Repository Contents
- `layoffs.csv`: The original, uncleaned dataset.
- `sql_data_cleaning-layoffs.sql`: SQL script containing all the steps to clean the data.
- `cleaning_report.pdf`: Detailed report documenting the data cleaning process, findings, and justifications.
- `README.md`: Project overview and instructions (this file).

## Steps of Data Cleaning
The data cleaning process includes the following key steps:

### 1. Remove Duplicates
- **Objective:** Identify and remove duplicate rows to ensure data uniqueness.
- **Process:**
  1. Check for duplicates using `ROW_NUMBER() OVER (PARTITION BY ...)`.
  2. Remove duplicate rows while keeping the first occurrence.

### 2. Standardize Data
- **Objective:** Ensure data consistency by correcting errors and standardizing formats.
- **Process:**
  1. Remove extra spaces and trailing periods.
  2. Correct spelling errors.
  3. Standardize naming conventions (e.g., "Crypto" vs. "Crypto Currency").
  4. Format date columns to a consistent date type.

### 3. Handle Null and Blank Values
- **Objective:** Address missing values to prevent inaccuracies during analysis.
- **Process:**
  1. Identify null and blank values in important columns.
  2. Populate null values where possible using available data.
  3. Decide on retaining or imputing remaining null values based on their relevance.

### 4. Remove Unnecessary Columns
- **Objective:** Eliminate columns that do not contribute to the analysis.
- **Process:**
  1. Identify columns that are not needed.
  2. Remove unnecessary columns to streamline the dataset.

## Additional Steps
To ensure a comprehensive data cleaning process, consider the following additional steps:
1. **Data Validation:** Perform validation checks to ensure the cleaned data meets expected criteria.
2. **Documentation:** Document all changes made to the dataset in a detailed report (`cleaning_report.pdf`).

## Usage
To run the data cleaning script:
1. Load the raw data into your database.
2. Execute the SQL script (`sql_data_cleaning-layoffs.sql`) to clean the data.
3. Review the final cleaned dataset and the detailed cleaning report for insights.

## Conclusion
This repository provides a structured approach to data cleaning using SQL. By following the outlined steps, the dataset is prepared for accurate and reliable analysis. If you have any questions or suggestions, please feel free to open an issue in the repository.

---

**Omar Akbar Sraban**  
[LinkedIn](https://linkedin.com/in/omarakbar1)  

Feel free to customize this README.md file to better fit your project and dataset. If you have any specific requirements or additional steps you'd like to include, please let me know!
