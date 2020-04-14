select * from [Application].[TransactionTypes]
select top 10 * from [Sales].[BuyingGroups]
select top 10 * from [Purchasing].[PurchaseOrders]
select top 10 * from [Purchasing].[SupplierTransactions]
select top 10 * from [Sales].[Customers]
select top 10 * from [Sales].[CustomerTransactions]
select top 10 * from [Sales].[InvoiceLines]
select top 10 * from [Sales].[Orders]
select top 10 * from [Sales].[OrderLines]
select top 10 * from [Sales].[SpecialDeals]
select top 10 * from [Warehouse].[StockItemTransactions]
select top 10 * from [Warehouse].[PackageTypes]
select top 10 * from [Warehouse].[StockItemHoldings]
select top 10 * from [Warehouse].[StockItemStockGroups]
select top 10 * from [Warehouse].[StockItems]
select top 10 * from [Warehouse].[StockItemStockGroups]
select top 10 * from [Warehouse].[StockItemTransactions]
select top 10 * from [Warehouse].[VehicleTemperatures]
select top 10 * from [Application].[Cities]
select top 10 * from [Application].[Countries]
select * from [Application].[DeliveryMethods]
select * from [Application].[PaymentMethods]
select top 10 * from [Application].[People]
select top 10 * from [Application].[StateProvinces]
select top 10 * from [Application].[SystemParameters]
select top 10 * from [Purchasing].[PurchaseOrderLines]
select top 10 * from [Purchasing].[PurchaseOrders]
select * from [Purchasing].[SupplierCategories]
select top 10 * from [Purchasing].[Suppliers]
select top 10 * from [Purchasing].[SupplierTransactions]
select top 10 * from [Sales].[BuyingGroups]
select top 10 * from [Sales].[CustomerCategories]
select top 10 * from [Sales].[Customers]
select top 10 * from [Sales].[CustomerTransactions]
select top 10 * from [Sales].[InvoiceLines]
select top 10 * from [Sales].[Invoices]
select top 10 * from [Sales].[OrderLines]
select top 10 * from [Sales].[Orders]
select * from [Sales].[SpecialDeals]
select top 10 * from [Warehouse].[ColdRoomTemperatures]
select top 10 * from [Warehouse].[Colors]
select top 10 * from [Warehouse].[PackageTypes]
select top 10 * from [Warehouse].[StockGroups]
select top 10 * from [Warehouse].[StockItemHoldings]
select top 10 * from [Warehouse].[StockItems]
select top 10 * from [Warehouse].[StockItemStockGroups]
select top 10 * from [Warehouse].[StockItemTransactions]


--����������, � ������� �� ���� ������� �� ������ ������
select a.SupplierName, count(b.SupplierTransactionID) as CntTransactions
from [Purchasing].[Suppliers] a left join
(select SupplierID, SupplierTransactionID from [Purchasing].[SupplierTransactions]) b on b.SupplierID = a.SupplierID
group by a.SupplierID, a.SupplierName
having count(b.SupplierTransactionID) = 0

--������� � ��������� ������, � ������� ���� �������, ������� ��������, � �������� ��������� �������, 
--�������� ����� � ����� ����� ���� ��������� ���� - ������ ����� �� 4 ������, 
--���� ������ ������ ������ ���� ������, � ����� ������ ����� 100$ ���� ���������� ������ ������ ����� 20. 
--�������� ������� ����� ������� � ������������ �������� ��������� ������ 1000 � ��������� ��������� 100 �������. 
--���������� ������ ���� �� ������ ��������, ����� ����, ���� �������.


select top 10 * from [Sales].[CustomerTransactions]

select 
	[TransactionDate], 
	DATENAME(MONTH, [TransactionDate]) as [MonthName],
	DATENAME(QUARTER, [TransactionDate]) as [Quarter],
	CASE 
	WHEN MONTH([TransactionDate]) in (1,2,3,4) THEN 1
	WHEN MONTH([TransactionDate]) in (5,6,7,8) THEN 2
	WHEN MONTH([TransactionDate]) in (9,10,11,12) THEN 3
	END as [Part],
	TransactionAmount
from [Sales].[CustomerTransactions]
order by [Quarter], [Part], [TransactionDate]
