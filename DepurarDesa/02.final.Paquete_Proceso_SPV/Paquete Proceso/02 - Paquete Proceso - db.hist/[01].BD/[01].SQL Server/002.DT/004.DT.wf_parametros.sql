Use emt_supervielle_desa_prueba
GO

IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'BaseDepur')
BEGIN
	UPDATE wf_parametros SET
	prt_valor='emt_supervielle_desa',
	prt_baja_fecha=null
	WHERE prt_nombre_corto = 'BaseDepur'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros

	INSERT INTO wf_parametros VALUES (ISNULL(@prt_id, 1),'Base Depuración','BaseDepur','Depuracion','emt_supervielle_desa_prueba','S','N','Base Depuración','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END
GO


IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'CboCommit')
BEGIN
	UPDATE wf_parametros SET
	prt_valor = '5000',
	prt_baja_fecha = null
	WHERE prt_nombre_corto = 'CboCommit'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros
	
	INSERT INTO wf_parametros values (@prt_id,'Bitácora obj-Cant. Reg. p/Transaccion','CboCommit','Depuracion','5000','S','N','Pase a Historico','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END

GO

IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'CboDias')
BEGIN
	UPDATE wf_parametros SET
	prt_valor='365',
	prt_baja_fecha=null
	WHERE prt_nombre_corto = 'CboDias'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros
	
	INSERT INTO wf_parametros values (@prt_id,'Bitácora obj-Cant. de Dias a depurar','CboDias','Depuracion','365','S','N','Pase a Historico','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END
go

IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'CsaCommit')
BEGIN
	UPDATE wf_parametros SET
	prt_valor = '5000',
	prt_baja_fecha = null
	WHERE prt_nombre_corto = 'CsaCommit'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros
	
	INSERT INTO wf_parametros values (@prt_id,'Bitacora saldos-Cant. Reg. p/Transaccion','CsaCommit','Depuracion','5000','S','N','Pase a Historico','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END

go

IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'CsaCant')
BEGIN
	UPDATE wf_parametros SET
	prt_valor='12',
	prt_baja_fecha=null
	WHERE prt_nombre_corto = 'CsaCant'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros
	
	INSERT INTO wf_parametros values (@prt_id,'Bitacora saldos-Cant. saldos a mantener','CsaCant','Depuracion','12','S','N','Pase a Historico','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END
go


IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'CctCommit')
BEGIN
	UPDATE wf_parametros SET
	prt_valor = '5000',
	prt_baja_fecha = null
	WHERE prt_nombre_corto = 'CctCommit'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros
	
	INSERT INTO wf_parametros values (@prt_id,'Bitacora ctas-Cant. Reg. p/Transaccion','CctCommit','Depuracion','5000','S','N','Pase a Historico','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END

go

IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'CctDias')
BEGIN
	UPDATE wf_parametros SET
	prt_valor='720',
	prt_baja_fecha=null
	WHERE prt_nombre_corto = 'CctDias'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros
	
	INSERT INTO wf_parametros values (@prt_id,'Bitacora de cta-Cant. de Dias a depurar','CctDias','Depuracion','720','S','N','Pase a Historico','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END
go

IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'CtfCommit')
BEGIN
	UPDATE wf_parametros SET
	prt_valor = '5000',
	prt_baja_fecha = null
	WHERE prt_nombre_corto = 'CtfCommit'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros
	
	INSERT INTO wf_parametros values (@prt_id,'Bitacora per_tel-Cant. Reg. Transaccion','CtfCommit','Depuracion','5000','S','N','Pase a Historico','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END

go

IF EXISTS (SELECT 1 FROM  wf_parametros WHERE prt_nombre_corto = 'CtfDias')
BEGIN
	UPDATE wf_parametros SET
	prt_valor='180',
	prt_baja_fecha=null
	WHERE prt_nombre_corto = 'CtfDias'
END
ELSE
BEGIN

	DECLARE @prt_id INT
	SELECT @prt_id= MAX(prt_id)+1 FROM wf_parametros
	
	INSERT INTO wf_parametros values (@prt_id,'Bitacora per_tel-Cant. Dias a depurar','CtfDias','Depuracion','180','S','N','Pase a Historico','','20190711',null,null,1,'')

	UPDATE id_numeracion SET idn_ultimo_id=(SELECT MAX(prt_id) FROM wf_parametros) WHERE idn_tabla='wf_parametros'
END
go
