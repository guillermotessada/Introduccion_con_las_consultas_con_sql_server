--Funcion Convert y Cast
Select 'El codigo ' + convert(varchar(5),productid) + ' corresponde al producto ' + productname
+ ' con el precio de ' + convert(varchar(150),unitprice) 
from products
go

Select 'El codigo ' + cast(productid as varchar(5)) + ' corresponde al producto ' + productname
+ ' con el precio de ' + cast(unitprice as varchar(150)) 
from products
go

--Parse
SELECT PARSE('Monday, 13 December 2010' AS datetime2 USING 'en-US') AS fecha; 
go
SELECT PARSE('€345,98' AS money USING 'de-DE') AS moneda; 
go

--iif
SELECT     productname, unitprice, 
                IIF(unitprice > 50, 'high','low') AS pricepoint
FROM products;

--choose
SELECT productname, 
CHOOSE (categoryid,'Beverages' ,'Condiments','Confections' ,'Dairy Products' ,'Grains/Cereals' ,'Meat/Poultry' ,'Produce' ,'Seafood')
from products
go

--is null
Select customerid, companyname, isnull(fax,'n/a') from customers
go

---COALESCE
--Toma el primer valor no nulo de una lista

SELECT     customerid, country, region, city,
                country + ',' + COALESCE(region, ' ') + ', ' + city as location
FROM customers;
go

Select customerid, fax, phone,  COALESCE(fax, phone) as comunication from customers

--nullif
--Si el precio es igual pone NULL si no pone el precio del primero
Select p.productname, p.unitprice, d.unitprice, NULLIF( p.unitprice,d.unitprice) as comparación
from products as p inner join [order details] as d
on p.productid=d.productid