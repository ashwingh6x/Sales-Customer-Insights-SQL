CREATE TABLE Customers (
  cid INT PRIMARY KEY,
  name VARCHAR(50),
  region VARCHAR(50),
  signup_date DATE
);

CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(50),
  category VARCHAR(50),
  price DECIMAL(10,2)
);

CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  cid INT,
  order_date DATE,
  region VARCHAR(50),
  total_amount DECIMAL(10,2),
  FOREIGN KEY (cid) REFERENCES Customers(cid)
);

CREATE TABLE Order_Details (
  order_detail_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT,
  price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers VALUES (1, 'Arjun', 'South', '2023-01-10');
INSERT INTO Customers VALUES (2, 'Priya', 'North', '2023-02-15');
INSERT INTO Customers VALUES (3, 'Kiran', 'West', '2023-03-12');
INSERT INTO Customers VALUES (4, 'Meera', 'East', '2023-04-05');
INSERT INTO Customers VALUES (5, 'Rahul', 'South', '2023-05-18');
INSERT INTO Customers VALUES (6, 'Sneha', 'North', '2023-06-22');
INSERT INTO Customers VALUES (7, 'Varun', 'West', '2023-07-09');
INSERT INTO Customers VALUES (8, 'Divya', 'South', '2023-08-15');
INSERT INTO Customers VALUES (9, 'Anil', 'East', '2023-09-03');
INSERT INTO Customers VALUES (10, 'Nisha', 'North', '2023-10-11');

INSERT INTO Products VALUES (101, 'Laptop', 'Electronics', 60000);
INSERT INTO Products VALUES (102, 'Mobile', 'Electronics', 20000);
INSERT INTO Products VALUES (103, 'Shoes', 'Fashion', 3000);
INSERT INTO Products VALUES (104, 'Headphones', 'Electronics', 3000);
INSERT INTO Products VALUES (105, 'Tablet', 'Electronics', 25000);
INSERT INTO Products VALUES (106, 'Watch', 'Fashion', 5000);
INSERT INTO Products VALUES (107, 'Jacket', 'Fashion', 4000);
INSERT INTO Products VALUES (108, 'Microwave', 'Home Appliances', 15000);
INSERT INTO Products VALUES (109, 'Refrigerator', 'Home Appliances', 45000);
INSERT INTO Products VALUES (110, 'Mixer Grinder', 'Home Appliances', 7000);

INSERT INTO Orders VALUES (1001, 1, '2023-03-15', 'South', 62000);
INSERT INTO Orders VALUES (1002, 2, '2023-03-20', 'North', 20000);
INSERT INTO Orders VALUES (1003, 1, '2023-04-05', 'South', 3000);
INSERT INTO Orders VALUES (1004, 4, '2023-04-18', 'East', 25000);
INSERT INTO Orders VALUES (1005, 5, '2023-05-21', 'South', 45000);
INSERT INTO Orders VALUES (1006, 6, '2023-06-25', 'North', 8000);
INSERT INTO Orders VALUES (1007, 7, '2023-07-12', 'West', 60000);
INSERT INTO Orders VALUES (1008, 8, '2023-08-20', 'South', 15000);
INSERT INTO Orders VALUES (1009, 9, '2023-09-10', 'East', 52000);
INSERT INTO Orders VALUES (1010, 10, '2023-10-15', 'North', 35000);

INSERT INTO Order_Details VALUES (1, 1001, 101, 1, 60000);
INSERT INTO Order_Details VALUES (2, 1001, 103, 2, 1000);
INSERT INTO Order_Details VALUES (3, 1002, 102, 1, 20000);
INSERT INTO Order_Details VALUES (4, 1003, 103, 1, 3000);
INSERT INTO Order_Details VALUES (5, 1004, 105, 1, 25000);
INSERT INTO Order_Details VALUES (6, 1005, 109, 1, 45000);
INSERT INTO Order_Details VALUES (7, 1006, 106, 1, 5000);
INSERT INTO Order_Details VALUES (8, 1006, 104, 1, 3000);
INSERT INTO Order_Details VALUES (9, 1007, 101, 1, 60000);
INSERT INTO Order_Details VALUES (10, 1008, 107, 1, 4000);
INSERT INTO Order_Details VALUES (11, 1008, 110, 1, 11000);
INSERT INTO Order_Details VALUES (12, 1009, 102, 2, 20000);
INSERT INTO Order_Details VALUES (13, 1009, 108, 1, 12000);
INSERT INTO Order_Details VALUES (14, 1010, 103, 2, 3000);
INSERT INTO Order_Details VALUES (15, 1010, 105, 1, 25000);

-- Showing all orders with product details by INNER JOIN

select Order_Details.order_id, Order_Details.order_detail_id, Products.product_id, Products.product_name, Products.category, Products.price
from Order_Details
inner join Products
on Products.product_id = Order_Details.product_id;

-- Showing total sales per product by aggregation functions

select
	p.product_id,
    p.product_name,
    p.category,
    SUM(od.quantity * od.price) AS total_sales,
    AVG(od.price) AS avg_price,
    COUNT(od.order_detail_id) AS total_orders
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_sales DESC;

-- Showing total sales per category

SELECT 
    p.category,
    SUM(od.quantity * od.price) AS category_sales,
    AVG(od.price) AS avg_item_price,
    COUNT(DISTINCT od.product_id) AS products_sold
FROM Order_Details od
JOIN Products p ON od.product_id = p.product_id
GROUP BY p.category;

-- Ranking products by price within each category by using window functions

SELECT 
    product_id,
    product_name,
    category,
    price,
    RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank_in_category
FROM Products
ORDER BY category, price_rank_in_category;

-- Exporting table data from the database to excel(.csv)

SELECT 
    od.order_id, 
    od.order_detail_id, 
    p.product_id, 
    p.product_name, 
    p.category, 
    p.price
FROM Order_Details od
JOIN Products p ON p.product_id = od.product_id
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- end of file


