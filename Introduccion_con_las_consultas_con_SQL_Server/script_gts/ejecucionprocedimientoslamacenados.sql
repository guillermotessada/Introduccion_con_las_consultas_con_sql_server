use Northwind

/* el procedimiento almacenado puede encapsular un insert, delete, update, delete*/

--procedimiento para SELECT

create procedure procventas
as
select
c.CustomerID,
c.CompanyName,
o.OrderID,
o.OrderDate
from Customers as c inner join Orders as o on c.CustomerID=o.CustomerID

--ejectuar un procedimiento almacenado
execute procventas


---SELECT un valor con un procedimiento ALTER

alter procedure procventas @cliente varchar(10)
as
select
c.CustomerID,
c.CompanyName,
o.OrderID,
o.OrderDate
from Customers as c inner join Orders as o on c.CustomerID=o.CustomerID
where c.CustomerID = @cliente

--ejectuar un procedimiento almacenado
execute procventas @cliente ='ANTON'

--ejectuar un procedimiento almacenado
execute procventas @cliente ='ALFKI'

-- BORRADO PROCEDIMIENTO
drop procedure procventas

--INSERTAR datos con store procedure
/* si no especifico todos los datos de la tabla esos quedan nulos*/

create procedure insertarcliente
(@customerid varchar(100),
@companyname varchar(100),
@contactname varchar(100),
@country varchar(100))
as
insert into Customers
(customerid ,
companyname,
contactname,
country)
values 
(@customerid,
@companyname,
@contactname,
@country)

--ejecutar
EXEC insertarcliente
'VHCV1','VISOAL','GUILLE','CHILE'

--test
select *
from
Customers
where CustomerID = 'VHCV1'

--procedimiento de UPDATES
create proc cambiopais
@nuevopais varchar(100),
@viejopais varchar(100),
@filasafectadas int output
as
update Customers
set Country =@nuevopais
where Country =@viejopais
set @filasafectadas = @@ROWCOUNT

/*cambia todos los clientes con country usa en estados unidos*/
declare @variable int --para @filasafectadas
exec cambiopais
'estados unidos', 'USA', @variable output
select @variable

select *
from Customers
where Country ='estados unidos'


---PARAMETROS DE UNA PROCEDURA
/*tengo todos los procedimientos*/
select * from sys.objects
where name = 'insertarcliente'
/* con esto veo los parametros*/
select * from sys.parameters
where object_id =722101613


----encapsulacion de select en procesos almacenados

---productos vendidos en marzo del 1998
select
distinct(p.ProductID),
p.ProductName
from Products as p inner join [Order Details] as d on p.ProductID = d.ProductID
inner join orders as o on o.CustomerID = o.CustomerID
where DATEPART(MM,o.OrderDate)=3 and DATEPART(YYYY,o.OrderDate)=1998

------crea un procedimiento almacenado
---query limpia
create procedure proc_prod1
as
select
distinct(p.ProductID),
p.ProductName
from Products as p inner join [Order Details] as d on p.ProductID = d.ProductID
inner join orders as o on o.CustomerID = o.CustomerID
--where DATEPART(MM,o.OrderDate)=3 and DATEPART(YYYY,o.OrderDate)=1998
where month(o.OrderDate)=3 and year(o.OrderDate) = 1998
---ejecutar proc
execute proc_prod1



---- procedura agregar parametros de entrada
/*alter modifica la procedura anterior*/
alter procedure proc_prod1
(@mes int,
@anio int)
as
select
distinct(p.ProductID),
p.ProductName
from Products as p inner join [Order Details] as d on p.ProductID = d.ProductID
inner join orders as o on o.CustomerID = o.CustomerID
--where DATEPART(MM,o.OrderDate)=@mes and DATEPART(YYYY,o.OrderDate)=@anio
where month(o.OrderDate)=@mes and year(o.OrderDate) = @anio
---ejecutar proc con parametros
execute proc_prod1 @mes =10 , @anio =1996


-----procedura para select pais
create procedure pais_pro
@pais as varchar(100)
as
select
CustomerID,
CompanyName,
ContactTitle
from Customers
where country = @pais

execute pais_pro @pais='estados unidos'


----------SQL DINAMICO-- 
/*el select esta entre comillas*/
execute 
('select
CustomerID,
CompanyName,
ContactTitle
from Customers') 

--version 2
execute
('select *
from customers')

/*declaro la variable @tabla y puedo insertarla
desde la declaracion
es peligroso por problemas de entradas no validas en la tabla */
declare @tabla varchar(100)
set @tabla = 'products'
execute
('select *
from ' + @tabla)

/* en este caso tengo los valores de customeres filtrados por mexico*/
declare @tabla varchar(100)
set @tabla = 'customers where country =''mexico'''
execute
('select *
from ' + @tabla)


/* para ejecutar un SQL DINAMICO se puede usar SP_executeSQL*/

declare @sqlstring nvarchar(500)
set @sqlstring = 'select EmployeeID,FirstName from Employees'
execute Sp_executeSQL @sqlstring

/*poner un filtro*/

declare @sqlstr nvarchar(500)
declare @emp nvarchar(100)
set @sqlstr = 'select EmployeeID,FirstName from Employees where EmployeeID =@EmployeeID'
set @emp = '@EmployeeID int'
execute Sp_executeSQL @sqlstr, @emp,@EmployeeID =5

/* englobar en sp*/
create procedure empleados
as
declare @sqlstring nvarchar(500)
set @sqlstring = 'select EmployeeID,FirstName from Employees'
execute Sp_executeSQL @sqlstring
/*ejecucion*/
execute empleados


/* englobar en sp 2, cuando creo sql dinaminco tengo que declarar el tipo de dato*/
create procedure sql_test @rep1 int
as
declare @query nvarchar(500)
declare @rep nvarchar(500)
set @query = 'select EmployeeID,FirstName from Employees where EmployeeID =@rep1'
set @rep = '@rep1 int'
execute SP_executeSQL @query, @rep, @rep1
/*ejecucion*/
execute sql_test  3


drop procedure sql_test











