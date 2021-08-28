/* ------------------------------------	Eliminar constraint -------------------------------------------------------	*/
use emt_supervielle_desa

DECLARE	@v_fec_proceso DATETIME   
SET @v_fec_proceso = CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),112))

DECLARE @v_usu_id    INT  
DECLARE @prc_nombre_corto varchar(10) 
DECLARE @cat_id        INT  
DECLARE @v_cod_ret     INT 
DECLARE @error_msg NVARCHAR(4000)

SET @prc_nombre_corto='PD-TRTB'  
SET @cat_id =0
SET @v_cod_ret=0 
SET @error_msg = ''
SET @v_usu_id = 1

-- Busco usuario default  
-- IF @v_usu_id IS NULL SELECT @v_usu_id = prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'USU_BATCH'  

  -- Si no se definio la fecha de proceso en el parametro, la tomo del parametro  
IF @v_fec_proceso IS NULL OR ISDATE(@v_fec_proceso) = 0    
BEGIN    
	-- Obtencion del parámetro @v_fec_proceso  
	SELECT @v_fec_proceso = prt_valor FROM dbo.wf_parametros WHERE prt_baja_fecha is null and prt_nombre_corto='FECPRO'  
  
	-- Si no se puede obtener la fecha del proceso cancelo  
	IF @v_fec_proceso IS NULL OR ISDATE(@v_fec_proceso)=0    
	BEGIN    
		INSERT dbo.wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','SCRIPT PASE A HISTORICO - Eliminar constraint - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
		INSERT dbo.wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id    
		SELECT @v_cod_ret = -1000    
		RETURN    
	END    
END    

INSERT dbo.wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','SCRIPT PASE A HISTORICO - Eliminar keys - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
	

DECLARE @v_tabla NVARCHAR(200)
DECLARE @v_constraint NVARCHAR(200)
DECLARE @Sqlstatment NVARCHAR(max)
DECLARE Sql_cursor CURSOR FOR 
						SELECT name as SQLstmt 
						FROM sys.tables t
						WHERE name like 'in[_]%'

OPEN Sql_cursor
FETCH NEXT FROM Sql_cursor
INTO @v_tabla

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT dbo.wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Tabla: ' + @v_tabla, @v_usu_id, Null,@cat_id  

	SET @Sqlstatment = 'TRUNCATE TABLE ' + @v_tabla
	EXEC sp_executesql @Sqlstatment

	FETCH NEXT FROM Sql_cursor 
	INTO @v_tabla
END

CLOSE Sql_cursor
DEALLOCATE Sql_cursor

INSERT dbo.wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - Eliminar constraint - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  

/* ----------------------------------------------------------------------------------------------------------------	*/