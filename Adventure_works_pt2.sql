-- 1. Retrieve from product tables all colours except blanks,Red, silver/black and white with unit price between £75 and £750.
--Rename the column standard cost price. Sort price in ascending order.

SELECT Color,
	   StandardCost AS StandardCost_Price
FROM [Production].[Product]
WHERE  Color != 'Red' AND Color!='Silver/Black'AND
	   Color!='White' AND 
	   Color IS NOT NULL AND 
	   StandardCost BETWEEN 75 AND 750
ORDER BY StandardCost

--2
--Find all male employees born from 1962 to 1970 and their hire date greater than 2001 and female employees born between 1972 to 1975 
--and hire date between 2001/2002.


SELECT NationalIDNumber,
	   Gender,	 
	   BirthDate,
	   HireDate
FROM [HumanResources].[Employee] 
WHERE 
(Gender = 'M' 
	AND YEAR(BirthDate) BETWEEN 1962 AND 1970
	AND YEAR(HireDate) > 2001)
	OR 
	(Gender = 'F' 
	AND YEAR(BirthDate) BETWEEN 1972 AND 1975
	AND YEAR(HireDate) BETWEEN 2001 AND 2002)


--3 Create a list of 10 most expensive products from the Production.Product table that have a product number beginning with ‘BK’.  
--Include only the product ID, Name and colour.

SELECT TOP 10 ProductID,
	   Name,
	   Color
FROM [Production].[Product]
WHERE ProductNumber LIKE 'BK%'
ORDER BY ListPrice DESC 


--4. Create a list of all contact persons where the first 4 characters of the front of the last name is the same as the first four characters of 
--the email address in small letters. Also, for all contacts whose first name and the last name begin with the same characters, create a new column 
--called full name combining first name and the last name only. Would also like information on the length of the full name?

SELECT PE.BusinessEntityID, 
	   PE.EmailAddress,
	   PP.FirstName, 
	   PP.LastName,
	   CASE WHEN LOWER(LEFT(PP.LastName, 4)) = LOWER(LEFT(PE.EmailAddress, 4))
         THEN CONCAT(FirstName, ' ', LastName)
         ELSE NULL
       END AS FullName,
	   LEN(CONCAT(PP.FirstName, ' ', PP.LastName)) AS FullNameLength
FROM Person.EmailAddress AS PE
JOIN Person.Person AS PP
ON PE.BusinessEntityID=PP.BusinessEntityID
WHERE LOWER(LEFT(PP.LastName, 4)) = LOWER(LEFT(PE.EmailAddress, 4))


--5.If commission is calculated based on 14.790% of standard cost, extract product item and calculate the margin if standard cost is increased or decreased as follows for each product colours as follows:
--Black +22%, Red - 12%, Silver +15%, Multi +5%
--White (2) times original price divided by the square root of the margin price ,while other colours remain the same.

--SELECT Color,
--	   StandardCost,
--        CASE
--        WHEN Color = 'Black' THEN ((0.1479) * (StandardCost*1.22)) - (StandardCost*0.1479)
--        WHEN Color = 'Red' THEN ((0.1479)*(StandardCost*0.88)) - (StandardCost*0.1479)
--        WHEN Color = 'Silver' THEN ((0.1479) * (StandardCost*1.15)) - (StandardCost*0.1479)
--        WHEN Color = 'Multi' THEN ((0.1479) * (StandardCost*1.05)) - (StandardCost*0.1479)
--           END AS Margin
--FROM Production.Product

  SELECT 
  
    Color,
    StandardCost,
    CASE 
        WHEN Color = 'Black' THEN StandardCost * (1 + 0.22)
        WHEN Color = 'Red' THEN StandardCost * (1 - 0.12)
        WHEN Color = 'Silver' THEN StandardCost * (1 + 0.15)
        WHEN Color = 'Multi' THEN StandardCost * (1 + 0.05)
        WHEN Color = 'White' THEN 
            (2 * StandardCost) / SQRT(StandardCost * 0.1479) -- Adjusted for commission
        ELSE StandardCost -- Other colors remain the same
    END AS AdjustedStandardCost,
    (CASE 
        WHEN Color = 'Black' THEN StandardCost * (1 + 0.22)
        WHEN Color = 'Red' THEN StandardCost * (1 - 0.12)
        WHEN Color = 'Silver' THEN StandardCost * (1 + 0.15)
        WHEN Color = 'Multi' THEN StandardCost * (1 + 0.05)
        WHEN Color = 'White' THEN 
            (2 * StandardCost) / SQRT(StandardCost * 0.1479) -- Adjusted for commission
        ELSE StandardCost -- Other colors remain the same
    END) * 0.1479 AS Commission,
    (CASE 
        WHEN Color = 'Black' THEN StandardCost * (1 + 0.22)
        WHEN Color = 'Red' THEN StandardCost * (1 - 0.12)
        WHEN Color = 'Silver' THEN StandardCost * (1 + 0.15)
        WHEN Color = 'Multi' THEN StandardCost * (1 + 0.05)
        WHEN Color = 'White' THEN 
            (2 * StandardCost) / SQRT(StandardCost * 0.1479) -- Adjusted for commission
        ELSE StandardCost -- Other colors remain the same
    END) - (CASE 
        WHEN Color = 'Black' THEN StandardCost * (1 + 0.22)
        WHEN Color = 'Red' THEN StandardCost * (1 - 0.12)
        WHEN Color = 'Silver' THEN StandardCost * (1 + 0.15)
        WHEN Color = 'Multi' THEN StandardCost * (1 + 0.05)
        WHEN Color = 'White' THEN 
            (2 * StandardCost) / SQRT(StandardCost * 0.1479) -- Adjusted for commission
        ELSE StandardCost -- Other colors remain the same
    END) * 0.1479 AS Margin
FROM 
    Production.Product;


 --6.	Return all product subcategory record that take an Average 3 days or longer to manufacture.

 SELECT P1.DaysToManufacture,
		PS.Name,
		PS.ProductSubcategoryID,
		PS.ProductCategoryID, 
		PS.rowguid,
		PS.ModifiedDate,
		P1.DaysToManufacture
 FROM Production.Product AS P1
 LEFT JOIN Production.ProductSubcategory AS PS
 ON P1.ProductSubcategoryID=PS.ProductSubcategoryID
 WHERE P1.DaysToManufacture >= 3



 --7.	Create a list of product segmentation by defining criteria that places each item in a predefined segment as follows. 
 --If price gets less than £200 then low value. If price is between £201 and £750 then mid value. 
 --If between £750 and £1250 then mid to high value else higher value.  For colours “black, silver and red” products.

 SELECT 
	name,
    Color,
    ListPrice,
    CASE 
        WHEN ListPrice < 200 THEN 'Low Value'
        WHEN ListPrice BETWEEN 201 AND 750 THEN 'Mid Value'
        WHEN ListPrice BETWEEN 751 AND 1250 THEN 'Mid to High Value'
        ELSE 'Higher Value'
    END AS Segment
FROM 
    [Production].[Product]
WHERE 
    Color IN ('Black', 'Silver', 'Red')
ORDER BY 
   ListPrice;


 --8.	How many Distinct Jobtitle are available in Employee table - 67 JOB TITLES

 SELECT COUNT(DISTINCT(JobTitle))'No Of Job Titles'
 FROM HumanResources.Employee

 --9.	Use employee table and calculate the ages of each employee at the time of hiring

 SELECT NationalIDNumber,
		BirthDate,
		HireDate, 
		Datediff(Year,BirthDate,HireDate)AgeTimeofHire
		--YEAR(HireDate) - YEAR(BirthDate) AS AgeTimeofHire
 FROM HumanResources.Employee

 --10.	How many employees will be due a long service award in the next 5 years if long service is 20 years?

 -- SELECT COUNT(NationalIDNumber) AS NoofEmployees
 --FROM HumanResources.Employee
 --WHERE DATEPART(YEAR, GETDATE()) - YEAR(HireDate) >= 15

 SELECT 
    COUNT(*) AS EmployeesDueForAward
FROM 
    [HumanResources].[Employee]
WHERE 
    DATEDIFF(YEAR, HireDate, GETDATE()) >=15



 --11.	How many more years does each employee have to work before reaching sentiment. If sentiment age is 65?
 --SELECT NationalIDNumber, BirthDate, HireDate, 
	--YEAR(HireDate) - YEAR(BirthDate) AS AgeTimeofHire, 
	--65 - (DATEPART(YEAR, GETDATE()) - YEAR(BirthDate)) AS SentimentAge
 --FROM HumanResources.Employee
 SELECT 
    NationalIDNumber,
    BirthDate,
	HireDate,
    65 - DATEDIFF(YEAR, BirthDate, GETDATE()) AS YearsUntilSentiment
FROM 
    [HumanResources].[Employee]
WHERE 
    DATEDIFF(YEAR, BirthDate, GETDATE()) < 65
ORDER BY 
    YearsUntilSentiment ASC;



 --12.	Derive the week day, month name and year from the hire. Also how long has each female employee been employed?

 SELECT NationalIDNumber,
		DATENAME(YEAR, HireDate) AS HireYear,
		DATENAME(MONTH, HireDate) AS HireMonth,
		DATENAME(WEEKDAY, HireDate) AS HireDay,
		Datediff(year,hiredate,getdate())'Years employed'
 FROM HumanResources.Employee
 

 SELECT NationalIDNumber, Gender, DATEPART(YEAR, GETDATE()) - YEAR(HireDate) AS Employmentlenght
 FROM HumanResources.Employee
 WHERE Gender = 'F'

--13.	 Implement new price policy on the product table base on the colour of the item
--If white increase price by 8%
--If yellow reduce price by 7.5%
--If black increase price by 17.2%
--If multi, silver, silver/black or blue take the square root of the price and double the value. 
--Column should be called Newprice, while other colours remain the same. For each item, also calculate commission as 37.5% of newly computed list price.

--SELECT Name, Color, ListPrice, 
--	CASE
--	WHEN Color = 'White' THEN ListPrice*1.08
--	WHEN Color = 'Yellow' THEN ListPrice*0.925
--	WHEN Color = 'Black' THEN ListPrice*1.172
--	WHEN Color IN ('Multi', 'Silver', 'Silver/Black', 'Blue') THEN (SQRT(ListPrice))*2
--	ELSE ListPrice
--	END AS NewPrice,
--	CASE 
--	WHEN Color = 'White' THEN ListPrice*1.08*0.375
--	WHEN Color = 'Yellow' THEN ListPrice*0.925*0.375
--	WHEN Color = 'Black' THEN ListPrice*1.172*0.375
--	WHEN Color IN ('Multi', 'Silver', 'Silver/Black', 'Blue') THEN (SQRT(ListPrice))*2*0.375
--	ELSE ListPrice*0.375
--	END AS Commission
--FROM Production.Product

SELECT 
    Name,
    Color,
    ListPrice AS OriginalPrice,
    CASE 
        WHEN Color = 'White' THEN ListPrice * (1 + 0.08)
        WHEN Color = 'Yellow' THEN ListPrice * (1 - 0.075)
        WHEN Color = 'Black' THEN ListPrice * (1 + 0.172)
        WHEN Color IN ('Multi', 'Silver', 'Silver/Black', 'Blue') THEN 2 * SQRT(ListPrice)
        ELSE ListPrice -- Other colors remain the same
    END AS NewPrice,
    CASE 
        WHEN Color = 'White' THEN ListPrice * (1 + 0.08) * 0.375
        WHEN Color = 'Yellow' THEN ListPrice * (1 - 0.075) * 0.375
        WHEN Color = 'Black' THEN ListPrice * (1 + 0.172) * 0.375
        WHEN Color IN ('Multi', 'Silver', 'Silver/Black', 'Blue') THEN 2 * SQRT(ListPrice) * 0.375
        ELSE ListPrice * 0.375 -- Commission for unchanged prices
    END AS Commission
FROM 
    [Production].[Product]
ORDER BY 
    Color, name;



--14.	 I would like information Sales.Person and their sales quota. 
--For every Sales person should have a FirstName, LastName, HireDate, SickLeave Hours  and Region where they Work

SELECT PP.FirstName,
	   PP.LastName,
	   SP.SalesQuota,
	   HE.HireDate,
	   HE.SickLeaveHours,
	   ST.Name,
	   ST.CountryRegionCode
FROM Sales.SalesPerson AS SP
LEFT JOIN Person.Person AS PP ON SP.BusinessEntityID=PP.BusinessEntityID
LEFT JOIN HumanResources.Employee AS HE ON SP.BusinessEntityID=HE.BusinessEntityID
LEFT JOIN Sales.SalesTerritory AS ST ON SP.TerritoryID=ST.TerritoryID


--15.	 Using adventure works, write a query to extract a  data table that must contain the following variables:
--•	Product name
--•	Product category name
--•	Product subcategory name 
--•	Sales person
--•	Revenue
--•	Month of transaction 
--•	Quarter of transaction
--•	Region 

SELECT  p.Name AS ProductName,
    pc.Name AS ProductCategoryName,
    psc.Name AS ProductSubcategoryName,
	pp.FirstName + ' ' + pp.LastName AS SalesPerson,
	SUM(S.TotalDue) AS Revenue,
	DATENAME(MONTH,s.OrderDate) AS MonthOfTransaction,
    CONCAT('Q', DATEPART(QUARTER, s.OrderDate)) AS QuarterOfTransaction,
    st.Name AS Region
FROM
    Sales.SalesOrderHeader AS s
LEFT JOIN
    Sales.SalesPerson AS sp ON s.SalesPersonID = sp.BusinessEntityID
LEFT JOIN
    Sales.SalesTerritory AS st ON sp.TerritoryID = st.TerritoryID
LEFT JOIN
    Person.Person AS pp ON sp.BusinessEntityID = pp.BusinessEntityID
LEFT JOIN
    Sales.SalesOrderDetail AS sod ON s.SalesOrderID = sod.SalesOrderID
LEFT JOIN
    Production.Product AS p ON sod.ProductID = p.ProductID
LEFT JOIN
    Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN
    Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pp.FirstName, pp.LastName, p.Name, pc.Name, psc.Name, s.OrderDate, s.OrderDate, st.Name


--16. A report on all products sold between January and December 2012, showing number of sales, sales proportions and the financial performance. 
--Ensure your analysis can be used to determine whether there is growth or decline on any of the product lines.

SELECT
    P.ProductID,
    P.Name AS ProductName,
    P.ProductLine,
	YEAR(soh.OrderDate) AS Year,
    SUM(sod.LineTotal) AS TotalSales,
    SUM(sod.LineTotal) / SUM(SUM(SOD.LineTotal)) OVER () AS SalesProportion,
    SUM(sod.LineTotal) - LAG(SUM(SOD.LineTotal)) OVER (PARTITION BY P.ProductLine ORDER BY P.ProductID) AS SalesGrowth
FROM
    Sales.SalesOrderDetail AS SOD
    INNER JOIN Production.Product AS P ON P.ProductID = SOD.ProductID
    INNER JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE
    YEAR(SOH.OrderDate) = '2012' 
GROUP BY
    P.ProductID, P.Name, P.ProductLine, YEAR(SOH.OrderDate)
ORDER BY ProductName


--Compare 2012 and 2013 figures to highlight year on year results.
SELECT
    P.ProductID,
    P.Name AS ProductName,
    P.ProductLine,
    SUM(CASE WHEN YEAR(SOH.OrderDate) = 2012 THEN SOD.LineTotal ELSE 0 END) AS TotalSales_2012,
    SUM(CASE WHEN YEAR(SOH.OrderDate) = 2013 THEN SOD.LineTotal ELSE 0 END) AS TotalSales_2013,
    SUM(CASE WHEN YEAR(SOH.OrderDate) = 2013 THEN SOD.LineTotal ELSE 0 END) - SUM(CASE WHEN YEAR(SOH.OrderDate) = 2012 THEN SOD.LineTotal ELSE 0 END) AS SalesGrowth
FROM
    Sales.SalesOrderDetail AS SOD
    INNER JOIN Production.Product AS P ON P.ProductID = SOD.ProductID
    INNER JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE
    YEAR(SOH.OrderDate) IN (2012, 2013)
GROUP BY
    P.ProductID, P.Name, P.ProductLine


--Reproduce the report at higher levels such as Product category and sub category.
SELECT
    PC.ProductCategoryID,
    PC.Name AS ProductCategory,
    PSC.ProductSubcategoryID,
    PSC.Name AS ProductSubcategory,
    SUM(CASE WHEN YEAR(SOH.OrderDate) = 2012 THEN SOD.LineTotal ELSE 0 END) AS TotalSales_2012,
    SUM(CASE WHEN YEAR(SOH.OrderDate) = 2013 THEN SOD.LineTotal ELSE 0 END) AS TotalSales_2013,
    SUM(CASE WHEN YEAR(SOH.OrderDate) = 2013 THEN SOD.LineTotal ELSE 0 END) - SUM(CASE WHEN YEAR(SOH.OrderDate) = 2012 THEN SOD.LineTotal ELSE 0 END) AS SalesGrowth
FROM
    Sales.SalesOrderDetail AS SOD
    INNER JOIN Production.Product AS P ON P.ProductID = SOD.ProductID
    INNER JOIN Production.ProductSubcategory AS PSC ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
    INNER JOIN Production.ProductCategory AS PC ON PC.ProductCategoryID = PSC.ProductCategoryID
    INNER JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
WHERE
    YEAR(SOH.OrderDate) IN (2012, 2013)
GROUP BY
    PC.ProductCategoryID, PC.Name, PSC.ProductSubcategoryID, PSC.Name;


--What key products are the drivers of performance?
WITH SalesData AS (
    SELECT
        P.ProductID,
        P.Name AS ProductName,
        PC.ProductCategoryID,
        PSC.Name AS ProductCategory,
        P.ProductSubcategoryID,
        PC.Name AS ProductSubcategory,
        SUM(SOD.LineTotal) AS TotalSales
    FROM
        Sales.SalesOrderDetail AS SOD
		INNER JOIN Production.Product AS P ON P.ProductID = SOD.ProductID
		INNER JOIN Production.ProductSubcategory AS PSC ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
		INNER JOIN Production.ProductCategory AS PC ON PC.ProductCategoryID = PSC.ProductCategoryID
		INNER JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
    WHERE
        YEAR(SOH.OrderDate) IN (2012, 2013)
    GROUP BY
        P.ProductID, P.Name, PC.ProductCategoryID, PSC.Name, P.ProductSubcategoryID, PC.Name
	)
SELECT
    *,
    RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM
    SalesData
ORDER BY
    SalesRank ASC


--If we would like to discontinue any product sub categories due to poor outcomes, what would this be? 
WITH SalesData AS (
    SELECT
        P.ProductSubcategoryID,
        PSC.Name AS ProductSubcategory,
        SUM(CASE WHEN YEAR(SOH.OrderDate) = 2012 THEN SOD.LineTotal ELSE 0 END) AS TotalSales_2012,
		SUM(CASE WHEN YEAR(SOH.OrderDate) = 2013 THEN SOD.LineTotal ELSE 0 END) AS TotalSales_2013,
		SUM(CASE WHEN YEAR(SOH.OrderDate) = 2013 THEN SOD.LineTotal ELSE 0 END) - SUM(CASE WHEN YEAR(SOH.OrderDate) = 2012 THEN SOD.LineTotal ELSE 0 END) AS SalesGrowth
	FROM
        Sales.SalesOrderDetail AS SOD
        INNER JOIN Production.Product AS P ON P.ProductID = SOD.ProductID
        INNER JOIN Production.ProductSubcategory AS PSC ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
        INNER JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SOD.SalesOrderID
    WHERE
        YEAR(SOH.OrderDate) IN (2012, 2013)
    GROUP BY
        P.ProductSubcategoryID, PSC.Name
		)
SELECT
    ProductSubcategoryID,
    ProductSubcategory,
    TotalSales_2012,
    TotalSales_2013,
    SalesGrowth
FROM
    SalesData
WHERE
    TotalSales_2013 < 0 OR SalesGrowth < 0






