use northwind;
---Subquery devuelto como un escalar calculando fila por fila

Select productname, unitprice, 
(Select avg(unitprice) from products) as Promedio, 
(Select avg(unitprice) from products)-unitprice as varianza
from products

--------------------Subquery como tabla---------------
Select T.orderid, Sum(T.unitprice*T.quantity) as Total from
#Ventas
as T
group by T.orderid

----Creacion de una vista
Create view ventas
as
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID

----borrar la vista
drop view ventas

----Crear una tabla temporal
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity 
into #Ventas
from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID

----Usando la tabla temporal
Select T.orderid, Sum(T.unitprice*T.quantity) as Total from
#Ventas
as T
group by T.orderid

----borrar la tabla ventas
drop table #Ventas

Select T.orderid, Sum(T.unitprice*T.quantity) as Total from
(
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID
)
as T
group by T.orderid

----Sub-consultas correlacionadas
---------------Si existe el query de adentro hace el query de fuera
Select c.companyname, c.country, c.contactname 
from customers as c where exists
(Select o.customerid from orders as o where year(o.orderdate)=2016)

----correlacionandolo --informacion de los clientes que si han ordenado
Select c.companyname, c.country, c.contactname 
from customers as c where exists
(Select o.customerid from orders as o where c.CustomerID=o.CustomerID)
---subquery con resultado de multiples valores

Select c.companyname, c.country, c.contactname 
from customers as c where c.customerid in
(Select customerid from orders )
-


----devuelvame todas las ordenes donde se pidieron mas de
----20 unidades del producto 23

Select o.orderid, o.orderdate from orders as o
where 20<
(
Select d. quantity from [Order Details] as d
where o.orderid=d.orderid and d.productid=23
)

------------Querys Empaquetados------------------------------
--Vista
go
Create view Ventas
(compañia, numero_orden, fecha, producto, precio, cantidad)
as
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID

Select * from ventas
----Creacion de vista
ALTER view clientesfrancia
as
Select customerid, companyname, contactname, country
from customers
where country='France'
with check option
----Consulta de vista
Select * from clientesfrancia
----Insercion de datos a la tabla por medio de la vista
Insert into clientesfrancia(customerid, companyname, contactname, country)
values
('ABC44','Test44','Julio Menendez','Guatemala')

---------------------Funciones con valores de tabla en linea
go
Alter function fnVentas (@productid int)
Returns Table
as
Return(
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID
where d.ProductID=@productid
)

Select * from fnVentas(23)

---------------------CTE------------------------------------
WITH CTE_year AS
	(
	SELECT YEAR(orderdate) AS orderyear, customerid
	FROM Orders
	)

SELECT orderyear, COUNT(DISTINCT customerid) AS cust_count
FROM CTE_year
GROUP BY orderyear;

select * from employees


Select companyname, country from customers
union
Select companyname, country from suppliers












