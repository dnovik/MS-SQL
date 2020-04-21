--1. �������� �����������, ������� �������� ������������, � ��� �� ������� �� ����� �������.
select PersonID, FullName from Application.People
where IsSalesperson = 1 and not exists (
select SalespersonPersonID from Sales.Orders);

--2. �������� ������ � ����������� ����� (�����������), 2 �������� ����������.
select StockItemName, UnitPrice from Warehouse.StockItems
where UnitPrice in (select min(UnitPrice) from Warehouse.StockItems);

select 
StockItemName, 
UnitPrice
from Warehouse.StockItems
where UnitPrice = (select min(UnitPrice) from Warehouse.StockItems);

--3. �������� ���������� �� ��������, ������� �������� �������� 5 ������������ �������� �� [Sales].[CustomerTransactions] 
--����������� 3 ������� (� ��� ����� � CTE)

with Top5Customers_CTE
as
(select top 5
c.CustomerName, 
c.CreditLimit, 
c.IsStatementSent, 
ct.TransactionAmount from Sales.CustomerTransactions ct
left join Sales.Customers c
on c.CustomerID=ct.CustomerID
order by TransactionAmount desc)
select * from Top5Customers_CTE;


select top 5
	CustomerName,
	CreditLimit,
	IsStatementSent
from Sales.Customers
where CustomerID in (select top 5 CustomerID
	from Sales.CustomerTransactions 
	order by TransactionAmount desc);



select top 5 CustomerID
from Sales.CustomerTransactions
group by CustomerID
order by MAX(TransactionAmount) desc

--4. �������� ������ (�� � ��������), � ������� ���� ���������� ������, �������� � ������ ����� ������� �������, 
--� ����� ��� ����������, ������� ����������� �������� �������
select c.PostalCityID, cs.CityName, p.FullName from Sales.Orders as o
inner join Sales.Customers as c
on c.CustomerID=o.CustomerID
inner join Application.Cities as cs
on cs.CityID=c.PostalCityID
inner join Application.People as p
on p.PersonID=o.SalespersonPersonID
where OrderID in (
select OrderID from Sales.OrderLines
where StockItemID in
(select top 3 with ties
StockItemID
from Warehouse.StockItems
order by UnitPrice desc))


--5. ���������, ��� ������ � ������������� ������:
SELECT
Invoices.InvoiceID,
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice,
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
FROM Sales.OrderLines
WHERE OrderLines.OrderId = (SELECT Orders.OrderId
FROM Sales.Orders
WHERE Orders.PickingCompletedWhen IS NOT NULL
AND Orders.OrderId = Invoices.OrderId)
) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals

ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC;