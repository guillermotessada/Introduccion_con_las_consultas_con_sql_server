use Northwind
go

--tipo de dato en sql server
-- declarar una variable en sql server
declare @variable as varchar(150) --vchar, int, decimal 
set @variable ='hola'
--para obtener el valor de la variable
select @variable

declare @variable as decimal(7,2) --vchar, int, decimal 
set @variable =7.89
--para obtener el valor de la variable
select @variable

-- creando una tabla indicando el tipo de dato
create table empleados
(codigo bigint,
nombre varchar(150),
apellido varchar (150)
)


-- creando tablas con declare
declare @empleados as table
(codigo bigint,
nombre varchar(150),
apellido varchar (150)
)
-- insertando datos en la tabla
insert into @empleados (codigo,nombre,apellido)
values (2,'victor','carde'),(3,'claudia','hernand')
-- para ejecutar el select se seleccionan las 3 sentencias juntas
select *
from @empleados

-- concatenacion de texto
--+
select
FirstName,
LastName,
FirstName + ' ' + LastName as nombreapellido
from Employees

--concatenacion con concat
select
FirstName,
LastName,
concat (FirstName,' ',LastName) as nombreapellido
from Employees

-- upper
select 
CompanyName,
upper(CompanyName) as mayu
from Suppliers

-- lower
select 
CompanyName,
lower(CompanyName) as minu
from Suppliers

--substring
select 
CompanyName,
substring(CompanyName, 3, 10) as porcioncompanyname
from Suppliers

--len
select
CompanyName,
len(CompanyName) as ncaract
from Suppliers

--charindex
select CHARINDEX ('levanten', 'que todos se levanten temprano')/* charindex indica si esta la palabra y en que posicion 
																	inicia la palabra buscada*/

--like
-- la companyname inicia con s
select
CompanyName,
ContactName
from Suppliers
where CompanyName like 's%' 
-- la companiname termina con y 
select
CompanyName,
ContactName
from Suppliers
where CompanyName like '%y'

-- la companyname empieza con un grupo de caracteres
select
CompanyName,
ContactName
from Suppliers
where CompanyName like '[G-H]%'

-- la companyname tiene como segunda letra la b
select
CompanyName,
ContactName
from Suppliers
where CompanyName like '_b%'

-- la companyname que no empiezaa con un grupo de caracteres
select
CompanyName,
ContactName
from Suppliers
where CompanyName not like '[G-H]%'


--fechas
/* atencion al formato de la fecha*/
select
OrderID,
OrderDate
from Orders
where OrderDate between '01-01-1996'and'12-31-1996'

--entrega la fecha de sistema
select getdate()












--


