ALTER PROCEDURE PR_DEVUELVE_MONTO (@v_OrderId INT, @v_Monto MONEY OUT)
AS
BEGIN
	SELECT @v_Monto=SUM(UNITPRICE*QUANTITY) 
	FROM [ORDER DETAILS] WHERE ORDERID=@v_OrderId
END
-----------------------------
DECLARE @v_Variable MONEY
execute PR_DEVUELVE_MONTO 10270, @v_Variable OUT
PRINT @v_Variable
-----------------------------
SELECT SUM(UNITPRICE*QUANTITY) FROM [ORDER DETAILS] 
WHERE ORDERID=10270
------------------------------------------------------
CREATE PROCEDURE p_Devuelve_Monto_Fechas
@p_FechaInicio DATE, @p_FechaTermino DATE, @p_Monto MONEY OUTPUT
AS
BEGIN
	SELECT @p_Monto=SUM(det.Quantity*det.UnitPrice)
	FROM [dbo].[Orders] ord, [dbo].[Order Details] det
	WHERE
		ord.OrderID = det.OrderID AND
		ord.OrderDate BETWEEN @p_FechaInicio AND @p_FechaTermino
END
------------------------------------------------------
DECLARE @v_Monto MONEY
EXECUTE p_Devuelve_Monto_Fechas '1996-07-01', '1996-12-31', @v_Monto OUTPUT
PRINT @v_Monto
------------------------------------------------------
DECLARE @v_Monto MONEY
EXECUTE p_Devuelve_Monto_Fechas '2006-07-01', '2006-12-31', @v_Monto OUTPUT
PRINT @v_Monto
------------------------------------------------------
--530739.37
--226298.50
-----------------------------
CREATE FUNCTION FN_MULTIPLICA (@v_num1 MONEY, @v_num2 MONEY)
RETURNS MONEY
AS
BEGIN
	DECLARE @resultado MONEY
	SET @resultado = @v_num1 * @v_num2
	RETURN @resultado
END
-----------------------------
SELECT dbo.fn_multiplica(50,9)
-----------------------------
DECLARE @v_suma MONEY = dbo.fn_multiplica(50,9)
PRINT @v_suma
-----------------------------
SELECT * FROM [dbo].[Products]




-----------------------------
CREATE FUNCTION fn_Valida_Stock (@p_Stock INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @v_mensaje VARCHAR(100)
	IF @p_Stock < 10 
		SET @v_mensaje = 'Necesita urgente compra immediata'
	ELSE IF @p_Stock < 100
		SET @v_mensaje = 'Revisar stock la siguiente semana'
	ELSE
		SET @v_mensaje = 'Aún tenemos stock suficiente'

	RETURN @v_mensaje
END
-------------------------------------------
SELECT ProductID, ProductName, UnitsInStock, 
	dbo.fn_Valida_Stock(UnitsInStock) 
FROM [dbo].[Products]
-------------------------------------------
SELECT * FROM Employees

SELECT COUNT(OrderId) FROM Orders WHERE EmployeeID=1

prmendez@cibertec.edu.pe
-------------------------------------------
CREATE FUNCTION fn_CalculaNumeroPedidos (@p_EmployeeID INT)
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(OrderId) FROM Orders WHERE EmployeeID=@p_EmployeeID)
END
-------------------------------------------
SELECT dbo.fn_CalculaNumeroPedidos(1)

SELECT EmployeeID, LastName, FirstName, 
dbo.fn_CalculaNumeroPedidos(EmployeeID)
FROM Employees

-------------------------------------------
bloqueos T-SQL
|-- procedimientos almacenados
|-- funciones propias

|-- disparadores / trigger

DML = INSERT UPDATE DELETE
DDL = CREATE ALTER DROP
LOGIN

-----------------------------------
SELECT * FROM sys.triggers
-----------------------------------
CREATE TRIGGER TRG_PRODUCTS_ALL_DML
ON [dbo].[Products]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	PRINT 'Evento I U D capturado'
END
-----------------------------------
INSERT INTO [dbo].[Products](ProductName) VALUES ('Jabones')
SELECT * FROM Products

UPDATE [dbo].[Products] SET UnitsInStock=100 WHERE ProductID=78
------------------------------------------------------------------
DELETE FROM [dbo].[Products] WHERE ProductID=78

DELETE FROM [dbo].[Products] WHERE ProductID=999
-----------------------------------
SELECT * FROM sys.tables WHERE name='Products'
--1157579162
SELECT * FROM sys.triggers
------------------------------------------------------------------
sp_helptext [TRG_PRODUCTS_ALL_DML]

DISABLE TRIGGER [TRG_PRODUCTS_ALL_DML] ON [dbo].[Products]
INSERT INTO [dbo].[Products](ProductName) VALUES ('Alcohol 96 botella 500ml')

ENABLE TRIGGER [TRG_PRODUCTS_ALL_DML] ON [dbo].[Products]

INSERT INTO [dbo].[Products](ProductName) VALUES ('Alcohol 96 botella 1000ml')
SELECT * FROM [dbo].[Products]


DROP TRIGGER [TRG_PRODUCTS_ALL_DML]
------------------------------------------------------------------
CREATE TRIGGER TRG_PRODUCTS_ONLY_INSERT
ON [dbo].[Products] FOR INSERT AS
BEGIN
	PRINT 'INSERT identificado'
END
------------------------------------------------------------------
INSERT INTO [dbo].[Products](ProductName) VALUES ('Hojas Bond A4 60g')
UPDATE [dbo].[Products] SET UnitsInStock=100 WHERE ProductID=79
------------------------------------------------------------------
CREATE TRIGGER TRG_PRODUCTS_ONLY_UPDATE
ON [dbo].[Products] FOR UPDATE AS
BEGIN
	PRINT 'UPDATE identificado'
END
------------------------------------------------------------------
CREATE TRIGGER TRG_PRODUCTS_ONLY_DELETE
ON [dbo].[Products] FOR DELETE AS
BEGIN
	PRINT 'DELETE identificado'
END
------------------------------------------------------------------
SELECT * FROM sys.triggers
SELECT * FROM sys.trigger_events
------------------------------------------------------------------
UPDATE [dbo].[Products] SET UnitsInStock=100 WHERE ProductID=79

SELECT * FROM Products

DELETE FROM Products WHERE ProductID=80

------------------------------------------------------------------
CREATE TRIGGER TRG_PRODUCTS_ONLY_INSERT_VERSION2
ON [dbo].[Products] FOR INSERT AS
BEGIN
	PRINT 'INSERT identificado VERSION 2'
END
------------------------------------------------------------------
INSERT INTO [dbo].[Products](ProductName) 
VALUES ('Alcohol 96 botella 2000ml')

DISABLE TRIGGER ALL ON [dbo].[Products]
ENABLE TRIGGER ALL ON [dbo].[Products]

INSERT INTO [dbo].[Products](ProductName) 
VALUES ('Alcohol 96 botella 5000ml')
------------------------------------
CREATE TABLE TB_AUDIT_PRODUCTS
(
LogId INT IDENTITY(1,1) NOT NULL,
ProductId INT NOT NULL,
Operacion VARCHAR(10) NOT NULL,
FechaActualiza	DATETIME NOT NULL
)
------------------------------------
CREATE TRIGGER TRG_PRODUCTS_ONLY_INSERT_AUDIT
ON [dbo].[Products]
FOR INSERT
AS
	INSERT INTO TB_AUDIT_PRODUCTS
	SELECT ProductID, 'INSERT',GETDATE() FROM INSERTED
---------------------------------------------
SELECT * FROM Products

INSERT INTO [dbo].[Products](ProductName) 
VALUES ('Lapiceros de goma')

CREATE TRIGGER TRG_PRODUCTS_ONLY_UPDATE_AUDIT
ON [dbo].[Products]
FOR UPDATE
AS
	INSERT INTO TB_AUDIT_PRODUCTS
	SELECT ProductID, 'UPDATE',GETDATE() FROM DELETED
---------------------------------------------
UPDATE [dbo].[Products] SET UnitPrice =  UnitPrice * 1.5 
WHERE ProductID=2
---------------------------------------------
SELECT * FROM TB_AUDIT_PRODUCTS
---------------------------------------------
CREATE TRIGGER TRG_PRODUCTS_ONLY_DELETE_AUDIT
ON [dbo].[Products]
FOR DELETE
AS
	INSERT INTO TB_AUDIT_PRODUCTS
	SELECT ProductID, 'DELETE',GETDATE() FROM DELETED
---------------------------------------------
DELETE FROM [dbo].[Products] WHERE ProductID=9999
DELETE FROM [dbo].[Products] WHERE ProductID=81
---------------------------------------------
SELECT * FROM [dbo].[Products] ORDER BY ProductID DESC
---------------------------------------------
SELECT * FROM TB_AUDIT_PRODUCTS
---------------------------------------------
CREATE TRIGGER TRG_PRODUCTS_ONLY_COLUMN_UPDATE_AUDIT
ON [dbo].[Products]
AFTER UPDATE
AS
BEGIN
    IF UPDATE ([UnitPrice])
        BEGIN
		INSERT INTO TB_AUDIT_PRODUCTS
		SELECT ProductID, 'UPDATE-C',GETDATE() FROM DELETED
		END
END
--------------------------------------------------
SELECT * FROM [dbo].[Products] WHERE ProductID=3
--------------------------------------------------
UPDATE [dbo].[Products] 
SET UnitPrice =  UnitPrice * 1.5 WHERE ProductID=3

SELECT * FROM TB_AUDIT_PRODUCTS --ORDER BY 1 DESC
--------------------------------------------------
UPDATE [dbo].[Products] 
SET UnitsInStock =  UnitsInStock * 1.5 WHERE ProductID=3

SELECT * FROM TB_AUDIT_PRODUCTS ORDER BY 1 DESC
