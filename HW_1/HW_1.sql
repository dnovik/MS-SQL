
--1. ��� ������, � ������� � �������� ���� ������� urgent ��� �������� ���������� � Animal
select StockItemName from Warehouse.StockItems
where StockItemName like 'Animal%' or StockItemName like '%urgent%'


--2. ����������, � ������� �� ���� ������� �� ������ ������
select supp.SupplierName, count(sutr.SupplierTransactionID) as CntTransactions
from [Purchasing].[Suppliers] supp 
left join [Purchasing].[SupplierTransactions] sutr on sutr.SupplierID = supp.SupplierID
group by supp.SupplierID, supp.SupplierName
having count(sutr.SupplierTransactionID) = 0


--3.1. ������� � ��������� ������, � ������� ���� �������, ������� ��������, � �������� ��������� �������, 
--�������� ����� � ����� ����� ���� ��������� ���� - ������ ����� �� 4 ������, 
--���� ������ ������ ������ ���� ������, � ����� ������ ����� 100$ ���� ���������� ������ ������ ����� 20. 
select 
	ct.TransactionDate, 
	DATENAME(MONTH, ct.TransactionDate) as [MonthName],
	DATENAME(QUARTER, ct.TransactionDate) as [Quarter],
	CEILING(MONTH(ct.TransactionDate) / 4.00) as [Part],
	ol.PickingCompletedWhen as PickingDate,
	ct.TransactionAmount
from [Sales].[CustomerTransactions] as ct
inner join Sales.Invoices as inv on inv.InvoiceID = ct.InvoiceID 
inner join Sales.OrderLines as ol on ol.OrderID = inv.OrderID
where ol.UnitPrice > 100 or ol.Quantity > 20 and ol.PickingCompletedWhen is not null


--3.2. �������� ������� ����� ������� � ������������ �������� ��������� ������ 1000 � ��������� ��������� 100 �������. 
--���������� ������ ���� �� ������ ��������, ����� ����, ���� �������.
select 
	ct.TransactionDate, 
	DATENAME(MONTH, ct.TransactionDate) as [MonthName],
	DATENAME(QUARTER, ct.TransactionDate) as [Quarter],
	CEILING(MONTH(ct.TransactionDate) / 4.00) as [Part],
	ol.PickingCompletedWhen as PickingDate,
	ct.TransactionAmount
from [Sales].[CustomerTransactions] as ct
inner join Sales.Invoices as inv on inv.InvoiceID = ct.InvoiceID 
inner join Sales.OrderLines as ol on ol.OrderID = inv.OrderID
where ol.UnitPrice > 100 or ol.Quantity > 20 and ol.PickingCompletedWhen is not null
order by [Quarter], [Part], [TransactionDate]
offset 1000 rows fetch next 100 rows only


-- 4. ������ �����������, ������� ���� ��������� �� 2014� ��� � ��������� Road Freight ��� Post, 
--�������� �������� ����������, ��� ����������� ���� ������������ �����
select
	supp.SupplierName as 'SupplierName',
	pe.FullName as 'ContactPerson',
	count(po.PurchaseOrderID) as 'CntPurchaseOrders'
from [Purchasing].[PurchaseOrders] as po 
inner join [Application].[DeliveryMethods] as dm on dm.DeliveryMethodID = po.DeliveryMethodID 
inner join [Purchasing].[Suppliers] as supp on supp.SupplierID = po.SupplierID 
inner join [Application].[People] as pe on pe.PersonID = po.ContactPersonID
where YEAR(po.ExpectedDeliveryDate) = '2014' and dm.DeliveryMethodName in ('Post', 'Road Freight')
group by supp.SupplierName, pe.FullName


--5. 10 ��������� �� ���� ������ � ������ ������� � ������ ����������, ������� ������� �����
select top 10 
	c.CustomerName as Customer,
	pe.FullName as Employee,
	a.TransactionAmount
from [Sales].[CustomerTransactions] as a 
inner join [Sales].[Invoices] as inv on inv.InvoiceID = a.InvoiceID 
inner join [Sales].[Customers] as c on c.CustomerID = a.CustomerID 
inner join [Application].[People] as pe on pe.PersonID = inv.ContactPersonID
order by TransactionDate desc


--6. ��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g
select 
	o.CustomerID,
	c.CustomerName,
	c.PhoneNumber,
	c.FaxNumber
from [Sales].[Orders] as o 
inner join Sales.Customers as c on c.CustomerID = o.CustomerID 
inner join Sales.OrderLines as ol on ol.OrderID = o.OrderID 
inner join Warehouse.StockItems as si on si.StockItemID = ol.StockItemID
where si.StockItemName = 'Chocolate frogs 250g'