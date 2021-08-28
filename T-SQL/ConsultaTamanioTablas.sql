
DECLARE @solo_con_datos BIT;
--set @solo_con_datos = 1

SET @solo_con_datos = 0;

DECLARE @tabla SYSNAME;

DECLARE nombres CURSOR
FOR SELECT 
           name
      FROM sysobjects
      WHERE xtype = 'U'
            AND name <> 'TABLA_IMPORTADA'
      ORDER BY 
               NAME;

CREATE TABLE #temp
(
             tabla     SYSNAME
           , registros INT
);

OPEN nombres;

FETCH NEXT FROM nombres INTO @tabla;

WHILE @@fetch_Status = 0
BEGIN
    EXEC ('insert into #temp select '''+@tabla+''', count(*) from '+@tabla);
    FETCH NEXT FROM nombres INTO @tabla;
END;

CLOSE nombres;

DEALLOCATE nombres;

SELECT 
       *
  FROM #temp
  WHERE tabla NOT LIKE 'robot%'
        AND registros >= @solo_con_datos;

DROP TABLE #temp;