USE Emerix
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_p_pase_historico_cta_BGP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[wf_p_pase_historico_cta_BGP]
go
CREATE PROCEDURE [dbo].[wf_p_pase_historico_cta_BGP] (  
													@v_fec_proceso DATETIME,   
													@v_usu_id    INT,  
													@cat_id        INT,  
													@v_cod_ret     INT OUT  
)  
AS  
  
SET NOCOUNT ON  
  
DECLARE @prc_nombre_corto varchar(10)  
SET @prc_nombre_corto='PD-CTA'  
 
  
DECLARE @total_ejecutados INT  
DECLARE @total_err   INT  
DECLARE @total_reg   INT  
  
DECLARE @CtaDiaInac   INT  
DECLARE @CtaDiaNoGs   INT  
DECLARE @CtaCommit   INT  
DECLARE @CtaMeses   INT  
DECLARE @v_base_depuracion VARCHAR(255)  
DECLARE @v_accion   VARCHAR(1)  

  
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
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),getdate(),'I','PROCESO PASE A HISTORICO - CUENTAS - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),getdate(),'A','PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id    
			SELECT @v_cod_ret = -1000    
			RETURN    
		END    
	END    
  
 
  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','PROCESO PASE A HISTORICO - CUENTAS - INICIADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Fecha Proceso: ' + CONVERT(CHAR(20),@v_fec_proceso,113), @v_usu_id, Null,@cat_id  
  
  
	--Parametros Generales  
	--SET @CtaDiaInac = (select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'CtaDiaInac')  
	--SET @CtaDiaNoGs = (select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'CtaDiaNoGs')  
	SET @CtaCommit  = isnull((select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'CtaCommit' and prt_baja_fecha is null),0)
	set @CtaMeses = isnull((select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'CtaMeses' and prt_baja_fecha is null),0)
	SET @v_base_depuracion = isnull((select prt_valor from wf_parametros where prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null) ,'')
	SET @v_accion = 'D' -- 'D' Depurar
    
	SET @total_ejecutados  = 0  
	SET @total_err = 0  
	SET @v_cod_ret = 0  

	/*condicion de depuracion de cuentas*/  
	SELECT @total_reg = COUNT(*) 
	from cuentas 
	WHERE 1=1   
    and cta_baja_fecha  is not null --fecha de Baja
	and DATEDIFF(mm,cta_baja_fecha,@v_fec_proceso) > @CtaMeses


   
   /*datos de logueo*/
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad Total de Cuentas a Depurar: '+ convert(varchar,@total_reg), @v_usu_id, Null,@cat_id  
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad de Cuentas por iteracion: '+ convert(varchar,@CtaCommit), @v_usu_id, Null,@cat_id 
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  	
   	

	/*dependencias agregadas propias de la implementacion*/
	if not exists(select 1 from tmp_dependencias_BGP where tabla_ori='prestamos' and tabla='add_prestamos')
		insert into tmp_dependencias_BGP values('prestamos','add_prestamos','apr_id')

	if not exists(select 1 from tmp_dependencias_BGP where tabla_ori='prestamos_cuotas' and tabla='add_prestamos_cuotas')
		insert into tmp_dependencias_BGP values('prestamos_cuotas','add_prestamos_cuotas','apc_id')

	if not exists(select 1 from tmp_dependencias_BGP where tabla_ori='tarjetas' and tabla='add_tarjetas')
		insert into tmp_dependencias_BGP values('tarjetas','add_tarjetas','ata_id')


	BEGIN TRY 
		WHILE 1 = 1  
		BEGIN  
  			
			/*Vacio La tabla temporal donde se guardan los id de la tabla a borrar y de sus hijos*/
			TRUNCATE TABLE tmp_borrar  

			/*selecciono un top de los registros de la tabla a depurar*/
			INSERT INTO tmp_borrar  
			SELECT TOP (@CtaCommit)  
				'cuentas', cta_id  
			from cuentas 
			WHERE 1=1   
			and cta_baja_fecha  is not null --fecha de Baja
			and DATEDIFF(mm,cta_baja_fecha,@v_fec_proceso) > @CtaMeses							 
  
			/*si no hay mas registros a depurar salgo del bucle y finaliza el proceso*/  
			IF (SELECT COUNT(*) FROM tmp_borrar) = 0 BREAK  
        
			/*Marco el numero de iteracion en la print out*/
			set @contador_vueltas = @contador_vueltas + 1
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','-------------------------------------------------------------------Iteracion N°: '+ convert(varchar,@contador_vueltas) +'------------------------------------------------------------------', @v_usu_id, Null,@cat_id  

			/*inicio una transaccion*/  
			BEGIN TRAN   
  		
				/*si es depuracion copia a la base historica los registros seleccionados y los borra de la base activa*/
    			if @v_accion = 'D'  
				BEGIN  
					set @v_sql = N'INSERT ' + rtrim(@v_base_depuracion) + '.dbo.cuentas SELECT * FROM cuentas WHERE EXISTS(SELECT TOP 1 1 FROM tmp_borrar WHERE cta_id = id AND tabla = ''cuentas'')'  
					--PRINT @v_sql  
					EXEC sp_executesql @v_sql  

					/*CHEQUEO DEPENDENCIAS EN OTRAS TABLAS  (esto mueve los hijos al historico y los borra de la base activa)*/
					EXEC dbo.wf_p_chequear_dependencias_BGP 'Cuentas', @v_accion, @prc_nombre_corto  

					DELETE cuentas FROM cuentas INNER JOIN tmp_borrar ON cta_id = id and tabla = 'cuentas'  
					--print 'DELETE cuentas FROM cuentas INNER JOIN tmp_borrar ON cta_id = id and tabla = ''cuentas''' 

				END  
	
				/*acumulo los registros en el contador*/
				SET @total_ejecutados = @total_ejecutados + (SELECT COUNT(*) FROM tmp_borrar WHERE tabla = 'cuentas')  

				
			/*confirmo todo*/
			COMMIT TRAN   
		--BREAK  
		/*itero*/	   
		END  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','  Total registros de cuentas depurados.....: ' + CONVERT(VARCHAR(8),@total_ejecutados), @v_usu_id, Null,@cat_id  
		SET @v_cod_ret =0

	END TRY
	BEGIN CATCH
		/*si hay error en el proceso o en el chequeo de dependencias hago rollback de lo no confirmado*/
		ROLLBACK TRAN
		set @error_msg= ERROR_MESSAGE()

		SELECT @total_err = @total_reg - @total_ejecutados  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E','  Total registros de cuentas con error.....: ' + CONVERT(VARCHAR(8),@total_err), @v_usu_id, error_number(),@cat_id  
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E',convert(varchar(255),@error_msg), @v_usu_id, error_number(),@cat_id  
		
		SET @v_cod_ret = 50000  
		 
	END CATCH
  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - CUENTAS - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
  
END  
GO