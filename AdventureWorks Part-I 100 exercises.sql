 --From the following table write a query in SQL to return all rows from the
 --salesorderheader table in Adventureworks database and calculate the percentage of
 --tax on the subtotal have decided. Return salesorderid, customerid, orderdate, subtotal,
 --percentage of tax column. Arranged the result set in descending order on subtotal.
select * from [Sales].[SalesOrderHeader];
Select SalesOrderID,
	   CustomerID,
	   OrderDate,
	   SubTotal,
	   (TaxAmt*100)/SubTotal as tax_percentage
 from [Sales].[SalesOrderHeader]
 order by SubTotal desc;

 --. From the following table write a query in SQL to create a list of unique jobtitles in the employee table in Adventureworks database.
 --Return jobtitle column and arranged the resultset in ascending order.
select * from [HumanResources].[Employee]
select distinct JobTitle 
from[HumanResources].[Employee]
order by JobTitle asc

-- From the following table write a query in SQL to calculate the total freight paid by each customer. 
--Return customerid and total freight. Sort the output in ascending order on customerid.
select * from [Sales].[SalesOrderHeader]
select CustomerID,
	   sum(freight) as total_freight 
from [Sales].[SalesOrderHeader]
group by CustomerID
order by CustomerID

--From the following table write a query in SQL to find the average and the sum of the subtotal for every customer. 
--Return customerid, average and sum of the subtotal. Grouped the result on customerid and salespersonid.
--Sort the result on customerid column in descending order.
select * from [Sales].[SalesOrderHeader]
select CustomerID,
       SalesPersonID,
       AVG(subtotal) average ,
	   sum(subtotal) total
from [Sales].[SalesOrderHeader]
group by CustomerID, SalesPersonID
order by CustomerID desc

--From the following table write a query in SQL to retrieve total quantity of each productid which are in shelf of 'A' or 'C' or 'H'. 
--Filter the results for sum quantity is more than 500. Return productid and sum of the quantity.
--Sort the results according to the productid in ascending order.
select * from [Production].[ProductInventory]
select ProductID, 
       SUM(quantity) total_q      
from [Production].[ProductInventory]
where Shelf in ('A' , 'C' ,'H')
group by ProductID
having SUM(quantity) > 500
order by ProductID asc

--From the following table write a query in SQL to find the total quentity for a group of locationid multiplied by 10.
select * from [Production].[ProductInventory]
select sum(quantity) as total_quantity
from [Production].[ProductInventory]
group by (LocationID * 10)

 --From the following tables write a query in SQL to find the persons whose last name starts with 
 --letter 'L'. Return BusinessEntityID, FirstName, LastName, and PhoneNumber. Sort the result on lastname and firstname.
select * from[Person].[PersonPhone]
select * from[Person].[Person]
select P.BusinessEntityID,
      P. Firstname,
	  P. lastname,
	  PP. phonenumber
from[Person].[PersonPhone] PP
join  [Person].[Person] P
on pp.BusinessEntityID=p.BusinessEntityID
where p.LastName like 'L%'
order by LastName, FirstName

--From the following table write a query in SQL to find the sum of subtotal column.
--Group the sum on distinct salespersonid and customerid. Rolls up the results into subtotal and running total.
--Return salespersonid, customerid and sum of subtotal column i.e. sum_subtotal.
select * from [Sales].[SalesOrderHeader]
select SalesPersonID,
       CustomerID,
	   sum(subtotal) subtotal
from [Sales].[SalesOrderHeader]
where SalesPersonID is not null
group by SalesPersonID,CustomerID


--From the following table write a query in SQL to find the sum of the quantity 
--of all combination of group of distinct locationid and shelf column.
--Return locationid, shelf and sum of quantity as TotalQuantity.
select * from [Production].[ProductInventory]
SELECT locationid, shelf, SUM(quantity) AS TotalQuantity
-- Retrieving data from the 'productinventory' table
FROM production.productinventory
-- Grouping the results by the CUBE function applied to location ID and shelf
GROUP BY CUBE (locationid, shelf);

--From the following table write a query in SQL to find the sum of the quantity with subtotal for each locationid.
--Group the results for all combination of distinct locationid and shelf column. 
--Rolls up the results into subtotal and running total.
--Return locationid, shelf and sum of quantity as TotalQuantity.
select * from [Production].[ProductInventory]
select LocationID,	
		Shelf,
		sum(quantity) total_quantity
from [Production].[ProductInventory]
GROUP BY GROUPING SETS ( ROLLUP (locationid, shelf), CUBE (locationid, shelf) );

--From the following table write a query in SQL to find the total quantity for each locationid and
--calculate the grand-total for all locations. 
--Return locationid and total quantity. Group the results on locationid.
select * from [Production].[ProductInventory]
select LocationID,
		sum(quantity) as total_quantity
from [Production].[ProductInventory]
GROUP BY GROUPING SETS ( locationid, () );

--From the following table write a query in SQL to retrieve the number of employees for each City.
--Return city and number of employees.
--Sort the result in ascending order on city.
select * from[Person].[BusinessEntityAddress]
select * from [Person].[Address]
select a.city,
		count(*) as no_employee		
from[Person].[BusinessEntityAddress] ba
inner join [Person].[Address] a
on ba.AddressID=a.AddressID
group by a.City
order by City

--From the following table write a query in SQL to retrieve the total sales for each year. 
--Return the year part of order date and total due amount.
--Sort the result in ascending order on year part of order date.
select * from [Sales].[SalesOrderHeader];
select year(OrderDate) as year,
		sum(TotalDue) as OrderAmount
from sales.SalesOrderHeader
GROUP by year(OrderDate)
order by year

--From the following table write a query in SQL to retrieve the total sales for each year. 
--Filter the result set for those orders where order year is on or before 2016.
--Return the year part of orderdate and total due amount.
--Sort the result in ascending order on year part of order date.
select * from [Sales].[SalesOrderHeader];
select year(OrderDate) Yearly
		,sum (totaldue) total
from [Sales].[SalesOrderHeader]
where year(OrderDate) <= 2016
group by  year(OrderDate)
order by  year(OrderDate)


--From the following table write a query in SQL to find the contacts who are designated as a manager in various departments.
--Returns ContactTypeID, name. Sort the result set in descending order.
select * from [Person].[ContactType]
select ContactTypeID,
		Name
from [Person].[ContactType]
where name like '%Manager%'
order by name desc

--From the following tables write a query in SQL to make a list of contacts who are designated as 'Purchasing Manager'. 
--Return BusinessEntityID, LastName, and FirstName columns. 
--Sort the result set in ascending order of LastName, and FirstName.
select * from [Person].[BusinessEntityContact]
select * from [Person].[ContactType]
select * from [Person].[Person]
-- Selecting BusinessEntityID, LastName, and FirstName from multiple tables based on specified conditions
SELECT pp.BusinessEntityID, LastName, FirstName
    -- Retrieving BusinessEntityID, LastName, and FirstName columns
    FROM Person.BusinessEntityContact AS pb 
        -- Joining Person.BusinessEntityContact with Person.ContactType based on ContactTypeID
        INNER JOIN Person.ContactType AS pc
            ON pc.ContactTypeID = pb.ContactTypeID
        -- Joining Person.BusinessEntityContact with Person.Person based on BusinessEntityID
        INNER JOIN Person.Person AS pp
            ON pp.BusinessEntityID = pb.PersonID
    -- Filtering the results to include only records where the ContactType Name is 'Purchasing Manager'
    WHERE pc.Name = 'Purchasing Manager'
    -- Sorting the results by LastName and FirstName
    ORDER BY LastName, FirstName;

--From the following tables write a query in SQL to retrieve the salesperson for each PostalCode 
--who belongs to a territory and SalesYTD is not zero.
--Return row numbers of each group of PostalCode, last name, salesytd, postalcode column.
--Sort the salesytd of each postalcode group in descending order. Shorts the postalcode in ascending order.
select *from[Sales].[SalesPerson]
select *from[Person].[Person]
select *from[Person].[Address]

SELECT ROW_NUMBER() OVER (PARTITION BY PostalCode ORDER BY SalesYTD DESC) AS "Row Number",
pp.LastName, sp.SalesYTD, pa.PostalCode
FROM Sales.SalesPerson AS sp
    INNER JOIN Person.Person AS pp
        ON sp.BusinessEntityID = pp.BusinessEntityID
    INNER JOIN Person.Address AS pa
        ON pa.AddressID = pp.BusinessEntityID
WHERE TerritoryID IS NOT NULL
    AND SalesYTD <> 0
ORDER BY PostalCode;


--From the following table write a query in SQL to count the number of contacts for combination of each type and name.
--Filter the output for those who have 100 or more contacts.
--Return ContactTypeID and ContactTypeName and BusinessEntityContact.
--Sort the result set in descending order on number of contacts.
select * from [Person].[BusinessEntityContact]
select * from [Person].[ContactType]

select  ct.ContactTypeID,
		ct.Name contactypename,
		count(*) no_of_contact
from [Person].[BusinessEntityContact] bec
inner join [Person].[ContactType] ct
on bec.ContactTypeID = ct.ContactTypeID
group by ct.ContactTypeID, ct.Name
having count(*) >= 100
order by count(*) desc

--From the following table write a query in SQL to retrieve the RateChangeDate,
--full name (first name, middle name and last name) 
--and weekly salary (40 hours in a week) of employees. 
--In the output the RateChangeDate should appears in date format.
Select * from [Person].[Person]
select * from [HumanResources].[EmployeePayHistory]
-- Selecting specific columns and performing calculations on them
SELECT 
    -- Casting the RateChangeDate column to VARCHAR(10) format and aliasing it as FromDate
    CAST(hur.RateChangeDate as VARCHAR(11)) AS FromDate,
    -- Concatenating the LastName, FirstName, and MiddleName columns and aliasing it as NameInFull
    CONCAT(LastName, ', ', FirstName, ' ', MiddleName) AS NameInFull,
    -- Multiplying the Rate column by 40 to calculate the SalaryInAWeek and selecting it as is
    (40 * hur.Rate) AS SalaryInAWeek
-- Joining the Person.Person table with the HumanResources.EmployeePayHistory table based on specific conditions
FROM Person.Person AS pp
    INNER JOIN HumanResources.EmployeePayHistory AS hur
        ON hur.BusinessEntityID = pp.BusinessEntityID
-- Ordering the result set by the concatenated name (NameInFull) in ascending order
ORDER BY NameInFull;

-- From the following tables write a query in SQL to calculate and display the latest weekly salary of each employee.
--Return RateChangeDate, full name (first name, middle name and last name) 
--and weekly salary (40 hours in a week) of employees 
--Sort the output in ascending order on NameInFull.
Select * from [Person].[Person]
select * from [HumanResources].[EmployeePayHistory]
-- Selecting specific columns and performing calculations on them
SELECT 
    -- Casting the RateChangeDate column to VARCHAR(10) format and aliasing it as FromDate
    CAST(hur.RateChangeDate as VARCHAR(10)) AS FromDate,
    -- Concatenating the LastName, FirstName, and MiddleName columns and aliasing it as NameInFull
    CONCAT(LastName, ', ', FirstName, ' ', MiddleName) AS NameInFull,
    -- Multiplying the Rate column by 40 to calculate the SalaryInAWeek and selecting it as is
    (40 * hur.Rate) AS SalaryInAWeek
-- Joining the Person.Person table with the HumanResources.EmployeePayHistory table based on specific conditions
FROM Person.Person AS pp
    INNER JOIN HumanResources.EmployeePayHistory AS hur
        ON hur.BusinessEntityID = pp.BusinessEntityID
-- Filtering the rows where RateChangeDate matches the maximum RateChangeDate for each employee
WHERE hur.RateChangeDate = (
    SELECT MAX(RateChangeDate)
    FROM HumanResources.EmployeePayHistory 
    WHERE BusinessEntityID = hur.BusinessEntityID
)
-- Ordering the result set by the concatenated name (NameInFull) in ascending order
ORDER BY NameInFull;


--From the following table write a query in SQL to find the sum, average, count, minimum, and maximum order quentity
--for those orders whose id are 43659 and 43664. 
--Return SalesOrderID, ProductID, OrderQty, sum, average, count, max, and min order quantity.
select* from [Sales].[SalesOrderDetail];
-- Selecting specific columns from the SalesOrderDetail table along with window functions applied
SELECT 
    SalesOrderID, -- Selecting the SalesOrderID column
    ProductID, -- Selecting the ProductID column
    OrderQty, -- Selecting the OrderQty column
    -- Calculating the sum of OrderQty for each SalesOrderID partition and aliasing it as "Total Quantity"
    SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Total Quantity",
    -- Calculating the average of OrderQty for each SalesOrderID partition and aliasing it as "Avg Quantity"
    AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Avg Quantity",
    -- Counting the number of occurrences of OrderQty for each SalesOrderID partition and aliasing it as "No of Orders"
    COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS "No of Orders",
    -- Finding the minimum value of OrderQty for each SalesOrderID partition and aliasing it as "Min Quantity"
    MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Min Quantity",
    -- Finding the maximum value of OrderQty for each SalesOrderID partition and aliasing it as "Max Quantity"
    MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Max Quantity"
FROM 
    Sales.SalesOrderDetail -- Selecting data from the SalesOrderDetail table
WHERE 
    SalesOrderID IN (43659,43664); -- Filtering the rows where SalesOrderID is either 43659 or 43664

-- From the following table write a query in  SQL to find the sum, average, and number of order quantity
--for those orders whose ids are 43659 and 43664 and product id starting with '71'. 
--Return SalesOrderID, OrderNumber,ProductID, OrderQty, sum, average, and number of order quantity.
select* from [Sales].[SalesOrderDetail]
-- Selecting specific columns from the SalesOrderDetail table along with window functions applied
SELECT 
    SalesOrderID, -- Selecting the SalesOrderID column
    ProductID, -- Selecting the ProductID column
    OrderQty, -- Selecting the OrderQty column
    -- Calculating the sum of OrderQty for each SalesOrderID partition and aliasing it as "Total Quantity"
    SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Total Quantity",
    -- Calculating the average of OrderQty for each SalesOrderID partition and aliasing it as "Avg Quantity"
    AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS "Avg Quantity",
    -- Counting the number of occurrences of OrderQty for each SalesOrderID partition and aliasing it as "No of Orders"
    COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS "No of Orders"
FROM 
    Sales.SalesOrderDetail -- Selecting data from the SalesOrderDetail table
WHERE 
    SalesOrderID IN (43659,43664) and productid like '71%' -- Filtering the rows where SalesOrderID is either 43659 or 43664

SELECT 

    SalesOrderID AS OrderNumber, -- Selecting the SalesOrderID column and renaming it as OrderNumber
    ProductID, -- Selecting the ProductID column
    OrderQty AS Quantity, -- Selecting the OrderQty column and renaming it as Quantity
    SUM(OrderQty) OVER (ORDER BY SalesOrderID, ProductID) AS Total, -- Calculating the cumulative sum of OrderQty over ordered SalesOrderID and ProductID
    AVG(OrderQty) OVER(PARTITION BY SalesOrderID ORDER BY SalesOrderID, ProductID) AS Avg, -- Calculating the average of OrderQty partitioned by SalesOrderID and ordered by SalesOrderID and ProductID
    COUNT(OrderQty) OVER(ORDER BY SalesOrderID, ProductID ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS Count -- Calculating the count of OrderQty over ordered SalesOrderID and ProductID with a window frame of one row before and one row after the current row
FROM 
    Sales.SalesOrderDetail
WHERE 
    SalesOrderID IN(43659,43664) and CAST(ProductID AS TEXT) LIKE '71%'; -- Filtering the rows where SalesOrderID is either 43659 or 43664 and ProductID starts with '71'

---From the following table write a query in SQL to ordered the BusinessEntityID column descendingly
--when SalariedFlag set to 'true' and BusinessEntityID in ascending order when SalariedFlag set to 'false'. 
--Return BusinessEntityID, SalariedFlag columns.
select* from[HumanResources].[Employee]
select BusinessEntityID,
		SalariedFlag
from[HumanResources].[Employee]
order by case SalariedFlag when 'true' then BusinessEntityID end desc,
         case  when salariedflag = 'false' then BusinessEntityID end

--From the following table write a query in SQL to set the result in order by the column
--TerritoryName when the column CountryRegionName is equal to 'United States' and by CountryRegionName for all other rows.
select* from[Sales].[SalesPerson]
-- Selecting specific columns from the vSalesPerson view
SELECT BusinessEntityID, LastName, TerritoryName, CountryRegionName  

-- From the Sales schema's vSalesPerson view
FROM Sales.vSalesPerson  

-- Filtering the results to include only rows where TerritoryName is not NULL
WHERE TerritoryName IS NOT NULL  

-- Ordering the results using a conditional CASE statement
-- If CountryRegionName is 'United States', order by TerritoryName
-- Otherwise, order by CountryRegionName
ORDER BY CASE CountryRegionName WHEN 'United States' THEN TerritoryName  
         ELSE CountryRegionName END

--From the following table write a query in SQL to list all the products that are Red or Blue in color.
--Return name, color and listprice.Sorts this result by the column listprice.
select* from[Production].[Product]
select name,
	   color,
	   ListPrice
from[Production].[Product]
where color = 'Red'
union all
select name,
	   color,
	   ListPrice
from[Production].[Product]
where color = 'Blue'
order by ListPrice

-- Create a SQL query from the SalesOrderDetail table to retrieve the product name and any associated sales orders.
--Additionally, it returns any sales orders that don't have any items mentioned in the Product table
--as well as any products that have sales orders other than those that are listed there. 
--Return product name, salesorderid. Sort the result set on product name column.
select* from[Production].[Product]
select* from[Sales].[SalesOrderDetail]
select pp.Name,
	   SOD.SalesOrderID
from[Production].[Product] pp
full outer join [Sales].[SalesOrderDetail] SOD
on pp.ProductID=SOD.ProductID
order by  pp.Name

--Write a query in SQL to find the employee's full name (firstname and lastname) and city from the following tables. 
--Order the result set on lastname then by firstname.

-- Selecting concatenated full names and cities
SELECT CONCAT((p.FirstName), ' ', (p.LastName)) AS Name, d.City  

-- From the Person schema's Person table, aliasing it as 'p'
FROM Person.Person AS p  

-- Joining Person and Employee tables based on BusinessEntityID
INNER JOIN HumanResources.Employee e ON p.BusinessEntityID = e.BusinessEntityID   

-- Joining an inner query result with Person table based on BusinessEntityID
INNER JOIN  
   (
    -- Selecting BusinessEntityID and City from Address and BusinessEntityAddress tables
    SELECT bea.BusinessEntityID, a.City   
    FROM Person.Address AS a  
    INNER JOIN Person.BusinessEntityAddress AS bea  
    ON a.AddressID = bea.AddressID
   ) AS d  

-- Joining the result of the inner query with Person table based on BusinessEntityID
ON p.BusinessEntityID = d.BusinessEntityID  

-- Ordering the results by last name and first name
ORDER BY p.LastName, p.FirstName;

--Write a SQL query to return the businessentityid,firstname and lastname columns of all persons in the person table 
--(derived table) with persontype is 'IN' and the last name is 'Adams'.
--Sort the result set in ascending order on firstname. 
--A SELECT statement after the FROM clause is a derived table.
select* from[Person].[Person]

select businessentityid
		,firstname
		, lastname
from (select* from[Person].[Person] where PersonType ='IN') as PDT
where lastname= 'Adams'
order by firstname

--Create a SQL query to retrieve individuals from the following table with
--a businessentityid inside 1500, a lastname starting with 'Al', and a firstname starting with 'M'.
select* from[Person].[Person]

select BusinessEntityID,
		LastName,
		FirstName
from[Person].[Person]
where BusinessEntityID <= 1500 and LastName like 'Al%' and FirstName like 'M%'

--Create a SQL query to display the total number of sales orders each sales representative receives annually.
--Sort the result set by SalesPersonID and then by the date component of the orderdate in ascending order.
--Return the year component of the OrderDate, SalesPersonID, and SalesOrderID.
select * from [Sales].[SalesOrderHeader];



-- Common Table Expression (CTE) named Sales_CTE
WITH Sales_CTE 
AS
(
    -- Selecting SalesPersonID, SalesOrderID, and extracting year from OrderDate as SalesYear
    SELECT SalesPersonID, SalesOrderID, year(OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    -- Filtering rows where SalesPersonID is not NULL
    WHERE SalesPersonID IS NOT NULL
)
-- Main query selecting from the Sales_CTE
SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear
FROM Sales_CTE
-- Grouping the results by SalesYear and SalesPersonID
GROUP BY SalesYear, SalesPersonID
-- Ordering the results by SalesPersonID and SalesYear
ORDER BY SalesPersonID, SalesYear;

--From the following table write a query in SQL to find the average number of sales orders 
--for all the years of the sales representatives.

-- Common Table Expression (CTE) named Sales_CTE defined
WITH Sales_CTE 
AS
(
    -- Query to calculate the number of orders per salesperson
    SELECT SalesPersonID, COUNT(*) AS NumberOfOrders

    -- From the SalesOrderHeader table in the Sales schema
    FROM Sales.SalesOrderHeader

    -- Filtering out rows where SalesPersonID is not NULL
    WHERE SalesPersonID IS NOT NULL

    -- Grouping the results by SalesPersonID
    GROUP BY SalesPersonID
)
-- Query to calculate the average number of orders per salesperson
SELECT AVG(NumberOfOrders) AS "Average Sales Per Person"
FROM Sales_CTE;

--Write a SQL query to retrieve the mailing address for any company that is outside the United States (US) 
--and in a city whose name starts with Pa.
--Return Addressline1, Addressline2, city, postalcode, countryregioncode columns.

-- Selecting specific columns from the Address and StateProvince tables
SELECT AddressLine1, AddressLine2, City, PostalCode, CountryRegionCode    

-- From the Person schema's Address table, aliasing it as 'a'
FROM Person.Address AS a  

-- Joining with the StateProvince table based on StateProvinceID
JOIN Person.StateProvince AS s ON a.StateProvinceID = s.StateProvinceID  

-- Filtering the results to include only rows where CountryRegionCode is not 'US' 
-- AND City starts with 'Pa'
WHERE not CountryRegionCode = 'US'  
AND City LIKE 'Pa%' ;

-- From the following tables write a SQL query to retrieve the orders with orderqtys
--greater than 5 or unitpricediscount less than 1000, and totaldues greater than 100.
--Return all the columns from the tables.
select * from[Sales].[SalesOrderDetail]
select * from[Sales].[SalesOrderHeader]

select * from[Sales].[SalesOrderHeader] SOH
join [Sales].[SalesOrderDetail] SOD
on SOH.SalesOrderID= SOD.SalesOrderID
where TotalDue > 100
and (OrderQty >5 or UnitPriceDiscount<1000)

--From the following table write a query in SQL that searches for the word 'red' in the name column.
--Return name, and color columns from the table.
select * from[Production].[Product]
select name,
		Color
from[Production].[Product]
where name like '%Red%'

--From the following table write a query in SQL to find all the products with a price of $80.99 
--that contain the word Mountain. Return name, and listprice columns from the table.
select * from[Production].[Product]
select  Name,
		ListPrice
from[Production].[Product]
where Name like '%Mountain%' and 
ListPrice =80.99

--From the following table write a query in SQL to retrieve all the products that contain either the phrase Mountain or Road. 
--Return name, and color columns.
select * from[Production].[Product]
select Name,
		Color
from[Production].[Product]
where name like '%Mountain%' or name like '%Road%'

--From the following table write a query in SQL to search for name which contains both the word 'Mountain' and the word 'Black'. 
--Return Name and color.
select * from[Production].[Product]
select Name,
		Color
from[Production].[Product]
where name like '%Mountain%' and name like '%Black%'

--From the following table write a query in SQL to return all the product names with at least 
--one word starting with the prefix chain in the Name column.
select * from[Production].[Product]
-- Selecting the 'Name' column from the 'Product' table
SELECT Name,
		Color
-- From the Production schema's Product table
FROM Production.Product
-- Filtering the results to include only rows where the 'Name' column contains at least one word starting with 'chain'
WHERE Name LIKE 'chain %'
   OR Name LIKE '% chain %'
   OR Name LIKE '% chain'
   OR Name LIKE 'chain';

   
--From the following table write a query in SQL to return all category descriptions
--containing strings with prefixes of either chain or full. 
select * from[Production].[Product]
select name,
		Color
from [Production].[Product]
WHERE Name LIKE 'chain %'
   OR Name LIKE '% chain %'
   OR Name LIKE '% chain'
   OR Name LIKE 'chain' or name like 'full%'

--From the following table write a SQL query to output an employee's name and email address, separated by a new line character.
select * from [Person].[Person]
select * from [Person].[EmailAddress]

select CONCAT(firstname,' ',LastName,' ',emailaddress)
from [Person].[Person] pp
join [Person].[EmailAddress] pea
on pp.BusinessEntityID=pea.BusinessEntityID

--From the following table write a SQL query to locate the position of the string "yellow" where it appears in the product name.
select * from[Production].[Product]
select p.Name,
		CHARINDEX('Yellow',Name)
from [Production].[Product] as p
where p.Name like '%yellow%'
order by CHARINDEX('Yellow',Name) asc

-- From the following table write a query in SQL to concatenate the name, color, and productnumber columns.
select * from[Production].[Product]
select CONCAT(name,'  Color: ',Color,' Product Number : ',ProductNumber) as results,
		Color
from [Production].[Product]

--Write a SQL query that concatenate the columns name, productnumber, colour,
--and a new line character from the following table, each separated by a specified character.
select * from[Production].[Product]
select CONCAT_WS(' ',Name,ProductNumber,Color) as results
from[Production].[Product]

--From the following table write a query in SQL to return the five leftmost characters of each product name.
select * from[Production].[Product]
select left(name,5) as ledt
from[Production].[Product]

-- From the following table write a query in SQL to select the number of characters 
--the data in FirstName for people located in Australia.
select * from[Sales].[vIndividualCustomer];
select len(FirstName) as length,
		FirstName, 
		LastName
from [Sales].[vindividualcustomer]
where CountryRegionName='Australia'

--From the following tables write a query in SQL to return the number of characters 
--in the column FirstName and the first and last name of contacts located in Australia.
select * from[Sales].[vStoreWithContacts]
select * from[Sales].[vStoreWithAddresses]
select len(FirstName) as  fnamelength,
		FirstName,
		LastName
from[Sales].[vStoreWithContacts] as c
    join [Sales].[vStoreWithAddresses] as a
	on c.BusinessEntityID=a.BusinessEntityID
order by fnamelength

--From the following table write a query in SQL to select product names that have prices between $1000.00 and $1220.00.
--Return product name as Lower, Upper, and also LowerUpper.
select * from[Production].[Product]
select lower(name) as LowerName,
		upper(Name) as UpperName
from [Production].[Product]
where ListPrice between 1000 and 1220

-- Write a query in SQL to remove the spaces from the beginning of a string.
-- Selecting a string containing five leading spaces followed by the text 'five space then the text', and aliasing it as "Original Text"
SELECT  '     five space then the text' as "Original Text",
-- Removing leading spaces from the string '     five space then the text' using the LTRIM() function, and aliasing the result as "Trimmed Text(space removed)"
LTRIM('     five space then the text') as "Trimmed Text(space removed)";

--From the following table write a query in SQL to remove the substring 'HN' from the start of the column productnumber.
--Filter the results to only show those productnumbers that start with "HN". 
--Return original productnumber column and 'TrimmedProductnumber'.  Go to the editor
select * from[Production].[Product]
select ProductNumber, substring(ProductNumber,3,10)
from [Production].[Product]
where ProductNumber like 'HN%'

--From the following table write a query in SQL to repeat a 0 character four times in front of a production line
--for production line 'T'.  Go to the editor
select * from[Production].[Product]
SELECT Name, 
		CASE 
        WHEN ProductLine = 'T' 
        THEN REPLICATE('0', 4) + ProductLine 
        ELSE ProductLine 
    END AS ProductionLineWithZeros
-- From the Production schema's Product table
FROM [Production].[Product]
-- Filtering the results to include only rows where the 'ProductLine' column is 'T'
WHERE ProductLine = 'T'  
-- Ordering the result set by the 'Name' column
ORDER BY Name;

--From the following table write a SQL query to retrieve all contact first names with the characters inverted 
--for people whose businessentityid is less than 6.
select * from[Person].[Person]
select FirstName, 
		REVERSE(FirstName) as 'REVERSE'
from [Person].[Person]
where BusinessEntityID<6
order by FirstName

--From the following table write a query in SQL to replace null values with 'N/A' 
--and return the names separated by commas in a single row.  
select * from[Person].[Person]
select coalesce(firstName,'N/A') as Name
from[Person].[Person] as p

-- From the following table write a query in SQL to return the names and modified date separated by commas in a single row. 
--Go to the editor
select * from[Person].[Person]

SELECT 
    STRING_AGG(CAST(FirstName + ' ' + LastName AS NVARCHAR(MAX)), ', ') AS FullNames,
    STRING_AGG(CAST(CONVERT(VARCHAR, ModifiedDate, 120) AS NVARCHAR(MAX)), ', ') AS ModifiedDates
FROM Person.Person;

--From the following table write a query in SQL to find the email addresses of employees and groups them by city.
--Return top ten rows.  Go to the editor
select * from  [Person].[BusinessEntityAddress]
select * from  [Person].[Address]
select * from  [Person].[EmailAddress]

SELECT TOP 10
    a.City,
	STRING_AGG(cast(e.EmailAddress as varchar(max)), ';') AS EmailAddresses
FROM 
    Person.BusinessEntityAddress bea
JOIN 
    Person.Address a ON bea.AddressID = a.AddressID
JOIN 
    Person.EmailAddress e ON bea.BusinessEntityID = e.BusinessEntityID
GROUP BY 
    a.City
ORDER BY 
    a.City;

--From the following table write a query in SQL to create a new job title called "Production Assistant"
--in place of "Production Supervisor". 
select * from [HumanResources].[Employee]
select JobTitle, REPLACE(JobTitle,'Supervisor','Assistant') as New_JobTitle
from [HumanResources].[Employee]
where JobTitle like '%Supervisor%'
order by JobTitle

-- From the following table write a SQL query to retrieve all the employees whose job titles begin with "Sales". Return firstname, middlename, lastname and jobtitle column.  Go to the editor
select * from [Person].[Person]
select FirstName, 
		MiddleName, 
		LastName, 
		JobTitle
from Person.Person  as p
    join HumanResources.Employee as e on  p.BusinessEntityID=e.BusinessEntityID
where JobTitle like 'Sales%'

-- From the following table write a query in SQL to return the last name of people so that it is in
--uppercase, trimmed, and concatenated with the first name.
select * from [Person].[Person]
SELECT CONCAT(UPPER(TRIM(LastName)),' , ',FirstName) as name
from [Person].[Person]

--From the following table write a query in SQL to show a resulting expression that is too small to display. 
--Return FirstName, LastName, Title, and SickLeaveHours. --
--The SickLeaveHours willources].[Employee]
select * from [Person].[Person]

-- Selecting the first name, last name, truncated title, and sick leave hours of employees
SELECT p.FirstName, p.LastName, SUBSTRING(p.Title, 1, 25) AS Title,
    CAST(e.SickLeaveHours AS char(1)) AS "Sick Leave"  
-- From the HumanResources schema's Employee table aliased as 'e' 
-- Joined with the Person schema's Person table aliased as 'p' based on matching BusinessEntityID
FROM HumanResources.Employee e JOIN Person.Person p 
    ON e.BusinessEntityID = p.BusinessEntityID  
-- Filtering the results to exclude rows where the BusinessEntityID is greater than 5
WHERE NOT e.BusinessEntityID > 5;

--From the following table write a query in SQL to calculate by dividing the total year-to-date sales (SalesYTD)
--by the commission percentage (CommissionPCT).
--Return SalesYTD, CommissionPCT, and the value rounded to the nearest whole number.
SELECT * FROM [Sales].[SalesPerson]
select salesytd, CommissionPct,
       CAST(ROUND(SalesYTD / CommissionPct, 0) AS INT)
from [Sales].[SalesPerson]
WHERE CommissionPCT != 0

-- From the following table write a query in SQL to find those persons that have a 2 in the first digit of their SalesYTD.
--Convert the SalesYTD column to an int type, and then to a char(20) type.
--Return FirstName, LastName, SalesYTD, and BusinessEntityID.
SELECT * FROM[Person].[Person]
SELECT * FROM[Sales].[SalesPerson]
select FirstName,
	   LastName, 
	   CAST(CAST(SalesYTD as INT) as Char(20)) as salesytd, sp.BusinessEntityID
from Sales.SalesPerson as sp
    join Person.Person as p on sp.BusinessEntityID=p.BusinessEntityID
where SalesYTD like '2%'


-- From the following table write a query in SQL to convert the Name column to a char(16) column. 
--Convert those rows if the name starts with 'Long-Sleeve Logo Jersey'. 
--Return name of the product and listprice.  Go to the editor
SELECT * FROM [Production].[Product]
select cast(name as CHAR(16)) as name, ListPrice
from [Production].[Product]
where name like 'Long-Sleeve Logo Jersey%'

--From the following table write a SQL query to determine the discount price for the salesorderid 46672.
--Calculate only those orders with discounts of more than.02 percent.
--Return productid, UnitPrice, UnitPriceDiscount, and DiscountPrice (UnitPrice*UnitPriceDiscount ).
SELECT * FROM [Sales].[SalesOrderDetail]
SELECT productid, UnitPrice,
	   UnitPriceDiscount,  
       CAST(ROUND(UnitPrice * UnitPriceDiscount, 0) AS int) AS DiscountPrice  
FROM sales.salesorderdetail  
WHERE SalesOrderid = 46672   
      AND UnitPriceDiscount > .02;

--From the following table write a query in SQL to calculate the average vacation hours,
--and the sum of sick leave hours, that the vice presidents have used.
SELECT * FROM [HumanResources].[Employee]

select avg(VacationHours) as 'Average Vacinations Hours', 
       sum(SickLeaveHours) as 'Total sick leave hours'
from [HumanResources].[Employee]
where JobTitle like '%Vice President%'

--From the following table write a query in SQL to calculate the average bonus received and the sum of year-to-date sales
--for each territory. Return territoryid, Average bonus, and YTD sales. 
SELECT * FROM [Sales].[SalesPerson]
select TerritoryID,
	   AVG(Bonus),
	   sum(SalesYTD)
from [Sales].[SalesPerson]
GROUP by TerritoryID


--From the following table write a query in SQL to return the average list price of products.
--Consider the calculation only on unique values.
SELECT * FROM [Production].[Product]
SELECT AVG(DISTINCT ListPrice)
FROM [Production].[Product]


--88 From the following table write a query in SQL to return a moving average of yearly sales for each territory. Return BusinessEntityID, TerritoryID, SalesYear, SalesYTD, average SalesYTD as MovingAvg, and total SalesYTD as CumulativeTotal.  Go to the editor
SELECT * FROM [Sales].[SalesPerson]
SELECT BusinessEntityID, TerritoryID   
   ,YEAR( ModifiedDate) AS SalesYear  -- Extracting the year from the ModifiedDate column
   ,CAST(SalesYTD AS VARCHAR(20)) AS SalesYTD  -- Converting SalesYTD to VARCHAR data type
   ,AVG(SalesYTD) OVER (PARTITION BY TerritoryID ORDER BY YEAR( ModifiedDate)) AS MovingAvg  -- Calculating moving average of SalesYTD partitioned by TerritoryID
   ,SUM(SalesYTD) OVER (PARTITION BY TerritoryID ORDER BY YEAR( ModifiedDate)) AS CumulativeTotal  -- Calculating cumulative total of SalesYTD partitioned by TerritoryID
FROM [Sales].[SalesPerson] -- From the SalesPerson table
-- Filtering the results to include only rows where TerritoryID is NULL or less than 5
WHERE TerritoryID IS NULL OR TerritoryID < 5  
-- Ordering the results by TerritoryID and SalesYear
ORDER BY TerritoryID, SalesYear;

--From the following table write a query in SQL to return a moving average of sales, by year,
--for all sales territories. Return BusinessEntityID, TerritoryID, SalesYear, SalesYTD, average SalesYTD as MovingAvg,
--and total SalesYTD as CumulativeTotal.
SELECT * FROM[Sales].[SalesPerson]
-- Selecting BusinessEntityID, TerritoryID, SalesYear, SalesYTD, MovingAvg, and CumulativeTotal
SELECT BusinessEntityID, TerritoryID   
   ,YEAR(ModifiedDate) AS SalesYear  -- Extracting the year from the ModifiedDate column as SalesYear
   ,CAST(SalesYTD AS VARCHAR(20)) AS SalesYTD  -- Converting SalesYTD to VARCHAR type
   ,AVG(SalesYTD) OVER (ORDER BY YEAR(ModifiedDate)) AS MovingAvg  -- Calculating moving average of SalesYTD
   ,SUM(SalesYTD) OVER (ORDER BY YEAR(ModifiedDate)) AS CumulativeTotal  -- Calculating cumulative total of SalesYTD
FROM  [Sales].[SalesPerson]
WHERE TerritoryID IS NULL OR TerritoryID < 5  -- Filtering rows with TerritoryID being NULL or less than 5
ORDER BY SalesYear;  -- Ordering the result set by SalesYear

--From the following table write a query in SQL to return the number of different titles that employees can hold.
SELECT * FROM [HumanResources].[Employee]
select Count( DISTINCT  JobTitle ) as 'Number of Jobtitles'
from HumanResources.Employee 


--From the following table write a query in SQL to find the total number of employees.  Go to the editor
SELECT * FROM [HumanResources].[Employee]
select count( *) as "Number of Employees"
from [HumanResources].[Employee]


--From the following table write a query in SQL to find the average bonus for the salespersons 
--who achieved the sales quota above 25000. 
--Return number of salespersons, and average bonus.
SELECT * FROM [Sales].[SalesPerson]
select count(BusinessEntityID) as count, 
	   avg(Bonus) as average
from [Sales].[SalesPerson]
where SalesQuota>25000


--From the following tables wirte a query in SQL to return aggregated values for each department.
--Return name, minimum salary, maximum salary, average salary, and number of employees in each department.
SELECT * FROM[HumanResources].[EmployeePayHistory]
SELECT * FROM[HumanResources].[EmployeeDepartmentHistory]
SELECT * FROM[HumanResources].[Department];
select Name,
	   min(Rate), 
	   max(Rate), 
	   avg(Rate), 
	   COUNT(*)
from HumanResources.employeedepartmenthistory as edh
    join HumanResources.employeepayhistory as eph on edh.BusinessEntityID=eph.BusinessEntityID
    join HumanResources.Department as d on edh.DepartmentID=d.DepartmentID
group by Name

--From the following tables write a SQL query to return the departments of a company that each have more than 15 employees. 
select * from[HumanResources].[Employee]
Select JobTitle, count(BusinessEntityID) as employeeindsig
from [HumanResources].[Employee]
group by JobTitle
having count(BusinessEntityID) >15
order by count(BusinessEntityID) desc


--From the following table write a query in SQL to find the number of products that ordered in each of the specified sales orders.
Select * from [Sales].[SalesOrderDetail]
select sod.SalesOrderID, COUNT(ProductID ) as ProductCount
from Sales.[Sales].[SalesOrderDetail] as sod
group by sod.SalesOrderID
order by sod.SalesOrderID

--From the following table write a query in SQL to compute the statistical variance of the sales quota values for each quarter 
--in a calendar year for a sales person. Return year, quarter, salesquota and variance of salesquota. 
Select * from[Sales].[SalesPersonQuotaHistory]
-- Selecting columns and calculating variance of sales quota over quarters for a specific salesperson in 2012
SELECT quotadate AS Year, datepart(quarter,quotadate) AS Quarter, SalesQuota AS SalesQuota,  
       var(SalesQuota) OVER (ORDER BY datepart(year,quotadate), datepart(quarter,quotadate)) AS Variance  
-- From the salesperson quota history table
FROM sales.salespersonquotahistory  
-- Filtering for a specific salesperson and year
WHERE businessentityid = 277 AND datepart(year,quotadate) = 2012  
-- Ordering the results by quarter
ORDER BY datepart(quarter,quotadate);
--From the following table write a query in SQL to populate the variance of all unique values as well as all values, including any duplicates values of SalesQuota column.  Go to the editor
Select * from [Sales].[SalesPersonQuotaHistory]
-- Calculating the population variance for distinct and all values of SalesQuota
SELECT varp(DISTINCT SalesQuota) AS Distinct_Values, varp(SalesQuota) AS All_Values  
-- From the salesperson quota history table
FROM sales.salespersonquotahistory;

--From the following table write a query in SQL to return the total ListPrice and StandardCost of products for each color.
--Products that name starts with 'Mountain' and ListPrice is more than zero. Return Color, total list price, 
--total standardcode. Sort the result set on color in ascending order.
Select * from [Production].[Product]
select color,
	   sum(ListPrice) as 'listPrice Sum', 
	   sum(StandardCost) as 'standard cost Sum'
from production.Product
where name like 'Mountain%'
		   AND ListPrice != 0.00   
group by Color

--From the following table write a query in SQL to calculate the sum of the ListPrice and StandardCost for each color.
--Return color, sum of ListPrice.
--Sample table: production.Product

select color,
	   sum(ListPrice) as 'listPrice Sum', 
	   sum(StandardCost) as 'standard cost Sum'
from production.Product
group by Color
