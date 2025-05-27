/*
-----------------TOPIC: CASE STATMENTS-----------------
*/

SELECT FirstName, LastName, Age,
CASE
	WHEN AGE > 30 THEN 'Old'
	WHEN Age BETWEEN 27 AND 30 THEN 'Young'
	ELSE 'Baby'
END
FROM SQL_Tutorial.dbo.EmployeeDemographics
WHERE Age is NOT NULL
ORDER BY Age

SELECT FirstName,LastName,JobTitle,Salary,
CASE
	WHEN JobTitle = 'Salesman' THEN Salary + (Salary*.10)
	WHEN JobTitle = 'Accountant' THEN Salary + (Salary*.05)
	WHEN JobTitle = 'HR' THEN Salary + (Salary*.000001)
	ELSE Salary + (Salary*.03)
END AS Raise
FROM SQL_Tutorial.dbo.EmployeeDemographics
JOIN SQL_Tutorial.dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

/*
-----------------TOPIC: HAVING-----------------
*/

SELECT JobTitle, AVG(Salary)
FROM SQL_Tutorial.dbo.EmployeeDemographics
JOIN SQL_Tutorial.dbo.EmployeeSalary
	ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle	
HAVING AVG(Salary) > 45000
ORDER BY AVG(SALARY)

/*
-----------------TOPIC: UPDATING/DELETING DATA-----------------
*/

SELECT *
FROM SQL_Tutorial.dbo.EmployeeDemographics

UPDATE SQL_Tutorial.dbo.EmployeeDemographics
SET Age = 31, Gender = 'Female'
WHERE FirstName = 'Holly' AND LastName = 'Flax'

DELETE FROM SQL_Tutorial.dbo.EmployeeDemographics
WHERE EmployeeID = 1005

/*
-----------------TOPIC: ALIASING-----------------
*/

SELECT FirstName + ' '+ LastName AS FullName
FROM [SQL_Tutorial].[dbo].[EmployeeDemographics]

SELECT AVG(Age) AS AvgAge
FROM [SQL_Tutorial].[dbo].[EmployeeDemographics]

SELECT Demo.EmployeeID
FROM [SQL_Tutorial].[dbo].[EmployeeDemographics] AS Demo
JOIN [SQL_Tutorial].[dbo].[EmployeeSalary] AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID

SELECT Demo.EmployeeID, Demo.FirstName, Demo.LastName, Sal.JobTitle, Ware.Age
FROM [SQL_Tutorial].[dbo].[EmployeeDemographics] Demo
LEFT JOIN [SQL_Tutorial].[dbo].[EmployeeSalary]  Sal
	ON Demo.EmployeeID = Sal.EmployeeID
LEFT JOIN [SQL_Tutorial].[dbo].[WareHouseEmployeeDemographics]  Ware
	ON Demo.EmployeeID = Ware.EmployeeID

/*
-----------------TOPIC: PARTITION BY-----------------
*/

SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender
FROM SQL_Tutorial..EmployeeDemographics dem
JOIN SQL_Tutorial..EmployeeSalary sal
	ON dem.EmployeeID = sal.EmployeeID


SELECT Gender,  COUNT(Gender)
FROM SQL_Tutorial..EmployeeDemographics dem
JOIN SQL_Tutorial..EmployeeSalary sal
	ON dem.EmployeeID = sal.EmployeeID
GROUP BY Gender

/*
-----------------TOPIC: CTEs-----------------
*/

WITH CTE_Employee as 
(SELECT FirstName, LastName, Gender, Salary
,COUNT(Gender) OVER (PARTITION BY Gender) AS TotalGender
,COUNT(Salary) OVER (PARTITION BY Gender) AS AvgSalary
FROM SQL_Tutorial..EmployeeDemographics emp
JOIN SQL_Tutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
WHERE Salary > '45000'
)
SELECT FirstName, Salary
FROM CTE_Employee

/*
-----------------TOPIC: TEMP TABLES-----------------
*/

CREATE TABLE #temp_Employee (
EmployeeID int,
JobTitle varchar(100),
Salary int
)

Select *
FROM #temp_Employee

INSERT INTO #temp_Employee VALUES(
'1001','HR','45000'
)

INSERT INTO #temp_Employee
SELECT *
FROM SQL_Tutorial..EmployeeSalary

DROP TABLE IF EXISTS #temp_Employee2
CREATE TABLE #Temp_Employee2 (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int)

INSERT INTO #Temp_Employee2
SELECT JobTitle, COUNT(JobTitle), COUNT(Age), COUNT(Salary)
FROM SQL_Tutorial..EmployeeDemographics emp
JOIN SQL_Tutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #temp_Employee2

/*
-----------------TOPIC: STRING FUNCTIONS-----------------
*/

CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM
SELECT EmployeeID, TRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) as IDLTRIM
FROM EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) as IDRTRIM
FROM EmployeeErrors

-- Using Replace 
SELECT LastName, REPLACE(LastName, '- Fired','') as LastNameFixed
FROM EmployeeErrors

-- Using Substring
SELECT  SUBSTRING(err.FirstName,1,3), SUBSTRING(dem.FirstName,1,3)
FROM EmployeeErrors err
JOIN EmployeeDemographics dem
	ON SUBSTRING(err.FirstName,1,3) = SUBSTRING(dem.FirstName,1,3)
--Gender, LastName, Age, DOB

-- Using UPPER and lower
SELECT FirstName, LOWER(FirstName) as Fixedlo
FROM EmployeeErrors

SELECT FirstName, UPPER(FirstName) as FixedUP
FROM EmployeeErrors

/*
-----------------TOPIC: STORED PROCEDURES-----------------
*/

CREATE PROCEDURE TEST 
AS
SELECT *
FROM EmployeeDemographics

EXEC TEST


CREATE PROCEDURE Temp_Employee
AS
CREATE TABLE #temp_employee (
JobTitle varchar(100),
EmployeesPerJob INT,
AvgAge INT,
AvgSalary INT)

INSERT INTO #temp_employee
SELECT JobTitle, COUNT(JobTitle), AVG(Age), AVG(Salary)
FROM SQL_Tutorial..EmployeeDemographics emp
JOIN SQL_Tutorial..EmployeeSalary sal
	ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTitle

SELECT * FROM #temp_employee

/*
-----------------TOPIC: SUBQUERIES-----------------
*/

-- Subquery in Select

SELECT EmployeeID, Salary, (SELECT AVG(Salary) FROM EmployeeSalary) as AllAvg
FROM EmployeeSalary


-- Subquery in Partition

SELECT EmployeeID, Salary,  AVG(Salary) over() as AllAvg
FROM EmployeeSalary

-- Subquery in From

SELECT a.EmployeeID, AllAvg
FROM (SELECT EmployeeID, Salary,  AVG(Salary) over() as AllAvg
	  FROM EmployeeSalary) a

-- Subquery in Where

SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary
WHERE EmployeeID in (
		SELECT EmployeeID
		FROM EmployeeDemographics
		WHERE Age > 30 )

