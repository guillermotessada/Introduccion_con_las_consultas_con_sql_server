use Northwind
go

/*expresiones de tabla
expresiones que devuelven ser de datos como la vista*/


--------------VISTA
/* se necesitamos usar la consulta varias veces se puede almacenar en una vista*/
create view ventas
as
select
c.CompanyName as compania,
o.OrderID,
o.OrderDate,
p.ProductName,
d.UnitPrice,
d.Quantity
from Customers as c
inner join Orders as o on c.CustomerID=o.CustomerID
inner join [Order Details] as d on d.OrderID=o.OrderID
inner join Products as p on p.ProductID =d.ProductID

select *
from ventas


----toda modifica se hace con ALTER
/*aqui agregramos una columna mas a la vista*/
alter view ventas
as
select
c.CompanyName,
o.OrderID,
o.OrderDate,
p.ProductName,
d.UnitPrice,
d.Quantity,
o.EmployeeID,
d.UnitPrice*d.Quantity as total
from Customers as c
inner join Orders as o on c.CustomerID=o.CustomerID
inner join [Order Details] as d on d.OrderID=o.OrderID
inner join Products as p on p.ProductID =d.ProductID

select *
from ventas

---usando agregado

select
CompanyName,
sum(total)
from ventas
group by CompanyName


/*eliminar vista con la funcion DROP*/

drop view ventas

/*eliminamos la vista*/
select *
from ventas


-------------FUNCIONES DE TABLA EN LINEA
/* a diferencia de las vistas se pueden agregar parametros*/

select
c.CompanyName as compania,
o.OrderID,
o.OrderDate,
p.ProductName,
p.ProductID,
d.UnitPrice,
d.Quantity
from Customers as c
inner join Orders as o on c.CustomerID=o.CustomerID
inner join [Order Details] as d on d.OrderID=o.OrderID
inner join Products as p on p.ProductID =d.ProductID

/* crear FUNCION*/
create function ventas_prod (@idprod int, @ciudad varchar(10))
returns table
as
return
(
select
c.CompanyName as compania,
c.City,
o.OrderID,
o.OrderDate,
p.ProductName,
p.ProductID,
d.UnitPrice,
d.Quantity
from Customers as c
inner join Orders as o on c.CustomerID=o.CustomerID
inner join [Order Details] as d on d.OrderID=o.OrderID
inner join Products as p on p.ProductID =d.ProductID
where p.ProductID = @idprod and c.city =@ciudad
)

/*usar la funcion */
/* la facilidad es no necesito armar la query solo interrogarla*/ 
select *
from ventas_prod (24,'Bern')


/* modificar la funcion*/

alter function ventas_prod (@idprod int, @ciudad varchar(10))
returns table
as
return
(
select
c.CompanyName as compania,
c.City,
c.ContactTitle,
o.OrderID,
o.OrderDate,
p.ProductName,
p.ProductID,
d.UnitPrice,
d.Quantity
from Customers as c
inner join Orders as o on c.CustomerID=o.CustomerID
inner join [Order Details] as d on d.OrderID=o.OrderID
inner join Products as p on p.ProductID =d.ProductID
where p.ProductID = @idprod and c.City = @ciudad
)

select * from ventas_prod (24,'Bern')

/*eliminar una funcion con drop*/
drop function ventas_prod


------TABLAS DERIVADAS
/* se trata de subconsultas generar una consulta sobre otra consulta*/

select
j.FirstName + ' ' + j.LastName  as jefe,
s.FirstName + ' ' + s.LastName as subalterno
from Employees as j inner join Employees as s on j.EmployeeID = s.ReportsTo

/*determinar cuantas subalternos tiene cada jefe*/
select
t.jefe,
count(t.subalterno) n_subalternos
from
(select
j.FirstName + ' ' + j.LastName  as jefe,
s.FirstName + ' ' + s.LastName as subalterno
from Employees as j inner join Employees as s on j.EmployeeID = s.ReportsTo) as t
group by t.jefe

select 
EmployeeID,
FirstName,
ReportsTo
from Employees

/* USO DE ALIAS PARA NOMBRES DE COLUMNAS EN TABLAS DERIVADAS*/

select
t.jefe,
count(t.subalterno) n_subalternos
from
(select
j.FirstName + ' ' + j.LastName,
s.FirstName + ' ' + s.LastName
from Employees as j inner join Employees as s on j.EmployeeID = s.ReportsTo) as t (jefe, subalterno) --los alias se pueden definir al final
group by t.jefe

/*PASANDO ARGUMENTOS A TABLAS DERIVADAS*/

select
c.CompanyName,
o.OrderID,
o.OrderDate,
p.ProductName,
d.UnitPrice,
d.Quantity
from customers as c
inner join Orders as o on c.CustomerID= o.CustomerID
inner join [Order Details] as d on d.OrderID=o.OrderID
inner join Products as p on p.ProductID=d.ProductID

/* INSERTANDO PARAMETROS*/

declare @anio bigint
set @anio=1996
select 
t.CompanyName,
t.OrderID,
sum (t.quantity*t.unitprice) as suma_total
from 
(select
c.CompanyName,
o.OrderID,
o.OrderDate,
p.ProductName,
d.UnitPrice,
d.Quantity
from customers as c
inner join Orders as o on c.CustomerID= o.CustomerID
inner join [Order Details] as d on d.OrderID=o.OrderID
inner join Products as p on p.ProductID=d.ProductID
where year(o.OrderDate) = @anio
) as t 
group by t.CompanyName, t.OrderID

/* ANIDACION*/

declare @anio bigint
set @anio=1996
select 
n.CompanyName,
n.suma_total,
n.quantity,
n.suma_total/n.quantity promedio
from
	(select 
	t.CompanyName,
	t.OrderID,
	t.quantity,
	sum (t.quantity*t.unitprice) as suma_total
	from 
		(select
		c.CompanyName,
		o.OrderID,
		o.OrderDate,
		p.ProductName,
		d.UnitPrice,
		d.Quantity
		from customers as c
		inner join Orders as o on c.CustomerID= o.CustomerID
		inner join [Order Details] as d on d.OrderID=o.OrderID
		inner join Products as p on p.ProductID=d.ProductID
		where year(o.OrderDate) = @anio
		) as t 
	group by t.CompanyName, t.OrderID, t.Quantity) as n

/*COMMON TABLE EXPRESSION CTE
PARA OBTENER UN RESULTADO TIENE QUE SER SEGUIDO DE UN SELECT*/

with cteyears as
(
select
CustomerID,
year(orderdate) as yearorder,
month(orderdate) as mesorder
from orders)

select 
yearorder,
count(distinct(customerid)) as clientes,
count(distinct(mesorder)) as mes
from cteyears
group by yearorder;


/*CTE*/
with jefe as 
(select 
EmployeeID,
FirstName + ' ' + LastName as nombrecompletojefe
from Employees 
)
select jefe.nombrecompletojefe, 
Employees.FirstName + ' ' + Employees.LastName as dependiente
from Employees inner join jefe on jefe.EmployeeID= Employees.ReportsTo

select
EmployeeID,
LastName,
ReportsTo
from Employees

select *
from Employees

/*CTE anidado
query donde se devolvera si es jefe y sus subalternos*/

with arbolempleados as
(
select 
EmployeeID,
FirstName + ' ' +LastName as nombre,+
ReportsTo,
0 as livelo
from Employees
where EmployeeID =5
union all
select 
e.EmployeeID,
e.FirstName + ' ' +LastName as nombre,
e.ReportsTo,
livelo+3
from Employees as e
inner join arbolempleados as es on es.EmployeeID=e.ReportsTo
)
select *
from arbolempleados



