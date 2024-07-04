SELECT * FROM Products
-- 6 - stock 120
SELECT * FROM Orders WHERE OrderID=10248
SELECT * FROM Orders WHERE OrderID=10249

SELECT * FROM [Order Details] WHERE OrderID=10248
SELECT * FROM [Order Details] WHERE OrderID=10249

SELECT * FROM Products

INSERT INTO [Order Details] VALUES (10248, 6, 19.99, 130, 0)
INSERT INTO [Order Details] VALUES (10248, 6, 19.99, 30, 0)

ROLLBACK TRANSACTION
-----------------------------------------------------------
ALTER TRIGGER TRG_Confirma_Stock
ON [Order Details]
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM Products p INNER JOIN INSERTED i ON p.ProductID = i.ProductID AND p.UnitsInStock < i.Quantity)
		BEGIN
			RAISERROR ('El producto seleccionado no tiene stock suficiente', 16, 1)
		END
	ELSE
		BEGIN
			INSERT INTO [Order Details]
			SELECT OrderID, ProductID, UnitPrice, Quantity, Discount FROM INSERTED
		END
END

---------------------------------------------
-- DDL Triggers / CREATE / ALTER / DROP
SELECT * FROM sys.triggers
SELECT * FROM sys.tables

DROP TRIGGER TRG_TABLE_CHANGES ON DATABASE
DROP TABLE TB_TABLE_CHANGES

CREATE TABLE TB_TABLE_CHANGES_2
(
LogId INT IDENTITY(1,1) NOT NULL,
EventVal XML NOT NULL,
Fecha	DATETIME NOT NULL,
Origen	SYSNAME NOT NULL
)

-----------------------------------------
CREATE TRIGGER TRG_TABLE_CHANGES
ON DATABASE
FOR
	CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO TB_TABLE_CHANGES_2 
	VALUES (EVENTDATA(), GETDATE(), USER)
END
-------------------------------------------
SELECT EVENTDATA()
SELECT USER, ORIGINAL_LOGIN()
-------------------------------------------
CREATE TABLE TB_EJEMPLO(N INT)
SELECT * FROM TB_TABLE_CHANGES_2

ALTER TABLE TB_EJEMPLO ADD NOMBRE VARCHAR(20)
SELECT * FROM TB_TABLE_CHANGES_2

DROP TABLE TB_EJEMPLO
SELECT * FROM TB_TABLE_CHANGES_2

---------------------------------------------
DISABLE TRIGGER TRG_TABLE_CHANGES on DATABASE

SELECT * FROM sys.triggers

ENABLE TRIGGER TRG_TABLE_CHANGES on DATABASE
---------------------------------------------
SELECT * FROM sys.triggers

DROP TRIGGER TRG_PRODUCTS_ALL_DML
DROP TRIGGER TRG_PRODUCTS_ONLY_INSERT
DROP TRIGGER TRG_PRODUCTS_ONLY_UPDATE
DROP TRIGGER TRG_PRODUCTS_ONLY_DELETE
DROP TRIGGER TRG_PRODUCTS_ONLY_INSERT_V2
DROP TRIGGER TRG_PRODUCTS_ONLY_INSERT_AUDIT
DROP TRIGGER TRG_PRODUCTS_ONLY_UPDATE_AUDIT
DROP TRIGGER TRG_PRODUCTS_ONLY_INSERT_AUDIT_V2
DROP TRIGGER TRG_PRODUCTS_ONLY_DELETE_AUDIT
DROP TRIGGER TRG_PRODUCTS_ONLY_COLUMN_UPDATE_AUDIT
DROP TRIGGER TRG_PRODUCTS_NO_INSERT
DROP TRIGGER TRG_PRODUCTS_NO_DML
DROP TRIGGER trg_Valida_Stock
DROP TRIGGER TRG_Confirma_Stock

DROP TRIGGER TRG_TABLE_CHANGES ON DATABASE

---------------------------------------------
CREATE TRIGGER TRG_PRODUCTS_NO_DML 
ON [dbo].[Products]
FOR INSERT, UPDATE, DELETE
AS
BEGIN
  PRINT 'YOU CANNOT PERFORM DML OPERATION'
  ROLLBACK TRANSACTION
END
---------------------------------------------
INSERT INTO [dbo].[Products](ProductName) VALUES ('Cualquier cosa')
UPDATE [dbo].[Products] SET UnitPrice =  UnitPrice * 1.5 WHERE ProductID=3
DELETE [dbo].[Products] WHERE ProductID=88
---------------------------------------------
SELECT * FROM [dbo].[Products] ORDER BY ProductID DESC

DISABLE TRIGGER ALL ON [dbo].[Products]

DROP TRIGGER TRG_PRODUCTS_NO_DML
--------------------------------------------
-- Login Triggers

-- user		(dbo)
-- login	(sa)

-- sp_who2
SELECT * FROM sys.dm_exec_sessions WHERE login_name='sa'

SELECT * FROM sys.dm_exec_sessions WHERE login_name='sa' AND is_user_process=1

SELECT * FROM sys.dm_exec_sessions WHERE login_name='sa' AND host_name IS NOT NULL

SELECT * FROM sys.syslogins

SELECT * FROM sys.sysusers
------------------------------------------------------
CREATE LOGIN login_t3fl WITH PASSWORD='test@123'

SELECT * FROM sys.syslogins WHERE name='login_t3fl'

SELECT * FROM sys.dm_exec_sessions WHERE login_name='login_t3fl'

sp_helpdb

SELECT @@SERVERNAME
SELECT HOST_NAME()
--------------------------------
CREATE TRIGGER TRG_LOGON_RESTRICT
ON ALL SERVER
AFTER LOGON
AS
BEGIN
	IF SUSER_NAME() = 'login_t3fl'
		BEGIN
			RAISERROR('Acceso Denegado',16,1)
			ROLLBACK;
		END
END
--------------------------------
SELECT * FROM sys.triggers
SELECT * FROM sys.server_triggers
SELECT * FROM sys.server_trigger_events

DROP TRIGGER TRG_LOGON_RESTRICT ON ALL SERVER


------------------------------------
-- Backup and Retsore

SELECT * FROM TB_AUDIT_PRODUCTS
SELECT * FROM TB_TABLE_CHANGES_2

DROP TABLE TB_AUDIT_PRODUCTS
DROP TABLE TB_TABLE_CHANGES_2

------------------------------------
