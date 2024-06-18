use nbd3
go
sp_helpconstraint TB_CLIENTE
go
sp_helpconstraint TB_PRODUCTO
go
sp_helpconstraint TB_FACTURA
go
SELECT * FROM sys.tables
--TB_CLIENTE	1381579960
--TB_PRODUCTO	1237579447
--TB_FACTURA	1557580587
--TB_DETALLE_FACTURA	1685581043

SELECT * FROM sys.indexes WHERE object_id=1381579960
-- pk
-- uk

CREATE INDEX IDX_TB_CLIENTE_ESTADO ON TB_CLIENTE(estado)
go
CREATE INDEX IDX_TB_CLIENTE_TIPO ON TB_CLIENTE(tipo)
go
sp_helpindex TB_CLIENTE

SELECT * FROM TB_CLIENTE WHERE codigo=100

ALTER INDEX IDX_TB_CLIENTE_TIPO ON TB_CLIENTE DISABLE

SELECT * FROM sys.indexes WHERE object_id=1381579960

ALTER INDEX ALL ON TB_CLIENTE DISABLE
GO
ALTER INDEX ALL ON TB_CLIENTE REBUILD
GO

--- sentencias DML (Data Manipulation Language)
--- INSERT / UPDATE / DELETE

--- sentencias DDL (Data Definition Language)
--- CREATE / ALTER / DROP

--- INSERT
SELECT * FROM TB_CLIENTE

INSERT INTO TB_CLIENTE VALUES (1000,'CLIENTE 1000','B',3)

INSERT INTO TB_CLIENTE VALUES 
(1100,'CLIENTE 1100','B',3),
(1200,'CLIENTE 1200','B',3),
(1300,'CLIENTE 1300','B',3),
(1400,'CLIENTE 1400','B',3)

SELECT * FROM TB_PRODUCTO

INSERT INTO TB_PRODUCTO (numero, nombre)
VALUES (40,'PRODUCTO 40')

-- SI O SI SIEMPRE INCLUIR COLUMNAS TIPO NOT NULL
-- TODAS LAS DEMAS COLUMNAS A TU ELECCION

INSERT INTO TB_PRODUCTO (numero) VALUES (50)

INSERT INTO TB_PRODUCTO (numero, estado) VALUES (60,'A')

-------------------
CREATE TABLE TB_DEMO
(
id INT PRIMARY KEY IDENTITY(1,1),
nombre VARCHAR(50),
estado CHAR(1)
)

INSERT INTO TB_DEMO VALUES ('Producto ABC','A')
GO 50

SELECT * FROM TB_DEMO

INSERT INTO TB_DEMO VALUES ('Producto XYZ','B')
GO 200

-------------------
SELECT * FROM TB_CLIENTE

SELECT * INTO TB_CLIENTE_20240602 FROM TB_CLIENTE

SELECT * FROM TB_CLIENTE_20240602 

SELECT * INTO TB_CLIENTE_B_20240602 FROM TB_CLIENTE WHERE ESTADO='B'

SELECT * FROM TB_CLIENTE_B_20240602

SELECT codigo, razon_social INTO TB_CLIENTE_PARCIAL FROM TB_CLIENTE

SELECT * FROM TB_CLIENTE_PARCIAL

SELECT * INTO TB_CLIENTE_VACIA FROM TB_CLIENTE WHERE CODIGO=0

SELECT * FROM TB_CLIENTE_VACIA 

SELECT * FROM TB_CLIENTE

INSERT INTO TB_CLIENTE_VACIA
SELECT * FROM TB_CLIENTE WHERE codigo IN (200,600,900,1300)

---------------

--BULK
BULK INSERT TB_CLIENTE
FROM 'D:\AAA_Cibertec\3° CICLO\BDA 1\sem2\carga_cliente.csv'
WITH
(
FIELDTERMINATOR=',' ,
ROWTERMINATOR='\n'
)

BULK INSERT TB_CLIENTE
FROM 'D:\AAA_Cibertec\3° CICLO\BDA 1\sem2\carga_cliente_1.csv'
WITH
(
FIELDTERMINATOR=',',
ROWTERMINATOR='\n'
)

BULK INSERT TB_CLIENTE
FROM 'D:\AAA_Cibertec\3° CICLO\BDA 1\sem2\carga_cliente_2.csv'
WITH
(
FIELDTERMINATOR=',',
ROWTERMINATOR='\n',
FIRSTROW=2
)

SELECT * FROM TB_CLIENTE

--------------------------------
SELECT * FROM TB_CLIENTE WHERE ESTADO='B'

UPDATE TB_CLIENTE
SET TIPO=1
WHERE ESTADO='B'

SELECT * FROM TB_CLIENTE WHERE codigo IN (1800,2000)

DELETE FROM TB_CLIENTE WHERE codigo IN (1800,2000)

--------------------------------
--MERGE

CREATE TABLE T_CAMP_2023_2
(Codigo	INT,
Producto VARCHAR(30),
Precio DECIMAL(9,2))

CREATE TABLE T_CAMP_2023_3
(Codigo	INT,
Producto VARCHAR(30),
Precio DECIMAL(9,2))

SELECT * FROM T_CAMP_2023_2
SELECT * FROM T_CAMP_2023_3

BULK INSERT T_CAMP_2023_2
FROM 'D:\AAA_Cibertec\3° CICLO\BDA 1\sem2\campana_2023_2.csv'
WITH
(
FIELDTERMINATOR=',' ,
ROWTERMINATOR='\n',
FIRSTROW=2
)

BULK INSERT T_CAMP_2023_3
FROM 'D:\AAA_Cibertec\3° CICLO\BDA 1\sem2\campana_2023_3.csv'
WITH
(
FIELDTERMINATOR=',' ,
ROWTERMINATOR='\n',
FIRSTROW=2
)

SELECT * FROM T_CAMP_2023_2
SELECT * FROM T_CAMP_2023_3


MERGE T_CAMP_2023_2 AS Target
USING T_CAMP_2023_3 AS Source
ON (Source.Codigo = Target.Codigo)
WHEN MATCHED THEN
	UPDATE SET Precio=Source.Precio, Producto=Source.Producto
WHEN NOT MATCHED THEN
	INSERT VALUES (Source.Codigo, Source.Producto, Source.Precio);

-- (4 filas afectadas)
-- 2 UPDATE
-- 2 INSERT

SELECT * FROM T_CAMP_2023_2
SELECT * FROM T_CAMP_2023_3

-----------------------------------
MERGE T_CAMP_2023_2 AS Target
USING T_CAMP_2023_3 AS Source
ON (Target.Codigo = Source.Codigo)
WHEN MATCHED THEN
	DELETE
WHEN NOT MATCHED THEN
	INSERT VALUES (Source.Codigo, Source.Producto, Source.Precio);

-- (4 filas afectadas)
-- 4 DELETE

--- SELECT 
USE Northwind

SELECT * FROM  Products

SELECT ProductID, ProductName, SupplierID, CategoryID, UnitPrice FROM  Products

SELECT ProductName, SupplierID, CategoryID, ProductID,  UnitPrice FROM  Products

SELECT ProductName AS 'Nombre_Producto', 
SupplierID AS 'Codigo_Distribuidor', 
CategoryID, 
ProductID,  
UnitPrice 
FROM  Products

-- funciones texto
UPPER
LOWER
CONCAT
SELECT * FROM Products
SELECT CONCAT(ProductID,ProductName) AS 'JUEGUITO' FROM Products
LEN
SUBSTRING
REPLACE
-- funciones numeros
ROUND
ABS
+ - * /
-- funciones fechas
DATEADD
DATEDIFF
YEAR
MONTH
DAY

DATE
DATETIME

DATEPART
DATENAME

SELECT OrderID, CustomerID, LOWER(CustomerID) AS 'Cliente_minus', 
EmployeeID, OrderDate, SUBSTRING(CustomerId,1,3) AS 'subString(1,3)'
FROM Orders
WHERE YEAR(OrderDate)=1997 AND 
MONTH(OrderDate)=12 AND
DAY(OrderDate) BETWEEN 1 AND 5

SELECT * FROM Products

SELECT * FROM Products ORDER BY UnitsInStock

SELECT * FROM Products ORDER BY UnitsInStock DESC

SELECT * FROM Products ORDER BY CategoryId, UnitsInStock

SELECT * FROM Products ORDER BY 6 desc

SELECT * FROM Products ORDER BY 20

SELECT TOP 5 * FROM Products ORDER BY UnitPrice DESC

SELECT TOP 1 * FROM Products ORDER BY UnitPrice DESC

SELECT distinct SupplierID FROM Products
SELECT * FROM Products

-- consultas de agrupamiento
-- COUNT / SUM / MAX / MIN / AVG / STD

SELECT * FROM Products 

SELECT CategoryId, COUNT(*) AS 'Conteo'
FROM Products
GROUP BY CategoryId

SELECT CategoryId, COUNT(ProductID) AS 'Conteo'
FROM Products
GROUP BY CategoryId

SELECT COUNT(ProductID) AS 'Conteo'
FROM Products

SELECT COUNT(ProductID) AS 'Conteo'
FROM Products
WHERE discontinued=1

SELECT * FROM Products 

SELECT CategoryId, discontinued,  COUNT(ProductID) 'Conteo'
FROM Products
GROUP BY CategoryId, discontinued
ORDER BY 1,2

SELECT CategoryId, discontinued,  COUNT(ProductID) 'Conteo'
FROM Products
GROUP BY CategoryId, discontinued
HAVING COUNT(ProductID) >=10
ORDER BY 1,2

SELECT MIN(OrderDate) 'MIN', MAX(OrderDate) 'MAX' FROM Orders

----------
-- Consultas MultiTabla

SELECT OrderId, CustomerId, EmployeeId, OrderDate 
FROM Orders
--830

SELECT Orders.OrderId, Orders.CustomerId, 
	Orders.EmployeeId, Orders.OrderDate,
	Customers.CustomerID, Customers.CompanyName
FROM Orders, Customers
WHERE
	Orders.CustomerID = Customers.CustomerID

sp_helpconstraint Orders

SELECT O.OrderId, O.CustomerId, 
	O.EmployeeId, O.OrderDate,
	C.CustomerID, C.CompanyName, C.Country
FROM Orders O, Customers C
WHERE
	O.CustomerID = C.CustomerID AND
	O.CustomerID in ('VINET','HANAR','FOLKO') AND
	C.Country = 'Brazil'

SELECT * FROM Customers

SELECT Orders.OrderId, Orders.CustomerId, 
	Orders.EmployeeId, Orders.OrderDate,
	Customers.CustomerID, Customers.CompanyName
FROM Orders INNER JOIN Customers 
ON (Orders.CustomerID = Customers.CustomerID)
	

SELECT Orders.OrderId, Orders.CustomerId, 
	Orders.EmployeeId, Orders.OrderDate,
	Customers.CustomerID, Customers.CompanyName,
	Employees.EmployeeID, Employees.LastName, Employees.FirstName
FROM Orders, Customers, Employees
WHERE
	Orders.CustomerID = Customers.CustomerID AND
	Orders.EmployeeID = Employees.EmployeeID


SELECT * FROM Orders

sp_helpconstraint Orders

SELECT Orders.OrderId, Orders.CustomerId, 
	Orders.EmployeeId, Orders.OrderDate,
	Orders.ShipVia,
	Customers.CustomerID, Customers.CompanyName,
	Employees.EmployeeID, Employees.LastName, Employees.FirstName,
	Shippers.ShipperID, Shippers.CompanyName
FROM Orders, Customers, Employees, Shippers
WHERE
	Orders.CustomerID = Customers.CustomerID AND
	Orders.EmployeeID = Employees.EmployeeID AND
	Orders.ShipVia = Shippers.ShipperID


SELECT Orders.OrderId, Orders.CustomerId, 
	Orders.EmployeeId, Orders.OrderDate,
	Orders.ShipVia,
	Customers.CustomerID, Customers.CompanyName,
	Employees.EmployeeID, Employees.LastName, Employees.FirstName,
	Shippers.ShipperID, Shippers.CompanyName
FROM Orders
inner join Customers on (Orders.CustomerID = Customers.CustomerID)
inner join Employees on (Orders.EmployeeID = Employees.EmployeeID)
inner join Shippers on (Orders.ShipVia = Shippers.ShipperID)

