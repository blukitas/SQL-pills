if exists (select 1 from  wf_parametros where prt_nombre_corto = 'BaseDepur')
begin
	update wf_parametros set
	prt_valor='emerix_hist',
	prt_baja_fecha=null
	where prt_nombre_corto = 'BaseDepur'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Base Depuración','BaseDepur','Depuracion','emerix_hist','S','N','Base Depuración','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end
go


if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CboCommit')
begin
	update wf_parametros set
	prt_valor = '5000',
	prt_baja_fecha = null
	where prt_nombre_corto = 'CboCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitácora obj-Cant. Reg. p/Transaccion','CboCommit','Depuracion','5000','S','N','Pase a Historico','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CboDias')
begin
	update wf_parametros set
	prt_valor='30',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CboDias'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitácora obj-Cant. de Dias a depurar','CboDias','Depuracion','30','S','N','Pase a Historico','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end
go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CsaCommit')
begin
	update wf_parametros set
	prt_valor = '5000',
	prt_baja_fecha = null
	where prt_nombre_corto = 'CsaCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora saldos-Cant. Reg. p/Transaccion','CsaCommit','Depuracion','5000','S','N','Pase a Historico','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CsaCant')
begin
	update wf_parametros set
	prt_valor='1',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CsaCant'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora saldos-Cant. de Dias a depurar','CsaCant','Depuracion','1','S','N','Pase a Historico','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end
go


if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CctCommit')
begin
	update wf_parametros set
	prt_valor = '5000',
	prt_baja_fecha = null
	where prt_nombre_corto = 'CctCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora de cuentas-Cant. Reg. p/Transaccion','CctCommit','Depuracion','5000','S','N','Pase a Historico','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CctDias')
begin
	update wf_parametros set
	prt_valor='360',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CctDias'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora de cta-Cant. de Dias a depurar','CctDias','Depuracion','360','S','N','Pase a Historico','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end
go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CtfCommit')
begin
	update wf_parametros set
	prt_valor = '5000',
	prt_baja_fecha = null
	where prt_nombre_corto = 'CtfCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora per_tel-Cant. Reg. Transaccion','CtfCommit','Depuracion','5000','S','N','Pase a Historico','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CtfDias')
begin
	update wf_parametros set
	prt_valor='90',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CtfDias'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora per_tel-Cant. Dias a depurar','CtfDias','Depuracion','90','S','N','Pase a Historico','','20190730',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end
go
