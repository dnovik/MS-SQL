--����������, � ������� �� ���� ������� �� ������ ������
select a.SupplierName, count(b.SupplierTransactionID) as CntTransactions
from [Purchasing].[Suppliers] a left join
(select SupplierID, SupplierTransactionID from [Purchasing].[SupplierTransactions]) b on b.SupplierID = a.SupplierID
group by a.SupplierID, a.SupplierName
having count(b.SupplierTransactionID) = 0


--������� � ��������� ������, � ������� ���� �������, ������� ��������, � �������� ��������� �������, 
--�������� ����� � ����� ����� ���� ��������� ���� - ������ ����� �� 4 ������, 
--���� ������ ������ ������ ���� ������, � ����� ������ ����� 100$ ���� ���������� ������ ������ ����� 20. 
select 
	[TransactionDate], 
	DATENAME(MONTH, [TransactionDate]) as [MonthName],
	DATENAME(QUARTER, [TransactionDate]) as [Quarter],
	CASE 
	WHEN MONTH([TransactionDate]) in (1,2,3,4) THEN 1
	WHEN MONTH([TransactionDate]) in (5,6,7,8) THEN 2
	WHEN MONTH([TransactionDate]) in (9,10,11,12) THEN 3
	END as [Part],
	c.PickingCompletedWhen as PickingDate,
	TransactionAmount
from [Sales].[CustomerTransactions] as a left join
(select InvoiceID, OrderID from [Sales].[Invoices]) as b on b.InvoiceID = a.InvoiceID left join
(select OrderID, PickingCompletedWhen from [Sales].[OrderLines] 
where UnitPrice > 100 or Quantity > 20 and PickingCompletedWhen is not null) as c on c.OrderID = b.OrderID


--�������� ������� ����� ������� � ������������ �������� ��������� ������ 1000 � ��������� ��������� 100 �������. 
--���������� ������ ���� �� ������ ��������, ����� ����, ���� �������.
select 
	[TransactionDate], 
	DATENAME(MONTH, [TransactionDate]) as [MonthName],
	DATENAME(QUARTER, [TransactionDate]) as [Quarter],
	CASE 
	WHEN MONTH([TransactionDate]) in (1,2,3,4) THEN 1
	WHEN MONTH([TransactionDate]) in (5,6,7,8) THEN 2
	WHEN MONTH([TransactionDate]) in (9,10,11,12) THEN 3
	END as [Part],
	c.PickingCompletedWhen as PickingDate,
	TransactionAmount
from [Sales].[CustomerTransactions] as a left join
(select InvoiceID, OrderID from [Sales].[Invoices]) as b on b.InvoiceID = a.InvoiceID left join
(select OrderID, PickingCompletedWhen from [Sales].[OrderLines] 
where UnitPrice > 100 or Quantity > 20 and PickingCompletedWhen is not null) as c on c.OrderID = b.OrderID
order by [Quarter], [Part], [TransactionDate]
offset 1000 rows fetch next 100 rows only


-- ������ �����������, ������� ���� ��������� �� 2014� ��� � ��������� Road Freight ��� Post, 
--�������� �������� ����������, ��� ����������� ���� ������������ �����
select
	c.SupplierName as SupplierName,
	d.FullName as ContactPerson,
	count(PurchaseOrderID) as CntPurchaseOrders
from [Purchasing].[PurchaseOrders] as a left join
(select DeliveryMethodID, DeliveryMethodName from [Application].[DeliveryMethods] 
where DeliveryMethodName in ('Post', 'Road Freight')) as b on b.DeliveryMethodID = a.DeliveryMethodID left join
(select SupplierID, SupplierName from [Purchasing].[Suppliers]) as c on c.SupplierID = a.SupplierID left join
(select PersonID, FullName from [Application].[People]) as d on d.PersonID = a.ContactPersonID
where YEAR(OrderDate) = '2014'
group by c.SupplierName, d.FullName


--10 ��������� �� ���� ������ � ������ ������� � ������ ����������, ������� ������� �����
select top 10 
	c.CustomerName as Customer,
	d.FullName as Employee,
	a.TransactionAmount
from [Sales].[CustomerTransactions] as a left join
(select InvoiceID, ContactPersonID from [Sales].[Invoices]) as b on b.InvoiceID = a.InvoiceID left join
(select CustomerID, CustomerName from [Sales].[Customers]) as c on c.CustomerID = a.CustomerID left join
(select PersonID, FullName from [Application].[People]) as d on d.PersonID = b.ContactPersonID
order by TransactionDate desc


--��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g
select 
	a.CustomerID,
	b.CustomerName,
	b.PhoneNumber,
	b.FaxNumber
from [Sales].[Orders] as a inner join
(select CustomerID, CustomerName, PhoneNumber, FaxNumber from [Sales].[Customers_Archive]) as b on b.CustomerID = a.CustomerID left join
(select OrderID, StockItemID from [Sales].[OrderLines]) as c on c.OrderID = a.OrderID left join
(select StockItemID, StockItemName from [Warehouse].[StockItems] where StockItemName = 'Chocolate frogs 250g') as d on d.StockItemID = c.StockItemID
where d.StockItemName = 'Chocolate frogs 250g'