-- Exercise 1: Return Employees and List of Managers --
-- SELF JOIN --

SELECT a.firstName 'Employee First Name', a.lastName 'Employee Last Name', 
  b.firstName 'Manager First Name', b.lastName 'Manager Last Name'
FROM employee a
JOIN employee b
  ON a.managerId = b.employeeId;


-- Exercise 2: Find Salespersons with 0 Sales --
-- LEFT JOIN TO IDENTIFY NULLS --

SELECT e.firstName 'First Name', e.lastName 'Last Name' 
FROM employee e 
LEFT JOIN sales s
  ON e.employeeId = s.employeeId
WHERE e.title = 'Sales Person' 
  AND s.employeeId IS NULL;


-- Exercise 3: Generate a List of All Customers and Associated Sales
-- Even if Data is Missing
-- LEFT JOIN 

SELECT c.firstName 'Customer First Name', c.lastName 'Customer Last Name', s.salesAmount 'Sales Amount'
FROM sales s
FULL JOIN customer c
  ON s.customerId = c.customerId;

-- Exercise 4: Total Cars Sold Per Employee
-- LEFT JOIN, COUNT, GROUP BY

SELECT s.employeeId, e.firstName 'Employee First Name', e.lastName 'Employee Last Name', 
  COUNT(s.inventoryId) 'Total Cars Sold'
FROM sales s
INNER JOIN employee e
  ON s.employeeId = e.employeeId
GROUP BY 1
ORDER BY 4 DESC;


-- Exercise 5: Least and Most Expensive Car 
-- Sold Per Employee This Year
-- Note: Found max year in dataset first before hardcoding year

SELECT s.employeeId, e.firstName 'Employee First Name', e.lastName 'Employee Last Name', 
  MIN(s.salesAmount) 'Least Expensive Car', MAX(s.salesAmount) 'Most Expensive Car'
FROM sales s
LEFT JOIN employee e
  ON s.employeeId = e.employeeId
WHERE strftime('%Y', s.soldDate) >= '2023'
GROUP BY 1;


-- Exercise 6: Employees Who Have Sold More Than 5 Cars This Year
SELECT s.employeeId, e.firstName 'Employee First Name', e.lastName 'Employee Last Name', 
  COUNT(s.inventoryId) 'Total Cars Sold'
FROM sales s
INNER JOIN employee e
  ON s.employeeId = e.employeeId
WHERE strftime('%Y', s.soldDate) >= '2023' 
GROUP BY 1
HAVING COUNT(*) > 5
ORDER BY 4 DESC;


-- Exercise 7: Total Sales Per Year 
WITH cte AS 
  (SELECT strftime('%Y', soldDate) AS SoldYear, salesAmount
FROM sales
GROUP BY 1)

SELECT SoldYear 'Sold Year', salesAmount) 'Annual Sales'
FROM cte
GROUP BY 1
ORDER BY 1;


-- Exercise 8: Total Sales Per Month Per Employee in 2021

WITH cte AS 
(SELECT s.employeeId, e.firstName, e.lastName, s.salesAmount, 
strftime('%m', soldDate) MonthofSale, strftime('%Y', soldDate) YearofSale
FROM sales s
INNER JOIN employee e
  ON s.employeeId = e.employeeId
WHERE strftime('%Y', soldDate) = '2021')

SELECT employeeId, firstName, lastName,
SUM(CASE WHEN MonthofSale = '01' 
THEN salesAmount END) AS JanSales,
SUM(CASE WHEN MonthofSale = '02'
THEN salesAmount END) AS FebSales,
SUM(CASE WHEN MonthofSale = '03'
THEN salesAmount END) AS MarchSales,
SUM(CASE WHEN MonthofSale = '04' 
THEN salesAmount END) AS AprilSales,
SUM(CASE WHEN MonthofSale = '05' 
THEN salesAmount END) AS MaySales,
SUM(CASE WHEN MonthofSale = '06' 
THEN salesAmount END) AS JuneSales,
SUM(CASE WHEN MonthofSale = '07'
THEN salesAmount END) AS JulySales,
SUM(CASE WHEN MonthofSale = '08'
THEN salesAmount END) AS AugustSales,
SUM(CASE WHEN MonthofSale = '09'
THEN salesAmount END) AS SeptSales,
SUM(CASE WHEN MonthofSale = '10' 
THEN salesAmount END) AS OctSales,
SUM(CASE WHEN MonthofSale = '11' 
THEN salesAmount END) AS NovSales,
SUM(CASE WHEN MonthofSale = '12'
THEN salesAmount END) AS DecSales
FROM cte
GROUP BY 1
ORDER BY 3, 2;

-- Exercise 9: All Sales of Electric Cars Using a Subquery
-- SUBQUERY IN WHERE CLAUSE
SELECT s.inventoryId, i.modelId, i.colour 'Car Colour', s.salesAmount 'Sales Amount', s.soldDate 'Sold Date', COUNT(s.inventoryId) 'Number Of Cars Sold'
FROM sales s
INNER JOIN inventory i
  ON s.inventoryId = i.inventoryId
WHERE i.modelId IN 
  (SELECT m.modelId
  FROM model m
  WHERE EngineType = 'Electric')
GROUP BY s.inventoryId
ORDER BY COUNT(s.inventoryId) DESC;


-- Exercise 10: For each Sales Person, Rank Car Models Sold Most
-- WINDOW FUNCTION

SELECT e.employeeId, e.firstName, e.lastName, m.model, s.salesId,
  COUNT(model) NumberSold, 
  RANK() OVER (PARTITION BY s.employeeId 
              ORDER BY COUNT(model) DESC) Rank
FROM sales s
INNER JOIN employee e
  ON s.employeeId = e.employeeId
INNER JOIN inventory i
  ON i.inventoryId = s.inventoryId
INNER JOIN model m
  ON m.modelId = i.modelId
GROUP BY e.employeeId, m.model;


-- Exercise 11: Generate a Sales Report Showing Total Sales Per Month 
-- and Annual Running Total
-- WINDOW FUNCTION WITH SUM

SELECT strftime('%Y', soldDate) YearofSale, strftime('%m', soldDate) MonthofSale,
 ROUND(SUM(salesAmount), 1) TotalSales,
 SUM(SUM(salesAmount)) OVER (PARTITION BY strftime('%Y', soldDate)
              ORDER BY strftime('%Y', soldDate), strftime('%m', soldDate)) AnnualRunningTotal
FROM Sales
GROUP BY 2,1;


-- Exercise 12: Number of Cars Sold This Month and Last Month
-- WINDOW FUNCTION WITH LAG
-- ALSO DEFINING OWN PARAMETERS

SELECT strftime('%Y-%m', soldDate) AS MonthSold,
  COUNT(*) AS NumberCarsSold,
-- LAG function looks at preceding window as defined by calMonth
  LAG (COUNT(*), 1, 0 ) OVER calMonth AS LastMonthCarsSold
FROM sales
GROUP BY strftime('%Y-%m', soldDate)
WINDOW calMonth AS (ORDER BY strftime('%Y-%m', soldDate))
ORDER BY strftime('%Y-%m', soldDate);
