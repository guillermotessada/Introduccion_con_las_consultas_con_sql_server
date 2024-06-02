use Northwind
go

--calculo, consultando la tabla de productos
/* se crea una nueva columna que corresponde al calculo impuestiva*/
select ProductName,
UnitPrice,
UnitPrice*0.12 as impuestoiva 
from Products

--calculo combinando mas columnas
select 
OrderID,
ProductID,
UnitPrice,
Quantity,
Discount,
(UnitPrice*Quantity)-(UnitPrice*Quantity*Discount) as parcial
from [Order Details]


--Obtener año mes y dia de una fecha
/* en este caso descompongo la variable orderdate en año, mes y dia
y creo una columna para cada uno de ellos*/
select CustomerID, 
OrderID, 
OrderDate, 
year(OrderDate) as anio,
month(OrderDate) as mes,
day(OrderDate) as dia
from Orders


--valores unicos
/* esta consulta presenta valores duplicados en las columnas*/
select 
CustomerID,
CompanyName,
Country
from Customers
order by Country

-- uso de DISTINCT para una variable
/* con la sentencia DISTINCT se obtienen solo los valores unicos de 
una variable*/
select
distinct(Country)
from Customers
order by Country

-- uso de alias 3 modos, as, ''
--as
select 
Country as pais
from Customers

-- ' '
select 
Country  pais
from Customers

-- uso alias con tablas as, ''
--as
select 
Country as pais
from Customers as c

-- ' '
select 
Country  pais
from Customers c

/* en caso de tener mas tablas a 
cada columna se antepone el alias de la tabla
en modo que pueda distinguir a cual tabla hace referencia
la variable */
select 
c.Country  pais
from Customers c

/* tener en cuenta que el alias es valido solo para el order,
nunca para where, group o having para estos se usa el nombre de
columna */
--as
select 
Country as pais
from Customers
-- where pais entrega error 
order by pais

-- Funcion CASE
select
ProductName,
categoria = -- se puede nombrar la columna
CategoryID,
	case CategoryID
	when 1 then 'uno'
	when 2 then 'dos'
	when 3 then 'tres'
	when 4 then 'cuatro'
	else 'otro'
	end
from Products
order by ProductName

-- Funcion CASE v2
select
ProductName,
	case	when CategoryID = 1 then 'uno' 
			when CategoryID = 2 then 'dos' 
	else 'otro'
	end as categoria -- nombre de la nueva columna
from Products
order by ProductName








