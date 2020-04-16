


--4. �������� ������ (�� � ��������), � ������� ���� ���������� ������, �������� � ������ ����� ������� �������, 
--� ����� ��� ����������, ������� ����������� �������� �������


--1. �������� �����������, ������� �������� ������������, � ��� �� ������� �� ����� �������.
select PersonID, FullName from Application.People
where IsSalesperson = 1 and not exists (
select SalespersonPersonID from Sales.Orders)

--2. �������� ������ � ����������� ����� (�����������), 2 �������� ����������.
select StockItemName, UnitPrice from Warehouse.StockItems
where UnitPrice in (select min(UnitPrice) from Warehouse.StockItems)

select StockItemName, UnitPrice from Warehouse.StockItems
where UnitPrice = (select min(UnitPrice) from Warehouse.StockItems)

--3. �������� ���������� �� ��������, ������� �������� �������� 5 ������������ �������� �� [Sales].[CustomerTransactions] 
--����������� 3 ������� (� ��� ����� � CTE)




select top 10 * from Sales.CustomerTransactions
select top 10 * from Sales.Orders
select top 10 * from Sales.OrderLines