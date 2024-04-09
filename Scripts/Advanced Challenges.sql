SELECT a.firstName 'Employee First Name', a.lastName 'Employee Last Name', 
  b.firstName 'Manager First Name', b.lastName 'Manager Last Name'
FROM employee a
JOIN employee b
  ON a.managerId = b.employeeId;