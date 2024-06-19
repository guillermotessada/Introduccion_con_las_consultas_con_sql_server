use Northwind
go

-- AGRUPACION ESCALAR que devuelve un unico valor por eso se usa groupby

select 
CompanyName,
Country
from Customers

-----------------COUNT
/* hay que tener cuidado que no tenga valores nulos*/
select
count(CompanyName) nCompania
from Customers
/*en este caso uso la columna fax que tiene nulos
count excluye o no cuenta los valores nulos*/
select 
count(fax) as nFax
from Customers
/* COUNT(*) permite de ver el numero total de registros
sin preocuparse por lo nulos*/
select
count(*) nTot
from Customers

/* conteo de companias por pais*/
select
Country,
CompanyName
from Customers

/* para el conteo agrupado uso group by*/
select
Country,
count(CompanyName) nCompany
from Customers
group by Country
order by nCompany desc

--DISTINCT que se usan con las funciones de agregado

select
count(Country) as pais
from Customers

/* la columna country tiene valores repetidos
tiene 89 filas*/
select
country
from Customers
order by Country desc

/* para obtener los valores unicos de country uso disctinct
tiene 21 filas, por lo tanto la empresa trabaja con 21 paises*/
select
distinct(Country)
from Customers

/* si quiero saber el valor total de una variable y cuantos son sus valores unicos*/
select
count(Country) as nTotcountry,
count(distinct(country)) as nDiscountry
from Customers

-- SUM por orderid
select
o.OrderID,
sum(od.Quantity*od.UnitPrice) as precio_tot
from Orders as o
inner join [Order Details] as od on o.OrderID=od.OrderID
group by o.OrderID

-- AVG, SUM , COUNT, COUNT(DISTINCT) por orderid
/* estos son escalares por lo tanto los puedo elencar*/
select
o.OrderID,
avg(od.Quantity*od.UnitPrice) as precio_AVG,
sum(od.Quantity*od.UnitPrice) as precio_tot,
count(o.CustomerID) as numero_customer,
count(distinct(o.CustomerID)) as distcustomer
from Orders as o
inner join [Order Details] as od on o.OrderID=od.OrderID
group by o.OrderID

-- uso de group by

select
Country,
CompanyName
from Customers
order by Country

/* contar los clientes por pais*/
select
country,
count(distinct(CustomerID)) as numeroClientes
from Customers
group by country
order by numeroClientes desc

/*cada orden por su detalle*/

select
o.OrderID,
p.ProductName,
od.Quantity,
od.UnitPrice,
od.Quantity*od.UnitPrice as tot_pedido
from Orders as o inner join [Order Details] as od on o.OrderID=od.OrderID
inner join Products as p on p.ProductID =od.ProductID

/* por cadad orderid obtengo estadisticos 
la variable que usa como agregado tiene que estar
en la lista, con having filtro los pedidos >= 12000*/

select
o.OrderID,
count(od.Quantity) as cantidadproductos,
min(od.UnitPrice) as minprod,
max(od.UnitPrice) as maxprod,
sum(od.Quantity*od.UnitPrice) as tot_pedido
from Orders as o inner join [Order Details] as od on o.OrderID=od.OrderID
inner join Products as p on p.ProductID =od.ProductID
group by o.OrderID
having sum(od.Quantity*od.UnitPrice) >=12000
order by sum(od.Quantity*od.UnitPrice) desc

/* paises con total de clientes >= 10*/
select 
Country,
count(distinct(CustomerID))
from Customers
group by Country
having count(distinct(CustomerID)) >=10

/*ventas 1996, con un valor especifico de valor de venta*/

select
o.OrderID,
year(o.OrderDate) as fecha_orden,
sum (od.Quantity*od.UnitPrice) as totven,
count(distinct(p.ProductName)) as nprod
from Orders as o inner join [Order Details] as od on o.OrderID=od.OrderID
inner join Products as p on p.ProductID =od.ProductID
where year(o.OrderDate) = 1996
group by o.OrderID, year(o.OrderDate)
having sum(od.Quantity*od.UnitPrice) >=12000



	














