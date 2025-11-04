USE master;
GO

-- Check if the database has already existed
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'MyDWH')
BEGIN
	ALTER DATABASE MyDWH SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE MyDWH;
END;
GO

-- Create the MyDWH database 
CREATE DATABASE MyDWH;
GO
USE MyDWH;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
