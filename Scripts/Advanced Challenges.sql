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
