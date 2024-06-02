use Northwind
go
--------------------ORDER BY-------------

--ordenar datos -por columna
select
CompanyName,
ContactName,
ContactTitle,
Country
from Suppliers
order by Country

--ordenar datos -posicion de la columna
select
CompanyName, --1
ContactName, --2
ContactTitle,--3
Country      --4
from Suppliers
order by 4

--ordenar datos con alias
/* order by es la unica funcion que acepta el alias*/
select
CompanyName, 
ContactName, 
ContactTitle,
Country  as pais    
from Suppliers
order by pais

--ordenar el resultado de order by desc/asc
/* asc desde el valor menor al mayor
desc desde el valor mayor al menor*/
select
CompanyName,
ContactName,
ContactTitle,
Country
from Suppliers
order by Country desc

--ordenar el resultado por varias columnas
/* primero ordena por country y con country ordenado
ordena por companyname*/
select
CompanyName,
ContactName,
ContactTitle,
Country
from Suppliers
order by Country, CompanyName

--ordenar el resultado por varias columnas y uso de desc y asc
/* primero ordena por country y con country ordenado
ordena por companyname*/
select
Country,
CompanyName,
ContactName,
ContactTitle
from Suppliers
order by Country desc, CompanyName asc

-------------------------------------WHERE------------------------------

--WHERE
/* predicado para seleccionar elementos de la tabla
se puede unir con and,or, usar in, not in , is null...*/
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where Country ='USA' or Country = 'Japan'

--uso like
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where Country like 'USA' 

--uso %
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where Country like 'U%'  --devuelve todos los country que empiezan con U

--uso %
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where Country like '%n'  --devuelve todos los country que terminan con n

--uso %
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where Country like '%in'  --se pueden usar parte cadenas de letras
							-- entrega todos los paises que terminan en in	
--uso %
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where Country like '%in%'  --se pueden usar parte cadenas de letras
							-- entrega todos los paises contengan in en cualquier posicion		

--uso _
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where Country like '_in%'  -- _ salta la primera letra	

--uso [ ]
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where CompanyName like '[A-C]%' --entrega todos los company name que inicien con A,B,C

--uso not like
select
CompanyName,
ContactName,
ContactTitle,Country
from Suppliers
where CompanyName not like '[A-C]%' --entrega todos los company name que no inicien con A,B,C

--uso between
select
s.CompanyName,
c.CategoryName,
p.ProductName,
p.UnitPrice
from Products p
inner join Suppliers as s
on p.SupplierID=s.SupplierID
inner join Categories as c
on p.CategoryID=c.CategoryID
WHERE p.UnitPrice between 18 and 31 --between no usa ()
--alternativa al between
select
s.CompanyName,
c.CategoryName,
p.ProductName,
p.UnitPrice
from Products p
inner join Suppliers as s
on p.SupplierID=s.SupplierID
inner join Categories as c
on p.CategoryID=c.CategoryID
WHERE p.UnitPrice >= 18 and p.UnitPrice <=31 --between no usa ()

--uso de in
select
s.CompanyName,
c.CategoryName,
p.ProductName,
p.UnitPrice
from Products p
inner join Suppliers as s
on p.SupplierID=s.SupplierID
inner join Categories as c
on p.CategoryID=c.CategoryID
WHERE (p.UnitPrice between 18 and 31) and (c.CategoryName in ('Beverages','Seafood'))

--uso de not in
select
s.CompanyName,
c.CategoryName,
p.ProductName,
p.UnitPrice
from Products p
inner join Suppliers as s
on p.SupplierID=s.SupplierID
inner join Categories as c
on p.CategoryID=c.CategoryID
WHERE (p.UnitPrice between 18 and 31) and (c.CategoryName not in ('Beverages','Seafood'))


--Top, with ties, fetch

--instruccion top
/* en caso de valore iguales los incluye en 
la lista  de top*/
select top 15 -- visualiza los primeros 5 elementos
ProductName,
UnitPrice
from Products
order by UnitPrice desc

/* uso de percent*/
select top 50 percent -- visualiza el 15% de la tabla
ProductName,
UnitPrice
from Products
order by UnitPrice desc

--instruccion with ties
/* en este caso hay mas productos con valor igual al 11
para incluir estos productos usamoso with ties*/
select top 11  with ties
ProductName,
UnitPrice
from Products
order by UnitPrice desc

-- fetch
/* se usa para listar los siguientes elementos despues
de los que estan indicados en top*/
select
ProductName,
UnitPrice
from Products
order by UnitPrice desc offset 10 rows --salta las primeras 10 filas y presenta las siguientes 10
fetch next 10 rows only


--fetch con ciclos
Declare @i int =0
while @i <10
begin
	select
	LastName+', '+FirstName
	from Employees
	order by LastName asc offset @i rows
	fetch next 2 rows only -- aqui se  indica lo step
	set @i  = @i +2
end



-- manejo valores nulos 
/* en este caso la columna fax presenta valores nulos
la caracteristica de los nulos es que * algo por un nulo 
dara como resultado null*/
select
CustomerID,
CompanyName,
ContactName,
Phone,
fax
from Customers

-- manejo valores nulos 
/* usando el case hay que estar atentos al
formato de la variable si es int se puede solo
sostituir con un int*/
select
CustomerID,
CompanyName,
ContactName,
Phone,
case when fax is null then 'NO APLICA'
else fax
end fax
from Customers

-- manejo valores nulos -- mismo resultado con otro modo de usar case
/* usando el case hay que estar atentos al
formato de la variable si es int se puede solo
sostituir con un int*/
select
CustomerID,
CompanyName,
ContactName,
Phone,
fax = case
	when fax is null then 'no aplica'
	else fax
	end 
from Customers
/*where fax is null selecciona las variables que tienen null en fax, 
como se puede ver funcion solo con null y no con no aplica */

--funcion isnull() /* permite de atribuir un valor a la variable con valor nulo
select 
CustomerID,
CompanyName,
ContactName,
phone,
isnull (fax,1) as casteo_nulos
from Customers

-- funcion coalesce() permite de rellenar con otra varible 
select
CompanyName,
Phone,
fax,
coalesce (Fax,Phone,'no tiene') as FaxNorm-- en este caso si es null fax tenta de rellenar con phone y al fin 'no tiene'
from Customers


-- is null
/* permite de filtrar todos los fax con valor nulo*/
select
CompanyName,
Phone,
fax
from Customers
where fax is null	


	








