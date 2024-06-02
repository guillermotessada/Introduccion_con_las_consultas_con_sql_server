use Northwind
go
------------------------INNER JOIN---------------------------------------------
---Inner join
/* para poder realizar cualquier join las tablas,
tienen que tener al menos un campo en comun
para estas tablas el campo en comun es CustomerID*/
select *
from Customers

select *
from orders
--Inner join ANSI SQL 92
/* son solo los valores que estan en ambas tablas
los campos con mismo nombre se usa alias*/
select
Customers.CustomerID,
Customers.CompanyName,
Customers.ContactName,
Customers.Country,
Orders.OrderID,
Orders.OrderDate
from Customers
inner join Orders on Customers.CustomerID=Orders.CustomerID

--Inner join con alias ANSI SQL92
/* son solo los valores que estan en ambas tablas
los campos con mismo nombre se usa alias*/
select
c.CustomerID,
c.CompanyName,
c.ContactName,
c.Country,
o.OrderID,
o.OrderDate
from Customers c
inner join Orders o on c.CustomerID=o.CustomerID

--Inner join con alias ANSI SQL89
/* son solo los valores que estan en ambas tablas
los campos con mismo nombre se usa alias*/
select
c.CustomerID,
c.CompanyName,
c.ContactName,
c.Country,
o.OrderID,
o.OrderDate
from Customers as c, Orders as o -- se mencionan las tablas
where c.CustomerID=o.CustomerID -- se vinculan las variables en comun


--Inner join con alias ANSI SQL89 con filtradp
/* son solo los valores que estan en ambas tablas
los campos con mismo nombre se usa alias*/
select
c.CustomerID,
c.CompanyName,
c.ContactName,
c.Country,
o.OrderID,
o.OrderDate
from Customers as c, Orders as o -- se mencionan las tablas
where c.CustomerID=o.CustomerID and c.Country ='USA'-- se vinculan las variables en comun 
													-- y se agrega un predicado de seleccion

													--Inner join con alias ANSI SQL92
--Inner join con alias ANSI SQL92
/* son solo los valores que estan en ambas tablas
los campos con mismo nombre se usa alias*/
select
c.CustomerID,
c.CompanyName,
c.ContactName,
c.Country,
o.OrderID,
o.OrderDate
from Customers c
inner join Orders o on c.CustomerID=o.CustomerID
where c.Country ='USA' -- queda mas claro el predicado de seleccion

--consulta de mas de dos tablas

select
c.CustomerID,
c.CompanyName,
c.ContactName,
c.Country,
o.OrderID,
o.OrderDate,
d.ProductID,
d.UnitPrice,
d.Quantity,
p.ProductName,
p.UnitPrice
from Customers c
inner join Orders o on c.CustomerID=o.CustomerID
inner join [Order Details] as d on o.OrderID= d.OrderID 
inner join Products as p on d.ProductID=p.ProductID

--unir tabla supliers con products
select
s.CompanyName,
p.ProductName,
p.CategoryID,
c.[Description]
from Suppliers as s
inner join Products as p
on s.SupplierID =p.SupplierID
inner join Categories as c
on p.CategoryID =c.CategoryID


--------------------------OUTER JOIN ------------------------------------
--LEFT JOIN
/* con left join pegamos la informacion de la tabla a la dx,
la tabla a la sx se muestra por completo, en caso no habia 
coincidencia con la tabla a la dx la variable queda en NULL
Nota: el orden de las tablas es importante*/
select
c.CustomerID,
c.CompanyName,
c.ContactName,
c.Country,
o.OrderID,
o.OrderDate
from Customers as c
left join Orders as o
on c.CustomerID =o.CustomerID

-- se seleccionan las filas que no cruzan entre customers y orders
/* se obtienen las filas que no tienen ordenes asociados*/                       kldkjajkd     



 
select
c.CustomerID,
c.CompanyName,
c.ContactName,
c.Country,
o.OrderID,
o.OrderDate
from Customers as c
left join Orders as o
on c.CustomerID =o.CustomerID
where o.OrderDate is null or OrderID is null


---------------------------CROSS OUTER JOIN ---------------------
/* CROSS JOIN lo que hace es unir con un left, right y inner 
todas las variables no necesita la clausola on
poco funcional no se usa*/
select
c.CustomerID,
c.ContactName,
o.EmployeeID,
o.OrderID
from Customers as c
cross join Orders as o 


-------------------------------SELF JOIN-----
/*se usa para obtener informacion de la misma tabla
aqui se elencan todos los empleados indipendentemiente
del cargo*/
select
EmployeeID,
FirstName, 
LastName, 
ReportsTo
from Employees

/* con la consulta agrupo los jefes con sus empleados directos
separo los cargos, jefes y empleados*/
 

select *
from Employees











