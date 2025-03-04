CREATE DATABASE EmployeeManagement;
USE EmployeeManagement;

CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE positions (
    position_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    department_id INT,
    position_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (position_id) REFERENCES positions(position_id)
);

CREATE TABLE salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    amount DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO departments (name) VALUES 
('IT'), 
('HR'), 
('Finance'), 
('Marketing');

INSERT INTO positions (title) VALUES 
('Software Developer'), 
('HR Manager'), 
('Accountant'), 
('Marketing Specialist');

INSERT INTO employees (first_name, last_name, hire_date, department_id, position_id) VALUES
('John', 'Doe', '2022-05-10', 1, 1),
('Alice', 'Smith', '2021-03-15', 2, 2),
('Bob', 'Johnson', '2023-07-20', 3, 3),
('Emma', 'Brown', '2020-01-25', 4, 4);

INSERT INTO salaries (employee_id, amount, start_date, end_date) VALUES
(1, 5000, '2022-05-10', NULL),
(2, 4500, '2021-03-15', NULL),
(3, 4000, '2023-07-20', NULL),
(4, 4800, '2020-01-25', NULL);

#list of the employees with informations about position and department
SELECT e.employee_id, e.first_name, e.last_name, d.name AS department, p.title AS position
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN positions p ON e.position_id = p.position_id;

#the average salary by departments
SELECT d.name AS department, AVG(s.amount) AS average_salary
FROM salaries s
JOIN employees e ON s.employee_id = e.employee_id
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.name;

#those employed in the last two years
SELECT first_name, last_name, hire_date 
FROM employees 
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR);

#the employee with the bigges salary
SELECT first_name, last_name, amount from salaries
JOIN employees
ON employees.employee_id = salaries.employee_id
ORDER BY salaries.amount DESC
LIMIT 1;

#all employees and their salaries
SELECT first_name, last_name, amount from employees e
JOIN salaries s
ON e.employee_id = s.employee_id
WHERE s.end_date IS NULL;

#we create a VIEW that shows only employees who have salaries higher than the company average
CREATE VIEW HighSalaryEmployees AS
SELECT e.employee_id, e.first_name, e.last_name, s.amount AS salary
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
WHERE s.amount > (SELECT AVG(amount) FROM salaries);

SELECT * FROM HighSalaryEmployees;

#we create a trigger that automatically sets the end_date for the old salary when an employee receieves a new salary.
DELIMITER $$

CREATE TRIGGER UpdateOldSalary
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN
    UPDATE salaries
    SET end_date = NEW.start_date
    WHERE employee_id = NEW.employee_id AND end_date IS NULL;
END $$

DELIMITER ;

INSERT INTO salaries (employee_id, amount, start_date, end_date) 
VALUES (1, 5500, '2025-03-01', NULL);

SELECT * FROM salaries WHERE employee_id = 1;

#we create a stored procedure that returns the employees in a given department as a paramater
DELIMITER $$

CREATE PROCEDURE GetEmployeesByDepartment(IN dept_name VARCHAR(100))
BEGIN
    SELECT e.employee_id, e.first_name, e.last_name, d.name AS department
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE d.name = dept_name;
END $$

DELIMITER ;

CALL GetEmployeesByDepartment('IT');


