USE emerix

IF OBJECT_ID( '[dbo].[emx_depuracion_inicial]') IS NOT NULL
    DROP PROCEDURE [dbo].[emx_depuracion_inicial]
GO

CREATE PROCEDURE [dbo].[emx_depuracion_inicial](
	@v_tiempo_depuracion int
)
AS

/************************************************/
/*                                              */
/*           SCRIPT DEPURACION                  */
/*                                              */
/************************************************/

declare	@v_fec_proceso DATETIME   
declare @v_minutos_depuracion int
DECLARE @v_base_depuracion VARCHAR(255)  
declare @CobCommit int
declare @CsaCommit int
declare @CctCommit int
declare @CtfCommit int

/*-----------------------------------------------------------------------*/
/*                              PARAMETRIZACION SCRIPT                   */
/*-----------------------------------------------------------------------*/

--> COLOCAR EL TIEMPO DE DEPURACION EN MINUTOS
SET @v_minutos_depuracion = @v_tiempo_depuracion

--> NOMBRE DE LA BASE HISTORICA
SET @v_base_depuracion = 'emerix_hist'

SET @CobCommit ='5000'						 ------------------->>>>Commit bitacora objetos
SET @CsaCommit ='5000'						 ------------------->>>>Commit bitacora saldos
SET @CctCommit ='5000'						 ------------------->>>>Commit bitacora cuentas
SET @CtfCommit ='5000'						 ------------------->>>>Commit bitacora per_tel

/*-----------------------------------------------------------------------*/
/*                          FIN PARAMETRIZACION SCRIPT                   */
/*-----------------------------------------------------------------------*/

SET NOCOUNT ON  

UPDATE wf_parametros SET PRT_VALOR=@v_base_depuracion WHERE prt_nombre_corto='BaseDepur' AND prt_baja_fecha IS NULL

UPDATE wf_parametros SET prt_valor= @CobCommit where prt_baja_fecha is null and prt_nombre_corto='CobCommit'
UPDATE wf_parametros SET prt_valor= @CsaCommit where prt_baja_fecha is null and prt_nombre_corto='CsaCommit'
UPDATE wf_parametros SET prt_valor= @CctCommit where prt_baja_fecha is null and prt_nombre_corto='CctCommit'
UPDATE wf_parametros SET prt_valor= @CtfCommit where prt_baja_fecha is null and prt_nombre_corto='CtfCommit'

DECLARE @inicio_proceso DATETIME
SET @inicio_proceso = GETDATE()

SET @v_fec_proceso = CONVERT(DATETIME,CONVERT(VARCHAR,GETDATE(),112))
SET @v_base_depuracion = ISNULL((SELECT prt_valor from wf_parametros where prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null) , '')

DECLARE @total_reg   INT  
declare @v_usu_id    INT  
DECLARE @prc_nombre_corto varchar(10) 
declare @cat_id        INT  
declare @v_cod_ret     INT 
DECLARE @total_ejecutados INT  
DECLARE @total_err   INT  

DECLARE @v_accion   VARCHAR(1)    
DECLARE @v_sql nvarchar(2000) 
DECLARE @error_msg nvarchar(4000)
DECLARE @contador_vueltas int

 
SET @prc_nombre_corto='PD-SCR'  
SET @cat_id =0
SET @v_cod_ret=0 

SET @v_sql = ''
SET @error_msg = ''
SET @contador_vueltas = 0
  
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
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'I', 'SCRIPT PASE A HISTORICO - SCRIPT - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', 'PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id    
		SELECT @v_cod_ret = -1000    
		RETURN    
	END    
END    


SET @CobCommit = ISNULL((SELECT prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CboCommit'),0)
SET @CsaCommit = ISNULL((SELECT prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CsaCommit'),0)
SET @CctCommit = ISNULL((SELECT prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CctCommit'),0)
SET @CtfCommit = ISNULL((SELECT prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CtfCommit'),0)

DECLARE @tablas_a_depurar TABLE (orden_depuracion int,
								 tabla varchar(50),
								 PK_tabla varchar(10),
								 par_commit int,
								 cant_reg int, 
								 query_cant_reg nvarchar(4000), 
								 query_depuracion nvarchar(4000),
								 accion nvarchar(1))


/* Solo Eliminar -> Utilizar accion = 'E' */
/*
	Tabla wf_cmb_objetos 
	-- Eliminar los que corresponden a la estrategia anterior (Cambio hecho el día: '20190328')
	-- SELECT COUNT(*) FROM wf_cmb_objetos WHERE cob_cambio_fecha BETWEEN '19000101' AND '20190327'
*/
INSERT INTO @tablas_a_depurar VALUES(1, 'wf_cmb_objetos', 'cob_id',@CobCommit,1,
'SELECT @total_reg = COUNT(*) FROM wf_cmb_objetos WHERE cob_cambio_fecha BETWEEN ''19000101'' AND ''20190327''',
'INSERT INTO tmp_borrar SELECT TOP (@v_commit) ''wf_cmb_objetos'', cob_id FROM wf_cmb_objetos WHERE cob_cambio_fecha BETWEEN ''19000101'' AND ''20190327''',
'E')

--/*
--	Tabla cmb_cuentas 
--	-- Eliminar registros cuyo dato anterior y dato nuevo es 0 (Sin definir)
--	-- SELECT COUNT(*) FROM cmb_cta c1 WHERE c1.cct_dato_nue = 0 AND c1.cct_dato_ant = 0
--*/
--INSERT INTO @tablas_a_depurar VALUES(5, 'cmb_cta', 'cct_id',@CctCommit,1,
--'SELECT @total_reg = COUNT(*) FROM cmb_cta c1 WHERE c1.cct_dato_nue = 0 AND c1.cct_dato_ant = 0',
--'INSERT INTO tmp_borrar SELECT TOP (@v_commit) ''cmb_cta'', cct_id FROM cmb_cta c1 WHERE c1.cct_dato_nue = 0 AND c1.cct_dato_ant = 0',
--'E')

/* ---------------------------------------------------------------------------------------------------------------------------------------------------------- */

/*
	Tabla wf_cmb_objetos 
	-- Dejar los últimos 30 días
*/
--INSERT INTO @tablas_a_depurar VALUES(2, 'wf_cmb_objetos', 'cob_id',@CobCommit,1,
--'SELECT @total_reg = COUNT(*) FROM wf_cmb_objetos WHERE cob_cambio_fecha between ''20190328'' and DATEADD(DAY,-91, GETDATE())',
--'INSERT INTO tmp_borrar SELECT TOP (@v_commit) ''wf_cmb_objetos'', cob_id FROM wf_cmb_objetos WHERE cob_cambio_fecha between ''20190328'' and DATEADD(DAY,-91, GETDATE())',
--'D')

--/*
--	Tabla cmb_saldos
--	-- Dejar solo el último saldo
--	Query más performante: SELECT count(*) FROM cmb_saldos s1 WHERE s1.csa_id < (Select max(s2.csa_id) from cmb_Saldos s2 where s1.csa_cta = s2.csa_cta)
--*/
--INSERT INTO @tablas_a_depurar VALUES(3, 'cmb_saldos', 'csa_id',@CsaCommit,1,
--'SELECT @total_reg = COUNT(*) FROM cmb_saldos s1 WHERE s1.csa_id < (Select max(s2.csa_id) from cmb_Saldos s2 where s1.csa_cta = s2.csa_cta)',
--'INSERT INTO tmp_borrar SELECT TOP (@v_commit) ''cmb_saldos'', s1.csa_id FROM cmb_saldos s1 WHERE s1.csa_id < (Select max(s2.csa_id) from cmb_Saldos s2 where s1.csa_cta = s2.csa_cta)',
--'D')

--/*
--	Tabla cmb_cuentas
--	- Dejar los últimos 365 días
--*/
--INSERT INTO @tablas_a_depurar VALUES(6, 'cmb_cta', 'cct_id',@CctCommit,1,
--'SELECT @total_reg = COUNT(*) FROM cmb_cta WHERE cct_cambio_fecha between ''19000101'' and DATEADD(DAY,-366, GETDATE())',
--'INSERT INTO tmp_borrar SELECT TOP (@v_commit) ''cmb_cta'', cct_id FROM cmb_cta WHERE cct_cambio_fecha between ''19000101'' and DATEADD(DAY,-365, GETDATE())',
--'D')

/*
	Tabla cmb_per_tel
	- Dejar los últimos 90 días online
*/
--INSERT INTO @tablas_a_depurar VALUES(4, 'cmb_pte', 'ctf_id',@CtfCommit,1,
--'SELECT @total_reg = COUNT(*) FROM cmb_pte WHERE ctf_cambio_fecha between ''19000110'' and DATEADD(DAY,-91, GETDATE())',
--'INSERT INTO tmp_borrar SELECT top (@v_commit) ''cmb_pte'', ctf_id FROM cmb_pte WHERE ctf_cambio_fecha between ''19000101'' and DATEADD(DAY,-91, GETDATE())',
--'D')


INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'I', 'SCRIPT PASE A HISTORICO - SCRIPT - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    


IF ISNULL((SELECT RTRIM(prt_valor) FROM wf_parametros WHERE prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null) , '')=''
BEGIN
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'E', 'NO hay base historica parametrizada ' , @v_usu_id, Null, @cat_id    
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'F', 'SCRIPT PASE A HISTORICO - SCRIPT - FINALIZADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    

	PRINT 'ERROR - NO hay base historica parametrizada '
	SELECT @v_cod_ret = -2000    
	RETURN    
END	

BEGIN TRY
	DECLARE @cons NVARCHAR (200)

	SET @cons = N'select top 1 1 from ' + rtrim(@v_base_depuracion) + '.dbo.cuentas'  
	EXEC sp_executesql @cons  
	
END TRY
BEGIN CATCH
	PRINT 'ERROR - La Base historica ' + @v_base_depuracion+ ' no existe, o no hay acceso'
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'E', 'La Base historica ' + @v_base_depuracion+ ' no existe, o no hay acceso' , @v_usu_id, Null, @cat_id    
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'F', 'SCRIPT PASE A HISTORICO - SCRIPT - FINALIZADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
	SELECT @v_cod_ret = -2000    
	RETURN
END CATCH



/* Si hay cursor, lo destruyo */
IF (SELECT CURSOR_STATUS('global', '#cur_tablas_depurar')) = 1 CLOSE #cur_tablas_depurar
IF (SELECT CURSOR_STATUS('global', '#cur_tablas_depurar')) = -1 DEALLOCATE #cur_tablas_depurar

declare @cur_tabla varchar(50)
declare @cur_query_cant_reg nvarchar(4000)

declare #cur_tablas_depurar cursor for
select tabla, query_cant_reg, accion from @tablas_a_depurar

open #cur_tablas_depurar
Fetch #cur_tablas_depurar into @cur_tabla, @cur_query_cant_reg, @v_accion

while @@fetch_status = 0
begin

	exec sp_executesql @cur_query_cant_reg, N'@total_reg int out',  @total_reg out  

	update @tablas_a_depurar 
		set cant_reg = ISNULL(@total_reg,0)
		where tabla = @cur_tabla and accion = @v_accion

	IF @v_accion = 'D'  -- Depurar
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', 'Tabla '+ @cur_tabla +' cantidad de registros a depurar: '+ convert(varchar,ISNULL(@total_reg,0)), @v_usu_id, Null, @cat_id    
	ELSE IF @v_accion = 'E' -- Eliminar
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', 'Tabla '+ @cur_tabla +' cantidad de registros a eliminar: '+ convert(varchar,ISNULL(@total_reg,0)), @v_usu_id, Null, @cat_id    
		
	PRINT 'Tabla '+ @cur_tabla +' cantidad de registros a depurar: ' + convert(varchar,ISNULL(@total_reg, 0))
	
	Fetch #cur_tablas_depurar into @cur_tabla, @cur_query_cant_reg, @v_accion
end

-- PRINT ' '
INSERT wf_print_out SELECT @prc_nombre_corto, GETDATE(), @v_fec_proceso, 'A', '', @v_usu_id, Null, @cat_id    

close #cur_tablas_depurar
deallocate #cur_tablas_depurar


BEGIN  
	--SET @v_accion = 'D' -- 'D' Depurar
    
	SET @total_ejecutados  = 0  
	SET @total_err = 0  
	SET @v_cod_ret = 0  

	
	--Parametros Generales  
	declare @v_commit int
	declare @v_tabla varchar(50)
	declare @v_tabla_anterior varchar(50)
	declare @v_cant_reg int
	declare @v_PK_tabla varchar(10)
	declare @v_query_depuracion nvarchar(4000)
	declare @v_accion_anterior varchar(1) = ''

   BEGIN TRY 
		WHILE 1 = 1  
		BEGIN  
  			
			SET @v_commit=0
			SET @v_tabla=''
			SET @v_PK_tabla=''
			SET @v_query_depuracion= '' 
			SET @v_cant_reg=0
			SET @v_accion='D'

			/*Vacio La tabla temporal donde se guardan los id de la tabla a borrar y de sus hijos*/
			TRUNCATE TABLE tmp_borrar  

			/*selecciono un top de los registros de la tabla a depurar*/
			SELECT TOP 1	@v_commit = par_commit,
							@v_tabla = tabla,
							@v_PK_tabla = PK_tabla,
							@v_query_depuracion = query_depuracion, 
							@v_cant_reg = cant_reg,
							@v_accion = accion
			FROM @tablas_a_depurar WHERE ISNULL(cant_reg, 0) > 0 ORDER BY orden_depuracion
			PRINT @v_commit
			PRINT @v_tabla
			PRINT @v_pk_tabla
			PRINT @v_query_depuracion
			PRINT @v_cant_reg
			PRINT @v_accion


			/*si la tabla esta vacia no hay tabla a depurar fin del proceso*/
			IF ISNULL(@v_tabla, '')=''
			BEGIN 
				IF ISNULL(@v_tabla_anterior, '') <> '' 
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'F', 'PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				ELSE
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'F', 'PROCESO PASE A HISTORICO - NO HAY REGISTROS QUE DEPURAR - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				BREAK
			END


			/*LOGUEO*/
			IF ISNULL(@v_tabla_anterior, '') <> ISNULL(@v_tabla, '') or
				ISNULL(@v_accion_anterior, 'D')  <> ISNULL(@v_accion, 'D')  
			BEGIN 					
				IF ISNULL(@v_tabla_anterior, '') <> '' and ISNULL(@v_tabla_anterior, '') <> ISNULL(@v_tabla, '')
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'F', 'PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  

				SET @v_tabla_anterior = @v_tabla
				SET @v_accion_anterior = @v_accion_anterior
				SET @contador_vueltas = 0

				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'I', 'PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla) +' - INICIADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', 'Fecha Proceso: ' + CONVERT(CHAR(20),@v_fec_proceso,113), @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', '', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', 'Cantidad Total de registros de '+ lower(@v_tabla) +' a Depurar: '+ convert(varchar,@v_cant_reg), @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', 'Cantidad de registros de '+ lower(@v_tabla) +' por iteracion: '+ convert(varchar,@v_commit), @v_usu_id, Null,@cat_id 
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', '', @v_usu_id, Null,@cat_id
			END

			/*ejecuto la condicion de depuracion*/
			IF ISNULL(@v_tabla, '') <> ''
				EXEC SP_EXECUTESQL @v_query_depuracion, N'@v_commit int',  @v_commit  
			 
			
			/*si no hay mas registros a depurar salgo del bucle y finaliza el proceso*/  
			IF (SELECT COUNT(*) FROM tmp_borrar) = 0
			BEGIN
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'F', 'PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				BREAK  
			END
			
			/*inicio una transaccion*/  
			BEGIN TRAN   
  		
				/*si es depuracion copia a la base historica los registros seleccionados y los borra de la base activa*/
    			
				IF @v_accion = 'D'  
				BEGIN  
					SET @contador_vueltas = @contador_vueltas + 1
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', @v_tabla +'----------------------------------------------------------Iteracion N°: '+ convert(varchar,@contador_vueltas) +'------------------------------------------------------------------', @v_usu_id, Null,@cat_id  


					SET @v_sql = N'INSERT ' + rtrim(@v_base_depuracion) + '.dbo.'+ @v_tabla +' SELECT * FROM ' + @v_tabla + ' WHERE EXISTS(SELECT TOP 1 1 FROM tmp_borrar WHERE ' + @v_PK_tabla + ' = id AND tabla = '''+@v_tabla+''')'  
					--PRINT @v_sql  
					EXEC sp_executesql @v_sql  

				 
					SET @v_sql = N'DELETE '+ @v_tabla +' FROM '+ @v_tabla +' INNER JOIN tmp_borrar ON '+ @v_PK_tabla +' = id and tabla = '''+@v_tabla+'''' 
					--PRINT @v_sql 
					EXEC sp_executesql @v_sql  					 					


					/* Decremento el nro de registros a depurar */
					UPDATE @tablas_a_depurar
						SET cant_reg = cant_reg - (SELECT COUNT(*) FROM tmp_borrar WHERE tabla = @v_tabla)
						WHERE tabla= @v_tabla and accion = @v_accion
				END  
				else IF @v_accion = 'E'  
				BEGIN  
					SET @contador_vueltas = @contador_vueltas + 1
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', @v_tabla +'----------------------------------------------------------Iteracion N°: '+ convert(varchar,@contador_vueltas) +'------------------------------------------------------------------', @v_usu_id, Null,@cat_id  


					SET @v_sql = N'DELETE '+ @v_tabla +' FROM '+ @v_tabla +' INNER JOIN tmp_borrar ON '+ @v_PK_tabla +' = id and tabla = '''+@v_tabla+'''' 
					--PRINT @v_sql 
					EXEC sp_executesql @v_sql  					 					


					/* Decremento el nro de registros a depurar */
					UPDATE @tablas_a_depurar
						SET cant_reg = cant_reg - (SELECT COUNT(*) FROM tmp_borrar WHERE tabla = @v_tabla)
						WHERE tabla = @v_tabla and accion = @v_accion
				END  
				else IF @v_accion = 'C'  
				BEGIN  
					/* 
						TODO: Falta adaptar para que vaya tomando bien. Como no mueve, no quedan menos registros. 
						Hay que agregar: where id > id_control.
						* Hacerlo genérico hace necesario reprobar todo
						* Hacerlo específico hace que cumpla menos su función
					*/
					SET @contador_vueltas = @contador_vueltas + 1
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', @v_tabla +'----------------------------------------------------------Iteracion N°: '+ convert(varchar,@contador_vueltas) +'------------------------------------------------------------------', @v_usu_id, Null,@cat_id  

					SET @v_sql = N'INSERT ' + rtrim(@v_base_depuracion) + '.dbo.'+ @v_tabla +' SELECT * FROM ' + @v_tabla + ' WHERE EXISTS(SELECT TOP 1 1 FROM tmp_borrar WHERE ' + @v_PK_tabla + ' = id AND tabla = '''+@v_tabla+''')'  
					--PRINT @v_sql  
					EXEC sp_executesql @v_sql  

					/* Decremento el nro de registros a depurar */
					UPDATE @tablas_a_depurar
						SET cant_reg = cant_reg - (SELECT COUNT(*) FROM tmp_borrar WHERE tabla = @v_tabla)
						WHERE tabla= @v_tabla and accion = @v_accion
				END  		

			/* Confirmo todo */
			COMMIT TRAN   
			
			/* Si se agoto el tiempo de depuracion salgo del bucle */
			IF DATEDIFF(n,@inicio_proceso,getdate()) > @v_minutos_depuracion
			BEGIN
				
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', '', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', 'Se agoto el tiempo de depuración ', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', '', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', ' Quedan registros por depurar en esta tabla'  , @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'A', '', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'F', 'PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  

				PRINT ''
				PRINT 'SE agotó el tiempo de depuración'
				PRINT ''
				PRINT 'Quedan registros por depurar en tabla ' + @v_tabla

				BREAK
			END
		
		--BREAK			 
		/*itero*/	   
		END  
		
		SET @v_cod_ret =0
		PRINT ''
		PRINT 'El script de depuracion ha finalizado'
	END TRY
	BEGIN CATCH
		/* Si hay error en el proceso o en el chequeo de dependencias, hago rollback de lo no confirmado */
		IF @@TRANCOUNT >0		
			ROLLBACK TRAN
		
		SET @error_msg= ERROR_MESSAGE()

		SELECT @total_err = @total_reg - @total_ejecutados  
		
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'E','SCRIPT PASE A HISTORICO - SCRIPT - ERROR', @v_usu_id, error_number(),@cat_id  
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'E',convert(varchar(255),@error_msg), @v_usu_id, error_number(),@cat_id  
		
		SET @v_cod_ret = 50000  
		 
	END CATCH
	
END 

INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso, 'F', 'SCRIPT PASE A HISTORICO - SCRIPT - FINALIZADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, NULL, @cat_id    
GO

