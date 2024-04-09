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