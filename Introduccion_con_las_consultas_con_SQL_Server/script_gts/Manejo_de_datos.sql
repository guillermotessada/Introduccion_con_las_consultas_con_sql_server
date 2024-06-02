use Northwind
go

-------------------------------Insert-----------------------------------

--INSERT /* en este caso se indica la tabla y las variables de la tabla
Insert into Customers (CustomerID ,CompanyName ,ContactName
,ContactTitle ,[Address] ,City ,Region ,PostalCode ,Country ,Phone, Fax)
values
('ABCD5','Compañia, S.A.','Juan Perez','Ing','7av 3-3 Zona 5'
,'Guatemala','Guatemala','01005', 'Guatemala','(502)-5435-5454'
,'(502)-5435-6676'),
('ABCD6','OtraCompañia, S.A.','Ana Perez','Lic','7av 3-3 Zona 10'
,'Guatemala','Guatemala','01010', 'Guatemala','(502)-5435-5454'
,'(502)-5435-6676')

--INSERT 
/* en este caso se indica la tabla pero no los campos de la tabla,
hay que estar atentos que las variables esten en el mismo orden*/
Insert into Customers
values
('ABCD7','Compañia, S.A.','Juan Perez','Ing','7av 3-3 Zona 5'
,'Guatemala','Guatemala','01005', 'Guatemala','(502)-5435-5454'
,'(502)-5435-6676'),
('ABCD8','OtraCompañia, S.A.','Ana Perez','Lic','7av 3-3 Zona 10'
,'Guatemala','Guatemala','01010', 'Guatemala','(502)-5435-5454'
,'(502)-5435-6676')

--insertar datos a partir de un select
/* nota se insertan datos a customer desde suppliers*/
--  tabla costumer, el customerid es de 5 caracteres
select *
from Customers

/* insert de datos de una tabla a otra*/
insert into Customers
select 
/* remplaza companyname los espacios con nada, toma los caracteres de 1a 4
agrega un 7 al final*/
concat(substring(replace(CompanyName, ' ',''),1,4),'9') as codigo,
CompanyName,
ContactName,
ContactTitle,
[Address],
City,
Region,
PostalCode,
Country,
Phone,
fax
from Suppliers

--insert datos a partir de un procedimiento
create procedure nombre_procedure
as
select
concat(substring(replace(CompanyName, ' ',''),1,4),'5') as codigo,
CompanyName,
ContactName,
ContactTitle,
[Address],
City,
Region,
PostalCode,
Country,
Phone,
fax
from Suppliers
/* para ejecutar el procedimiento*/
insert Customers --solo con insert se insertan en la taba
execute nombre_procedure --llamando solo execute se tiene una vista previa 

--INTO crear a partir de los datos de un select otra tabla
/* esta tabla no tiene pk*/
select
c.CustomerID,
c.CompanyName,
o.OrderID,
o.OrderDate
into ordernesnuevas -- se genera una nueva tabla con el nombre ordenesnuevas
from Customers as c
inner join orders as o on c.CustomerID=o.CustomerID

select * 
from ordernesnuevas

--borrar tabla drop table
drop table ordernesnuevas

--INTO crear una tabla temporal se usa #  a partir de los datos de un select otra tabla
/* las tablas temporales se borran al cerrar el motor */
select
c.CustomerID,
c.CompanyName,
o.OrderID,
o.OrderDate
into #ordernesnuevas -- se genera una nueva tabla con el nombre ordenesnuevas
from Customers as c
inner join orders as o on c.CustomerID=o.CustomerID

--borrar tabla temporal drop table
drop table #ordernesnuevas

-- para llamar la tabla temporal uso #
select * 
from #ordernesnuevas


--eliminar registro
select *
from ordernesnuevas
--eliminamos VINET
delete from ordernesnuevas
where customerID = 'VINET'
--
select *
from ordernesnuevas
where customerID = 'VINET'

--update
select *
from Customers

update Customers
set CompanyName = 'GUILLE'
where CustomerID = 'ABCD5'


--update

update Customers
set CompanyName= 'GUILLERMO'
where CustomerID = 'ABCD5' --update de solo una fila
--test
select *
from Customers

/* update de la tabla Customer con las company name que sean de USA*/
update Customers
set CompanyName = CompanyName + 'USA'
where Country = 'USA' --update de filas segun el predicado
--compruevo

--revertir el cambio
update Customers
set CompanyName = replace(CompanyName,',USA','')
where Country ='USA'

--- actualizar una tabla respecto a otra con update

select *
from products
select *
from Suppliers

--creo una tabla con los productos de estados unidos
/* actualizo con un nuevo campo*/
select
p.ProductName,
s.Country,
p.UnitPrice,
p.UnitPrice*0.10 as nuevo_precio
from Products as p
inner join Suppliers as s
on p.SupplierID=s.SupplierID
where s.Country = 'USA'

-- actualizo con update

update p
set p.UnitPrice= p.UnitPrice*0.20
from Products as p
inner join Suppliers as s
on p.SupplierID=s.SupplierID
where s.Country = 'USA'



-- truncate table <nombre tabla> elimina todos los registros de una tabla

select *
from ordernesnuevas
/*uso de truncate, elimana todos los valores pero no toca el schema
truncate no funciona en el caso de tablas con llaves foraneas*/
truncate table ordernesnuevas

-- creo una nueva tabla ordernesnuevas2
select
c.CustomerID,
c.CompanyName,
o.OrderID,
o.OrderDate
into ordernesnuevas2 -- 
from Customers as c
inner join orders as o on c.CustomerID=o.CustomerID

--ahora relleno con los valores de ordernesnuevas2 la ordernesnuevas que esta vacia

insert into ordernesnuevas
select *
from ordernesnuevas2

select *
from ordernesnuevas


-----eliminar datos de una tabla con respecto a otra tabla

select
c.CustomerID,
c.CompanyName,
o.OrderDate,
o.OrderDate
from Customers as c
left join Orders as o
on c.CustomerID=o.CustomerID
where o.OrderDate is null

-----eliminar nulos de una tabla
delete from c
from Customers as c
left join Orders as o
on c.CustomerID=o.CustomerID
where o.OrderDate is null


----------merge
/*creo la tabla clientesA*/
select
CustomerID,
CompanyName,
ContactName,
ContactTitle
into clientesA
from Customers
where Country in ('Mexico','Argentina','Venezuela')

/*creo la tabla clientesB*/
select
CustomerID,
CompanyName,
ContactName,
ContactTitle
into clientesB
from Customers
where Country in ('Mexico','Argentina','Venezuela')

------------------eliminar y actualizar datosde clientesa para que sea diferente a clientesb
delete from clientesA
where CustomerID like '[a-c]%'

update clientesA
set CompanyName = '***no definido***',
ContactName = '***no tiene***'
where CustomerID like'[G_H]%'

delete from clientesB
where CustomerID = 'TORTU'

---consultar las dos tablas clientesa y clientesb
select *
from clientesA

select *
from clientesB

----MERGE
/*compara dos tablas y si hay coincidencia o no
se decide que accion tomar-- objetivo clientesa = clientesb*/

merge into dbo.clientesa as A using dbo.clientesb as B --clientesa tabla objetivo clientesb tabla fuente
on A.customerid=B.customerid
/*que hacer cuando los datos estan en la fuente y no en el objetivo*/
when matched then
	update set A.Companyname =b.companyname, A.contactname = B.contactname
/* que hacer cuando no esten en la fuente y no en objetivo,
inserta datos en la objetivo*/
when not matched then
	insert (Customerid, companyname, contactname,contactTitle)
	values
	(b.Customerid, b.companyname, b.contactname, b.contactTitle)
/* que hacer cuando esten en el objetivo y no en la fuente
inserta en la fuente los datos que estan en la objetivo*/
when not matched by source then
	delete;

--control
select *
from clientesA
select *
from clientesB


------------identity
/*genera numeros secuenciales para una variable*/
create table test1
(
codigo int identity(1,1) primary key, --en indentity parte con 1 y se incrementa de 1
nombre varchar (100)
)
go
insert into test1
(nombre) values ('jose'), ('claudia')

select *
from test1

/* con @@identity se obtiene el ultimo identity*/
select @@IDENTITY

/* con indent_current se obtiene el ultimo identity para una tabla especifica*/
select IDENT_CURRENT ('Suppliers')


----                                sequence
/* crea objeto sequence numerador*/
create sequence numerador --nombre numerador
as int --tipo numerador
start with 1
increment by 1
minvalue 1
maxvalue 100
NO Cycle -- puede hacer un ciclo

--llamada de mas una tabla
select next value for numerador

/* creo tabla para usar sequence*/
create table test2
(
codigo int,
nombre varchar(100)
)

/* para que cada fila tome un correlativo con la funcion numerador*/
insert into test2 (codigo,nombre)
values
(next value for numerador, 'gianni'),
(next value for numerador, 'paola'),
(next value for numerador, 'ale')

select *
from test2

/* automatizar sequence*/

create table test3
(
codigo int primary key default(next value for numerador),
nombre varchar(100)
)

insert into test3
(nombre) values ('gianni'), ('ale'),('paola')

select *
from test3

drop table test3















