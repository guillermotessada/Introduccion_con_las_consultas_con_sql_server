-------------------------------Insert-----------------------------------

Insert into Customers (CustomerID ,CompanyName ,ContactName
,ContactTitle ,[Address] ,City ,Region ,PostalCode ,Country ,Phone, Fax)
values
('ABCD5','Compañia, S.A.','Juan Perez','Ing','7av 3-3 Zona 5'
,'Guatemala','Guatemala','01005', 'Guatemala','(502)-5435-5454'
,'(502)-5435-6676'),
('ABCD6','OtraCompañia, S.A.','Ana Perez','Lic','7av 3-3 Zona 10'
,'Guatemala','Guatemala','01010', 'Guatemala','(502)-5435-5454'
,'(502)-5435-6676')

---------------------Insertar datos a partir de un select------------------------
Insert into customers
 Select Concat(substring(Replace(companyName,' ',''),1,4),'9') as codigo
 , CompanyName  ,ContactName ,ContactTitle ,[Address] ,City
 ,Region ,PostalCode  ,Country ,Phone, Fax
from suppliers

-----Creando un procedimiento almacenado para posteriormente insertar datos------
CREATE Procedure DatosProveedor
as
 Select Concat(substring(Replace(companyName,' ',''),1,4),'9') as codigo
 , CompanyName  ,ContactName ,ContactTitle ,[Address] ,City
 ,Region ,PostalCode  ,Country ,Phone, Fax
from suppliers
-----Insertar datos a partir del procedimiento anterior creado---------------------
Insert into Customers
Execute DatosProveedor

---------------------Crear a partir de los datos de un select otra tabla-----------
select c.customerid, c.companyname, o.orderid, o.orderdate
INTO ORDENESNUEVAS
from customers as c inner join orders as o
on c.CustomerID=o.customerid

Select * from ORDENESNUEVAS
---------------------Borrar el objeto-----------------------------------
DROP TABLE ORDENESNUEVAS
---------------------Objetos Temporales
#TablaTemporal    --Tabla Temporal Local solo se ve en mi sesion (local)
##TablaTemporal   --Tabla Temporal se ve en todas las sesiones (global)

---------------------Crear una tabla basica para usar default----------
Create table Test
(codigo int identity(1,1) not null primary key,
nombre varchar(100),
estadocivil varchar(100) default ('Soltero')
)

Insert into Test(  nombre, estadocivil)
values ('Juan Piao', DEFAULT)

---------------------------------Borrar datos------------------------------------
select * from ORDENESNUEVAS

--------------------BORRA SIN PASAR POR EL LOG DE TRANSACCIONES (CRIMEN PERFECTO)
TRUNCATE TABLE ORDENESNUEVAS

--------------------BORRADO NORMAL CON DELETE------------------------------------
DELETE FROM CUSTOMERS WHERE CUSTOMERID IN
(Select concat(substring(Replace(companyName,' ',''),1,4),'9') as codigo
from suppliers)
-------------
SELECT C.CUSTOMERID, C.COMPANYNAME, O.ORDERID, O.ORDERDATE
FROM CUSTOMERS AS C INNER JOIN ORDERS AS O ON C.CustomerID=O.CustomerID
WHERE O.OrderID IS NULL


--------------------ELIMINAR DATOS DE UNA TABLA CON RESPECTO A OTRA TABLA
--ELIMINAR LOS CLIENTES QUE NO HAN REALIZADO UNA ORDEN
Delete from C
from customers as c left join orders as o
on c.CustomerID=o.customerid where
 o.orderid is null


--------------------UPDATE
UPDATE CUSTOMERS
SET CompanyName=Companyname+',USA'
where country='USA'

--------------------ACTUALIZAR
--TODOS LOS PRECIOS DE LOS PRODUCTOS DE ESTADOS UNIDOS
SELECT S.COMPANYNAME
, S.COUNTRY, P.PRODUCTNAME, P.UnitPrice
FROM
SUPPLIERS AS S INNER JOIN
PRODUCTS AS P ON P.SupplierID=S.SupplierID
WHERE S.COUNTRY='USA'
--------------------SUBE EL 5% A TODOS LOS PRODUCTOS DE USA
UPDATE P SET P.UnitPrice=P.UnitPrice * 1.05
FROM
SUPPLIERS AS S INNER JOIN
PRODUCTS AS P ON P.SupplierID=S.SupplierID
WHERE S.COUNTRY='USA'
----------------------------Merge-------------------------------------------------
Select *
into ClientesA
from Customers

Select *
into ClientesB
from Customers

Delete clientesA where companyname like '[a-d]%'

Update clientesA Set companyname='Nombre-Eliminado' where country='USA' or Country='France'
---------------------------Identity--------------------------
DBCC CHECKIDENT (suppliers, RESEED, 200);
GO
Set identity_insert suppliers on

---------------------------Uso de Sequence--------------------
Create sequence numerador
as int
start with 5
increment by 5
go

Create table TablaEjemplo2
(codigo int primary key default (next value for numerador) ,
nombre varchar(100)
)
Insert into TablaEjemplo2 (codigo, nombre) values
(Default, 'Hugo'),
(Default, 'Paco'),
(Default , 'Luis')

Select max(supplierid) from suppliers

insert into suppliers (companyname, contactname, country)
values ('Empresa prueba','Juanito Bazooka','Guatemala')