USE NORTHWIND_T3HL

--PREGUNTA 1
CREATE TABLE Inmuebles_2024_FEB
(
COD_AGN	CHAR(4),
NOM_AGN	VARCHAR(100),
VENTAS	INT
)

CREATE TABLE Inmuebles_2024_MAR
(
CODIGO	CHAR(4),
NOMBRECOMPLETO	VARCHAR(100),
NRO_VENTAS	INT
)

CREATE TABLE Inmuebles_2024_ABR
(
CODIGO_AGEN	CHAR(4),
NOMBRE_AGEN	VARCHAR(100),
VENTAS_AGEN	INT
)

SELECT * FROM sys.tables

BULK INSERT Inmuebles_2024_FEB
FROM 'D:\AAA_Cibertec\3° CICLO\BDA 1\BDA1_Raul_Rosas_T2\bulk_1.csv'
WITH
(
FIELDTERMINATOR=',' ,
ROWTERMINATOR='\n'
)

BULK INSERT Inmuebles_2024_MAR
FROM 'D:\AAA_Cibertec\3° CICLO\BDA 1\BDA1_Raul_Rosas_T2\bulk_2.csv'
WITH
(
FIELDTERMINATOR=',' ,
ROWTERMINATOR='\n'
)

BULK INSERT Inmuebles_2024_ABR
FROM 'D:\AAA_Cibertec\3° CICLO\BDA 1\BDA1_Raul_Rosas_T2\bulk_3.csv'
WITH
(
FIELDTERMINATOR=',' ,
ROWTERMINATOR='\n'
)

SELECT * FROM Inmuebles_2024_FEB
SELECT * FROM Inmuebles_2024_MAR
SELECT * FROM Inmuebles_2024_ABR

MERGE Inmuebles_2024_FEB AS Target
USING Inmuebles_2024_ABR AS Source
ON (Target.COD_AGN = Source.CODIGO_AGEN)
WHEN MATCHED THEN
	UPDATE SET VENTAS=Source.VENTAS_AGEN
WHEN NOT MATCHED THEN
	INSERT VALUES (Source.CODIGO_AGEN, Source.NOMBRE_AGEN, Source.VENTAS_AGEN);



MERGE Inmuebles_2024_MAR AS Target
USING Inmuebles_2024_ABR AS Source
ON (Target.CODIGO = Source.CODIGO_AGEN)
WHEN MATCHED THEN
	DELETE
WHEN NOT MATCHED THEN
	INSERT VALUES (Source.CODIGO_AGEN, Source.NOMBRE_AGEN, Source.VENTAS_AGEN);


SELECT * FROM Inmuebles_2024_FEB
SELECT * FROM Inmuebles_2024_MAR
SELECT * FROM Inmuebles_2024_ABR



-- PREGUNTA 2

--CURSOR COMPLETO

DECLARE c_paises_suppliers CURSOR FOR
	SELECT DISTINCT Country FROM Suppliers
DECLARE @v_country VARCHAR(15)
OPEN c_paises_suppliers
-----------------------------------------
FETCH NEXT FROM c_paises_suppliers INTO @v_country
WHILE (@@FETCH_STATUS=0)
	BEGIN
		PRINT 'País: ' + @v_country
-----------------------------------------
		---------------------------------------------------------------
DECLARE c_proveedores_suppliers CURSOR FOR
	SELECT SupplierID, CompanyName, Region FROM Suppliers WHERE Country = @v_country
DECLARE @v_supplierID INT, @v_companyName VARCHAR(40), @v_region VARCHAR (15)
OPEN c_proveedores_suppliers
		---------------------------------------------------------------
FETCH NEXT FROM c_proveedores_suppliers INTO @v_supplierID, @v_companyName, @v_region
WHILE (@@FETCH_STATUS=0)
	BEGIN
		PRINT '   Proveedor: ' + @v_companyName + ' - Region: ' + ISNULL(@v_region,'/NULL/')
		---------------------------------------------------------------
				---------------------------------------------------------------
DECLARE c_productos CURSOR FOR
	SELECT p.ProductName, c.CategoryName, SUM(od.Quantity)
	FROM Products p, Categories c, [Order Details] od, Suppliers s
	WHERE p.ProductID = od.ProductID AND c.CategoryID = p.CategoryID AND s.SupplierID=p.SupplierID AND s.SupplierID=@v_supplierID
	GROUP BY p.ProductName, c.CategoryName
	ORDER BY 2, 1
DECLARE @v_prodName VARCHAR(40), @v_catName VARCHAR(15), @v_cantidad SMALLINT, @indice INT = 1, @totalProdVendidos INT = 0
OPEN c_productos
				---------------------------------------------------------------
FETCH NEXT FROM c_productos INTO @v_prodName, @v_catName, @v_cantidad
WHILE (@@FETCH_STATUS=0)
	BEGIN
		PRINT '      Producto #' + CONVERT(VARCHAR,@indice) + ': ' + @v_prodName + ' - ' + 'Categoría: ' + @v_catName + ' - ' + 'Pedidos: ' + CONVERT(VARCHAR,@v_cantidad)
		SET @indice = @indice + 1
		SET @totalProdVendidos = @totalProdVendidos + @v_cantidad
		FETCH NEXT FROM c_productos INTO @v_prodName, @v_catName, @v_cantidad
	END
	PRINT '      >>>>>>> TOTAL DE PRODUCTOS VENDIDOS: ' + CONVERT(VARCHAR,@totalProdVendidos) + ' <<<<<<<'
				---------------------------------------------------------------
CLOSE c_productos
DEALLOCATE c_productos
				---------------------------------------------------------------
		---------------------------------------------------------------
		FETCH NEXT FROM c_proveedores_suppliers INTO @v_supplierID, @v_companyName, @v_region
	END
		---------------------------------------------------------------
CLOSE c_proveedores_suppliers
DEALLOCATE c_proveedores_suppliers
		---------------------------------------------------------------
-----------------------------------------
		FETCH NEXT FROM c_paises_suppliers INTO @v_country
	END
-----------------------------------------
CLOSE c_paises_suppliers
DEALLOCATE c_paises_suppliers



-- PREGUNTA 3

select * from Employees

DECLARE @v_desc_employee VARCHAR (1000) = 'nancy'
PRINT 'Descripción recibida...'
IF EXISTS (SELECT * FROM Employees WHERE FirstName LIKE @v_desc_employee OR LastName LIKE @v_desc_employee OR Title LIKE @v_desc_employee)
	BEGIN
		PRINT 'Sí existe empleado con la descripción.'
		DECLARE @V_cod_employee INT = (SELECT EmployeeID FROM Employees WHERE FirstName LIKE @v_desc_employee OR LastName LIKE @v_desc_employee OR Title LIKE @v_desc_employee)
		
		IF EXISTS (SELECT * FROM Orders WHERE EmployeeID = @V_cod_employee)
			PRINT 'Empleado tiene pedidos.'
		ELSE
			BEGIN
				PRINT 'ERROR: Empleado no tiene pedidos.'
			END
		PRINT 'Procesando pedidos registrados del empleado...'
		DECLARE c_importeTotal_OD CURSOR FOR
			SELECT od.OrderID, SUM(od.UnitPrice*od.Quantity)
			FROM [Order Details] od, Orders o, Employees e
			WHERE e.EmployeeID = o.EmployeeID AND o.OrderID = od.OrderID AND o.EmployeeID=@V_cod_employee
			GROUP BY od.OrderID
		DECLARE @v_contador INT=1, @v_idPedido INT, @v_montoTotalPedido MONEY
		OPEN c_importeTotal_OD
		FETCH NEXT FROM c_importeTotal_OD INTO @v_idPedido, @v_montoTotalPedido
		WHILE(@@FETCH_STATUS=0)
			BEGIN
				PRINT '#' + CONVERT(VARCHAR,@v_contador) + ' - OrderID: ' + CONVERT(VARCHAR,@v_idPedido) + ' - Importe Total: ' + CONVERT(VARCHAR,@v_montoTotalPedido)
				SET @v_contador = @v_contador + 1
				FETCH NEXT FROM c_importeTotal_OD INTO @v_idPedido, @v_montoTotalPedido
			END
		CLOSE c_importeTotal_OD
		DEALLOCATE c_importeTotal_OD
	END
ELSE
	PRINT 'ERROR: No se hallaron coincidencias con la descripción.'





-- PREGUNTA 4
SELECT * FROM Categories

ALTER PROCEDURE delete_Category (@p_categoryID INT)
AS
BEGIN
	IF EXISTS (SELECT * FROM Categories WHERE CategoryID=@p_categoryID)
		BEGIN TRY
			DELETE od 
			FROM [Order Details] od INNER JOIN products p 
			ON (od.ProductID = p.ProductID)
			WHERE p.CategoryID = @p_categoryID
			
			DELETE FROM Products WHERE CategoryID = @p_categoryID

			DELETE FROM Categories WHERE CategoryID = @p_categoryID
		END TRY
		BEGIN CATCH
			DECLARE @v_error_message VARCHAR (1000), @v_error_severity INT, @v_error_state INT
			SELECT @v_error_message = ERROR_MESSAGE(), @v_error_severity = ERROR_SEVERITY(), @v_error_state = ERROR_STATE()
			RAISERROR (@v_error_message,@v_error_severity,@v_error_state)
			ROLLBACK TRANSACTION
			THROW
		END CATCH
	ELSE
		PRINT 'Categoría no existe.'
END

INSERT INTO Categories (CategoryName, Description) values ('categoriaNueva','Descripcion nueva')

select * from Categories

EXECUTE delete_Category 10
EXECUTE delete_Category 3
EXECUTE delete_Category 4

select * from Categories
