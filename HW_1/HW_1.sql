
--1. Все товары, в которых в название есть пометка urgent или название начинается с Animal
select StockItemName from Warehouse.StockItems
where StockItemName like 'Animal%' or StockItemName like '%urgent%'


--2. Поставщики, у которых не было сделано ни одного заказа
select supp.SupplierName, count(sutr.SupplierTransactionID) as CntTransactions
from [Purchasing].[Suppliers] supp 
left join [Purchasing].[SupplierTransactions] sutr on sutr.SupplierID = supp.SupplierID
group by supp.SupplierID, supp.SupplierName
having count(sutr.SupplierTransactionID) = 0


--3.1. Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа, 
--включите также к какой трети года относится дата - каждая треть по 4 месяца, 
--дата забора заказа должна быть задана, с ценой товара более 100$ либо количество единиц товара более 20. 
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


--3.2. Добавьте вариант этого запроса с постраничной выборкой пропустив первую 1000 и отобразив следующие 100 записей. 
--Соритровка должна быть по номеру квартала, трети года, дате продажи.
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


-- 4. Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post, 
--добавьте название поставщика, имя контактного лица принимавшего заказ
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


--5. 10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ
select top 10 
	c.CustomerName as Customer,
	pe.FullName as Employee,
	a.TransactionAmount
from [Sales].[CustomerTransactions] as a 
inner join [Sales].[Invoices] as inv on inv.InvoiceID = a.InvoiceID 
inner join [Sales].[Customers] as c on c.CustomerID = a.CustomerID 
inner join [Application].[People] as pe on pe.PersonID = inv.ContactPersonID
order by TransactionDate desc


--6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g
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