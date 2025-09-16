CREATE TABLE Customers (
  cid INT PRIMARY KEY,
  name VARCHAR(100),
  region VARCHAR(50),
  signup_date DATE
);

CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
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

INSERT INTO Products VALUES (101, 'Laptop', 'Electronics', 60000);
INSERT INTO Products VALUES (102, 'Mobile', 'Electronics', 20000);
INSERT INTO Products VALUES (103, 'Shoes', 'Fashion', 3000);

INSERT INTO Orders VALUES (1001, 1, '2023-03-15', 'South', 62000);
INSERT INTO Orders VALUES (1002, 2, '2023-03-20', 'North', 20000);
INSERT INTO Orders VALUES (1003, 1, '2023-04-05', 'South', 3000);

INSERT INTO Order_Details VALUES (1, 1001, 101, 1, 60000);
INSERT INTO Order_Details VALUES (2, 1001, 103, 2, 1000);
INSERT INTO Order_Details VALUES (3, 1002, 102, 1, 20000);
INSERT INTO Order_Details VALUES (4, 1003, 103, 1, 3000);

-- Showing all orders with product details by INNER JOIN

select Order_Details.order_id, Order_Details.order_detail_id, Products.product_id, Products.product_name, Products.category, Products.price
from Order_Details
inner join Products
on Products.product_id = Order_Details.product_id

-- Showing total sales per product by aggregation functions

SELECT 
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

-- end of file







