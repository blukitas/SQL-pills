

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'BaseDepur')
begin
	update wf_parametros set
	prt_valor='emt_bgp_desa_hist',
	prt_baja_fecha=null
	where prt_nombre_corto = 'BaseDepur'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Base Depuración','BaseDepur','Depuracion','emt_bgp_desa_hist','S','N','Base Depuración','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end
go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CtaCommit')
begin
	update wf_parametros set
	prt_valor='20000',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CtaCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Cuentas - Cant. Reg. p/Transaccion','CtaCommit','Depuracion','20000','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CtaMeses')
begin
	update wf_parametros set
	prt_valor='12',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CtaMeses'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Cuentas - Cant. de Meses a depurar','CtaMeses','Depuracion','12','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end


go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'AccCommit')
begin
	update wf_parametros set
	prt_valor='100000',
	prt_baja_fecha=null
	where prt_nombre_corto = 'AccCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Acciones - Cant. Reg. p/Transaccion','AccCommit','Depuracion','100000','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go
if exists (select 1 from  wf_parametros where prt_nombre_corto = 'AccMeses')
begin
	update wf_parametros set
	prt_valor='24',
	prt_baja_fecha=null
	where prt_nombre_corto = 'AccMeses'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Acciones - Cant. de Meses a depurar','AccMeses','Depuracion','24','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go
if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CctCommit')
begin
	update wf_parametros set
	prt_valor='100000',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CctCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora Cta - Cant. Reg. p/Transaccion','CctCommit','Depuracion','100000','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go
if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CctMeses')
begin
	update wf_parametros set
	prt_valor='24',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CctMeses'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora Cta - Cant. de Meses a depurar','CctMeses','Depuracion','24','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go
if exists (select 1 from  wf_parametros where prt_nombre_corto = 'ObjCommit')
begin
	update wf_parametros set
	prt_valor='100000',
	prt_baja_fecha=null
	where prt_nombre_corto = 'ObjCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora Obj - Cant. Reg. p/Transaccion','ObjCommit','Depuracion','100000','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go
if exists (select 1 from  wf_parametros where prt_nombre_corto = 'ObjMeses')
begin
	update wf_parametros set
	prt_valor='24',
	prt_baja_fecha=null
	where prt_nombre_corto = 'ObjMeses'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Bitacora Obj - Cant. de Meses a depurar','ObjMeses','Depuracion','24','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end


go
if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CmaCommit')
begin
	update wf_parametros set
	prt_valor='100',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CmaCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Cargas Msv - Cant. Reg. p/Transaccion','CmaCommit','Depuracion','100','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go
if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CmaMeses')
begin
	update wf_parametros set
	prt_valor='12',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CmaMeses'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Cargas Msv - Cant. de Meses a depurar','CmaMeses','Depuracion','12','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go



if exists (select 1 from  wf_parametros where prt_nombre_corto = 'MovCommit')
begin
	update wf_parametros set
	prt_valor='50000',
	prt_baja_fecha=null
	where prt_nombre_corto = 'MovCommit'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Movimientos - Cant. Reg. p/Transaccion','MovCommit','Depuracion','50000','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go

if exists (select 1 from  wf_parametros where prt_nombre_corto = 'MovMeses')
begin
	update wf_parametros set
	prt_valor='24',
	prt_baja_fecha=null
	where prt_nombre_corto = 'MovMeses'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Movimientos - Cant. de Meses a depurar','MovMeses','Depuracion','24','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go



if exists (select 1 from  wf_parametros where prt_nombre_corto = 'CarJuiAct')
begin
	update wf_parametros set
	prt_valor='EMP01,PATRI',
	prt_baja_fecha=null
	where prt_nombre_corto = 'CarJuiAct'
end
else
begin

	declare @prt_id int
	select @prt_id= MAX(prt_id)+1 from wf_parametros
	
	insert into wf_parametros values (@prt_id,'Carteras juicio activo','CarJuiAct','Depuracion','EMP01,PATRI','S','N','Pase a Historico','','20181122',null,null,1,'')

	update id_numeracion set idn_ultimo_id=(select MAX(prt_id) from wf_parametros) where idn_tabla='wf_parametros'
end

go



