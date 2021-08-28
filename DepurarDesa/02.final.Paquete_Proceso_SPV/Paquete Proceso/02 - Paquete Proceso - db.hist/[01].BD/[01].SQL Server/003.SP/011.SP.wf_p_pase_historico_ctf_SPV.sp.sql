USE emt_supervielle_desa_prueba
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_p_pase_historico_ctf_SPV]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[wf_p_pase_historico_ctf_SPV]
GO

CREATE PROCEDURE [dbo].[wf_p_pase_historico_ctf_SPV] (  
													@v_fec_proceso DATETIME,   
													@v_usu_id    INT,  
													@cat_id        INT,  
													@v_cod_ret     INT OUT  
)  
AS  
  
SET NOCOUNT ON  
  
DECLARE @prc_nombre_corto varchar(10)  
SET @prc_nombre_corto='PD-CTF'  
 
  
DECLARE @total_ejecutados INT  
DECLARE @total_err   INT  
DECLARE @total_reg   INT  
  

DECLARE @CtfCommit   INT  
DECLARE @v_base_depuracion VARCHAR(255)  
DECLARE @v_accion   VARCHAR(1)  
DECLARE @CtfDias INT

  
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
	SET @CtfCommit  = isnull((select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'CtfCommit' and prt_baja_fecha is null),0)
	SET @CtfDias  = isnull((select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'CtfDias' and prt_baja_fecha is null),999)

	SET @v_base_depuracion = isnull((select prt_valor from wf_parametros where prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null) ,'')
	SET @v_accion = 'D' -- 'D' Depurar
    
	SET @total_ejecutados  = 0  
	SET @total_err = 0  
	SET @v_cod_ret = 0  

	/*condicion de depuracion de bitacora de cuentas*/  
	SELECT @total_reg = COUNT(*)
		FROM cmb_pte a
		WHERE
		--Anteriores a N Dias
		DATEDIFF(DAY, a.ctf_alta_fecha,@v_fec_proceso) > @CtfDias
	


   
   /*datos de logueo*/
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad Total de registros de bitacora de cuentas a Depurar: '+ convert(varchar,@total_reg), @v_usu_id, Null,@cat_id  
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad de registros de bitacora de cuentas por iteracion: '+ convert(varchar,@CtfCommit), @v_usu_id, Null,@cat_id 
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  	
   	

   BEGIN TRY 
		WHILE 1 = 1  
		BEGIN  
  			
			/*Vacio La tabla temporal donde se guardan los id de la tabla a borrar y de sus hijos*/
			TRUNCATE TABLE tmp_borrar  

			/*selecciono un top de los registros de la tabla a depurar*/
			INSERT INTO tmp_borrar
			SELECT TOP (@CtfCommit) 'cmb_pte', ctf_id, ctf_alta_fecha
			FROM cmb_pte a
			WHERE
			--Anteriores a N Dias
			DATEDIFF(DAY, a.ctf_alta_fecha,@v_fec_proceso) > @CtfDias
			
				 
  
			/*si no hay mas registros a depurar salgo del bucle y finaliza el proceso*/  
			IF (SELECT COUNT(*) FROM tmp_borrar) = 0 BREAK  
        
			/*Marco el numero de iteracion en la print out*/
			SET @contador_vueltas = @contador_vueltas + 1
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','-------------------------------------------------------------------Iteracion N°: '+ convert(varchar,@contador_vueltas) +'------------------------------------------------------------------', @v_usu_id, Null,@cat_id  

			/*inicio una transaccion*/  
			BEGIN TRAN   
				/*si es depuracion copia a la base historica los registros seleccionados y los borra de la base activa*/
    			IF @v_accion = 'D'  
				BEGIN  
					--SET @v_sql = N'INSERT ' + rtrim(@v_base_depuracion) + '.dbo.cmb_pte SELECT * FROM cmb_pte WHERE EXISTS(SELECT TOP 1 1 FROM tmp_borrar WHERE ctf_id = id AND tabla = ''cmb_pte'')'  
					----PRINT @v_sql  
					--EXEC sp_executesql @v_sql  

					/*CHEQUEO DEPENDENCIAS EN OTRAS TABLAS  (esto mueve los hijos al historico y los borra de la base activa)*/
					EXEC dbo.wf_p_chequear_dependencias_SPV @v_fec_proceso, 'cmb_pte', @v_accion, @prc_nombre_corto  

					DELETE cmb_pte FROM cmb_pte INNER JOIN tmp_borrar ON ctf_id = id and ctf_alta_fecha = cambio_fecha and tabla = 'cmb_pte'
					--print 'DELETE cmb_pte FROM cmb_pte INNER JOIN tmp_borrar ON ctf_id = id and tabla = ''cmb_pte''' 
				END  
	
				/*acumulo los registros en el contador*/
				SET @total_ejecutados = @total_ejecutados + (SELECT COUNT(*) FROM tmp_borrar WHERE tabla = 'cmb_pte')  

				
			/*confirmo todo*/
			COMMIT TRAN   
		--BREAK  
		/*itero*/	   
		END  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','  Total registros de bitacora de cuentas depurados.....: ' + CONVERT(VARCHAR(8),@total_ejecutados), @v_usu_id, Null,@cat_id  
		
		UPDATE tablas_depurar_SPV SET atd_ultima_ejecucion = GETDATE() WHERE atd_tabla = 'cmb_pte'		

		SET @v_cod_ret =0

	END TRY
	BEGIN CATCH
		/*si hay error en el proceso o en el chequeo de dependencias hago rollback de lo no confirmado*/
		ROLLBACK TRAN
		set @error_msg= ERROR_MESSAGE()

		SELECT @total_err = @total_reg - @total_ejecutados  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E','  Total registros de bitacora de cuentas con error.....: ' + CONVERT(VARCHAR(8),@total_err), @v_usu_id, error_number(),@cat_id  
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E',convert(varchar(255),@error_msg), @v_usu_id, error_number(),@cat_id  
		
		SET @v_cod_ret = 50000  
		 
	END CATCH
  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - BITACORA DE CUENTAS - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
  
END  
GO