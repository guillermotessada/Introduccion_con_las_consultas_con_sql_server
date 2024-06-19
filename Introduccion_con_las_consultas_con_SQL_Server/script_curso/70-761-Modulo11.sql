------------Expresiones de Tabla------------------------------
------------Expresiones que devuelven set de datos como la Vista
go
Create view Ventas
(compañia, numero_orden, fecha, producto, precio, cantidad)
with encryption, schemabinding, View_metadata
as
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from dbo.customers as c
inner join dbo.orders as o on c.customerid=o.customerid
inner join dbo.[Order Details] as d on d.OrderID=o.orderid
inner join dbo.products as p on p.ProductID=d.ProductID
Go
------------Consultar el script de la vista
sp_helptext Ventas
Go
Select * from ventas
Go
------------Creacion de vista
Create view clientesArgentina
as
Select customerid, companyname, contactname, country
from customers
where country='Argentina'
with check option
Go
Select * from clientesArgentina
Go
Insert into clientesArgentina 
(customerid, companyname, contactname, country)
values ('ABCD4','Empresa X','Juan Perez','Guatemala')
Go

------------Consulta de vista
Select * from clientesArgentina
go
----Insercion de datos a la tabla por medio de la vista
Insert into clientesArgentina(customerid, companyname, contactname, country)
values
('ABC44','Test44','Julio Menendez','Guatemala')
Go
---------------------Funciones con valores de tabla en linea
Create function fnVentas (@productid int)
Returns Table
as
Return(
Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID
where d.ProductID=@productid
)
Go
Select * from fnVentas(23)
Go
---------------------CTE------------------------------------
WITH CTE_year AS
	(
	SELECT YEAR(orderdate) AS orderyear, customerid
	FROM Orders
	)
SELECT orderyear, COUNT(DISTINCT customerid) AS cust_count
FROM CTE_year
GROUP BY orderyear
Go
---Hacer un selft join normal y con CTE
Select j.FirstName+ ' ' + j.LastName as jefe,
s.FirstName+ ' ' + s.LastName as subalterno
from employees as j inner join employees as s
on j.employeeid=s.reportsto
Go
----con CTE
WITH Jefe AS
	(Select EmployeeID, FirstName + ' '+ LastName 
	as empleado from Employees
	)
SELECT Jefe.empleado, Employees.FirstName, Employees.LastName
from Employees inner join Jefe on 
Jefe.EmployeeID=Employees.ReportsTo
Go

------------Empacar el CTE en una funcion
Create function fn_jerarquia(@empid as int)
Returns table
as 
Return(
With Empleado_Arbol(employeeid, name, reportsto, lvl)
as
(Select Employeeid, FirstName +' '+LastName as name, reportsto,
0 as lvl from Employees where Employeeid=@empid
union all
Select e.EmployeeId, e.FirstName+' '+e.LastName as name,
e.Reportsto, es.lvl+1 as lvl from Employees as e inner join
Empleado_Arbol as es on e.Reportsto=es.Employeeid)
Select * from Empleado_Arbol
)
Go

Select * from fn_jerarquia(2)
Go

Select T.companyname, Sum(T.unitprice*T.quantity) from
(Select c.companyname, o.orderid, o.orderdate,
p.productname, d.unitprice, d.quantity from customers as c
inner join orders as o on c.customerid=o.customerid
inner join [Order Details] as d on d.OrderID=o.orderid
inner join products as p on p.ProductID=d.ProductID
Order by C.CompanyName
) as T
group by T.CompanyName
Go
Select orderyear, count(distinct customerid) as cust_count
from (Select Year(orderdate), customerid from Orders) as
     derived_year(orderyear, customerid)
	 Group by orderyear
Go