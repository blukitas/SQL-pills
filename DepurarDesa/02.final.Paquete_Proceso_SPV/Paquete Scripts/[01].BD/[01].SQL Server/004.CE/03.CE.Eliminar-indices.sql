/* ------------------------------------	Eliminar constraint -------------------------------------------------------	*/
use emerix_hist 

IF OBJECT_ID( '[dbo].[emx_indices_depuracion]') IS NOT NULL
    DROP PROCEDURE [dbo].[emx_indices_depuracion]
GO

CREATE PROCEDURE [dbo].[emx_indices_depuracion]
AS

DECLARE	@v_fec_proceso DATETIME   
SET @v_fec_proceso = CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),112))

DECLARE @v_usu_id    INT  
DECLARE @prc_nombre_corto varchar(10) 
DECLARE @cat_id        INT  
DECLARE @v_cod_ret     INT 
DECLARE @error_msg NVARCHAR(4000)

SET @prc_nombre_corto='PD-KEY'  
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
	SELECT @v_fec_proceso = prt_valor FROM wf_parametros WHERE prt_baja_fecha is null and prt_nombre_corto='FECPRO'  
  
	-- Si no se puede obtener la fecha del proceso cancelo  
	IF @v_fec_proceso IS NULL OR ISDATE(@v_fec_proceso)=0    
	BEGIN    
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','SCRIPT PASE A HISTORICO - Eliminar constraint - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id    
		SELECT @v_cod_ret = -1000    
		RETURN    
	END    
END    

INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','SCRIPT PASE A HISTORICO - Eliminar keys - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
	

DECLARE @v_tabla NVARCHAR(200)
DECLARE @v_constraint NVARCHAR(200)
DECLARE @Sqlstatment NVARCHAR(max)
DECLARE Sql_cursor CURSOR FOR 
						SELECT TABLE_NAME, constraint_name   as SQLstmt 
						FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
						WHERE TABLE_NAME = 'wf_cmb_objetos' or
						  	  TABLE_NAME = 'cmb_saldos' or
							  TABLE_NAME = 'cmb_cta' or
							  TABLE_NAME = 'cmb_pte'

OPEN Sql_cursor
FETCH NEXT FROM Sql_cursor
INTO @v_tabla, @v_constraint

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Constraint: ' + @v_constraint + ', Tabla: ' + @v_tabla, @v_usu_id, Null,@cat_id  

	SET @Sqlstatment = 'ALTER TABLE ' + @v_tabla + ' DROP CONSTRAINT ' + @v_constraint
	EXEC sp_executesql @Sqlstatment

	FETCH NEXT FROM Sql_cursor 
	INTO @v_tabla, @v_constraint
END

CLOSE Sql_cursor
DEALLOCATE Sql_cursor

INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - Eliminar constraint - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  

/* ----------------------------------------------------------------------------------------------------------------	*/