-- Procedures
IF OBJECT_ID( '[dbo].[_buscar_en_sp]') IS NOT NULL
    DROP PROC [dbo].[_buscar_en_sp];

-- Tables
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'users'))
BEGIN
    DROP TABLE [dbo].[users];
END

IF OBJECT_ID (N'mytablename', N'U') IS NOT NULL 
    DROP TABLE [dbo].[users];

-- Views
IF EXISTS(select * FROM sys.views where name = 'dbo.vw_users')
   DROP VIEW [dbo].[vw_users];

IF OBJECT_ID('dbo.vw_users', 'V') IS NOT NULL
    DROP VIEW [dbo].[vw_users];

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'user')
BEGIN
	EXEC('CREATE SCHEMA user')
END

-- Schema
IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'stock' )
    EXEC('CREATE SCHEMA [stock]');
GO