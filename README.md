# SQL_Hospital

🏥 Healthcare Patient & Hospital Operations Analysis

![alt text](https://img.shields.io/badge/Database-SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server)


![alt text](https://img.shields.io/badge/Status-Complete-green?style=for-the-badge)


![alt text](https://img.shields.io/badge/Focus-ETL_%26_Cleaning-blue?style=for-the-badge)

📄 Project Overview

This project involves the Data Cleaning, Transformation, and Analysis of a comprehensive hospital database. The goal was to consolidate multi-year patient visit records, clean inconsistent demographic data, and derive actionable insights regarding hospital revenue, patient satisfaction, and operational efficiency.

The project simulates a real-world data engineering and analyst workflow: moving from raw, messy data 
→
→
 clean structures 
→
→
 business intelligence.

🧹 Data Cleaning & Transformation (ETL)

Before analysis, raw data required significant preprocessing. The following SQL techniques were applied:

1. Patient Data Standardization

Name Formatting: Converted FirstName and LastName to Title Case (e.g., "JOHN" 
→
→
 "John") and concatenated them into a full name.

Gender Normalization: Standardized values (e.g., 'M'/'F' 
→
→
 'Male'/'Female').

Address Parsing: Used the PARSENAME function to split a composite CityStateCountry string into distinct columns (City, State, Country).

Quality Control: Removed records with missing essential identification.

2. Department Restructuring

Schema Optimization: Refactored the table to use 'Specialization' as the primary Department Name.

Data Integrity: Filtered out null categories to ensure accurate reporting.

3. Data Consolidation (The Fact Table)

Unioning Data: Merged four separate tables representing different time periods (2020-2021, 2022-2023, 2024, 2025) into a single, unified PatientVisits table using UNION ALL.

📊 Database Schema

The final clean schema consists of a central fact table and supporting dimension tables:

PatientVisits (Fact Table): Contains transactional visit data, linked to all dimensions.

DIM_Patient_Clean: Normalized patient demographics.

DIM_Department_Clean: Hospital department categories.

Dim_Doctor: Physician details.

Dim_Diagnosis & Dim_Treatment: Clinical details.

Dim_PaymentMethod: Financial transaction types.

erDiagram
    Dim_Patient ||--o{ PatientVisits : "has"
    Dim_Doctor ||--o{ PatientVisits : "attends"
    Dim_Department ||--o{ PatientVisits : "handles"
    Dim_Diagnosis ||--o{ PatientVisits : "diagnosed_in"
    Dim_Treatment ||--o{ PatientVisits : "prescribed_in"
    Dim_PaymentMethod ||--o{ PatientVisits : "pays_via"

    Dim_Patient {
        varchar PatientID PK
        varchar FullName
        varchar Gender
        date DOB
        varchar City
        varchar State
        varchar Country
    }
    Dim_Department {
        varchar DepartmentID PK
        varchar DepartmentName
        varchar DepartmentCategory
    }
    PatientVisits {
        varchar VisitID PK
        varchar PatientID FK
        varchar DoctorID FK
        varchar DepartmentID FK
        varchar DiagnosisID FK
        varchar TreatmentID FK
        decimal BillAmount
        int SatisfactionScore
    }

🧠 Key SQL Concepts Demonstrated

String Manipulation: LEFT, SUBSTRING, UPPER, LOWER, LTRIM/RTRIM.

Advanced Parsing: PARSENAME for delimited string splitting.

Set Operations: UNION ALL to combine datasets.

Window Functions:

RANK() for ranking departments and treatments.

SUM() OVER (...) for running cumulative totals.

CTEs (Common Table Expressions): For readability and complex logic (e.g., Age Grouping).

Date Functions: DATEDIFF, DATENAME, DATEFROMPARTS.

🔎 Business Analysis (Key Insights)

The SQL scripts answer 10 critical business questions:

Doctor Workload: Count of distinct patients treated per doctor.

Financial Overview: Total revenue and visit volume split by payment method.

Demographics: Categorizing patients into age groups (0-17, 18-35, etc.) and analyzing average spend.

Department Performance: Revenue and volume metrics per department.

Performance Ranking: Ranking departments by revenue within their specific categories.

Quality of Care: Average satisfaction scores and wait times per department.

Operational Trends: Comparing traffic volume between Weekdays vs. Weekends.

Growth Metrics: Monthly visit counts with a running cumulative total.

Top Physicians: Identifying doctors with high satisfaction scores (>100 visits).

Clinical Trends: Identifying the most common treatment for every diagnosis.

💻 How to Use

Prerequisites: Microsoft SQL Server.

Setup:

Run the Data_Cleaning_Scripts.sql to create the clean tables and consolidate the visit data.

Analysis:

Run the queries in Data_Exploration.sql to generate insights.

Fill in your Name and Links at the bottom.

Upload your SQL file (you can put both the cleaning and the questions in one file, or split them into two files as suggested in the "File Structure" section).
