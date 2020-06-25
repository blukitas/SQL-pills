
IF OBJECT_ID( '[dbo].[_buscar_en_sp]') IS NOT NULL
    DROP PROC [dbo].[_buscar_en_sp]
GO

CREATE PROC [dbo].[_buscar_en_sp](@texto AS VARCHAR(200))
AS
     SELECT DISTINCT 
            o.Name
     FROM sysobjects o
          INNER JOIN syscomments s ON s.id = o.id
     WHERE s.text LIKE '%' + @texto + '%'
     ORDER BY o.name;