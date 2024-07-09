-------------------------------------------
### Tablas Temporales
- locales

CREATE TABLE #LocalTempTable(
StudentID int,
StudentName varchar(50),
StudentAddress varchar(150))

insert into #LocalTempTable values ( 1, 'Ram','India');

select * from #LocalTempTable

- globales
CREATE TABLE ##NewGlobalTempTable(
StudentID int,
StudentName varchar(50),
StudentAddress varchar(150))

Insert Into ##NewGlobalTempTable values ( 1,'Ram','India');
Select * from ##NewGlobalTempTable

There is already an object named '#tempTable' in the database.
drop table #tempTable
Cannot drop the table '#tempTable', because it does not exist or you do not have permission.
IF OBJECT_ID ('tempdb..#tempTable', 'U') is not null DROP TABLE #tempTable

DROP TABLE IF EXISTS #TempTable



-------------------------------------------
### Variables Tipo Tablas

declare @temp table(age int, name varchar(15))

insert into @temp
select 18, 'matt' union all
select 21, 'matt' union all
select 21, 'matt' union all
select 18, 'luke' union all
select 18, 'luke' union all
select 21, 'luke' union all
select 18, 'luke' union all
select 21, 'luke'

SELECT Age, Name, count(1) count
FROM @temp
GROUP BY Age, Name
-------------------------------------------
DECLARE @orders TABLE(OrderID INT, Name NVARCHAR(100))
INSERT INTO @orders VALUES
( 1, 'Matt' ),
( 2, 'John' ),
( 3, 'Matt' ),
( 4, 'Luke' ),
( 5, 'John' ),
( 6, 'Luke' ),
( 7, 'John' ),
( 8, 'John' ),
( 9, 'Luke' ),
( 10, 'John' ),
( 11, 'Luke' )

SELECT Name, COUNT(*) AS 'Orders'
FROM @orders
GROUP BY Name

-------------------------------------------
### Formato de Fechas

DECLARE @Date DATETIME = '2016-09-05 00:01:02.333'
SELECT FORMAT(@Date, N'dddd, MMMM dd, yyyy hh:mm:ss tt')

DECLARE @Date DATETIME = '2016-09-05 00:01:02.333'
SELECT FORMAT(@Date, N'U')

-------------------------------------------
CREATE FUNCTION [dbo].[Calc_Age]
(
@DOB datetime , @calcDate datetime
)
RETURNS int
AS
BEGIN
declare @age int
IF (@calcDate < @DOB )
	RETURN -1
	-- If a DOB is supplied after the comparison date, then return -1
	SELECT @age = YEAR(@calcDate) - YEAR(@DOB) +
		CASE WHEN DATEADD(year,YEAR(@calcDate) - YEAR(@DOB),@DOB) > @calcDate THEN -1 ELSE 0 END
RETURN @age
END
-------------------------------------------
SELECT dbo.Calc_Age('2000-01-01',Getdate())

-------------------------------------------
### Enmascaramiento

-- Demo 1: Dynamic Data Masking - DDM
USE Northwind

-- Create a dynamic data mask
-- schema to contain user tables
CREATE SCHEMA SCH_DATA;
GO

-- simple table
CREATE TABLE SCH_DATA.SOCIOS (
    MemberID INT IDENTITY(100, 1) NOT NULL PRIMARY KEY,
    Nombres VARCHAR(100) NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Telefono VARCHAR(12) NULL,
    Email VARCHAR(100) NOT NULL,
    DiscountCode SMALLINT NULL
);
GO
-- inserting sample data
INSERT INTO SCH_DATA.SOCIOS (Nombres, Apellidos, Telefono, Email, DiscountCode)
VALUES
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@canvia.com', 10),
('Ana Maria', 'Galvin', '555.123.4568', 'AMGalvin@canvia.com.pe', 5),
('Joselito', 'Gutierrez', '555.123.4570', 'JGutierrez@canvia.net', 50),
('Zheng', 'Mu', '555.123.4569', 'ZMu@canvia.net', 40);
GO
SELECT * FROM SCH_DATA.SOCIOS;
GO

------------------------------------------------------------------------------
CREATE USER CNV_DMM_USER WITHOUT LOGIN;
GO
GRANT SELECT ON SCHEMA::SCH_DATA TO CNV_DMM_USER;
GO
------------------------------------------------------------------------------
-- Open New Query

-- impersonate for testing:
EXECUTE AS USER = 'CNV_DMM_USER';

SELECT * FROM SCH_DATA.SOCIOS;

REVERT;
------------------------------------------------------------------------------
-- Masking
ALTER TABLE SCH_DATA.SOCIOS
ALTER COLUMN Nombres VARCHAR(100) 
MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL;
GO
--ALTER TABLE SCH_DATA.SOCIOS ALTER COLUMN 
--    Apellidos VARCHAR(100) NOT NULL;
--GO
ALTER TABLE SCH_DATA.SOCIOS 
ALTER COLUMN Telefono VARCHAR(12) 
MASKED WITH (FUNCTION = 'default()') NULL;
GO
--texto --> xxxx
--numero --> 0
--fecha --> '01/01/1900'

ALTER TABLE SCH_DATA.SOCIOS 
ALTER COLUMN DiscountCode SMALLINT 
MASKED WITH (FUNCTION = 'random(1, 100)') NULL;
GO

ALTER TABLE SCH_DATA.SOCIOS 
ALTER COLUMN Email VARCHAR(100) 
MASKED WITH (FUNCTION = 'email()') NOT NULL;
GO

------------------------------------------------------------------------------
-- Open New Query

-- impersonate for testing:
EXECUTE AS USER = 'CNV_DMM_USER';

SELECT * FROM SCH_DATA.SOCIOS;

REVERT;
--------------------------------------------------------------------------------
-- Part 2
-- Add or editing a mask on an existing column
ALTER TABLE SCH_DATA.SOCIOS
ALTER COLUMN Apellidos 
ADD MASKED WITH (FUNCTION = 'partial(2,"####",0)');

--------------------------------------------------------------------------------
-- Part 3
ALTER TABLE SCH_DATA.SOCIOS
ALTER COLUMN Apellidos VARCHAR(100) 
MASKED WITH (FUNCTION = 'default()');

SELECT * FROM SCH_DATA.SOCIOS;

------------------------------------------------------------------------------
-- Open New Query
EXECUTE AS USER = 'CNV_DMM_USER';
SELECT * FROM SCH_DATA.SOCIOS;
REVERT;
  
--------------------------------------------------------------------------------
-- Part 4
-- Grant permissions to view unmasked data
GRANT UNMASK TO CNV_DMM_USER;

--------------------------------------------------------------------------------
-- Part 5
-- Removing the UNMASK permission
REVOKE UNMASK TO CNV_DMM_USER;

--------------------------------------------------------------------------------
-- Part 6
-- Drop a dynamic data mask
ALTER TABLE SCH_DATA.SOCIOS
ALTER COLUMN Apellidos DROP MASKED;
