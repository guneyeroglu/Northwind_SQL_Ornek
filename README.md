# Northwind_SQL_Ornek

--Örnek 1 (Hangi üründen ne kadar sipariş edildiğinin, yıllara göre gruplandırılmış listesi)

SELECT P.ProductName AS 'Product Name', ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) AS 'Total' , DATENAME(YEAR, O.OrderDate) AS 'Year'
FROM Products P
JOIN [Order Details] OD ON P.ProductID = OD.ProductID
JOIN Orders O ON OD.OrderID = O.OrderID
GROUP BY DATENAME(YEAR, O.OrderDate), P.ProductName

--Örnek 2 (Her bir çalışanın sorumlu olduğu satış bölgesinin listesi)

SELECT E.FirstName AS 'First Name', T.TerritoryDescription AS 'Territory Description'
FROM Employees E
JOIN EmployeeTerritories ET ON E.EmployeeID = ET.EmployeeID
JOIN Territories T ON ET.TerritoryID = T.TerritoryID

--Örnek 3 (Ortalama fiyatın üstünde satılan ürünlerin listesi)

SELECT P.ProductName AS 'Product Name', OD.UnitPrice AS 'Unit Price'
FROM [Order Details] OD
JOIN Products P ON OD.ProductID = P.ProductID
GROUP BY P.ProductName, OD.UnitPrice HAVING OD.UnitPrice > (SELECT AVG(OD_2.UnitPrice) FROM [Order Details] OD_2)
ORDER BY OD.UnitPrice DESC

--Örnek 4 (Henüz sipariş vermemiş olan müşterilerin listesi)

SELECT C.CustomerID AS 'Customer ID'
FROM Customers C
FULL JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL

--Örnek 5 (Satış ortalamasının üstünde kalan, 28 yıldan fazla çalışmış kişilerin; isimlerinin, işe giriş tarihlerinin ve toplam satışlarının listesi)

SELECT E.FirstName AS 'First Name', ROUND(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 2) AS 'Total', E.HireDate AS 'Hire Date'
FROM Employees E
JOIN Orders O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] OD ON O.OrderID = OD.OrderID
WHERE DATENAME(YEAR, E.HireDate) < (SELECT DATEPART(YEAR, GETDATE())) - 28
GROUP BY E.FirstName, E.HireDate HAVING SUM (OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) > (SELECT AVG(OD_2.UnitPrice * OD_2.Quantity * (1 - OD_2.Discount)) FROM [Order Details] OD_2)
ORDER BY 'Total' DESC
