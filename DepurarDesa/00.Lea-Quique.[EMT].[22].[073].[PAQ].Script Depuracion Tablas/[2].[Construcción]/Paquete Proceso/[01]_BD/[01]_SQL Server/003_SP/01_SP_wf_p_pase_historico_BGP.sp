USE Emerix
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_p_pase_historico_BGP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[wf_p_pase_historico_BGP]
GO
CREATE PROCEDURE [dbo].[wf_p_pase_historico_BGP] (
	@v_fec_proceso DATETIME = NULL, 
	@v_usu_id	   INT = NULL,
	@cat_id	       INT = NULL,
	@v_cod_ret     INT = NULL OUT
)
AS

SET NOCOUNT ON

DECLARE @prc_nombre_corto varchar(10)
SET @prc_nombre_corto='PPH'


-- Busco usuario default
IF @v_usu_id IS NULL SELECT @v_usu_id = prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'USU_BATCH'


-- Si no se definio la fecha de proceso en el parametro, la tomo del parametro
IF @v_fec_proceso IS NULL OR ISDATE(@v_fec_proceso) = 0  
BEGIN  
	-- Obtencion del parámetro @v_fec_proceso
	SELECT @v_fec_proceso = prt_valor FROM wf_parametros where prt_baja_fecha is null and prt_nombre_corto='FECPRO'

	-- Si no se puede obtener la fecha del proceso cancelo
	IF @v_fec_proceso IS NULL OR ISDATE(@v_fec_proceso)=0  
	BEGIN  
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),getdate(),'I','PROCESO PASE A HISTORICO - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id  
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),getdate(),'A','PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id  
		SELECT @v_cod_ret = -1000  
		RETURN  
	END  
END  



INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','PROCESO PASE A HISTORICO - INICIADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id
INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Fecha Proceso: ' + CONVERT(CHAR(20),@v_fec_proceso,113), @v_usu_id, Null,@cat_id

DECLARE @atd_tabla          VARCHAR(30)
DECLARE @atd_SP             VARCHAR(50)
DECLARE @atd_orden          INT

DECLARE @v_total_ejecutados   INT
DECLARE @v_total_err          INT

DECLARE @error_tran         INT


/*si quedo un cursor abierto por una mala finalizacion anterior lo cierro*/
IF (SELECT CURSOR_STATUS('global', '#cur_atd')) = 1 CLOSE #cur_atd
IF (SELECT CURSOR_STATUS('global', '#cur_atd')) = - 1 DEALLOCATE #cur_atd

BEGIN TRY

	SET @v_total_ejecutados  = 0
	SET @v_total_err = 0

	DECLARE #cur_atd CURSOR FOR
		SELECT 
			atd_tabla,
			atd_SP,
			atd_orden 
		FROM 
			tablas_depurar_BGP
		WHERE 
			atd_baja_fecha IS NULL
		order by atd_orden

	OPEN #cur_atd
	FETCH NEXT FROM #cur_atd INTO @atd_tabla,@atd_SP,@atd_orden 
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		BEGIN
			Declare @sql nvarchar(2000)
			Select @sql = 'Exec ' + @atd_SP + ' @v_fec_proceso ,@cat_id, @v_usu_id, @v_cod_ret OUT'

			--TRUNCATE TABLE tmp_dependencias
		
			-- print @sql
			EXEC sp_executesql @sql, N'@v_fec_proceso DATETIME,@cat_id INT, @v_usu_id INT, @v_cod_ret INT OUT', @v_fec_proceso ,@cat_id, @v_usu_id, @v_cod_ret OUT
			SET @error_tran = @@Error
		END
		IF @error_tran = 0 AND @v_cod_ret = 0
		BEGIN
			SET @v_total_ejecutados = @v_total_ejecutados + 1
		END
		ELSE
		BEGIN
			SET @v_total_err = @v_total_err + 1
		END			
		FETCH NEXT FROM #cur_atd INTO @atd_tabla,@atd_SP,@atd_orden 
	END

	CLOSE #cur_atd
	DEALLOCATE #cur_atd

	SET @v_cod_ret = 0
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Total procesos ejecutados.....: ' + CONVERT(VARCHAR(8),@v_total_ejecutados), @v_usu_id, Null,@cat_id
	
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id


END TRY
BEGIN CATCH

	/*si quedo un cursor abierto por una mala finalizacion anterior lo cierro*/
	IF (SELECT CURSOR_STATUS('global', '#cur_atd')) = 1 CLOSE #cur_atd
	IF (SELECT CURSOR_STATUS('global', '#cur_atd')) = - 1 DEALLOCATE #cur_atd

	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Total procesos ejecutados.....: ' + CONVERT(VARCHAR(8),@v_total_ejecutados), @v_usu_id, Null,@cat_id
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Total procesos con error.....: ' + CONVERT(VARCHAR(8),@v_total_err), @v_usu_id, Null,@cat_id
	SET @v_cod_ret = 50000
	
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id

END CATCH
GO