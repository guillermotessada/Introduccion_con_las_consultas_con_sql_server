--USAR UNA BASE DE DATOS ESPECIFICA--
USE Northwind
GO

--Hacer una consulta de todos los datos y columnas de una tabla --
select *
from Suppliers

--Limitar las columnas a mostrar
/* en este caso address es una palabra reservada de sql se puede [ ] */
select
CompanyName,
CompanyName, 
ContactTitle, 
ContactName, 
[Address] ,
Phone, 
Country
from Suppliers

--Uso de Alias
/* con los alias se pueden cambiar los nombres de las columnas y tablas */
select 
S.CompanyName as nombre_compania,
S.CompanyName as nombre_compania1, 
S.ContactTitle as titulo_contacto, 
S.ContactName as nombre_contacto, 
S.[Address] as direccion,
S.Phone as telefono, 
S.Country as estado
from dbo.Suppliers as S --dbo es el schema



