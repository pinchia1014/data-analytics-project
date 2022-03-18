# CREATE TABLES
CREATE TABLE Product_Categories ( 
Category_ID   VARCHAR(10)   PRIMARY KEY, 
Name   VARCHAR(50)   NOT NULL, 
Description   VARCHAR(255)   NOT NULL);

CREATE TABLE Product_Type ( 
Type_ID   VARCHAR(10)    PRIMARY KEY, 
Type_Description   VARCHAR(255)   NOT NULL, 
Category_ID   VARCHAR(10), 
FOREIGN KEY (Category_ID)  REFERENCES  Product_Categories (Category_ID)); 

CREATE TABLE Factory( 
Factory_ID  VARCHAR(10)    PRIMARY KEY, 
Address   VARCHAR(255)   NOT NULL, 
Phone  VARCHAR(20)   NOT NULL); 

CREATE TABLE Employee( 
Employee_ID  VARCHAR(10)   PRIMARY KEY, 
Name   VARCHAR(50)   NOT NULL, 
Email   VARCHAR(50)   NOT NULL, 
Phone  VARCHAR(20)   NOT NULL, 
Hire_Date  DATE   NOT NULL, 
Factory_ID  VARCHAR(10), 
FOREIGN KEY (Factory_ID) REFERENCES  Factory(Factory_ID)); 

CREATE TABLE Supplier ( 
Supplier_ID  VARCHAR(10)    PRIMARY KEY, 
Name   VARCHAR(50)   NOT NULL, 
Address   VARCHAR(255)   NOT NULL, 
Phone  VARCHAR(20)   NOT NULL, 
Factory_ID  VARCHAR(10), 
FOREIGN KEY (Factory_ID) REFERENCES  Factory(Factory_ID)); 

CREATE TABLE Product ( 
Product_ID   VARCHAR(10)   PRIMARY KEY, 
Name   VARCHAR(50)   NOT NULL, 
Price   INT   NOT NULL, 
Cost   INT   NOT NULL, 
Quantity_on_Hand   INT  NOT NULL, 
Category_ID   VARCHAR(10), 
TYpe_ID   VARCHAR(10), 
Supplier_ID  VARCHAR(10), 
FOREIGN KEY (Category_ID)  REFERENCES  Product_Categories (Category_ID), 
FOREIGN KEY (Type_ID)  REFERENCES  Product_Type (Type_ID), 
FOREIGN KEY (Supplier_ID)  REFERENCES  Supplier (Supplier_ID)); 

CREATE TABLE Customer ( 
Customer_ID  VARCHAR(10)  PRIMARY KEY, 
Name   VARCHAR(50)   NOT NULL, 
Address   VARCHAR(255)   NOT NULL, 
Email   VARCHAR(50)   NOT NULL, 
Phone_Number  VARCHAR(20)   NOT NULL); 

CREATE TABLE Orders( 
Order_ID  VARCHAR(10)    PRIMARY KEY, 
Order_Amount INT   NOT NULL, 
Shipping_Address VARCHAR(255)   NOT NULL, 
Order_Date DATE  NOT NULL, 
Quantity INT   NOT NULL, 
Unit_Price INT   NOT NULL, 
Customer_ID VARCHAR(10), 
Product_ID VARCHAR(10), 
FOREIGN KEY (Customer_ID) REFERENCES  Customer (Customer_ID), 
FOREIGN KEY (Product_ID)  REFERENCES  Product (Product_ID)); 

CREATE TABLE Review ( 
Review_ID  VARCHAR(10)  PRIMARY KEY, 
Product_ID   VARCHAR(10) , 
Customer_ID   VARCHAR(10), 
Rating INT NOT NULL, 
FOREIGN KEY (Product_ID)  REFERENCES  Product (Product_ID), 
FOREIGN KEY (Customer_ID) REFERENCES  Customer (Customer_ID)); 

# DATA ANALYSIS
SELECT f.Factory_ID, f.Address, count(f.Factory_ID) as 'Total Employee'
FROM Factory f, Employee e
WHERE f.Factory_ID = e.Factory_ID 
GROUP BY f.Factory_ID, f.Address
ORDER BY f.Factory_ID asc;

SELECT distinct Factory_ID, extract(Year from Hire_Date) AS Year, count(Employee_ID) AS 'Number of Employee Hired'
FROM Employee
GROUP BY Factory_ID, Year
ORDER BY Factory_ID, Year;

SELECT State, count(Order_ID) AS 'Number of Order'
FROM (
SELECT Shipping_Address, SUBSTRING_INDEX(SUBSTRING_INDEX(Shipping_Address,',',-2),',',1) AS State, Order_ID
FROM orders) o
GROUP BY State
ORDER BY count(Order_ID) DESC;

SELECT o.Product_ID, Name, count(o.Product_ID) AS 'Number of Order', sum(Order_Amount) AS 'Sales Revenue', sum((Unit_Price-Cost)*Quantity) AS Profit
FROM Orders o, Product p
WHERE o.Product_ID = p.Product_ID
GROUP BY o.Product_ID, Name
HAVING Profit>100
ORDER BY Profit DESC;

SELECT p.Product_ID, p.Name, sum(o.Quantity) as 'Total Quantity'
FROM Product p, Orders o 
WHERE p.Product_ID = o.Product_ID
GROUP BY p.Product_ID, p.Name
ORDER BY sum(o.Quantity) DESC;

SELECT p.Product_ID, p.Name, round(avg(r.Rating),2) as 'Average Rating'
FROM Product p, Review r
WHERE p.Product_ID = r.Product_ID 
GROUP BY p.Product_ID, p.Name
ORDER BY avg(r.Rating) desc;

SELECT p.Product_ID,p.Name, (p.Quantity_on_Hand-sum(o.Quantity)) as 'Left Over Inventory'
FROM Product p, Orders o 
WHERE p.Product_ID = o.Product_ID 
GROUP BY p.Product_ID,p.Name
ORDER BY (p.Quantity_on_Hand-sum(o.Quantity)) asc;

SELECT c.Customer_ID, c.Name, sum(o.Order_Amount) as 'Total Order Amount', sum(o.Quantity)as 'Total Quantity Amount'
FROM Customer c, Orders o
WHERE c.Customer_ID = o.Customer_ID 
GROUP BY c.Customer_ID, c.Name 
ORDER BY sum(o.Order_Amount) desc
LIMIT 10;

SELECT extract(Month from Order_Date) AS Month, count(Order_ID) AS 'Number of Order'
FROM Orders
GROUP BY Month
ORDER BY Month;

SELECT f.Factory_ID, count(p.Product_ID) AS 'Number of Product'
FROM Factory f, Supplier s, Product p
WHERE f.Factory_ID = s.Factory_ID
AND p.Supplier_ID = s.Supplier_ID
GROUP BY Factory_ID;






