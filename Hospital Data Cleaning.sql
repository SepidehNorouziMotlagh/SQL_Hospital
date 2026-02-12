-- Data Cleaning (Patient Table)
-- Remove patient rown where FisrtName is missing
-- Standaradize FirstName and LastName to proper case and creat a new FullName column
-- Gender values should be either Male or Female
-- Split CityStateCountry into City, State and Country columns

CREATE TABLE DIM_Patient_Clean (
PatientID varchar(20) PRIMARY KEY,
FullName varchar(100),
Gender varchar(10),
DOB date,
City varchar(50),
State varchar(50),
Country varchar(50) )

INSERT INTO DIM_Patient_Clean (
PatientID, FullName, Gender, DOB, City, State, Country)

SELECT p.PatientID,
UPPER(LEFT(LTRIM(RTRIM(p.FirstName)),1)) + LOWER(SUBSTRING(LTRIM(RTRIM(p.FirstName)), 2, LEN(LTRIM(RTRIM(p.FirstName))))) 
+ ' ' +
UPPER(LEFT(LTRIM(RTRIM(p.LastName)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(p.LastName)), 2, LEN(LTRIM(RTRIM(p.LastName)))))
AS FullName,
CASE 
WHEN p.Gender = 'M' THEN 'Male'
WHEN p.Gender = 'F' THEN 'Female'
ELSE p.Gender
END AS Gender,
p.DOB,
PARSENAME(REPLACE(p.CityStateCountry, ',', '.'), 1) AS Country,
PARSENAME(REPLACE(p.CityStateCountry, ',', '.'), 2) AS State,
PARSENAME(REPLACE(p.CityStateCountry, ',', '.'), 3) AS City
FROM Dim_Patient p
WHERE p.FirstName IS NOT NULL

-- Data Cleaning (Department Table)
-- Remove departments where DepartmentCategory is missing
-- Drop HOD and DepartmentName columns
-- Use Specialization as DepartmentName column

CREATE TABLE DIM_Department_Clean (
DepartmentID varchar(20) PRIMARY KEY,
DepartmentName varchar(100),
DepartmentCategory varchar(100) )

INSERT INTO DIM_Department_Clean (
DepartmentID, DepartmentName, DepartmentCategory)

SELECT d.DepartmentID, d.Specialization AS DepartmentName, d.DepartmentCategory
FROM Dim_Department d
WHERE d.DepartmentCategory IS NOT NULL

-- Data Cleaning (Patient Vsits Table)
-- Merge all yearly visits tables (2020 - 20205) into one consolidated PatientVisits table

CREATE TABLE PatientVisits (
VisitID varchar(20) PRIMARY KEY,
PatientID varchar(20) FOREIGN KEY REFERENCES DIM_Patient_Clean(PatientID),
DoctorID varchar(20) FOREIGN KEY REFERENCES DIM_Doctor(DoctorID),
DepartmentID varchar(20) FOREIGN KEY REFERENCES DIM_Department_Clean(DepartmentID),
DiagnosisID varchar(20) FOREIGN KEY REFERENCES DIM_Diagnosis(DiagnosisID),
TreatmentID varchar(20) FOREIGN KEY REFERENCES Dim_Treatment(TreatmentID),
PaymentMethodID varchar(20) FOREIGN KEY REFERENCES Dim_PaymentMethod(PaymentMethodID),
VisitDate DATE,
VisitTime TIME,
DischargeDate DATE,
BillAmount DECIMAL(18, 2),
InsuranceAmount DECIMAL(18,2),
SatisfactionScore INT,
WaitTimeMinutes INT )

INSERT INTO PatientVisits (VisitID, PatientID, DoctorID, DepartmentID,
DiagnosisID, TreatmentID, PaymentMethodID, VisitDate, VisitTime,
DischargeDate, BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes)

SELECT VisitID, PatientID, DoctorID, DepartmentID,
DiagnosisID, TreatmentID, PaymentMethodID, VisitDate, VisitTime,
DischargeDate, BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
FROM PatientVisits_2020_2021

UNION ALL

SELECT VisitID, PatientID, DoctorID, DepartmentID,
DiagnosisID, TreatmentID, PaymentMethodID, VisitDate, VisitTime,
DischargeDate, BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
FROM PatientVisits_2022_2023

UNION ALL

SELECT VisitID, PatientID, DoctorID, DepartmentID,
DiagnosisID, TreatmentID, PaymentMethodID, VisitDate, VisitTime,
DischargeDate, BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
FROM PatientVisits_2024

UNION ALL

SELECT VisitID, PatientID, DoctorID, DepartmentID,
DiagnosisID, TreatmentID, PaymentMethodID, VisitDate, VisitTime,
DischargeDate, BillAmount, InsuranceAmount, SatisfactionScore, WaitTimeMinutes
FROM PatientVisits_2025
