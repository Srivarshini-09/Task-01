-- Step 1: Create the database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS ECommerceDB;

-- Select the database to use for the session
USE ECommerceDB;

-- Step 2: Create Category Table
CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each category (auto-generated)
    Name VARCHAR(50) NOT NULL,                -- Name of the category, cannot be null
    Description TEXT                          -- Optional text description of the category
);

-- Step 3: Create Product Table
CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each product (auto-generated)
    Name VARCHAR(100) NOT NULL,              -- Product name, required
    Price DECIMAL(10, 2) NOT NULL,           -- Product price with 2 decimal places
    Stock INT DEFAULT 0,                     -- Number of items in stock, default is 0
    CategoryID INT,                          -- Foreign key referencing Category table
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
        ON DELETE SET NULL                  -- If a category is deleted, set this field to NULL
        ON UPDATE CASCADE                   -- If CategoryID changes, update this field too
);

-- Step 4: Create Customer Table
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each customer
    Name VARCHAR(100) NOT NULL,               -- Customer's name
    Email VARCHAR(100) UNIQUE NOT NULL,       -- Unique email address, required
    Phone VARCHAR(20),                        -- Optional phone number
    Address TEXT                              -- Optional physical address
);

-- Step 5: Create Orders Table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,    -- Unique ID for each order
    CustomerID INT,                            -- Foreign key linking to the customer who placed the order
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- Date/time of the order, defaults to current time
    TotalAmount DECIMAL(10, 2),                -- Total price of the order
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE                      -- If customer is deleted, delete their orders
        ON UPDATE CASCADE                      -- Update this field if CustomerID changes
);

-- Step 6: Create OrderItem Table
CREATE TABLE OrderItem (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each item in an order
    OrderID INT,                                -- Foreign key linking to the order
    ProductID INT,                              -- Foreign key linking to the product
    Quantity INT NOT NULL,                      -- Quantity of this product in the order
    Price DECIMAL(10, 2) NOT NULL,              -- Price at the time of order (not from product table)
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE                       -- If an order is deleted, delete its items
        ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE CASCADE                       -- If a product is deleted, remove the order item
        ON UPDATE CASCADE
);

-- Step 7: Create Payment Table
CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,   -- Unique ID for each payment
    OrderID INT,                                -- Foreign key linking to the associated order
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP, -- Payment date/time, defaults to now
    Amount DECIMAL(10, 2) NOT NULL,             -- Payment amount
    PaymentMethod VARCHAR(50),                  -- e.g., Credit Card, PayPal, Cash
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE                       -- If an order is deleted, delete the payment
        ON UPDATE CASCADE
);

