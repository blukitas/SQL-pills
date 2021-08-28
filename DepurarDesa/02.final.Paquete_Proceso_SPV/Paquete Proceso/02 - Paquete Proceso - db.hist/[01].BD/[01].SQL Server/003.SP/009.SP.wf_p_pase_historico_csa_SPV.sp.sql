USE emt_supervielle_desa_prueba
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_p_pase_historico_csa_SPV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[wf_p_pase_historico_csa_SPV]
go
CREATE PROCEDURE [dbo].[wf_p_pase_historico_csa_SPV] (  
													@v_fec_proceso DATETIME,   
													@v_usu_id    INT,  
													@cat_id        INT,  
													@v_cod_ret     INT OUT  
)  
AS  
  
SET NOCOUNT ON  
  
DECLARE @prc_nombre_corto varchar(10)  
SET @prc_nombre_corto='PD-CSA'  
 
  
DECLARE @total_ejecutados INT  
DECLARE @total_err   INT  
DECLARE @total_reg   INT  
  

DECLARE @CsaCommit   INT  
DECLARE @v_base_depuracion VARCHAR(255)  
DECLARE @v_accion   VARCHAR(1)  
DECLARE @CsaCant INT

  
DECLARE @v_sql nvarchar(2000) 
DECLARE @error_msg nvarchar(4000)
DECLARE @contador_vueltas int
  
BEGIN  
	
	set @v_sql=''
	set @error_msg=''
	set @contador_vueltas =0

  
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
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),getdate(),'I','PROCESO PASE A HISTORICO - BITACORA DE CUENTAS - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),getdate(),'A','PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id    
			SELECT @v_cod_ret = -1000    
			RETURN    
		END    
	END    
  
 
  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','PROCESO PASE A HISTORICO - BITACORA DE CUENTAS - INICIADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Fecha Proceso: ' + CONVERT(CHAR(20),@v_fec_proceso,113), @v_usu_id, Null,@cat_id  
  
  
	--Parametros Generales  
	SET @CsaCommit = isnull((select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'CsaCommit' and prt_baja_fecha is null),0)
	SET @CsaCant  = isnull((select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'CsaCant' and prt_baja_fecha is null),1)
	
	SET @v_base_depuracion = isnull((select prt_valor from wf_parametros where prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null) ,'emt_supervielle_desa_prueba')
	SET @v_accion = 'D' -- 'D' Depurar
    
	SET @total_ejecutados  = 0  
	SET @total_err = 0  
	SET @v_cod_ret = 0  

	/*condicion de depuracion de bitacora de cuentas*/  
	SELECT @total_reg = COUNT(*)
		FROM (SELECT ROW_NUMBER() OVER(PARTITION BY csa_cta ORDER BY csa_cambio_fecha DESC ) AS r, csa_cta, csa_id
				FROM cmb_saldos ) as r 
		where r.r > @CsaCant 
   
   /*datos de logueo*/
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad Total de registros de bitacora de cuentas a Depurar: '+ convert(varchar,@total_reg), @v_usu_id, Null,@cat_id  
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad de registros de bitacora de cuentas por iteracion: '+ convert(varchar,@CsaCommit), @v_usu_id, Null,@cat_id 
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  	
   	

   BEGIN TRY 
		WHILE 1 = 1  
		BEGIN  
  			
			/*Vacio La tabla temporal donde se guardan los id de la tabla a borrar y de sus hijos*/
			TRUNCATE TABLE tmp_borrar  

			/*selecciono un top de los registros de la tabla a depurar*/
			INSERT INTO tmp_borrar
			SELECT TOP (@CsaCommit) 'cmb_saldos', csa_id, csa_alta_fecha
			FROM (SELECT ROW_NUMBER() OVER(PARTITION BY csa_cta ORDER BY csa_cambio_fecha DESC ) AS r, csa_cta, csa_id, csa_alta_fecha
					FROM cmb_saldos ) AS r 
			WHERE r.r > @CsaCant 
			
			/*si no hay mas registros a depurar salgo del bucle y finaliza el proceso*/  
			IF (SELECT COUNT(*) FROM tmp_borrar) = 0 BREAK  
        
			/*Marco el numero de iteracion en la print out*/
			set @contador_vueltas = @contador_vueltas + 1
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','-------------------------------------------------------------------Iteracion N°: '+ convert(varchar,@contador_vueltas) +'------------------------------------------------------------------', @v_usu_id, Null,@cat_id  

			/*inicio una transaccion*/  
			BEGIN TRAN t1
  		
				/*si es depuracion copia a la base historica los registros seleccionados y los borra de la base activa*/
    			if @v_accion = 'D'  
				BEGIN  
					--set @v_sql = N'INSERT ' + rtrim(@v_base_depuracion) + '.dbo.cmb_saldos SELECT * FROM cmb_saldos WHERE EXISTS(SELECT TOP 1 1 FROM tmp_borrar WHERE csa_id = id AND tabla = ''cmb_saldos'')'  
					----PRINT @v_sql  
					--EXEC sp_executesql @v_sql  

					/*CHEQUEO DEPENDENCIAS EN OTRAS TABLAS  (esto mueve los hijos al historico y los borra de la base activa)*/
					EXEC dbo.wf_p_chequear_dependencias_SPV @v_fec_proceso, 'cmb_saldos', @v_accion, @prc_nombre_corto  

					DELETE cmb_saldos FROM cmb_saldos INNER JOIN tmp_borrar ON csa_id = id and csa_alta_fecha = cambio_fecha and tabla = 'cmb_saldos'
					--print 'DELETE cmb_saldos FROM cmb_saldos INNER JOIN tmp_borrar ON csa_id = id and tabla = ''cmb_saldos''' 

				END  
	
				/*acumulo los registros en el contador*/
				SET @total_ejecutados = @total_ejecutados + (SELECT COUNT(*) FROM tmp_borrar WHERE tabla = 'cmb_saldos')  

				
			/*confirmo todo*/
			COMMIT TRAN t1
		--BREAK  
		/*itero*/	   
		END  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','  Total registros de bitacora de cuentas depurados.....: ' + CONVERT(VARCHAR(8),@total_ejecutados), @v_usu_id, Null,@cat_id  
		
		UPDATE tablas_depurar_SPV SET atd_ultima_ejecucion = GETDATE() WHERE atd_tabla = 'cmb_saldos'		

		SET @v_cod_ret =0

	END TRY
	BEGIN CATCH
		/*si hay error en el proceso o en el chequeo de dependencias hago rollback de lo no confirmado*/
		ROLLBACK TRAN t1
		set @error_msg= ERROR_MESSAGE()

		SELECT @total_err = @total_reg - @total_ejecutados  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E','  Total registros de bitacora de cuentas con error.....: ' + CONVERT(VARCHAR(8),@total_err), @v_usu_id, error_number(),@cat_id  
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E',convert(varchar(255),@error_msg), @v_usu_id, error_number(),@cat_id  
		
		SET @v_cod_ret = 50000  
		 
	END CATCH
  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - BITACORA DE CUENTAS - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
  
END  
GO