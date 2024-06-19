use Northwind
go

/* SUBCONSULTAS son consultas que apuntan a otra consulta*/

-- SUB CONSULTA INDIPENDIENTE
select
t.CompanyName,
sum (t.total) venta_tot_cliente
from
(
select
c.CustomerID,
c.CompanyName,
c.Country,
o.OrderID,
o.OrderDate,
od.UnitPrice,
od.Quantity,
(od.UnitPrice*od.Quantity) as total
from Customers as c inner join Orders as o on c.CustomerID=o.CustomerID 
inner join [Order Details] as od on o.OrderID=od.OrderID
inner join Products as p on od.ProductID = p.ProductID
) as t
group by t.CompanyName 

---usar un filtro con el predicado where
/*selecciono todos los clientes que tienen ordernes*/
select
CompanyName,
Country,
phone,
Fax
from Customers
where CustomerID in
(
select                           
distinct(CustomerID) as distcomp
from Orders   --lista de los ordenes
)

-- devuelve solo un valor escalar
select
CompanyName,
Country,
phone,
Fax
from Customers
where CustomerID not in
(
select                           
distinct(CustomerID) as distcomp
from Orders   --lista de los ordenes
)

-----subquery con valores agregados
select
ProductName,
UnitPrice,
(select 
avg(UnitPrice) from products) as valormedio, --calculo media de un select
(select avg(UnitPrice) from products) - UnitPrice as varianza --calculo varianza de un select
from Products


--SUB CONSULTAS CORRELACIONADAS
/*la consulta interna pasa un parametro a la consulta externa) consulta de todas las ordenes donde de pidieron mas de
20 unidades del producto 23*/


--consulta externa
select
o.CustomerID,
o.OrderID,
o.OrderDate
from Orders as o
where
--consulta interna
(
select
d.Quantity
from [Order Details] as d
where d.ProductID = 23 and o.OrderID = d.OrderID
) >20

--el mismo resultado con un inner join directo
select
o.CustomerID,
o.OrderID,
o.OrderDate,
d.Quantity
from orders as o inner join [Order Details] as d on o.OrderID = d.OrderID
where d.ProductID =23 and d.Quantity>20

/*entrega codigo clientes que han hecho una orden*/

select
c.CompanyName,
c.Country,
c.ContactName
from Customers as c 
where c.CustomerID in 
(select CustomerID from Orders)

--consulta con exists en este caso no se correlaciona
--externa
select 
c.CompanyName,
c.Country,
c.ContactName
from Customers as c
where exists
(
select
o.CustomerID from orders as o
)


--consulta con exists en este caso se correlaciona
--externa
select 
c.CompanyName,
c.Country,
c.ContactName
from Customers as c
where exists
--interna
(
select
o.CustomerID from orders as o
where c.CustomerID=o.CustomerID
)







