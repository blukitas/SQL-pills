/************************************************/
/*                                              */
/*           SCRIPT DEPURACION                  */
/*                                              */
/************************************************/
declare	@v_fec_proceso DATETIME   
declare @v_minutos_depuracion int
DECLARE @v_base_depuracion VARCHAR(255)  
declare @CtaCommit int
declare @AccCommit int
declare @MovCommit int
declare @CctCommit int
declare @ObjCommit int
declare @CmaCommit int
declare @carteras_juicio_activo varchar(255)

/*-----------------------------------------------------------------------*/
/*                              PARAMETRIZACION SCRIPT                   */


set @v_minutos_depuracion = 5  --------------------------------->>>>COLOCAR EL TIEMPO DE DEPURACION EN MINUTOS

SET @v_base_depuracion = 'emt_bgp_desa_hist' ------------------->>>>NOMBRE DE LA BASE HISTORICA

set @CtaCommit ='20000'						 ------------------->>>>Commit cuentas
set @AccCommit ='100000'					 ------------------->>>>Commit acciones
set @MovCommit ='50000'						 ------------------->>>>Commit movimientos
set @CctCommit ='100000'					 ------------------->>>>Commit bitacora cuentas
set @ObjCommit ='100000'					 ------------------->>>>Commit bitacora objetos
set @CmaCommit ='100'						 ------------------->>>>Commit cargas masivas

set @carteras_juicio_activo='EMP01,PATRI'    ------------------->>>>Carteras de Juicio Activo para acciones


/*                          FIN PARAMETRIZACION SCRIPT                   */
/*-----------------------------------------------------------------------*/

SET NOCOUNT ON  

UPDATE wf_parametros SET PRT_VALOR=@v_base_depuracion WHERE prt_nombre_corto='BaseDepur' AND prt_baja_fecha IS NULL

UPDATE wf_parametros SET prt_valor= @CtaCommit where prt_baja_fecha is null and prt_nombre_corto='CtaCommit'
UPDATE wf_parametros SET prt_valor= @AccCommit where prt_baja_fecha is null and prt_nombre_corto='AccCommit'
UPDATE wf_parametros SET prt_valor= @MovCommit where prt_baja_fecha is null and prt_nombre_corto='MovCommit'
UPDATE wf_parametros SET prt_valor= @CctCommit where prt_baja_fecha is null and prt_nombre_corto='CctCommit'
UPDATE wf_parametros SET prt_valor= @ObjCommit where prt_baja_fecha is null and prt_nombre_corto='ObjCommit'
UPDATE wf_parametros SET prt_valor= @CmaCommit where prt_baja_fecha is null and prt_nombre_corto='CmaCommit'

UPDATE wf_parametros SET prt_valor= @carteras_juicio_activo where prt_baja_fecha is null and prt_nombre_corto='CarJuiAct'


declare @inicio_proceso datetime
set @inicio_proceso =getdate()

set @v_fec_proceso = convert(datetime,convert(varchar,getdate(),112))

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
set @cat_id =0
set @v_cod_ret=0 

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
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','SCRIPT PASE A HISTORICO - SCRIPT - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
		INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','PROCESO ABORTADO - No existe fecha de proceso ' + CONVERT(CHAR(20),GETDATE(),113), @v_usu_id, Null, @cat_id    
		SELECT @v_cod_ret = -1000    
		RETURN    
	END    
END    



set @CtaCommit = isnull((select prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CtaCommit'),0)
set @AccCommit = isnull((select prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='AccCommit'),0)
set @MovCommit = isnull((select prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='MovCommit'),0)
set @CctCommit = isnull((select prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CctCommit'),0)
set @ObjCommit = isnull((select prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='ObjCommit'),0)
set @CmaCommit = isnull((select prt_valor from wf_parametros where prt_baja_fecha is null and prt_nombre_corto='CmaCommit'),0)

declare @tablas_a_depurar table (orden_depuracion int,tabla varchar(50),PK_tabla varchar(10),par_commit int,cant_reg int, query_cant_reg nvarchar(4000), query_depuracion nvarchar(4000))

/*Tabla Movimientos*/
insert into @tablas_a_depurar values(1, 'Movimientos','mov_id',@MovCommit,0,
'SELECT @total_reg = COUNT(*) FROM movimientos 	WHERE mov_fec_contab between ''19000101'' and ''20161231''',
'INSERT INTO tmp_borrar SELECT TOP (@v_commit) ''movimientos'', mov_id FROM movimientos WHERE mov_fec_contab between ''19000101'' and ''20161231''')

/*Tabla cmb_cta*/
insert into @tablas_a_depurar values(2, 'cmb_cta','cct_id',@CctCommit,0,
'SELECT @total_reg = COUNT(*) FROM cmb_cta WHERE cct_alta_fecha between ''19000101'' and ''20161231''',
'INSERT INTO tmp_borrar SELECT TOP (@v_commit) ''cmb_cta'', cct_id FROM cmb_cta WHERE cct_alta_fecha between ''19000101'' and ''20161231''')

/*carga_masiva_arch*/
insert into @tablas_a_depurar values(3, 'carga_masiva_arch','acm_id',@CmaCommit,0,
'SELECT @total_reg = COUNT(*) FROM carga_masiva_arch WHERE acm_esa in (3,4) and acm_alta_fecha between ''19000101'' and ''20171231''',
'INSERT INTO tmp_borrar SELECT top (@v_commit) ''carga_masiva_arch'', acm_id FROM carga_masiva_arch WHERE acm_esa in (3,4) and acm_alta_fecha between ''19000101'' and ''20171231''')

/*wf_cmb_objetos*/
insert into @tablas_a_depurar values(4, 'wf_cmb_objetos','cob_id',@ObjCommit,0,
'SELECT @total_reg = COUNT(*) FROM wf_cmb_objetos WHERE cob_alta_fecha between ''19000101'' and ''20161231''',
'INSERT INTO tmp_borrar SELECT top (@v_commit) ''wf_cmb_objetos'', cob_id FROM wf_cmb_objetos WHERE cob_alta_fecha between ''19000101'' and ''20161231''')

/*acciones*/
insert into @tablas_a_depurar values(5, 'acciones','acc_id',@AccCommit,0,
'SELECT @total_reg = COUNT(*) from acciones where  not exists (select 1 from #tbl_juicio_activo where cta_id=acc_cta) and not exists (select 1 from #tbl_juicio_activo where cta_per=acc_per ) and acc_alta_fecha between ''19000101'' and ''20161231''',
'INSERT INTO tmp_borrar SELECT top (@v_commit) ''acciones'', acc_id FROM acciones where  not exists (select 1 from #tbl_juicio_activo where cta_id=acc_cta) and not exists (select 1 from #tbl_juicio_activo where cta_per=acc_per ) and acc_alta_fecha between ''19000101'' and ''20161231''')

/*cuentas*/
insert into @tablas_a_depurar values(6, 'cuentas','cta_id',@CtaCommit,0,
'SELECT @total_reg = COUNT(*) from cuentas where cta_baja_fecha is not null and cta_baja_fecha between ''19000101'' and ''20171231''',
'INSERT INTO tmp_borrar SELECT top (@v_commit) ''cuentas'', cta_id FROM cuentas where cta_baja_fecha is not null and cta_baja_fecha between ''19000101'' and ''20171231''')



/*Tabla temporal para gusrdar cuentas en carteras de juicio activo para depuracion de acciones*/
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




INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','SCRIPT PASE A HISTORICO - SCRIPT - INICIADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    


if isnull((select rtrim(prt_valor) from wf_parametros where prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null) ,'')=''
begin
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E','NO hay base historica parametrizada ' , @v_usu_id, Null, @cat_id    
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','SCRIPT PASE A HISTORICO - SCRIPT - FINALIZADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    

	print 'ERROR - NO hay base historica parametrizada '
	SELECT @v_cod_ret = -2000    
	RETURN    
end	

begin try
	declare @cons nvarchar (200)

	set @cons = N'select top 1 1 from ' + rtrim(@v_base_depuracion) + '.dbo.cuentas'  
	EXEC sp_executesql @cons  
	
end try
begin catch
	print 'ERROR - La Base historica ' + @v_base_depuracion+ ' no existe, o no hay acceso'
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E','La Base historica ' + @v_base_depuracion+ ' no existe, o no hay acceso' , @v_usu_id, Null, @cat_id    
	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','SCRIPT PASE A HISTORICO - SCRIPT - FINALIZADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    
	SELECT @v_cod_ret = -2000    
	RETURN
end catch



/*si hay cursor lo destruyo*/
IF (SELECT CURSOR_STATUS('global','#cur_tablas_depurar')) = 1 CLOSE #cur_tablas_depurar
IF (SELECT CURSOR_STATUS('global','#cur_tablas_depurar')) = -1 DEALLOCATE #cur_tablas_depurar

declare @cur_tabla varchar(50)
declare @cur_query_cant_reg nvarchar(4000)

declare #cur_tablas_depurar cursor for
select tabla,query_cant_reg from @tablas_a_depurar

open #cur_tablas_depurar
Fetch #cur_tablas_depurar into @cur_tabla, @cur_query_cant_reg

while @@fetch_status = 0
begin

	exec sp_executesql @cur_query_cant_reg, N'@total_reg int out',  @total_reg out  

	update @tablas_a_depurar set
	cant_reg= isnull(@total_reg,0)
	where tabla=@cur_tabla

	INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Tabla '+@cur_tabla +' cantidad de registros a depurar: '+ convert(varchar,isnull(@total_reg,0)), @v_usu_id, Null, @cat_id    

	print 'Tabla '+@cur_tabla +' cantidad de registros a depurar: '+ convert(varchar,isnull(@total_reg,0))

	Fetch #cur_tablas_depurar into @cur_tabla, @cur_query_cant_reg
end

print ''
INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null, @cat_id    

close #cur_tablas_depurar
deallocate #cur_tablas_depurar


/*dependencias agregadas propias de la implementacion*/
if not exists(select 1 from tmp_dependencias_BGP where tabla_ori='prestamos' and tabla='add_prestamos')
	insert into tmp_dependencias_BGP values('prestamos','add_prestamos','apr_id')

if not exists(select 1 from tmp_dependencias_BGP where tabla_ori='prestamos_cuotas' and tabla='add_prestamos_cuotas')
	insert into tmp_dependencias_BGP values('prestamos_cuotas','add_prestamos_cuotas','apc_id')

if not exists(select 1 from tmp_dependencias_BGP where tabla_ori='tarjetas' and tabla='add_tarjetas')
	insert into tmp_dependencias_BGP values('tarjetas','add_tarjetas','ata_id')

if not exists(select 1 from tmp_dependencias_BGP where tabla_ori='carga_masiva_arch' and tabla='carga_masiva_arch_de')
	insert into tmp_dependencias_BGP values('carga_masiva_arch','carga_masiva_arch_de','dtu_arc')
  
BEGIN  
	

	SET @v_base_depuracion = isnull((select prt_valor from wf_parametros where prt_nombre_corto = 'BaseDepur' and prt_baja_fecha is null) ,'')
	SET @v_accion = 'D' -- 'D' Depurar
    
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
	 
	--select orden_depuracion ,tabla,cant_reg from @tablas_a_depurar order by orden_depuracion

   BEGIN TRY 
		WHILE 1 = 1  
		BEGIN  
  			
			set @v_commit=0
			set @v_tabla=''
			set @v_PK_tabla=''
			set @v_query_depuracion= '' 
			set @v_cant_reg=0

			/*Vacio La tabla temporal donde se guardan los id de la tabla a borrar y de sus hijos*/
			TRUNCATE TABLE tmp_borrar  

			/*selecciono un top de los registros de la tabla a depurar*/
			select top 1	@v_commit=par_commit,
							@v_tabla=tabla,
							@v_PK_tabla=PK_tabla,
							@v_query_depuracion= query_depuracion, 
							@v_cant_reg=cant_reg
							from @tablas_a_depurar where isnull(cant_reg,0) > 0 order by orden_depuracion
			

			/*si la tabla esta vacia no hay tabla a depurar fin del proceso*/
			if isnull(@v_tabla,'')=''
			begin 
				if isnull(@v_tabla_anterior,'') <> '' 
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				else
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - NO HAY REGISTROS QUE DEPURAR - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  

				break
			end


			/*logueo*/
			if isnull(@v_tabla_anterior,'') <> isnull(@v_tabla,'')
			begin 
					
					if isnull(@v_tabla_anterior,'') <> '' and isnull(@v_tabla_anterior,'') <> isnull(@v_tabla,'')
						INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  


					set @v_tabla_anterior=@v_tabla
					set @contador_vueltas =0

					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'I','PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla) +' - INICIADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Fecha Proceso: ' + CONVERT(CHAR(20),@v_fec_proceso,113), @v_usu_id, Null,@cat_id  
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad Total de registros de '+ lower(@v_tabla) +' a Depurar: '+ convert(varchar,@v_cant_reg), @v_usu_id, Null,@cat_id  
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','Cantidad de registros de '+ lower(@v_tabla) +' por iteracion: '+ convert(varchar,@v_commit), @v_usu_id, Null,@cat_id 
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id
			
			end

			/*ejecuto la condicion de depuracion*/
			if isnull(@v_tabla,'') <> ''
			exec sp_executesql @v_query_depuracion, N'@v_commit int',  @v_commit  
									 
  
			/*si no hay mas registros a depurar salgo del bucle y finaliza el proceso*/  
			IF (SELECT COUNT(*) FROM tmp_borrar) = 0
			begin
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  
				BREAK  
			end
			
			/*inicio una transaccion*/  
			BEGIN TRAN   
  		
				/*si es depuracion copia a la base historica los registros seleccionados y los borra de la base activa*/
    			if @v_accion = 'D'  
				BEGIN  

					set @contador_vueltas = @contador_vueltas + 1
					INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A', @v_tabla +'----------------------------------------------------------Iteracion N°: '+ convert(varchar,@contador_vueltas) +'------------------------------------------------------------------', @v_usu_id, Null,@cat_id  



					set @v_sql = N'INSERT ' + rtrim(@v_base_depuracion) + '.dbo.'+ @v_tabla +' SELECT * FROM ' + @v_tabla + ' WHERE EXISTS(SELECT TOP 1 1 FROM tmp_borrar WHERE ' + @v_PK_tabla + ' = id AND tabla = '''+@v_tabla+''')'  
					--PRINT @v_sql  
					EXEC sp_executesql @v_sql  

					/*CHEQUEO DEPENDENCIAS EN OTRAS TABLAS  (esto mueve los hijos al historico y los borra de la base activa)*/
					EXEC dbo.wf_p_chequear_dependencias_BGP @v_tabla, @v_accion, @prc_nombre_corto  

				 
					set @v_sql = N'DELETE '+ @v_tabla +' FROM '+ @v_tabla +' INNER JOIN tmp_borrar ON '+ @v_PK_tabla +' = id and tabla = '''+@v_tabla+'''' 
					--PRINT @v_sql 
					EXEC sp_executesql @v_sql  					 					

					/*decremento el nro de registros a depurar*/
					update @tablas_a_depurar set
					cant_reg = cant_reg - (SELECT COUNT(*) FROM tmp_borrar WHERE tabla = @v_tabla)
					where tabla= @v_tabla
				END  
					
			/*confirmo todo*/
			COMMIT TRAN   
			
			/*si se agoto el tiempo de depuracion salgo del bucle*/
			if DATEDIFF(n,@inicio_proceso,getdate()) > @v_minutos_depuracion
			begin
				
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','SE agoto el tiempo de depuracion ', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A',' Quedan registros por depurar en esta tabla'  , @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'A','', @v_usu_id, Null,@cat_id  
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','PROCESO PASE A HISTORICO - '+ UPPER(@v_tabla_anterior) +' - FINALIZADO ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null,@cat_id  

				Print ''
				Print 'SE agoto el tiempo de depuracion'
				Print ''
				print 'Quedan registros por depurar en tabla ' + @v_tabla

				BREAK
			end
		
		--BREAK			 
		/*itero*/	   
		END  
		
		SET @v_cod_ret =0
		Print ''
		print 'El script de depuracion ha finalizado'
	END TRY
	BEGIN CATCH
		/*si hay error en el proceso o en el chequeo de dependencias hago rollback de lo no confirmado*/
		if @@TRANCOUNT >0		
		ROLLBACK TRAN
		
		set @error_msg= ERROR_MESSAGE()

		SELECT @total_err = @total_reg - @total_ejecutados  
		
				INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'E',convert(varchar(255),@error_msg), @v_usu_id, error_number(),@cat_id  
		
		SET @v_cod_ret = 50000  
		 
	END CATCH
  
	
END 
INSERT wf_print_out SELECT @prc_nombre_corto,GETDATE(),@v_fec_proceso,'F','SCRIPT PASE A HISTORICO - SCRIPT - FINALIZADO. ' + CONVERT(CHAR(20),GETDATE(),113) , @v_usu_id, Null, @cat_id    




GO

