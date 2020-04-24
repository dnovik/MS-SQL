
--1. —оздать базу данных.
create database CRM;
go

use CRM;
go


--2. 3-4 основные таблицы дл€ своего проекта.
create table Accounts(
[id] int not null primary key,
[name] varchar(70),
[phone] varchar (15),
[fax] varchar (15),
[address] varchar(150),
[city] varchar(50)
);
go

create table Contacts(
[contact_id] int not null primary key,
[account_id] int,
[first name] varchar(70),
[last name] varchar(70),
[phone] varchar (15),
[e-mail] varchar(15))
go

create table Projects(
[project_id] int not null primary key,
[account_id] int,[contact_id] int,
[employee_id] int, 
[name] varchar(100), 
[created date] date);
go

create table Employees(
[employee_id] int not null primary key,
[first name] varchar(70),
[last name] varchar(70),
[phone] varchar (15),
[e-mail] varchar(15));
go

create table Cities(
[city_id] int not null primary key,
[name] varchar(70));
go

--3. ѕервичные и внешние ключи дл€ всех созданных таблиц.
alter table Accounts ADD contact_id int NULL;
go

alter table Accounts add constraint Acc_Con foreign key(contact_id)
references Contacts(contact_id);
go

alter table Contacts add city_id int;
go

alter table Contacts add constraint Con_City foreign key(city_id)
references Cities (city_id);

alter table Projects add constraint Prj_Acc foreign key(account_id)
references Accounts (id);

alter table Projects add constraint Prj_Con foreign key(contact_id)
references Contacts (contact_id);

alter table Projects add constraint Prj_Emp foreign key(employee_id)
references Employees (employee_id);
go

--4. 1-2 индекса на таблицы.
create index idx_project on Projects (project_id);
go

create index idx_contact on Contacts(contact_id);
go


--5. Ќаложите по одному ограничению в каждой таблице на ввод данных.
alter table Accounts add constraint constr_name check ([name] <> 'The Company');
alter table Contacts add constraint constr_first_name check ([first name] <> 'Semion');
alter table Projects add constraint constr_created_date check ([created date] >= '2020-04-24');
alter table Employees add constraint constr_position check ([last name] >= 'test');
alter table Cities add constraint constr_city check ([name] >= 'Tashkent');
