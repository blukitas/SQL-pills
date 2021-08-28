USE emt_supervielle_desa_prueba
GO

IF EXISTS (SELECT 1 FROM tablas_depurar_SPV WHERE  atd_tabla='wf_cmb_objetos'  )
BEGIN
	UPDATE tablas_depurar_SPV set 
		atd_SP='wf_p_pase_historico_cob_SPV',
		atd_orden = 1,
		atd_baja_fecha = null,
		atd_periodicidad = 7,
		atd_ultima_ejecucion = '19010101'
	WHERE  atd_tabla='wf_cmb_objetos'
END
ELSE
BEGIN
	INSERT INTO tablas_depurar_SPV VALUES('wf_cmb_objetos', 'wf_p_pase_historico_cob_SPV', 1, '19010101', 7, '', '20190626', null, null, 1, '')
END


IF EXISTS (SELECT 1 FROM tablas_depurar_SPV WHERE  atd_tabla='cmb_saldos'  )
BEGIN
	UPDATE tablas_depurar_SPV set 
		atd_SP = 'wf_p_pase_historico_csa_SPV',
		atd_orden = 2,
		atd_baja_fecha = null,
		atd_periodicidad = 28,
		atd_ultima_ejecucion = '19010101'
	WHERE  atd_tabla='cmb_saldos'
END
ELSE
BEGIN
	INSERT INTO tablas_depurar_SPV VALUES('cmb_saldos', 'wf_p_pase_historico_csa_SPV', 2, '19010101', 28, '', '20190626', null, null, 1, '')
END


IF EXISTS (SELECT 1 FROM tablas_depurar_SPV WHERE  atd_tabla='cmb_cta'  )
BEGIN
	UPDATE tablas_depurar_SPV set 
		atd_SP = 'wf_p_pase_historico_cct_SPV',
		atd_orden = 3,
		atd_baja_fecha = null,
		atd_periodicidad = 7,
		atd_ultima_ejecucion = '19010101'
	WHERE  atd_tabla='cmb_cta'
END
ELSE
BEGIN
	INSERT INTO tablas_depurar_SPV VALUES('cmb_cta', 'wf_p_pase_historico_cct_SPV', 3, '19010101', 7, '', '20190626', null, null, 1, '')
END

IF EXISTS (SELECT 1 FROM tablas_depurar_SPV WHERE  atd_tabla='cmb_pte'  )
BEGIN
	UPDATE tablas_depurar_SPV set 
		atd_SP = 'wf_p_pase_historico_ctf_SPV',
		atd_orden = 4,
		atd_baja_fecha = null,
		atd_periodicidad = 7,
		atd_ultima_ejecucion = '19010101'
	WHERE  atd_tabla='cmb_pte'
END
ELSE
BEGIN
	INSERT INTO tablas_depurar_SPV VALUES('cmb_pte', 'wf_p_pase_historico_ctf_SPV', 4, '19010101', 7, '', '20190626', null, null, 1, '')
END