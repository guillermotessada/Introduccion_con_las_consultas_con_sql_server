--Order by  Orden ascendente
Select customerid, companyname, contactname, country
from customers
order by country asc

--Order by  Orden descendente
Select customerid, companyname, contactname, country
from customers
order by country desc


--Order by  Orden descendente indicando numero de columna
Select customerid, companyname, contactname, country
from customers
order by 4 desc

--Uso del Top, mostrando los 10 productos mas caros de la tabla producto
Select top 10  productname, unitprice
from products
order by unitprice desc

--Uso del Top, mostrando el 10 por ciento de productos mas caros de la tabla producto
Select top 10 percent  productname, unitprice
from products
order by unitprice desc

----With ties
Select top 11 with ties  productname, unitprice
from products
order by unitprice desc