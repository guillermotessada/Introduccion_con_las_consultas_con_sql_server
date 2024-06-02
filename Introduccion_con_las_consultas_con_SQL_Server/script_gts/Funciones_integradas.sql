use Northwind
go


---funciones escalares
/* extraer el ano mes de una fecha*/

select
OrderID,
OrderDate,
year(OrderDate) as anio,
month(OrderDate) as mes,
day(OrderDate) as dia
from Orders

--dias transcurridos desde la fecha de pedido hasta hoy
/* calculo diferencia fechas datediff(dd,fecha1,fecha2)*/
select
OrderID,
OrderDate,
DATEDIFF(dd,OrderDate,getdate()) as dias,
DATEDIFF(mm,OrderDate,getdate()) as meses,
DATEDIFF(yyyy,OrderDate,getdate())as anios
from Orders

---Funciones de agregado

/*conteo completo de los clientes*/
select count(CustomerID) as numeroclientes
from Customers

/*conteo de los clientes por country*/
select
Country,
count(CustomerID) as ncliente
from Customers
group by Country

/* conteo de los productos por categoria
todas las veces que agrego una variable a una funcion
es necesario usar group by*/
select 
c.CategoryName,
count(p.ProductName) as nprod
from Products as p
inner join Categories as c on p.CategoryID =c.CategoryID
group by c.CategoryName

-----fucniones de ventana, muestra detalle
select
c.CategoryName,
p.ProductName,
count(p.ProductID) over	(partition by c.CategoryName) as n
from Products as p 
inner join Categories as c on p.CategoryID=c.CategoryID

---funciones de conversion

--conversion implicita

/*declaro variable tipo texto asignandole un valor numerico
por lo tanto lo castea como texto*/
declare @texto varchar(10);
set @texto = 1;
--test
select @texto +' ' + 'es un texto'
/* declaro un in, lo seteo como string, pero lo mantiene como num*/
declare @num int;
set @num = '10'
--tet
select @num + '1' /* hace la suma del valor set que es 10 mas '1' que 
aunque es declarado como string lo toma como numero*/

-- funcion CAST

select 
'el producto :' + ProductName  + 'el precio:' + cast(UnitPrice as varchar (20)) as precio
from Products

/* como trasformar en formato ano, mes, dia*/
select SYSDATETIME()
select (cast(SYSDATETIME() as date)) as datea,
cast(SYSDATETIME() as datetime) as datetimea



---funcion CONVERT
select 'el producto :' + ProductName +'el precio: ' +convert(varchar(10),UnitPrice)
from Products

---funcion TRY_CONVERT
/*devuelve un error en cuanto los caracteres de unitprice son >1, con try
devuelve nulo y no error*/
select 'el producto :' + ProductName +'el precio: ' +try_convert(varchar(1),UnitPrice)
from Products

--funcion convert con formato fecha
select CURRENT_TIMESTAMP
-- convert
select convert(char(10),CURRENT_TIMESTAMP,101) --formato USA
select convert(char(10),CURRENT_TIMESTAMP,102) --formato iso_ansi
select convert(char(10),CURRENT_TIMESTAMP,103) --formato uk


---PARSE permite de transformar texto en fecha
select parse('monday, 13 december 2010'as datetime2 using 'EN-us') as fecha


---ISNUMERIC

--tabla producto
select
ProductName,
UnitPrice,
CategoryID
from Products
-- evaluar si el valor es numerico o no
/* es numero si isnumeric es 1 no es numerico si es 0*/
select
ProductName,
isnumeric(ProductName) as productname,
unitprice,
isnumeric(UnitPrice) as unitprice,
categoryid,
isnumeric(CategoryID) as categoryid
from Products

--IIF
/*permite de realizar una condicion con resultado si verdadera o falsa*/
select
ProductName,
UnitPrice,
IIF(UnitPrice > 50, 'precio_alto','bajo') as categoria /* en IIF los argumentos son la condicion, si la condicion es verdadera
														si la condiciones falsa*/
from Products

--ISNULL 
/*permite de rellenar un valor nulo con un valor default
en costumer tengo valores nulos, necesito rellenarlos*/
select *
from Customers
where fax is null or phone is null
--ISNULL
/*creo consulta de los clientes con fax null para llamarlos*/
select
CustomerID,
ContactName,
isnull(Fax, 'llamar')
from Customers

/* puedo rellenar con un numero*/
select
CustomerID,
ContactName,
phone,
isnull(fax, '00-0')
from Customers

--COALESCE
/*devuelve el primer valor no nulo de una lista o variables 
dadas*/
/* en este caso busca los fax si son nulos pasa a phone si este tambien es nulo, advierte de actualizar*/
select
CompanyName,
coalesce(fax,phone,'actualizar') primer_valor_no_null --aqui la lista de variables es fax, phone, 'actualizar', 
from Customers

-- NULLIF
/* compara dos variables se iguales retorna null si son diferentes retorna
el primer valor*/
select
od.UnitPrice as precio_costo,
p.UnitPrice as precio_vend,
(od.Unitprice - p.unitprice) as delta_ganancia,
nullif(od.UnitPrice, p.unitprice) as precio_costo_1
from [Order Details] as od
inner join Products as p on od.ProductID=p.ProductID























