--Поставщики, у которых не было сделано ни одного заказа
select a.SupplierName, count(b.SupplierTransactionID) as CntTransactions
from [Purchasing].[Suppliers] a left join
(select SupplierID, SupplierTransactionID from [Purchasing].[SupplierTransactions]) b on b.SupplierID = a.SupplierID
group by a.SupplierID, a.SupplierName
having count(b.SupplierTransactionID) = 0


--Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа, 
--включите также к какой трети года относится дата - каждая треть по 4 месяца, 
--дата забора заказа должна быть задана, с ценой товара более 100$ либо количество единиц товара более 20. 
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


--Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей. 
--Соритровка должна быть по номеру квартала, трети года, дате продажи.
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


-- Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post, 
--добавьте название поставщика, имя контактного лица принимавшего заказ
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


--10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ
select top 10 
	c.CustomerName as Customer,
	d.FullName as Employee,
	a.TransactionAmount
from [Sales].[CustomerTransactions] as a left join
(select InvoiceID, ContactPersonID from [Sales].[Invoices]) as b on b.InvoiceID = a.InvoiceID left join
(select CustomerID, CustomerName from [Sales].[Customers]) as c on c.CustomerID = a.CustomerID left join
(select PersonID, FullName from [Application].[People]) as d on d.PersonID = b.ContactPersonID
order by TransactionDate desc


--Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g
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