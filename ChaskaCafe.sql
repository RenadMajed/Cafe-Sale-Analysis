

SELECT * FROM CafeProject.dbo.ChaskaCafe

--Data cleaining 
--1. remove duplicates  
--2. null values or blank values 
--3. standardize the data
 



--make a copy 
SELECT * INTO CafeCopy FROM CafeProject.dbo.ChaskaCafe


SELECT * FROM CafeCopy 

--step 1 
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY "Date",Category,Item,Sales ORDER BY "Date") AS RowNum
FROM CafeCopy


 --filters to show only duplicates

;WITH Duplicate_cte AS(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY "Date",Category,Item,Sales ORDER BY "Date") AS RowNum
FROM CafeCopy
)
SELECT * FROM Duplicate_cte
WHERE RowNum >1;

--no duplicates found 

--step 2

SELECT * FROM CafeCopy 
WHERE "Date"=' ' OR "Date" IS NULL OR
Category= ' ' OR Category IS NULL OR
Item =' ' OR Item IS NULL OR
Sales = ' ' OR Sales IS NULL ;

--No null values or blankes founded 

--step 3 

SELECT Item , TRIM(Item) FROM CafeCopy 

UPDATE CafeCopy
SET Item = TRIM(Item)

SELECT * FROM CafeCopy

SELECT DISTINCT Item FROM CafeCopy ORDER BY 1

SELECT DISTINCT Category FROM CafeCopy ORDER BY 1

SELECT Category, COUNT(*) AS Countitem
FROM CafeCopy 
GROUP BY Category 
HAVING COUNT(*) > 1
ORDER BY 1,2



SELECT Item, COUNT(*) AS Countitem
FROM CafeCopy 
GROUP BY Item 
HAVING COUNT(*) > 1
ORDER BY 1,2
--Data Analysis 


--Which Item sale the most
SELECT 
    Item, 
    SUM(Sales) AS Total_Sales
FROM 
    CafeCopy
GROUP BY 
    Item
ORDER BY 
    Total_Sales DESC;
--Veg alfredo pasta

--	Which category sale the most

SELECT Category, SUM(Sales) AS TotalSale
FROM CafeCopy
GROUP BY Category
ORDER BY TotalSale DESC 

--Pastas is the category sale the most

--Peak sales period

SELECT CAST([Date] AS DATE) AS SaleDate, 
SUM(Sales) AS TotalSale
FROM CafeCopy
GROUP BY CAST([Date] AS DATE)
ORDER BY TotalSale DESC

--11/8/2023 is the most sales date 


--Total sales 

SELECT SUM(Sales) AS TotalSales
FROM CafeCopy

--361785 total sales

--Avg sales each item and each category 



SELECT Item, AVG(Sales) AS AvgSaleItem
FROM CafeCopy
GROUP BY  Item
ORDER BY AvgSaleItem DESC
--kinda close to each other but Veg alfredo pasta is the most avg sales 28.6


SELECT Category, AVG(Sales) AS AvgSaleItem
FROM CafeCopy
GROUP BY  Category
ORDER BY AvgSaleItem DESC
--kinda close to each other but pastas is the most 28.14


--The best selling items within each category 

;WITH SalesSummary AS (
    SELECT 
        Category,
        Item,
        SUM(Sales) AS TotalSales
    FROM 
        CafeCopy
    GROUP BY 
        Category, Item
)

SELECT 
    Category,
    Item,
    TotalSales
FROM 
    SalesSummary AS ss
WHERE 
    TotalSales = (
        SELECT MAX(TotalSales)
        FROM SalesSummary
        WHERE Category = ss.Category
    )
ORDER BY 
    Category;
--Beverages is lemonade ,Desserts is ice cream sundae,fries is classic fries, pastas is veg alfredo
--salads is garden salad ,sandwiches is veg club ,veg burgers is spicy ver burger
--veg pizza is farmhouse pizza , wraps is aloo wrap 


--how sales fluctuate every months
SELECT 
    DATEPART(MONTH, [Date]) AS SaleMonth,
    SUM(Sales) AS TotalSales
FROM 
    CafeCopy
GROUP BY 
    DATEPART(MONTH, [Date])
ORDER BY 
    TotalSales DESC
--the least month sales is 2 and the most is 8 by using this
--we can know if the sales increased by seasons or events
