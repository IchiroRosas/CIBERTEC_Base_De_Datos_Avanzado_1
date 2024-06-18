USE t3fl_comercio

SELECT * FROM TB_FACTURA
--21
SELECT * FROM TB_DETALLE_FACTURA

SELECT DISTINCT NUM_FAC FROM TB_DETALLE_FACTURA
--20

sp_helpconstraint TB_DETALLE_FACTURA

SELECT f.NUM_FAC, f.COD_CLI, f.FEC_FAC,
d.NUM_FAC, d.COD_PRO, d.CAN_VEN, d.PRE_VEN
FROM TB_FACTURA f, TB_DETALLE_FACTURA d
WHERE
	f.NUM_FAC = d.NUM_FAC

SELECT num_fac FROM TB_FACTURA

SELECT DISTINCT NUM_FAC FROM TB_DETALLE_FACTURA

SELECT * FROM TB_FACTURA
where NUM_FAC NOT IN  
(SELECT DISTINCT NUM_FAC FROM TB_DETALLE_FACTURA)

INSERT TB_FACTURA VALUES
(GETDATE(),'C001', '1998-05-08', 2, 'V01', '0.19')


SELECT f.NUM_FAC, f.COD_CLI, f.FEC_FAC,
d.NUM_FAC, d.COD_PRO, d.CAN_VEN, d.PRE_VEN
FROM TB_FACTURA f INNER JOIN TB_DETALLE_FACTURA d
ON (f.NUM_FAC = d.NUM_FAC)
--------------------------
SELECT f.NUM_FAC, f.COD_CLI, f.FEC_FAC,
d.NUM_FAC, d.COD_PRO, d.CAN_VEN, d.PRE_VEN
FROM TB_FACTURA f LEFT JOIN TB_DETALLE_FACTURA d
ON (f.NUM_FAC = d.NUM_FAC)
--------------------------
SELECT f.NUM_FAC, f.COD_CLI, f.FEC_FAC,
d.NUM_FAC, d.COD_PRO, d.CAN_VEN, d.PRE_VEN
FROM TB_FACTURA f RIGHT JOIN TB_DETALLE_FACTURA d
ON (f.NUM_FAC = d.NUM_FAC)
--------------------------
SELECT f.NUM_FAC, f.COD_CLI, f.FEC_FAC,
d.NUM_FAC, d.COD_PRO, d.CAN_VEN, d.PRE_VEN
FROM TB_DETALLE_FACTURA d RIGHT JOIN TB_FACTURA f 
ON (f.NUM_FAC = d.NUM_FAC)

--------------------
USE Northwind

SELECT * FROM Products
--77

SELECT * FROM Products WHERE CategoryID=1
--12

SELECT * FROM Products WHERE CategoryID=3
--13

SELECT * FROM Products WHERE CategoryID=1
UNION
SELECT * FROM Products WHERE CategoryID=3
--25

SELECT * FROM Products
UNION
SELECT * FROM Products WHERE CategoryID=3
--77

SELECT * FROM Products
UNION ALL
SELECT * FROM Products WHERE CategoryID=3
--90

--------------------
-- Programacion 
-- Transact-SQL / t-sql

DECLARE @v_texto VARCHAR(100)
SET @v_texto = 'CIBERTEC'
PRINT @v_texto
SET @v_texto = 'instituto'
PRINT @v_texto
---------------------------
DECLARE @v_numero MONEY=18.25
PRINT @v_numero
SET @v_numero = 19.78
PRINT @v_numero
---------------------------
DECLARE @v_numero MONEY=18.25
PRINT 'Valor Cuota: ' + @v_numero

--No se puede convertir un valor char a money.
---------------------------
DECLARE @v_numero MONEY=18.25
PRINT 'Valor Cuota: ' + STR(@v_numero)

---------------------------
DECLARE @v_numero MONEY=18.25
PRINT 'Valor Cuota: ' + CONVERT(VARCHAR, @v_numero)

---------------------------
DECLARE @v_numero MONEY=18.25
PRINT 'Valor Cuota: ' + CAST(@v_numero AS VARCHAR)
---------------------------
--DATE
--DATETIME
DECLARE @v_fecha1 DATE=GETDATE()
DECLARE @v_fecha2 DATETIME=GETDATE()

PRINT @v_fecha1
PRINT @v_fecha2
-----------------------------------
SELECT GETDATE()

-----------------------------------
DECLARE @v_fecha1 DATE=GETDATE()
DECLARE @v_fecha2 DATETIME=GETDATE()

SELECT @v_fecha1, @v_fecha2

-----------------------------------
BEGIN
	DECLARE @v_puntaje INT=18

	IF @v_puntaje <13
		BEGIN
			SET @v_puntaje = @v_puntaje+1
			PRINT 'Desaprobado'
		END
	ELSE IF @v_puntaje <16
		PRINT 'Aprobado'
	ELSE
		PRINT 'Buen trabajo'
END
-----------------------------------
SELECT ProductID, ProductName, UnitPrice 
FROM Products
WHERE ProductID=55
-----------------------------------
DECLARE @v_productid INT
DECLARE @v_productname VARCHAR(40)
DECLARE @v_unitprice MONEY

SELECT @v_productid=ProductID, 
@v_productname=ProductName, 
@v_unitprice=UnitPrice 
FROM Products

PRINT @v_productid
PRINT @v_productname
PRINT @v_unitprice

-----------------------------------
DECLARE @v_productid INT
DECLARE @v_productname VARCHAR(40)
DECLARE @v_unitprice MONEY

SELECT @v_productid=ProductID, 
@v_productname=ProductName, 
@v_unitprice=UnitPrice 
FROM Products WHERE ProductID=55

PRINT @v_productid
PRINT @v_productname
PRINT @v_unitprice

-----------------------------------
DECLARE @v_productid INT
DECLARE @v_productname VARCHAR(40)
DECLARE @v_unitprice MONEY
DECLARE @v_productid_busca INT=59

SELECT @v_productid=ProductID, 
@v_productname=ProductName, 
@v_unitprice=UnitPrice 
FROM Products WHERE ProductID=@v_productid_busca

PRINT @v_productid
PRINT @v_productname
PRINT @v_unitprice

-----------------------------------
DECLARE @v_productid INT
DECLARE @v_productname VARCHAR(40)
DECLARE @v_unitprice MONEY
DECLARE @v_productid_busca INT=9

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

