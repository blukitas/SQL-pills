IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_p_chequear_dependencias_BGP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[wf_p_chequear_dependencias_BGP]
GO
CREATE PROCEDURE [dbo].[wf_p_chequear_dependencias_BGP]    
      @v_tabla VARCHAR(50),    
      @v_accion VARCHAR(1), --'D' Depurar
      @prc_nombre_corto VARCHAR(10) = null
AS 
/**********************************************************/
/*en la tabla tmp_tablas_ma estan los nombre de las tablas*/
/*de mora avanzada que no deben ser depuradas, colocar    */
/*registros en esta tabla, provoca que se salteen las     */
/*mismas y no se verifiquen sus dependencias              */
/*                                                        */
/**********************************************************/

SET NOCOUNT ON  
DECLARE @v_table_name VARCHAR(50)    
DECLARE @v_col_name VARCHAR(50)    
DECLARE @v_sql NVARCHAR(4000)    
DECLARE @v_base_depuracion VARCHAR(255)  
DECLARE @total_ejecutados int

/*si quedo un cursor abierto por una mala finalizacion anterior lo cierro*/
SET @v_sql = 'IF (SELECT CURSOR_STATUS(''global'', ''cur_' + @v_tabla  +''''+  ')) = 1 CLOSE cur_' + @v_tabla  
EXEC sp_executesql @v_sql    

SET @v_sql = 'IF (SELECT CURSOR_STATUS(''global'', ''cur_' + @v_tabla  +''''+  ')) = -1 DEALLOCATE cur_' + @v_tabla  
EXEC sp_executesql @v_sql 



BEGIN TRY
  
	select @v_base_depuracion = prt_valor from wf_parametros where prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null  
	
	if @v_base_depuracion is null set @v_base_depuracion=''

	IF @prc_nombre_corto IS NULL set @prc_nombre_corto = 'PDD'
  
  
	INSERT INTO tmp_dependencias_BGP    
	SELECT DISTINCT @v_tabla, FK.TABLE_NAME tabla, CU.COLUMN_NAME columna    
	FROM    
		INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C    
		INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS FK ON C.CONSTRAINT_NAME = FK.CONSTRAINT_NAME    
		INNER JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS PK ON C.UNIQUE_CONSTRAINT_NAME = PK.CONSTRAINT_NAME    
		INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME    
		INNER JOIN (    
		SELECT i1.TABLE_NAME, i2.COLUMN_NAME    
		FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS i1    
		INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE i2 ON i1.CONSTRAINT_NAME = i2.CONSTRAINT_NAME    
		WHERE i1.CONSTRAINT_TYPE = 'PRIMARY KEY'    
		) PT ON PT.TABLE_NAME = PK.TABLE_NAME    
	WHERE      
	PK.TABLE_NAME = @v_tabla   
    and @v_tabla<>FK.TABLE_NAME      
	AND NOT EXISTS(SELECT 1 FROM tmp_dependencias_BGP WHERE tabla_ori = @v_tabla AND tabla = FK.TABLE_NAME AND columna = CU.COLUMN_NAME)      
	ORDER BY       
		1 ASC  
    
	-- DECLARE cur CURSOR FOR SELECT * FROM @v_tab    
	SET @v_sql = 'DECLARE cur_' + @v_tabla + ' CURSOR READ_ONLY FAST_FORWARD FOR SELECT tabla, columna FROM tmp_dependencias_BGP WHERE tabla_ori = ''' + @v_tabla + ''''    
	EXEC sp_executesql @v_sql    
    
	SET @v_sql = 'OPEN cur_' + @v_tabla    
	EXEC sp_executesql @v_sql    
  
	SET @v_sql = 'FETCH cur_' + @v_tabla + ' INTO @v_table_name, @v_col_name'    
	EXEC sp_executesql @v_sql, N'@v_table_name varchar(50) OUT, @v_col_name varchar(50) OUT', @v_table_name OUT, @v_col_name OUT    
  
	WHILE @@FETCH_STATUS = 0    
	BEGIN    
  
 		IF (@v_accion = 'D') 
		BEGIN   
			/*Si la tabla no es de mora avanzada*/
			IF @v_table_name not in (select tabla_ma from  tmp_tablas_ma)
			BEGIN 
				/*guardo los id de los registros que se van a borrar*/ 
				SET @v_sql = 'INSERT INTO tmp_borrar SELECT ''' + @v_table_name + ''', ' + LEFT(@v_col_name,4) + 'id' + ' FROM ' + @v_table_name +' INNER JOIN tmp_borrar ON ' + @v_col_name + ' = id AND tabla = ''' + @v_tabla + ''''    
				--print(@v_sql)
				EXEC(@v_sql)    
			
				/*inserto los registros en la base historica*/
				SET @v_sql = 'INSERT ' + rtrim(@v_base_depuracion) + '.dbo.' + @v_table_name + ' SELECT * FROM ' + @v_table_name + ' WHERE EXISTS(SELECT TOP 1 1 FROM tmp_borrar WHERE ' + @v_col_name + ' = id AND tabla = ''' + @v_tabla + ''')'    
				--PRINT @v_sql
				EXEC(@v_sql)    
			
				/*chequeo dependencias de la tabla depurada*/
				EXEC dbo.wf_p_chequear_dependencias_BGP @v_table_name, @v_accion ,@prc_nombre_corto 

				/*borro de la base activa los registros pasados a la base historica*/
				SET @v_sql = 'DELETE ' + @v_table_name + ' FROM ' + @v_table_name +' INNER JOIN tmp_borrar ON ' + @v_col_name + ' = id AND tabla = ''' + @v_tabla + ''''    
				--PRINT @v_sql
				EXEC(@v_sql)
				set @total_ejecutados = @@ROWCOUNT

				if @total_ejecutados > 0
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),convert(datetime,convert(varchar,GETDATE(),112)),'A','  Total registros de '+@v_table_name+' eliminados.....: ' + CONVERT(VARCHAR(8),@total_ejecutados), 1, Null,0
			end
					END    
	          
	    SET @v_sql = 'FETCH cur_' + @v_tabla + ' INTO @v_table_name, @v_col_name'    
	    EXEC sp_executesql @v_sql, N'@v_table_name varchar(50) OUT, @v_col_name varchar(50) OUT', @v_table_name OUT, @v_col_name OUT    
     
	END    
    
	SET @v_sql = 'CLOSE cur_' + @v_tabla    
	EXEC sp_executesql @v_sql    
    
	SET @v_sql = 'DEALLOCATE  cur_' + @v_tabla    
	EXEC sp_executesql @v_sql  

END TRY
BEGIN CATCH

	SET @v_sql = 'IF (SELECT CURSOR_STATUS(''global'', ''cur_' + @v_tabla  +''''+  ')) = 1 CLOSE cur_' + @v_tabla  
	EXEC sp_executesql @v_sql    

	SET @v_sql = 'IF (SELECT CURSOR_STATUS(''global'', ''cur_' + @v_tabla  +''''+  ')) = -1 DEALLOCATE cur_' + @v_tabla  
	EXEC sp_executesql @v_sql 
	
	
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  

    SELECT   
        @ErrorMessage = ERROR_MESSAGE(),  
        @ErrorSeverity = ERROR_SEVERITY(),  
        @ErrorState = ERROR_STATE();  

    RAISERROR (@ErrorMessage, -- Message text.  
               @ErrorSeverity, -- Severity.  
               @ErrorState -- State.  
               );  
END CATCH  
  
