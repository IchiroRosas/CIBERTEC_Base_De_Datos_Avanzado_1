DECLARE @v_productid INT
DECLARE @v_productname VARCHAR(40)
DECLARE @v_unitprice MONEY
DECLARE @v_productid_busca INT=30

SELECT @v_productid=ProductID, 
@v_productname=ProductName, 
@v_unitprice=UnitPrice 
FROM Products WHERE ProductID=@v_productid_busca

PRINT 'El producto '+ STR(@v_productid) + ' con nombre ' + @v_productname +
 ' tiene un precio unitario de ' + CONVERT(VARCHAR, @v_unitprice)

IF @v_unitprice BETWEEN 0 AND 20
	PRINT 'Producto de bajo costo'
ELSE
	PRINT  'Producto promedio'
------------------------------------------
--procedure
--function
--trigger

------------------------------------------
CREATE PROCEDURE [nombre_procedure]
AS
BEGIN
	<<----- codigo
END

------------------------------------------
CREATE PROCEDURE pr_consulta_producto
AS
BEGIN
	DECLARE @v_productid INT
	DECLARE @v_productname VARCHAR(40)
	DECLARE @v_unitprice MONEY
	DECLARE @v_productid_busca INT=30

	SELECT @v_productid=ProductID, 
	@v_productname=ProductName, 
	@v_unitprice=UnitPrice 
	FROM Products WHERE ProductID=@v_productid_busca

	PRINT 'El producto '+ STR(@v_productid) + ' con nombre ' + @v_productname +
	 ' tiene un precio unitario de ' + CONVERT(VARCHAR, @v_unitprice)

	IF @v_unitprice BETWEEN 0 AND 20
		PRINT 'Producto de bajo costo'
	ELSE
		PRINT  'Producto promedio'
END
----------------------------------
execute pr_consulta_producto
exec pr_consulta_producto
pr_consulta_producto
----------------------------------
SELECT * FROM sys.procedures
SELECT * FROM INFORMATION_SCHEMA.ROUTINES

sp_helptext pr_consulta_producto

------------------------------------------
DROP PROCEDURE pr_consulta_producto
ALTER PROCEDURE pr_consulta_producto (@v_productid_busca INT)
AS
BEGIN
	DECLARE @v_productid INT
	DECLARE @v_productname VARCHAR(40)
	DECLARE @v_unitprice MONEY
	--DECLARE @v_productid_busca INT=30

	SELECT @v_productid=ProductID, 
	@v_productname=ProductName, 
	@v_unitprice=UnitPrice 
	FROM Products WHERE ProductID=@v_productid_busca

	PRINT 'El producto '+ STR(@v_productid) + ' con nombre ' + @v_productname +
	 ' tiene un precio unitario de ' + CONVERT(VARCHAR, @v_unitprice)

	IF @v_unitprice BETWEEN 0 AND 20
		PRINT 'Producto de bajo costo'
	ELSE
		PRINT  'Producto promedio'
END
----------------------------------
execute pr_consulta_producto 60
----------------------------------

DECLARE @v_contador INT =0
WHILE (@v_contador <=100)
	BEGIN
		PRINT @v_contador
		SET @v_contador = @v_contador +1
	END
-------------------------
@v_contador
0		VERDADERO		1
1		VERDADERO		2
..
..
..
9		VERDADERO		10
10		VERDADERO		11
11		FALSO	<--- TERMINA WHILE

----------------------------------
DECLARE @v_contador INT =0
WHILE (@v_contador >=0)
	BEGIN
		PRINT @v_contador
		SET @v_contador = @v_contador +1
	END
----------------------------------
select * from products

--cursor
1. definicion
2. open
3. posicionar 1r la posicion
4. recorrido cursor
5. cerrar
6. liberamos memoria
-----------------------------------
-- Cursores
1. DECLARE
2. OPEN
3. FETCH 
4. WHILE ()
	BEGIN
	END
5. CLOSE
6. DEALLOCATE
-------------------------------------------------------
SELECT employeeid, lastname, firstname FROM Employees
	
-------------------------------------------------------
DECLARE c_misempleados CURSOR FOR 
	SELECT employeeid, lastname, firstname FROM Employees
DECLARE @v_employeeid INT, @v_lastname VARCHAR(20), @v_firstname VARCHAR(10)

OPEN c_misempleados
---------------------
FETCH NEXT FROM c_misempleados INTO @v_employeeid, @v_lastname, @v_firstname 
WHILE (@@FETCH_STATUS=0)
	BEGIN
		PRINT 'Codigo Empleado: ' + STR(@v_employeeid)
		PRINT 'Apellido: ' + @v_lastname
		PRINT 'Nombres: '+ @v_firstname
		FETCH NEXT FROM c_misempleados INTO @v_employeeid, @v_lastname, @v_firstname
	END
---------------------
CLOSE c_misempleados
DEALLOCATE c_misempleados

-------------------------------------

CREATE PROCEDURE pr_lista_empleados
AS
BEGIN
	DECLARE c_misempleados CURSOR FOR 
		SELECT employeeid, lastname, firstname FROM Employees
	DECLARE @v_employeeid INT, @v_lastname VARCHAR(20), @v_firstname VARCHAR(10)

	OPEN c_misempleados
	---------------------
	FETCH NEXT FROM c_misempleados INTO @v_employeeid, @v_lastname, @v_firstname 
	WHILE (@@FETCH_STATUS=0)
		BEGIN
			PRINT 'Codigo Empleado: ' + STR(@v_employeeid)
			PRINT 'Apellido: ' + @v_lastname
			PRINT 'Nombres: '+ @v_firstname
			FETCH NEXT FROM c_misempleados INTO @v_employeeid, @v_lastname, @v_firstname
		END
	---------------------
	CLOSE c_misempleados
	DEALLOCATE c_misempleados
END
----------------------
execute pr_lista_empleados

----------------------------
ALTER PROCEDURE pr_consulta_producto (@v_productid_busca INT)
AS
BEGIN
	DECLARE @v_productid INT
	DECLARE @v_productname VARCHAR(40)
	DECLARE @v_unitprice MONEY
	--> buscar el max id 

	SELECT @v_productid=ProductID, 
	@v_productname=ProductName, 
	@v_unitprice=UnitPrice 
	FROM Products WHERE ProductID=@v_productid_busca

	IF @v_productid IS NULL
		PRINT 'No existe el codigo'
	ELSE
		BEGIN
			PRINT 'El producto '+ STR(@v_productid) + ' con nombre ' + @v_productname +
			 ' tiene un precio unitario de ' + CONVERT(VARCHAR, @v_unitprice)

			IF @v_unitprice BETWEEN 0 AND 20
				PRINT 'Producto de bajo costo'
			ELSE
				PRINT  'Producto promedio'
		END
END
----------------------------------
select * from Products where ProductID=999
EXECUTE pr_consulta_producto 5
EXECUTE pr_consulta_producto 99999
----------------------------------
USE T3FL_COMERCIO

SELECT * FROM TB_PRODUCTO

DELETE FROM TB_PRODUCTO WHERE COD_PRO='P003'

SELECT * FROM TB_ABASTECIMIENTO WHERE COD_PRO='P003' 
SELECT * FROM TB_DETALLE_FACTURA WHERE COD_PRO='P003'
SELECT * FROM TB_DETALLE_COMPRA WHERE COD_PRO='P003'
--------------------------------
CREATE PROCEDURE TB_ELIMINA_PRODUCTO (@v_cod_pro CHAR(4))
AS
BEGIN
	IF EXISTS (SELECT * FROM TB_PRODUCTO WHERE COD_PRO=@v_cod_pro)
		BEGIN
			DELETE FROM TB_ABASTECIMIENTO WHERE COD_PRO=@v_cod_pro
			DELETE FROM TB_DETALLE_FACTURA WHERE COD_PRO=@v_cod_pro
			DELETE FROM TB_DETALLE_COMPRA WHERE COD_PRO=@v_cod_pro

			DELETE FROM TB_PRODUCTO WHERE COD_PRO=@v_cod_pro
		END
	ELSE
		PRINT 'Codigo Producto no existe'
END
---------------
execute TB_ELIMINA_PRODUCTO 'P999'
execute TB_ELIMINA_PRODUCTO 'P003'
---------------
	DECLARE @DIVISOR INT, @DIVIDENDO INT, @RESULTADO DECIMAL(9,2)
	SET @DIVIDENDO = 9
	SET @DIVISOR = 0
	-- ESTA LINEA PROVOCA UN ERROR DE DIVISION POR 0
	SET @RESULTADO = @DIVIDENDO/@DIVISOR
	PRINT @RESULTADO
--------------------------------------------------
BEGIN TRY
	DECLARE @DIVISOR INT, @DIVIDENDO INT, @RESULTADO DECIMAL(9,2)
	SET @DIVIDENDO = 9
	SET @DIVISOR = 0
	-- ESTA LINEA PROVOCA UN ERROR DE DIVISION POR 0
	SET @RESULTADO = @DIVIDENDO/@DIVISOR
	PRINT @RESULTADO
END TRY
BEGIN CATCH
	PRINT 'Error en la ejecucion de la operación'
END CATCH
--------------------------------------------------
BEGIN TRY
	DECLARE @DIVISOR INT, @DIVIDENDO INT, @RESULTADO INT
	SET @DIVIDENDO = 1
	SET @DIVISOR = 0
	-- ESTA LINEA PROVOCA UN ERROR DE DIVISION POR 0
	SET @RESULTADO = @DIVIDENDO/@DIVISOR
	PRINT 'NO HAY ERROR - EL RESULTADO ES: ' + STR(@RESULTADO)
END TRY
BEGIN CATCH
	--PRINT 'SE HA PRODUCIDO UN ERROR'
	SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
--------------------------------------------------
BEGIN TRY
	DECLARE @DIVISOR INT, @DIVIDENDO INT, @RESULTADO INT
	SET @DIVIDENDO = 1
	SET @DIVISOR = 0
	-- ESTA LINEA PROVOCA UN ERROR DE DIVISION POR 0
	SET @RESULTADO = @DIVIDENDO/@DIVISOR
	PRINT 'NO HAY ERROR - EL RESULTADO ES: ' + STR(@RESULTADO)
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 8134 
		PRINT 'La operación ejecutada no es divisible entre Zero'
	ELSE
		PRINT 'Ocurrio otro error - no identificado'
END CATCH;

-------------------------------------
SELECT * FROM UnaTablaQueNoExiste;
--Msg 208, Level 16, State 1, Line 58
--Invalid object name 'UnaTablaQueNoExiste'.

-----------------------------------
BEGIN TRY
	-- Tabla no existe error no capturado y es enviado al nivel superior.
	SELECT * FROM UnaTablaQueNoExiste
END TRY
BEGIN CATCH
	SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
-----------------------------------
CREATE PROCEDURE SP_CONSULTA_TABLA_NO_EXISTE
AS
	SELECT * FROM UnaTablaQueNoExiste
-----------------------------------
EXECUTE SP_CONSULTA_TABLA_NO_EXISTE
-----------------------------------
BEGIN TRY
	-- Tabla no existe error no capturado y es enviado al nivel superior.
	EXECUTE SP_CONSULTA_TABLA_NO_EXISTE;
END TRY
BEGIN CATCH
	SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
---------------------------------------------------

---------------------------------------------------
USE Northwind

SELECT * FROM [dbo].[Products]

DELETE FROM [dbo].[Products] WHERE ProductID=3
--Mens. 547, Nivel 16, Estado 0, Línea 255
--Instrucción DELETE en conflicto con la restricción REFERENCE 'FK_Order_Details_Products'. El conflicto ha aparecido en la base de datos 'Northwind', tabla 'dbo.Order Details', column 'ProductID'.

SELECT * FROM [dbo].[Order Details] WHERE ProductID=3
----------------------------------
DELETE FROM [dbo].[Products] WHERE ProductID=3
IF @@ERROR = 547
	PRINT 'No se puede eliminar el producto porque esta siendo referencia en por lo menos un Detalle de Pedido'
----------------------------------
BEGIN TRY
	DELETE FROM [dbo].[Products] WHERE ProductID=3
END TRY
BEGIN CATCH
	IF @@ERROR = 547
		PRINT 'No se puede eliminar el producto porque esta siendo referencia en por lo menos un Detalle de Pedido'
END CATCH

----------------------------------
SELECT * FROM sys.sysmessages WHERE error=547 AND msglangid=1033
SELECT * FROM sys.sysmessages WHERE error=547 AND msglangid=3082
----------------------------------
DECLARE @TIPO INT, @CLASIFICACION INT 
SET @TIPO = 1
SET @CLASIFICACION = 3
	IF (@TIPO = 1 AND @CLASIFICACION = 3)
	BEGIN
		RAISERROR ('EL TIPO NO PUEDE VALER UNO Y LA CLASIFICACION 3',
					16, -- SEVERIDAD
					1 -- ESTADO
					)
		PRINT 'Continua luego del raise error'
	END
	PRINT 'Finaliza el codigo...'
GO
---------------------------------------------------
Categoria: 1 - Nombre Categoria 1
	Producto # 1 - Nombre Producto 1 - 100 unidades en stock
	Producto # 2 - Nombre Producto 2 - 200 unidades en stock
	Producto # 3 - Nombre Producto 3 - 300 unidades en stock

Categoria: 2 - Nombre Categoria 2
	Producto # 4 - Nombre Producto 4 - 400 unidades en stock
	Producto # 5 - Nombre Producto 5 - 500 unidades en stock
	Producto # 6 - Nombre Producto 6 - 600 unidades en stock
---------------------------------------------------
-- Cursores
1. DECLARE
2. OPEN
3. FETCH 
4. WHILE ()
	BEGIN
	END
5. CLOSE
6. DEALLOCATE
-----------------------------------
SELECT CategoryID, CategoryName FROM Categories

-----------------------------------
DECLARE c_categoria CURSOR FOR
SELECT CategoryID, CategoryName FROM Categories

DECLARE @v_ID INT, @v_NOM VARCHAR(15)
OPEN c_categoria
-------
FETCH NEXT FROM c_categoria INTO @v_ID, @v_NOM
WHILE (@@FETCH_STATUS=0)
	BEGIN
		PRINT 'Categoria: ' + STR(@v_ID) + ' - ' + @v_NOM
		FETCH NEXT FROM c_categoria INTO @v_ID, @v_NOM
	END
-------
CLOSE c_categoria
DEALLOCATE c_categoria
-----------------------------------
DECLARE c_Productos CURSOR FOR 
SELECT ProductID, ProductName, CategoryID FROM PRODUCTS
DECLARE @v_ProductID INT, @v_ProductName VARCHAR(40)
DECLARE @v_CategoryID INT

OPEN c_Productos
FETCH NEXT FROM c_Productos INTO @v_ProductID, @v_ProductName, @v_CategoryID
WHILE(@@FETCH_STATUS=0)
      BEGIN
        PRINT 'Productos: ' + STR(@v_ProductID) + ' - ' + @v_ProductName + ' - ' + STR(@v_CategoryID)
        FETCH NEXT FROM c_Productos INTO @v_ProductID, @v_ProductName, @v_CategoryID
      END
CLOSE c_Productos
DEALLOCATE c_Productos
-----------------------------------
-----------------------------------
-----------------------------------
-----------------------------------

DECLARE c_categoria CURSOR FOR
SELECT CategoryID, CategoryName FROM Categories

DECLARE @v_ID INT, @v_NOM VARCHAR(15)
OPEN c_categoria
-------
FETCH NEXT FROM c_categoria INTO @v_ID, @v_NOM
WHILE (@@FETCH_STATUS=0)
	BEGIN
		PRINT 'Categoria: ' + STR(@v_ID) + ' - ' + @v_NOM
		----------------------------------------------------
		DECLARE c_Productos CURSOR FOR 
			SELECT ProductID, ProductName, CategoryID FROM PRODUCTS
			WHERE categoryid=@v_ID
		DECLARE @v_ProductID INT, @v_ProductName VARCHAR(40)
		DECLARE @v_CategoryID INT, @v_contador INT=0

		OPEN c_Productos
		FETCH NEXT FROM c_Productos INTO @v_ProductID, @v_ProductName, @v_CategoryID
		WHILE(@@FETCH_STATUS=0)
      		  BEGIN
      			PRINT '   Productos: ' + STR(@v_ProductID) + ' - ' + @v_ProductName + ' - ' + STR(@v_CategoryID)
				SET @v_contador = @v_contador+1
        		FETCH NEXT FROM c_Productos INTO @v_ProductID, @v_ProductName, @v_CategoryID
      		  END
		CLOSE c_Productos
		DEALLOCATE c_Productos
		PRINT ' --> Total Productos por Categoria: ' + STR(@v_contador)
		----------------------------------------------------
		FETCH NEXT FROM c_categoria INTO @v_ID, @v_NOM
	END
-------
CLOSE c_categoria
DEALLOCATE c_categoria

------------------------------
CREATE PROCEDURE PR_LISTADO_CATEGORIA_PRODUCTO
AS
BEGIN
	DECLARE c_categoria CURSOR FOR
	SELECT CategoryID, CategoryName FROM Categories

	DECLARE @v_ID INT, @v_NOM VARCHAR(15)
	OPEN c_categoria
	-------
	FETCH NEXT FROM c_categoria INTO @v_ID, @v_NOM
	WHILE (@@FETCH_STATUS=0)
		BEGIN
			PRINT 'Categoria: ' + STR(@v_ID) + ' - ' + @v_NOM
			----------------------------------------------------
			DECLARE c_Productos CURSOR FOR 
				SELECT ProductID, ProductName, CategoryID FROM PRODUCTS
				WHERE categoryid=@v_ID
			DECLARE @v_ProductID INT, @v_ProductName VARCHAR(40)
			DECLARE @v_CategoryID INT, @v_contador INT=0

			OPEN c_Productos
			FETCH NEXT FROM c_Productos INTO @v_ProductID, @v_ProductName, @v_CategoryID
			WHILE(@@FETCH_STATUS=0)
      			  BEGIN
      				PRINT '   Productos: ' + STR(@v_ProductID) + ' - ' + @v_ProductName + ' - ' + STR(@v_CategoryID)
					SET @v_contador = @v_contador+1
        			FETCH NEXT FROM c_Productos INTO @v_ProductID, @v_ProductName, @v_CategoryID
      			  END
			CLOSE c_Productos
			DEALLOCATE c_Productos
			PRINT ' --> Total Productos por Categoria: ' + STR(@v_contador)
			----------------------------------------------------
			FETCH NEXT FROM c_categoria INTO @v_ID, @v_NOM
		END
	-------
	CLOSE c_categoria
	DEALLOCATE c_categoria

END
-----------------------------------------
EXECUTE PR_LISTADO_CATEGORIA_PRODUCTO
-----------------------------------------

SELECT * FROM [ORDERS] WHERE ORDERID=10260
SELECT * FROM [ORDER DETAILS] WHERE ORDERID=10260
SELECT *, UNITPRICE*QUANTITY FROM [ORDER DETAILS] WHERE ORDERID=10260

SELECT SUM(UNITPRICE*QUANTITY) FROM [ORDER DETAILS] WHERE ORDERID=10260
-----------------------------
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
SELECT * FROM INFORMATION_SCHEMA.ROUTINES

sp_helptext "dbo.fn_multiplica"
sp_helptext fn_multiplica

