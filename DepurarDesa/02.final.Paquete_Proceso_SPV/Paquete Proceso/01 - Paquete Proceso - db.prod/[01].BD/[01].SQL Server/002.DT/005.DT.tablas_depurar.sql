Use emt_supervielle_desa
GO

if exists (select 1 from tablas_depurar_SPV where  atd_tabla='wf_cmb_objetos'  )
begin
	update tablas_depurar_SPV set 
		atd_SP='wf_p_pase_historico_cob_SPV',
		atd_orden = 1,
		atd_baja_fecha = null,
		atd_periodicidad = 7,
		atd_ultima_ejecucion = '19010101'
	where  atd_tabla='wf_cmb_objetos'
end
else
begin
	insert into tablas_depurar_SPV values('wf_cmb_objetos', 'wf_p_pase_historico_cob_SPV', 1, '19010101', 7, '', '20190722', null, null, 1, '')
end


if exists (select 1 from tablas_depurar_SPV where  atd_tabla='cmb_saldos'  )
begin
	update tablas_depurar_SPV set 
		atd_SP = 'wf_p_pase_historico_csa_SPV',
		atd_orden = 2,
		atd_baja_fecha = null,
		atd_periodicidad = 28,
		atd_ultima_ejecucion = '19010101'
	where  atd_tabla='cmb_saldos'
end
else
begin
	insert into tablas_depurar_SPV values('cmb_saldos', 'wf_p_pase_historico_csa_SPV', 2, '19010101', 28, '', '20190722', null, null, 1, '')
end


if exists (select 1 from tablas_depurar_SPV where  atd_tabla='cmb_cta'  )
begin
	update tablas_depurar_SPV set 
		atd_SP = 'wf_p_pase_historico_cct_SPV',
		atd_orden = 3,
		atd_baja_fecha = null,
		atd_periodicidad = 7,
		atd_ultima_ejecucion = '19010101'
	where  atd_tabla='cmb_cta'
end
else
begin
	insert into tablas_depurar_SPV values('cmb_cta', 'wf_p_pase_historico_cct_SPV', 3, '19010101', 7, '', '20190722', null, null, 1, '')
end

if exists (select 1 from tablas_depurar_SPV where  atd_tabla='cmb_pte'  )
begin
	update tablas_depurar_SPV set 
		atd_SP = 'wf_p_pase_historico_ctf_SPV',
		atd_orden = 4,
		atd_baja_fecha = null,
		atd_periodicidad = 7,
		atd_ultima_ejecucion = '19010101'
	where  atd_tabla='cmb_pte'
end
else
begin
	insert into tablas_depurar_SPV values('cmb_pte', 'wf_p_pase_historico_ctf_SPV', 4, '19010101', 7, '', '20190722', null, null, 1, '')
end