

--3. Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей из [Sales].[CustomerTransactions] 
--представьте 3 способа (в том числе с CTE)
--4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, 
--а также Имя сотрудника, который осуществлял упаковку заказов


--1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.
select PersonID, FullName from Application.People
where IsSalesperson = 1 and not exists (
select SalespersonPersonID from Sales.Orders)

--2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса.
select StockItemName, UnitPrice from Warehouse.StockItems
where exists (select min(UnitPrice) from Warehouse.StockItems)

select 
	StockItemName,
	(select min(UnitPrice) from Warehouse.StockItems) as min_price
from Warehouse.StockItems




select top 10 * from Sales.CustomerTransactions
select top 10 * from Sales.Orders
select top 10 * from Sales.OrderLines