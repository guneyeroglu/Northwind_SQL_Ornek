--�rnek 1 (Hangi �r�nden ne kadar sipari� edildi�inin, y�llara g�re grupland�r�lm�� listesi)

SELECT P.ProductName as 'Product Name', ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) as 'Total' , DATENAME(YEAR, O.OrderDate) as 'Year'
FROM Products P
JOIN [Order Details] OD on P.ProductID = OD.ProductID
JOIN Orders O on OD.OrderID = O.OrderID
GROUP BY DATENAME(YEAR, O.OrderDate), P.ProductName

--�rnek 2 (Her bir �al��an�n sorumlu oldu�u sat�� b�lgesinin listesi)

SELECT E.FirstName as 'First Name', T.TerritoryDescription as 'Territory Description'
FROM Employees E
JOIN EmployeeTerritories ET on E.EmployeeID = ET.EmployeeID
JOIN Territories T on ET.TerritoryID = T.TerritoryID

--�rnek 3 (Ortalama fiyat�n �st�nde sat�lan �r�nlerin listesi)

SELECT P.ProductName as 'Product Name', OD.UnitPrice as 'Unit Price'
FROM [Order Details] OD
JOIN Products P on OD.ProductID = P.ProductID
GROUP BY P.ProductName, OD.UnitPrice HAVING OD.UnitPrice > (SELECT AVG(OD_2.UnitPrice) FROM [Order Details] OD_2)
ORDER BY OD.UnitPrice DESC

--�rnek 4 (Hen�z sipari� vermemi� olan m��terilerin listesi)

SELECT C.CustomerID as 'Customer ID'
FROM Customers C
FULL JOIN Orders O on C.CustomerID = O.CustomerID
WHERE O.OrderID is null

--�rnek 5 (Sat�� ortalamas�n�n �st�nde kalan, 28 y�ldan fazla �al��m�� ki�ilerin; isimlerinin, i�e giri� tarihlerinin ve toplam sat��lar�n�n listesi)

SELECT E.FirstName as 'First Name', ROUND(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 2) as 'Total', E.HireDate as 'Hire Date'
FROM Employees E
JOIN Orders O on E.EmployeeID = O.EmployeeID
JOIN [Order Details] OD on O.OrderID = OD.OrderID
WHERE DATENAME(YEAR, E.HireDate) < (SELECT DATEPART(YEAR, GETDATE())) - 28
GROUP BY E.FirstName, E.HireDate HAVING SUM (OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) > (SELECT AVG(OD_2.UnitPrice * OD_2.Quantity * (1 - OD_2.Discount)) FROM [Order Details] OD_2)
ORDER BY 'Total' DESC