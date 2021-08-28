/* ------------------------------------	Reenumerar las tablas depuradas -----------------------------------------------	*/

IF OBJECT_ID( '[dbo].[emx_reenumerar_depuracion]') IS NOT NULL
    DROP PROCEDURE [dbo].[emx_reenumerar_depuracion]
GO

CREATE PROCEDURE [dbo].[emx_reenumerar_depuracion]
AS

SET NOCOUNT ON  


/************************************************/
/*                                              */
/*      Reenumerar las tablas depuradas			*/
/*                                              */
/************************************************/

DECLARE	@v_fec_proceso DATETIME   
SET @v_fec_proceso = CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),112))

DECLARE @CobCommit INT
DECLARE @CsaCommit INT
DECLARE @CctCommit INT
DECLARE @CtfCommit INT

DECLARE @total_reg   INT  
DECLARE @v_usu_id    INT  
DECLARE @prc_nombre_corto VARCHAR(10) ='PD-REN' 
DECLARE @cat_id      INT = 0
DECLARE @v_cod_ret   INT = 0
DECLARE @total_ejecutados INT  
DECLARE @total_err   INT  

DECLARE @ultimo_id   VARCHAR(1)    
DECLARE @v_sql NVARCHAR(2000) = ''
DECLARE @error_msg NVARCHAR(4000) = ''
DECLARE @contador_vueltas INT = 0
  
-- Busco usuario default  
IF @v_usu_id IS NULL SELECT @v_usu_id = prt_valor FROM wf_parametros WHERE prt_nombre_corto = 'USU_BATCH'  
set @v_usu_id = 1  
  
-- Si no se definio la fecha de proceso en el parametro, la tomo del parametro  
IF @v_fec_proceso IS NULL OR ISDATE(@v_fec_proceso) = 0    
BEGIN    
	-- Obtencion del parámetro @v_fec_proceso  
	SELECT @v_fec_proceso = prt_valor FROM wf_parametros where prt_baja_fecha is null and prt_nombre_corto='FECPRO'  
  
	-- Si no se puede obtener la fecha del proceso cancelo  
	IF @v_fec_proceso IS NULL OR ISDATE(@v_fec_proceso)=0    
	BEGIN    
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','SCRIPT PASE A HISTORICO - Reenumerar - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id    
		SELECT @v_cod_ret = -1000    
		RETURN    
	END    
END    


SET @CobCommit = 100000
--SET @CobCommit = ISNULL((SELECT prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CboCommit'),5000)
SET @CsaCommit = 100000
--SET @CsaCommit = ISNULL((SELECT prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CsaCommit'),5000)
SET @CctCommit = 100000
--SET @CctCommit = ISNULL((SELECT prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CctCommit'),5000)
SET @CtfCommit = 100000
--SET @CtfCommit = ISNULL((SELECT prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CtfCommit'),5000)

DECLARE @tablas_a_reenumerar TABLE (orden int,
								  tabla varchar(50),
								  PK_tabla varchar(10),
								  par_commit int,
								  cant_reg int, 
								  query_cant_reg nvarchar(4000), 
								  ultimo_id int)

--/*
--	Tabla wf_cmb_objetos 
--*/

INSERT INTO @tablas_a_reenumerar VALUES(1, 'wf_cmb_objetos','cob_id',@CobCommit,1,
'SELECT @total_reg = max(cob_id) - count(*) from wf_cmb_objetos',
0)

/*
	Tabla cmb_saldos
*/
INSERT INTO @tablas_a_reenumerar VALUES(2, 'cmb_saldos','csa_id',@CsaCommit,2,
'SELECT @total_reg = max(csa_id) - count(*) from cmb_saldos',
0)

--/*
--	Tabla cmb_cuentas
--*/
INSERT INTO @tablas_a_reenumerar VALUES(3, 'cmb_cta','cct_id',@CctCommit,3,
'SELECT @total_reg = max(cct_id) - count(*) from cmb_cta',
0)

--/*
--	Tabla cmb_per_tel
--*/
INSERT INTO @tablas_a_reenumerar VALUES(4, 'cmb_pte','ctf_id',@CtfCommit,4,
'SELECT @total_reg = max(ctf_id) - count(*) from cmb_pte',
0)


INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','SCRIPT PASE A HISTORICO - Reenumerar - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    


/* Si hay cursor, lo destruyo */
IF (SELECT CURSOR_STATUS('global','#cur_tablas_depurar')) = 1 CLOSE #cur_tablas_depurar
IF (SELECT CURSOR_STATUS('global','#cur_tablas_depurar')) = -1 DEALLOCATE #cur_tablas_depurar

declare @cur_tabla varchar(50)
declare @cur_query_cant_reg nvarchar(4000)

-- Cuanto falta
declare #cur_tablas_depurar cursor for
select tabla, query_cant_reg, ultimo_id from @tablas_a_reenumerar

open #cur_tablas_depurar
Fetch #cur_tablas_depurar into @cur_tabla, @cur_query_cant_reg, @ultimo_id

-- Por cada tabla, calcular cuantos registros faltan operar
while @@fetch_status = 0
begin
	exec sp_executesql @cur_query_cant_reg, N'@total_reg int out',  @total_reg out  

	update @tablas_a_reenumerar set
	cant_reg = ISNULL(@total_reg,0)
	where tabla=@cur_tabla

	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Tabla '+ @cur_tabla +' cantidad de registros a renumerar: '+ convert(varchar,ISNULL(@total_reg,0)), @v_usu_id, Null, @cat_id    
		
	PRINT 'Tabla '+ @cur_tabla +' cantidad de registros a renumerar: ' + convert(varchar,ISNULL(@total_reg,0))
	
	Fetch #cur_tablas_depurar into @cur_tabla, @cur_query_cant_reg, @ultimo_id
end

select * from @tablas_a_reenumerar
INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null, @cat_id    

close #cur_tablas_depurar
deallocate #cur_tablas_depurar


BEGIN  
	SET @total_ejecutados  = 0  
	SET @total_err = 0  
	SET @v_cod_ret = 0  

	
	--Parametros Generales  
	declare @v_commit INT
	declare @v_tabla varchar(50)
	declare @v_tabla_anterior varchar(50)
	declare @v_cant_reg INT
	declare @v_query_cant_reg nvarchar(1000)
	declare @v_PK_tabla varchar(10)
	declare @v_PK_tabla_ant varchar(10)
	declare @id_control INT = 0

	-- Reenumerar
   BEGIN TRY 
		WHILE 1 = 1  
		BEGIN  
			print 'Iteracion' + CAST(@contador_vueltas as varchar(10))
			SET @v_commit = 0
			SET @v_tabla = ''
			SET @v_PK_tabla = ''
			SET @v_cant_reg = 0
			SET @ultimo_id = 0

			/*Vacio La tabla temporal donde se guardan los id de la tabla a borrar y de sus hijos*/
			TRUNCATE TABLE tmp_borrar  

			/* Selecciono top 1, la tabla a depurar */
			SELECT TOP 1	@v_commit=par_commit,
							@v_tabla=tabla,
							@v_PK_tabla=PK_tabla,
							@v_cant_reg=cant_reg,
							@v_query_cant_reg=query_cant_reg,
							@ultimo_id=ultimo_id
			FROM @tablas_a_reenumerar WHERE ISNULL(cant_reg,0) <> 0 ORDER BY orden
			print @@rowcount 
			print @v_tabla
			print @v_PK_tabla
			print @v_cant_reg
			
			set @v_commit = 100000

			/* Si la tabla esta vacia => No hay tabla a depurar. Fin del proceso de la tabla */
			IF ISNULL(@v_tabla,'') = ''
			BEGIN 
				IF ISNULL(@v_tabla_anterior, '') <> '' 
					BEGIN
						INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - Actualizar idn_numeracion ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
						SET @v_sql = 'UPDATE id_numeracion SET idn_ultimo_id = (SELECT MAX(' + @v_PK_tabla_ant + ') from ' + @v_tabla_anterior + ' ) WHERE idn_tabla = ' + @v_tabla_anterior 
						EXEC sp_executesql @v_sql  	

						INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
					END
				ELSE
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - NO HAY REGISTROS QUE RENUMERAR - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				BREAK
			END


			/* Si no hay tabla actual, ni anterior => Terminamos */
			IF ISNULL(@v_tabla_anterior,'') <> ISNULL(@v_tabla,'')
			BEGIN 					
				IF ISNULL(@v_tabla_anterior,'') <> '' and ISNULL(@v_tabla_anterior,'') <> ISNULL(@v_tabla,'')
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  

				SET @v_tabla_anterior = @v_tabla
				SET @v_PK_tabla_ant = @v_PK_tabla
				SET @contador_vueltas = 0

				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla) +' - INICIADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Fecha Proceso: ' + CONVERT(CHAR(20),@v_fec_proceso,113), @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad Total de registros de '+ lower(@v_tabla) +' a Renumerar: '+ convert(varchar,@v_cant_reg), @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad de registros de '+ lower(@v_tabla) +' por iteracion: '+ convert(varchar,@v_commit), @v_usu_id, Null,@cat_id 
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id
			END

			/*Inicio transaccion para reenumerar (Cierta cantidad de registros) */  
			IF ISNULL(@v_tabla,'') <> ''
			BEGIN
				BEGIN TRAN   

					SET @v_sql = 'UPDATE x SET x.' + @v_PK_tabla + '= x.New_CODE_DEST FROM (SELECT TOP ' + CAST( @v_commit as varchar(10)) + ' ' + @v_PK_tabla + ', ' + CAST(@contador_vueltas * @v_commit as varchar(10)) + ' + ROW_NUMBER() OVER (ORDER BY ' + @v_PK_tabla + ') AS New_CODE_DEST FROM ' + @v_tabla + ' WHERE ' + @v_PK_tabla + ' > ' +  CAST(@id_control as varchar(10))  + ') x' --+ ' AND ' + @v_PK_tabla + ' <= ' + CAST(@id_control + @v_commit as varchar(10)) + ') x'
					print @v_sql
					--SET @v_sql = 'UPDATE x SET x.' + @v_PK_tabla + '= x.New_CODE_DEST FROM (SELECT ' + @v_PK_tabla + ', ' + CAST(@contador_vueltas * @v_commit as varchar(10)) + ' + ROW_NUMBER() OVER (ORDER BY ' + @v_PK_tabla + ') AS New_CODE_DEST FROM ' + @v_tabla + ' WHERE ' + @v_PK_tabla + ' > ' +  CAST(@id_control as varchar(10))  + ') x' --+ ' AND ' + @v_PK_tabla + ' <= ' + CAST(@id_control + @v_commit as varchar(10)) + ') x'
					EXEC sp_executesql @v_sql  	
				
					EXEC sp_executesql @v_query_cant_reg, N'@total_reg int out',  @total_reg out  
					PRINT 'registros: ' + CAST(@total_reg AS VARCHAR(10))
					print @total_reg
				
					/* Desde que id parte la próxima iteración */
					SET @id_control = @id_control + @v_commit
					UPDATE @tablas_a_reenumerar 
						SET @ultimo_id = @id_control, cant_reg = @total_reg 
						WHERE tabla = @v_tabla 

					SET @contador_vueltas = @contador_vueltas + 1

					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A', @v_tabla +'----------------------------------------------------------Iteracion N°: '+ convert(varchar,@contador_vueltas) +'------------------------------------------------------------------', @v_usu_id, Null,@cat_id  

				/* Confirmo todo */
				COMMIT TRAN   
			END
				
			/* Si no hay mas registros a depurar => Salgo del bucle y finaliza el proceso*/  
			IF ISNULL(@total_reg,0) = 0
			BEGIN
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - Actualizar idn_numeracion ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  

				SET @v_sql = 'UPDATE id_numeracion SET idn_ultimo_id = (SELECT MAX(' + @v_PK_tabla_ant + ') from ' + @v_tabla_anterior + ' ) WHERE idn_tabla = ''' + @v_tabla_anterior + ''''
				EXEC sp_executesql @v_sql 	

				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - Reenumerar'+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				BREAK  
			END
			
		--BREAK			 
		/*itero*/	   
		END  
		
		SET @v_cod_ret =0
		PRINT ''
		PRINT 'El script de reenumeracion ha finalizado'
	END TRY
	BEGIN CATCH
		/* Si hay error en el proceso o en el chequeo de dependencias, hago rollback de lo no confirmado */
		IF @@TRANCOUNT >0		
			ROLLBACK TRAN
		
		SET @error_msg= ERROR_MESSAGE()
		print @error_msg
		 
		SELECT @total_err = @total_reg - @total_ejecutados  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E',convert(varchar(255),@error_msg), @v_usu_id, error_number(),@cat_id  
		
		SET @v_cod_ret = 50000  
		 
	END CATCH
	
END 

INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','SCRIPT PASE A HISTORICO - Reenumerar - FINALIZADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, NULL, @cat_id    
GO

