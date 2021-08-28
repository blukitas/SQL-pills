USE Emerix
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_p_pase_historico_acc_BGP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[wf_p_pase_historico_acc_BGP]
go
CREATE PROCEDURE [dbo].[wf_p_pase_historico_acc_BGP] (  
													@v_fec_proceso DATETIME,   
													@v_usu_id    INT,  
													@cat_id        INT,  
													@v_cod_ret     INT OUT  
)  
AS  
  
SET NOCOUNT ON  
  
DECLARE @prc_nombre_corto varchar(10)  
SET @prc_nombre_corto='PD-ACC'  
 
  
DECLARE @total_ejecutados INT  
DECLARE @total_err   INT  
DECLARE @total_reg   INT  
  

DECLARE @AccCommit   INT  
DECLARE @v_base_depuracion VARCHAR(255)  
DECLARE @v_accion   VARCHAR(1)  
DECLARE @AccMeses INT

  
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
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),getdate(),'I','PROCESO PASE A HISTORICO - ACCIONES - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
			INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),getdate(),'A','PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id    
			SELECT @v_cod_ret = -1000    
			RETURN    
		END    
	END    
  
 
  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','PROCESO PASE A HISTORICO - ACCIONES - INICIADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Fecha Proceso: ' + CONVERT(CHAR(20),@v_fec_proceso,113), @v_usu_id, Null,@cat_id  
  
  
	--Parametros Generales  
	SET @AccCommit  = isnull((select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'AccCommit' and prt_baja_fecha is null),0)
	SET @AccMeses  = isnull((select prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'AccMeses' and prt_baja_fecha is null),999)

	SET @v_base_depuracion = isnull((select prt_valor from wf_parametros where prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null) ,'')
	SET @v_accion = 'D' -- 'D' Depurar
    
	SET @total_ejecutados  = 0  
	SET @total_err = 0  
	SET @v_cod_ret = 0  

	/*condicion de depuracion de acciones*/  
	/*Tabla temporal para gusrdar cuentas en carteras de juicio activo para depuracion de acciones*/
	declare @carteras_juicio_activo varchar(255)

	set @carteras_juicio_activo=(select prt_valor from wf_parametros where prt_nombre_corto='CarJuiAct' and prt_baja_fecha is null)


	if OBJECT_ID('tempdb..#tbl_juicio_activo') is not null 
	DROP TABLE #tbl_juicio_activo 

	create table #tbl_juicio_activo (cta_per int, cta_id int)
	create index IX_Jucio_activo_cta_per on #tbl_juicio_activo (cta_per)
	create index IX_Jucio_activo_cta_id on #tbl_juicio_activo (cta_id)

	insert into #tbl_juicio_activo
	select cta_per,cta_id 
	from cuentas 
	where cta_baja_fecha is null 
	and cta_cat in (select cat_id 
					from carteras 
					inner join dbo.ew_ng_f_split(@carteras_juicio_activo,',') t on t.value=cat_nombre_corto and t.value <>''
					where cat_baja_fecha is null)


	SELECT @total_reg = COUNT(*)
	FROM acciones (NOLOCK)
	WHERE DATEDIFF(mm,acc_fec_hora,@v_fec_proceso) > @AccMeses
	and not exists (select 1 from #tbl_juicio_activo where cta_id=acc_cta) 
	and not exists (select 1 from #tbl_juicio_activo where cta_per=acc_per )
	
	
   
   /*datos de logueo*/
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad Total de Acciones a Depurar: '+ convert(varchar,@total_reg), @v_usu_id, Null,@cat_id  
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad de Acciones por iteracion: '+ convert(varchar,@AccCommit), @v_usu_id, Null,@cat_id 
   INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  	
   	

   BEGIN TRY 
		WHILE 1 = 1  
		BEGIN  
  			
			/*Vacio La tabla temporal donde se guardan los id de la tabla a borrar y de sus hijos*/
			TRUNCATE TABLE tmp_borrar  

			/*selecciono un top de los registros de la tabla a depurar*/
			INSERT INTO tmp_borrar
			SELECT TOP (@AccCommit)
				'acciones', acc_id
			FROM acciones (NOLOCK)
			WHERE DATEDIFF(mm,acc_fec_hora,@v_fec_proceso) > @AccMeses
			and not exists (select 1 from #tbl_juicio_activo where cta_id=acc_cta) 
			and not exists (select 1 from #tbl_juicio_activo where cta_per=acc_per)		
									 
  
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
					set @v_sql = N'INSERT ' + rtrim(@v_base_depuracion) + '.dbo.acciones SELECT * FROM acciones WHERE EXISTS(SELECT TOP 1 1 FROM tmp_borrar WHERE acc_id = id AND tabla = ''acciones'')'  
					--PRINT @v_sql  
					EXEC sp_executesql @v_sql  

					/*CHEQUEO DEPENDENCIAS EN OTRAS TABLAS  (esto mueve los hijos al historico y los borra de la base activa)*/
					EXEC dbo.wf_p_chequear_dependencias_BGP 'Acciones', @v_accion, @prc_nombre_corto  

					DELETE acciones FROM acciones INNER JOIN tmp_borrar ON acc_id = id and tabla = 'acciones'  
					--print 'DELETE acciones FROM acciones INNER JOIN tmp_borrar ON acc_id = id and tabla = ''acciones''' 

				END  
	
				/*acumulo los registros en el contador*/
				SET @total_ejecutados = @total_ejecutados + (SELECT COUNT(*) FROM tmp_borrar WHERE tabla = 'acciones')  

				
			/*confirmo todo*/
			COMMIT TRAN   
		--BREAK  
		/*itero*/	   
		END  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','  Total registros de acciones depurados.....: ' + CONVERT(VARCHAR(8),@total_ejecutados), @v_usu_id, Null,@cat_id  
		SET @v_cod_ret =0

	END TRY
	BEGIN CATCH
		/*si hay error en el proceso o en el chequeo de dependencias hago rollback de lo no confirmado*/
		ROLLBACK TRAN
		set @error_msg= ERROR_MESSAGE()

		SELECT @total_err = @total_reg - @total_ejecutados  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E','  Total registros de acciones con error.....: ' + CONVERT(VARCHAR(8),@total_err), @v_usu_id, error_number(),@cat_id  
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E',convert(varchar(255),@error_msg), @v_usu_id, error_number(),@cat_id  
		
		SET @v_cod_ret = 50000  
		 
	END CATCH
  
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - ACCIONES - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
  
END  
GO