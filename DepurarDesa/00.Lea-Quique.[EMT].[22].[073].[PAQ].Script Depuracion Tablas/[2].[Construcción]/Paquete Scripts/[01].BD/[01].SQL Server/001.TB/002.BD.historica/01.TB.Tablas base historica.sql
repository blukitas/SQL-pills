use emt_bgp_desa_hist
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[acciones]') AND type in (N'U'))
drop table dbo.acciones
go
CREATE TABLE [dbo].[acciones](
	[acc_id] [int] NOT NULL,
	[acc_per] [int] NOT NULL,
	[acc_cta] [int] NOT NULL,
	[acc_fec_hora] [datetime] NOT NULL,
	[acc_tac] [int] NOT NULL,
	[acc_obs] [varchar](255) NULL,
	[acc_estado] [varchar](1) NOT NULL,
	[acc_trp] [int] NOT NULL,
	[acc_res_fec_hora] [datetime] NULL,
	[acc_usu] [int] NOT NULL,
	[acc_obs_resp] [varchar](255) NOT NULL,
	[acc_fec_vto] [datetime] NULL,
	[acc_etg] [int] NOT NULL,
	[acc_esc] [int] NOT NULL,
	[acc_fec_esc] [datetime] NOT NULL,
	[acc_est] [int] NOT NULL,
	[acc_fec_est] [datetime] NOT NULL,
	[acc_usu_resp] [int] NOT NULL,
	[acc_deuda_a_venc] [numeric](20, 6) NULL,
	[acc_deuda_venc] [numeric](20, 6) NULL,
	[acc_eve] [int] NOT NULL,
	[acc_mov] [int] NOT NULL,
	[acc_costo] [numeric](9, 2) NOT NULL,
	[acc_alta_fecha] [datetime] NOT NULL,
	[acc_modi_fecha] [datetime] NULL,
	[acc_baja_fecha] [datetime] NULL,
	[acc_usu_id] [int] NOT NULL,
	[acc_filler] [varchar](255) NULL
) ON [PRIMARY]
GO
alter table dbo.acciones add primary key nonclustered (acc_id)
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[acciones_x_cuentas]') AND type in (N'U'))
drop table dbo.acciones_x_cuentas
go
CREATE TABLE [dbo].[acciones_x_cuentas](
	[axc_id] [int] NOT NULL,
	[axc_acc] [int] NOT NULL,
	[axc_cta] [int] NOT NULL,
	[axc_per] [int] NOT NULL,
	[axc_obs] [varchar](255) NOT NULL,
	[axc_alta_fecha] [datetime] NOT NULL,
	[axc_modi_fecha] [datetime] NULL,
	[axc_baja_fecha] [datetime] NULL,
	[axc_usu_id] [int] NOT NULL,
	[axc_filler] [varchar](255) NULL
) ON [PRIMARY]
GO
alter table dbo.acciones_x_cuentas add primary key nonclustered (axc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_marcas_cuentas]') AND type in (N'U'))
drop table dbo.add_marcas_cuentas
go
CREATE TABLE [dbo].[add_marcas_cuentas](
	[mct_id] [int] NOT NULL,
	[mct_cta] [int] NOT NULL,
	[mct_marca_0] [varchar](30) NULL,
	[mct_marca_1] [varchar](30) NULL,
	[mct_marca_2] [varchar](30) NULL,
	[mct_marca_3] [varchar](30) NULL,
	[mct_marca_4] [varchar](30) NULL,
	[mct_marca_5] [varchar](30) NULL,
	[mct_marca_6] [varchar](30) NULL,
	[mct_marca_7] [varchar](30) NULL,
	[mct_marca_8] [varchar](30) NULL,
	[mct_marca_9] [varchar](30) NULL,
	[mct_obs] [varchar](255) NULL,
	[mct_alta_fecha] [datetime] NULL,
	[mct_modi_fecha] [datetime] NULL,
	[mct_baja_fecha] [datetime] NULL,
	[mct_usu_id] [int] NULL,
	[mct_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.add_marcas_cuentas add primary key nonclustered (mct_id)
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_movimientos]') AND type in (N'U'))
drop table dbo.add_movimientos
go
CREATE TABLE [dbo].[add_movimientos](
	[amo_id] [int] NOT NULL,
	[amo_tipo_recobro] [varchar](1) NOT NULL,
	[amo_recobro_ejecutivo] [int] NOT NULL,
	[amo_recobro_obs] [varchar](50) NOT NULL,
	[amo_obs] [varchar](100) NOT NULL,
	[amo_alta_fecha] [datetime] NOT NULL,
	[amo_modi_fecha] [datetime] NULL,
	[amo_baja_fecha] [datetime] NULL,
	[amo_usu_id] [int] NOT NULL,
	[amo_filler] [varchar](255) NULL,
	[amo_deuda_venc] [numeric](20, 6) NULL) ON [PRIMARY]
GO
alter table dbo.add_movimientos add primary key nonclustered (amo_id)
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[asg_resp_x_cta]') AND type in (N'U'))
drop table dbo.asg_resp_x_cta
go
CREATE TABLE [dbo].[asg_resp_x_cta](
	[rxc_id] [int] NOT NULL,
	[rxc_rgc] [int] NOT NULL,
	[rxc_age] [int] NOT NULL,
	[rxc_usu] [int] NOT NULL,
	[rxc_cta] [int] NOT NULL,
	[rxc_asig_fecha_ini] [datetime] NULL,
	[rxc_asig_fecha_fin] [datetime] NULL,
	[rxc_monto_inicial] [numeric](20, 6) NULL,
	[rxc_monto_asignado] [numeric](20, 6) NULL,
	[rxc_monto_recuperado] [numeric](20, 6) NULL,
	[rxc_monto_recu_total] [numeric](20, 6) NULL,
	[rxc_fecha_canc] [datetime] NULL,
	[rxc_obs] [varchar](255) NOT NULL,
	[rxc_alta_fecha] [datetime] NOT NULL,
	[rxc_modi_fecha] [datetime] NULL,
	[rxc_baja_fecha] [datetime] NULL,
	[rxc_usu_id] [int] NOT NULL,
	[rxc_filler] [varchar](255) NULL) ON [PRIMARY]
GO

alter table dbo.asg_resp_x_cta add primary key nonclustered (rxc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[carga_masiva_arch]') AND type in (N'U'))
drop table dbo.carga_masiva_arch
go
CREATE TABLE [dbo].[carga_masiva_arch](
	[acm_id] [int] NOT NULL,
	[acm_nombre_archivo] [varchar](100) NULL,
	[acm_cat] [int] NOT NULL,
	[acm_age] [int] NOT NULL,
	[acm_fecha_subido] [datetime] NULL,
	[acm_fecha_procesado] [datetime] NULL,
	[acm_cant_ok] [int] NOT NULL,
	[acm_importe_ok] [numeric](16, 2) NOT NULL,
	[acm_cant_err] [int] NOT NULL,
	[acm_ata] [int] NOT NULL,
	[acm_esa] [int] NOT NULL,
	[acm_obs] [varchar](255) NOT NULL,
	[acm_alta_fecha] [datetime] NOT NULL,
	[acm_modi_fecha] [datetime] NULL,
	[acm_baja_fecha] [datetime] NULL,
	[acm_usu_id] [int] NOT NULL,
	[acm_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.carga_masiva_arch add primary key nonclustered (acm_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[carga_masiva_arch_de]') AND type in (N'U'))
drop table dbo.carga_masiva_arch_de
go
CREATE TABLE [dbo].[carga_masiva_arch_de](
	[dtu_id] [int] NOT NULL,
	[dtu_arc] [int] NOT NULL,
	[dtu_dato_1] [varchar](255) NOT NULL,
	[dtu_dato_2] [varchar](255) NOT NULL,
	[dtu_dato_3] [varchar](255) NOT NULL,
	[dtu_dato_4] [varchar](255) NOT NULL,
	[dtu_dato_5] [varchar](255) NOT NULL,
	[dtu_dato_6] [varchar](255) NOT NULL,
	[dtu_dato_7] [varchar](255) NOT NULL,
	[dtu_dato_8] [varchar](255) NOT NULL,
	[dtu_dato_9] [varchar](255) NOT NULL,
	[dtu_dato_10] [varchar](255) NOT NULL,
	[dtu_dato_11] [varchar](255) NOT NULL,
	[dtu_dato_12] [varchar](255) NOT NULL,
	[dtu_dato_13] [varchar](255) NOT NULL,
	[dtu_dato_14] [varchar](255) NOT NULL,
	[dtu_dato_15] [varchar](255) NOT NULL,
	[dtu_dato_16] [varchar](255) NOT NULL,
	[dtu_dato_17] [varchar](255) NOT NULL,
	[dtu_dato_18] [varchar](255) NOT NULL,
	[dtu_dato_19] [varchar](255) NOT NULL,
	[dtu_dato_20] [varchar](255) NOT NULL,
	[dtu_dato_21] [varchar](255) NOT NULL,
	[dtu_dato_22] [varchar](255) NOT NULL,
	[dtu_dato_23] [varchar](255) NOT NULL,
	[dtu_dato_24] [varchar](255) NOT NULL,
	[dtu_dato_25] [varchar](255) NOT NULL,
	[dtu_dato_26] [varchar](255) NOT NULL,
	[dtu_dato_27] [varchar](255) NOT NULL,
	[dtu_dato_28] [varchar](255) NOT NULL,
	[dtu_dato_29] [varchar](255) NOT NULL,
	[dtu_dato_30] [varchar](255) NOT NULL,
	[dtu_dato_31] [varchar](255) NOT NULL,
	[dtu_dato_32] [varchar](255) NOT NULL,
	[dtu_dato_33] [varchar](255) NOT NULL,
	[dtu_dato_34] [varchar](255) NOT NULL,
	[dtu_dato_35] [varchar](255) NOT NULL,
	[dtu_dato_36] [varchar](255) NOT NULL,
	[dtu_dato_37] [varchar](255) NOT NULL,
	[dtu_dato_38] [varchar](255) NOT NULL,
	[dtu_dato_39] [varchar](255) NOT NULL,
	[dtu_dato_40] [varchar](255) NOT NULL,
	[dtu_dato_41] [varchar](255) NOT NULL,
	[dtu_dato_42] [varchar](255) NOT NULL,
	[dtu_dato_43] [varchar](255) NOT NULL,
	[dtu_dato_44] [varchar](255) NOT NULL,
	[dtu_dato_45] [varchar](255) NOT NULL,
	[dtu_dato_46] [varchar](255) NOT NULL,
	[dtu_dato_47] [varchar](255) NOT NULL,
	[dtu_dato_48] [varchar](255) NOT NULL,
	[dtu_dato_49] [varchar](255) NOT NULL,
	[dtu_dato_50] [varchar](255) NOT NULL,
	[dtu_estado] [varchar](255) NOT NULL) ON [PRIMARY]
GO
alter table dbo.carga_masiva_arch_de add primary key nonclustered (dtu_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cca_ca]') AND type in (N'U'))
drop table dbo.cca_ca
go
CREATE TABLE [dbo].[cca_ca](
	[cca_id] [int] NOT NULL,
	[cca_cta] [int] NOT NULL,
	[cca_acuerdo] [numeric](20, 6) NULL,
	[cca_saldo] [numeric](20, 6) NULL,
	[cca_porfolio] [numeric](20, 6) NULL,
	[cca_obs] [varchar](255) NULL,
	[cca_p_alta_fecha] [datetime] NOT NULL,
	[cca_p_modi_fecha] [datetime] NULL,
	[cca_alta_fecha] [datetime] NOT NULL,
	[cca_modi_fecha] [datetime] NULL,
	[cca_baja_fecha] [datetime] NULL,
	[cca_usu_id] [int] NOT NULL,
	[cca_filler] [varchar](255) NULL,
	[cca_estado] [varchar](30) NULL,
	[cca_int_cobrar] [numeric](20, 6) NULL,
	[cca_depuracion] [varchar](1) NULL,
	[cca_abogado] [varchar](1) NULL,
	[cca_arrpago_leg] [varchar](1) NULL,
	[cca_arrpago] [varchar](1) NULL) ON [PRIMARY]
GO
alter table dbo.cca_ca add primary key nonclustered (cca_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cheques]') AND type in (N'U'))
drop table dbo.cheques
go
CREATE TABLE [dbo].[cheques](
	[chq_id] [int] NOT NULL,
	[chq_cca] [int] NOT NULL,
	[chq_nro] [varchar](8) NOT NULL,
	[chq_fecha_rechazo] [datetime] NOT NULL,
	[chq_mon] [int] NOT NULL,
	[chq_monto] [numeric](20, 6) NULL,
	[chq_estado] [varchar](30) NOT NULL,
	[chq_fecha_recupero] [datetime] NOT NULL,
	[chq_fecha_dtlmtreg] [datetime] NOT NULL,
	[chq_estado_bcra] [varchar](30) NOT NULL,
	[chq_baja] [char](1) NOT NULL,
	[chq_obs] [varchar](255) NULL,
	[chq_p_alta_fecha] [datetime] NOT NULL,
	[chq_p_modi_fecha] [datetime] NULL,
	[chq_alta_fecha] [datetime] NOT NULL,
	[chq_modi_fecha] [datetime] NULL,
	[chq_baja_fecha] [datetime] NULL,
	[chq_usu_id] [int] NOT NULL,
	[chq_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.cheques add primary key nonclustered (chq_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cheques_rech]') AND type in (N'U'))
drop table dbo.cheques_rech
go
CREATE TABLE [dbo].[cheques_rech](
	[chr_id] [int] NOT NULL,
	[chr_cta] [int] NOT NULL,
	[chr_nro] [varchar](8) NOT NULL,
	[chr_mon] [int] NOT NULL,
	[chr_monto_capital] [numeric](20, 6) NOT NULL,
	[chr_intereses] [numeric](20, 6) NOT NULL,
	[chr_fecha_rechazo] [datetime] NULL,
	[chr_motivo_rechazo] [varchar](30) NOT NULL,
	[chr_fecha_deposito] [datetime] NULL,
	[chr_banco] [varchar](30) NULL,
	[chr_nombre_firmante] [varchar](100) NULL,
	[chr_tipo_doc_firmante] [varchar](10) NULL,
	[chr_nro_doc_firmante] [varchar](15) NULL,
	[chr_domicilio_firmante] [varchar](100) NULL,
	[chr_cp_firmante] [varchar](20) NULL,
	[chr_operacion] [varchar](10) NULL,
	[chr_sub_operacion] [varchar](10) NULL,
	[chr_estado] [varchar](20) NULL,
	[chr_obs] [varchar](255) NULL,
	[chr_p_alta_fecha] [datetime] NOT NULL,
	[chr_p_modi_fecha] [datetime] NULL,
	[chr_alta_fecha] [datetime] NOT NULL,
	[chr_modi_fecha] [datetime] NULL,
	[chr_baja_fecha] [datetime] NULL,
	[chr_usu_id] [int] NOT NULL,
	[chr_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.cheques_rech add primary key nonclustered (chr_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmb_cta]') AND type in (N'U'))
drop table dbo.cmb_cta
go
CREATE TABLE [dbo].[cmb_cta](
	[cct_id] [int] NOT NULL,
	[cct_cta] [int] NOT NULL,
	[cct_cambio_fecha] [datetime] NOT NULL,
	[cct_tipo] [varchar](30) NOT NULL,
	[cct_dato_ant] [int] NOT NULL,
	[cct_dato_nue] [int] NOT NULL,
	[cct_nombre_ant] [varchar](100) NOT NULL,
	[cct_nombre_nue] [varchar](100) NOT NULL,
	[cct_obs] [varchar](100) NOT NULL,
	[cct_alta_fecha] [datetime] NOT NULL,
	[cct_modi_fecha] [datetime] NULL,
	[cct_baja_fecha] [datetime] NULL,
	[cct_usu_id] [int] NOT NULL,
	[cct_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.cmb_cta add primary key nonclustered (cct_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmb_cta_fechas]') AND type in (N'U'))
drop table dbo.cmb_cta_fechas
go
CREATE TABLE [dbo].[cmb_cta_fechas](
	[cfe_id] [int] NOT NULL,
	[cfe_cta] [int] NOT NULL,
	[cfe_cambio_fecha] [datetime] NOT NULL,
	[cfe_tipo] [varchar](30) NOT NULL,
	[cfe_dato_ant] [datetime] NOT NULL,
	[cfe_dato_nue] [datetime] NOT NULL,
	[cfe_nombre_ant] [varchar](100) NOT NULL,
	[cfe_nombre_nue] [varchar](100) NOT NULL,
	[cfe_obs] [varchar](255) NOT NULL,
	[cfe_alta_fecha] [datetime] NOT NULL,
	[cfe_modi_fecha] [datetime] NULL,
	[cfe_baja_fecha] [datetime] NULL,
	[cfe_usu_id] [int] NOT NULL,
	[cfe_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.cmb_cta_fechas add primary key nonclustered (cfe_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmb_saldos]') AND type in (N'U'))
drop table dbo.cmb_saldos
go
CREATE TABLE [dbo].[cmb_saldos](
	[csa_id] [int] NOT NULL,
	[csa_cta] [int] NOT NULL,
	[csa_cambio_fecha] [datetime] NOT NULL,
	[csa_tipo] [varchar](30) NOT NULL,
	[csa_dato_ant] [numeric](20, 6) NOT NULL,
	[csa_dato_nue] [numeric](20, 6) NOT NULL,
	[csa_nombre_ant] [varchar](100) NOT NULL,
	[csa_nombre_nue] [varchar](100) NOT NULL,
	[csa_obs] [varchar](255) NOT NULL,
	[csa_alta_fecha] [datetime] NOT NULL,
	[csa_modi_fecha] [datetime] NULL,
	[csa_baja_fecha] [datetime] NULL,
	[csa_usu_id] [int] NOT NULL,
	[csa_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.cmb_saldos add primary key nonclustered (csa_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmb_sob]') AND type in (N'U'))
drop table dbo.cmb_sob
go
CREATE TABLE [dbo].[cmb_sob](
	[cso_id] [int] NOT NULL,
	[cso_sob] [int] NOT NULL,
	[cso_cambio_fecha] [datetime] NOT NULL,
	[cso_tipo] [varchar](30) NOT NULL,
	[cso_dato_ant] [int] NOT NULL,
	[cso_dato_nue] [int] NOT NULL,
	[cso_nombre_ant] [varchar](100) NOT NULL,
	[cso_nombre_nue] [varchar](100) NOT NULL,
	[cso_obs] [varchar](100) NOT NULL,
	[cso_alta_fecha] [datetime] NOT NULL,
	[cso_modi_fecha] [datetime] NULL,
	[cso_baja_fecha] [datetime] NULL,
	[cso_usu_id] [int] NOT NULL,
	[cso_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.cmb_sob add primary key nonclustered (cso_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmb_sot]') AND type in (N'U'))
drop table dbo.cmb_sot
go
CREATE TABLE [dbo].[cmb_sot](
	[cso_id] [int] NOT NULL,
	[cso_sot] [int] NOT NULL,
	[cso_cambio_fecha] [datetime] NOT NULL,
	[cso_tipo] [varchar](30) NOT NULL,
	[cso_dato_ant] [int] NOT NULL,
	[cso_dato_nue] [int] NOT NULL,
	[cso_nombre_ant] [varchar](100) NOT NULL,
	[cso_nombre_nue] [varchar](100) NOT NULL,
	[cso_obs] [varchar](100) NOT NULL,
	[cso_alta_fecha] [datetime] NOT NULL,
	[cso_modi_fecha] [datetime] NULL,
	[cso_baja_fecha] [datetime] NULL,
	[cso_usu_id] [int] NOT NULL,
	[cso_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.cmb_sot add primary key nonclustered (cso_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cuentas]') AND type in (N'U'))
drop table dbo.cuentas
go
CREATE TABLE [dbo].[cuentas](
	[cta_id] [int] NOT NULL,
	[cta_per] [int] NOT NULL,
	[cta_pro] [int] NOT NULL,
	[cta_cla] [int] NOT NULL,
	[cta_num_oper] [varchar](50) NULL,
	[cta_cli] [varchar](20) NOT NULL,
	[cta_suc] [int] NOT NULL,
	[cta_mon] [int] NOT NULL,
	[cta_cnl] [int] NOT NULL,
	[cta_cam] [int] NOT NULL,
	[cta_bnc] [int] NOT NULL,
	[cta_ent] [int] NOT NULL,
	[cta_civ] [int] NOT NULL,
	[cta_fec_origen] [datetime] NULL,
	[cta_fec_vto] [datetime] NULL,
	[cta_fec_ing] [datetime] NOT NULL,
	[cta_fec_egr] [datetime] NULL,
	[cta_monto_origen] [numeric](20, 6) NULL,
	[cta_monto_transf] [numeric](20, 6) NULL,
	[cta_deuda_venc] [numeric](20, 6) NULL,
	[cta_deuda_a_venc] [numeric](20, 6) NULL,
	[cta_det_mov] [varchar](1) NOT NULL,
	[cta_fec_cla] [datetime] NOT NULL,
	[cta_age] [int] NOT NULL,
	[cta_age_fec_ini] [datetime] NULL,
	[cta_age_fec_fin] [datetime] NULL,
	[cta_age_respons] [varchar](30) NOT NULL,
	[cta_tco] [int] NOT NULL,
	[cta_res_com] [varchar](64) NULL,
	[cta_contrato] [varchar](20) NOT NULL,
	[cta_fec_ult_acc] [datetime] NULL,
	[cta_gat] [int] NOT NULL,
	[cta_gta_numero] [varchar](20) NOT NULL,
	[cta_gta_mon] [int] NOT NULL,
	[cta_gta_monto] [numeric](20, 6) NULL,
	[cta_gta_obs] [varchar](255) NOT NULL,
	[cta_centro] [varchar](10) NOT NULL,
	[cta_linea] [varchar](20) NOT NULL,
	[cta_tna] [numeric](8, 4) NOT NULL,
	[cta_lockeo_usu] [int] NOT NULL,
	[cta_lockeo_fec_hora] [datetime] NULL,
	[cta_lockeo_id_session] [varchar](255) NULL,
	[cta_cant_ing_mora] [int] NOT NULL,
	[cta_fec_est_inac] [datetime] NULL,
	[cta_caj] [int] NOT NULL,
	[cta_tpa] [int] NOT NULL,
	[cta_paq_nro] [int] NOT NULL,
	[cta_paq_pes] [int] NOT NULL,
	[cta_paq_precierre_deuda] [numeric](20, 6) NULL,
	[cta_paq_precierre_fecha] [datetime] NULL,
	[cta_obs] [varchar](255) NOT NULL,
	[cta_alta_fecha] [datetime] NOT NULL,
	[cta_modi_fecha] [datetime] NULL,
	[cta_baja_fecha] [datetime] NULL,
	[cta_p_alta_fecha] [datetime] NULL,
	[cta_p_modi_fecha] [datetime] NULL,
	[cta_usu_id] [int] NOT NULL,
	[cta_filler] [varchar](255) NULL,
	[cta_cat] [int] NULL,
	[cta_fec_ult_pago] [varchar](8) NULL,
	[cta_letra] [numeric](20, 6) NULL,
	[cta_saldo_proyect] [numeric](20, 6) NULL,
	[cta_vto_ley_prefer] [varchar](8) NULL,
	[cta_saldo_legal] [numeric](20, 6) NULL,
	[cta_costas] [numeric](20, 6) NULL,
	[cta_gastos] [numeric](20, 6) NULL,
	[cta_depurada] [varchar](138) NULL) ON [PRIMARY]
GO
alter table dbo.cuentas add primary key nonclustered (cta_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[disputas]') AND type in (N'U'))
drop table dbo.disputas
go
CREATE TABLE [dbo].[disputas](
	[dis_id] [int] NOT NULL,
	[dis_fecha] [datetime] NOT NULL,
	[dis_motivo] [varchar](255) NOT NULL,
	[dis_cta] [int] NOT NULL,
	[dis_mon] [int] NOT NULL,
	[dis_monto] [numeric](20, 6) NULL,
	[dis_obs] [varchar](255) NOT NULL,
	[dis_alta_fecha] [datetime] NOT NULL,
	[dis_modi_fecha] [datetime] NULL,
	[dis_baja_fecha] [datetime] NULL,
	[dis_usu_id] [int] NOT NULL,
	[dis_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.disputas add primary key nonclustered (dis_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[excepciones_x_cuenta]') AND type in (N'U'))
drop table dbo.excepciones_x_cuenta
go
CREATE TABLE [dbo].[excepciones_x_cuenta](
	[exc_id] [int] NOT NULL,
	[exc_per] [int] NOT NULL,
	[exc_cta] [int] NOT NULL,
	[exc_tac] [int] NOT NULL,
	[exc_fec_desde] [datetime] NOT NULL,
	[exc_fec_hasta] [datetime] NOT NULL,
	[exc_alta_fecha] [datetime] NOT NULL,
	[exc_modi_fecha] [datetime] NULL,
	[exc_baja_fecha] [datetime] NULL,
	[exc_usu_id] [int] NOT NULL,
	[exc_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.excepciones_x_cuenta add primary key nonclustered (exc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ind_asignaciones_call]') AND type in (N'U'))
drop table dbo.ind_asignaciones_call
go
CREATE TABLE [dbo].[ind_asignaciones_call](
	[iac_id] [int] NOT NULL,
	[iac_fecha_inicio] [datetime] NOT NULL,
	[iac_fecha_fin] [datetime] NULL,
	[iac_cta] [int] NOT NULL,
	[iac_age] [int] NOT NULL,
	[iac_esc] [int] NOT NULL,
	[iac_usu_res] [int] NOT NULL,
	[iac_monto_asig] [numeric](16, 2) NOT NULL,
	[iac_monto_pago] [numeric](16, 2) NOT NULL,
	[iac_obs] [varchar](100) NOT NULL,
	[iac_alta_fecha] [datetime] NOT NULL,
	[iac_modi_fecha] [datetime] NULL,
	[iac_baja_fecha] [datetime] NULL,
	[iac_usu_id] [int] NOT NULL,
	[iac_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.ind_asignaciones_call add primary key nonclustered (iac_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[leasing]') AND type in (N'U'))
drop table dbo.leasing
go
CREATE TABLE [dbo].[leasing](
	[lea_id] [int] NOT NULL,
	[lea_cta] [int] NOT NULL,
	[lea_banca_originante] [varchar](30) NOT NULL,
	[lea_canon_total] [varchar](10) NOT NULL,
	[lea_banco] [varchar](40) NOT NULL,
	[lea_tipo_bien] [varchar](40) NOT NULL,
	[lea_dom_leg] [varchar](255) NOT NULL,
	[lea_proveedor] [varchar](40) NULL,
	[lea_oficial_originante] [varchar](100) NULL,
	[lea_oficial_comercial] [varchar](100) NOT NULL,
	[lea_obs] [varchar](255) NULL,
	[lea_p_alta_fecha] [datetime] NOT NULL,
	[lea_p_modi_fecha] [datetime] NULL,
	[lea_alta_fecha] [datetime] NOT NULL,
	[lea_modi_fecha] [datetime] NULL,
	[lea_baja_fecha] [datetime] NULL,
	[lea_usu_id] [int] NOT NULL,
	[lea_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.leasing add primary key nonclustered (lea_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[leasing_conceptos]') AND type in (N'U'))
drop table dbo.leasing_conceptos
go
CREATE TABLE [dbo].[leasing_conceptos](
	[lco_id] [int] NOT NULL,
	[lco_lea] [int] NOT NULL,
	[lco_tipo] [varchar](30) NOT NULL,
	[lco_nro] [varchar](10) NOT NULL,
	[lco_nro_liquidacion] [int] NOT NULL,
	[lco_importe] [numeric](20, 6) NOT NULL,
	[lco_venc_fecha] [datetime] NULL,
	[lco_pago_fecha] [datetime] NULL,
	[lco_estado] [varchar](1) NULL,
	[lco_obs] [varchar](255) NULL,
	[lco_p_alta_fecha] [datetime] NOT NULL,
	[lco_p_modi_fecha] [datetime] NULL,
	[lco_alta_fecha] [datetime] NOT NULL,
	[lco_modi_fecha] [datetime] NULL,
	[lco_baja_fecha] [datetime] NULL,
	[lco_usu_id] [int] NOT NULL,
	[lco_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.leasing_conceptos add primary key nonclustered (lco_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mov_x_mov]') AND type in (N'U'))
drop table dbo.mov_x_mov
go
CREATE TABLE [dbo].[mov_x_mov](
	[mvv_id] [int] NOT NULL,
	[mvv_mov] [int] NOT NULL,
	[mvv_mov_vinc] [int] NOT NULL,
	[mvv_alta_fecha] [datetime] NOT NULL,
	[mvv_modi_fecha] [datetime] NULL,
	[mvv_baja_fecha] [datetime] NULL,
	[mvv_p_alta_fecha] [datetime] NULL,
	[mvv_p_modi_fecha] [datetime] NULL,
	[mvv_usu_id] [int] NOT NULL,
	[mvv_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mov_x_mov add primary key nonclustered (mvv_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[movimientos]') AND type in (N'U'))
drop table dbo.movimientos
go
CREATE TABLE [dbo].[movimientos](
	[mov_id] [int] NOT NULL,
	[mov_cta] [int] NOT NULL,
	[mov_mon] [int] NOT NULL,
	[mov_mon_origen] [int] NOT NULL,
	[mov_com] [int] NOT NULL,
	[mov_fec_carga] [datetime] NOT NULL,
	[mov_fec_contab] [datetime] NULL,
	[mov_fec_oper] [datetime] NOT NULL,
	[mov_fec_vto] [datetime] NULL,
	[mov_cos] [int] NOT NULL,
	[mov_scn] [int] NOT NULL,
	[mov_grupo] [int] NOT NULL,
	[mov_importe] [numeric](20, 6) NULL,
	[mov_importe_origen] [numeric](20, 6) NULL,
	[mov_signo] [char](1) NOT NULL,
	[mov_num] [int] NOT NULL,
	[mov_comentario] [varchar](255) NOT NULL,
	[mov_importe_ajc] [numeric](20, 6) NULL,
	[mov_importe_int] [numeric](20, 6) NULL,
	[mov_importe_imp] [numeric](20, 6) NULL,
	[mov_importe_gastos] [numeric](20, 6) NULL,
	[mov_usu_res] [int] NOT NULL,
	[mov_coh] [int] NOT NULL,
	[mov_comprobante] [varchar](30) NOT NULL,
	[mov_alta_fecha] [datetime] NOT NULL,
	[mov_modi_fecha] [datetime] NULL,
	[mov_baja_fecha] [datetime] NULL,
	[mov_p_alta_fecha] [datetime] NULL,
	[mov_p_modi_fecha] [datetime] NULL,
	[mov_usu_id] [int] NOT NULL,
	[mov_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.movimientos add primary key nonclustered (mov_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_acciones_trm]') AND type in (N'U'))
drop table dbo.mwf_acciones_trm
go
CREATE TABLE [dbo].[mwf_acciones_trm](
	[acc_id] [int] NOT NULL,
	[acc_per] [int] NOT NULL,
	[acc_sob] [int] NOT NULL,
	[acc_fec_hora] [datetime] NOT NULL,
	[acc_tac] [int] NOT NULL,
	[acc_obs] [varchar](255) NULL,
	[acc_estado] [varchar](1) NOT NULL,
	[acc_trp] [int] NOT NULL,
	[acc_res_fec_hora] [datetime] NULL,
	[acc_usu] [int] NOT NULL,
	[acc_obs_resp] [varchar](255) NOT NULL,
	[acc_eve] [int] NOT NULL,
	[acc_mov] [int] NOT NULL,
	[acc_costo] [numeric](9, 2) NOT NULL,
	[acc_wfl] [int] NOT NULL,
	[acc_alta_fecha] [datetime] NOT NULL,
	[acc_modi_fecha] [datetime] NULL,
	[acc_baja_fecha] [datetime] NULL,
	[acc_usu_id] [int] NOT NULL,
	[acc_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_acciones_trm add primary key nonclustered (acc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_acciones_x_objetos_trm]') AND type in (N'U'))
drop table dbo.mwf_acciones_x_objetos_trm
go
CREATE TABLE [dbo].[mwf_acciones_x_objetos_trm](
	[axc_id] [int] NOT NULL,
	[axc_acc] [int] NOT NULL,
	[axc_sob] [int] NOT NULL,
	[axc_per] [int] NOT NULL,
	[axc_obs] [varchar](255) NOT NULL,
	[axc_alta_fecha] [datetime] NOT NULL,
	[axc_modi_fecha] [datetime] NULL,
	[axc_baja_fecha] [datetime] NULL,
	[axc_usu_id] [int] NOT NULL,
	[axc_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_acciones_x_objetos_trm add primary key nonclustered (axc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_asig_resp_hist_trm]') AND type in (N'U'))
drop table dbo.mwf_asig_resp_hist_trm
go
CREATE TABLE [dbo].[mwf_asig_resp_hist_trm](
	[asr_id] [int] NOT NULL,
	[asr_sob] [int] NOT NULL,
	[asr_usu] [int] NOT NULL,
	[asr_ege] [int] NOT NULL,
	[asr_age] [int] NOT NULL,
	[asr_tia] [int] NOT NULL,
	[asr_default] [varchar](1) NOT NULL,
	[asr_fecha_asig] [datetime] NOT NULL,
	[asr_obs] [varchar](255) NOT NULL,
	[asr_alta_fecha] [datetime] NOT NULL,
	[asr_modi_fecha] [datetime] NULL,
	[asr_baja_fecha] [datetime] NULL,
	[asr_usu_id] [int] NOT NULL,
	[asr_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_asig_resp_hist_trm add primary key nonclustered (asr_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_asig_resp_trm]') AND type in (N'U'))
drop table dbo.mwf_asig_resp_trm
go
CREATE TABLE [dbo].[mwf_asig_resp_trm](
	[asr_id] [int] NOT NULL,
	[asr_sob] [int] NOT NULL,
	[asr_usu] [int] NOT NULL,
	[asr_ege] [int] NOT NULL,
	[asr_age] [int] NOT NULL,
	[asr_tia] [int] NOT NULL,
	[asr_default] [varchar](1) NOT NULL,
	[asr_fecha_asig] [datetime] NOT NULL,
	[asr_obs] [varchar](255) NOT NULL,
	[asr_alta_fecha] [datetime] NOT NULL,
	[asr_modi_fecha] [datetime] NULL,
	[asr_baja_fecha] [datetime] NULL,
	[asr_usu_id] [int] NOT NULL,
	[asr_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_asig_resp_trm add primary key nonclustered (asr_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_cmb_objetos_trm]') AND type in (N'U'))
drop table dbo.mwf_cmb_objetos_trm
go
CREATE TABLE [dbo].[mwf_cmb_objetos_trm](
	[cob_id] [int] NOT NULL,
	[cob_sob] [int] NOT NULL,
	[cob_cambio_fecha] [datetime] NOT NULL,
	[cob_tipo] [varchar](30) NOT NULL,
	[cob_dato_ant] [int] NOT NULL,
	[cob_dato_nue] [int] NOT NULL,
	[cob_nombre_ant] [varchar](100) NOT NULL,
	[cob_nombre_nue] [varchar](100) NOT NULL,
	[cob_reg] [int] NOT NULL,
	[cob_obs] [varchar](100) NOT NULL,
	[cob_alta_fecha] [datetime] NOT NULL,
	[cob_modi_fecha] [datetime] NULL,
	[cob_baja_fecha] [datetime] NULL,
	[cob_usu_id] [int] NOT NULL,
	[cob_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_cmb_objetos_trm add primary key nonclustered (cob_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_eventos_trm]') AND type in (N'U'))
drop table dbo.mwf_eventos_trm
go
CREATE TABLE [dbo].[mwf_eventos_trm](
	[eve_id] [int] NOT NULL,
	[eve_sob] [int] NOT NULL,
	[eve_evento] [int] NOT NULL,
	[eve_param] [varchar](4000) NOT NULL,
	[eve_dias_min] [int] NOT NULL,
	[eve_reg] [int] NOT NULL,
	[eve_param2] [varchar](4000) NOT NULL,
	[eve_param3] [varchar](4000) NOT NULL,
	[eve_param4] [varchar](4000) NOT NULL,
	[eve_alta_fecha] [datetime] NOT NULL,
	[eve_modi_fecha] [datetime] NULL,
	[eve_baja_fecha] [datetime] NULL,
	[eve_usu_id] [int] NOT NULL,
	[eve_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_eventos_trm add primary key nonclustered (eve_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_excepciones_x_objeto_trm]') AND type in (N'U'))
drop table dbo.mwf_excepciones_x_objeto_trm
go
CREATE TABLE [dbo].[mwf_excepciones_x_objeto_trm](
	[exc_id] [int] NOT NULL,
	[exc_per] [int] NOT NULL,
	[exc_sob] [int] NOT NULL,
	[exc_tac] [int] NOT NULL,
	[exc_fec_desde] [datetime] NOT NULL,
	[exc_fec_hasta] [datetime] NOT NULL,
	[exc_alta_fecha] [datetime] NOT NULL,
	[exc_modi_fecha] [datetime] NULL,
	[exc_baja_fecha] [datetime] NULL,
	[exc_usu_id] [int] NOT NULL,
	[exc_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_excepciones_x_objeto_trm add primary key nonclustered (exc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_obj_x_alm_his_trm]') AND type in (N'U'))
drop table dbo.mwf_obj_x_alm_his_trm
go
CREATE TABLE [dbo].[mwf_obj_x_alm_his_trm](
	[oxa_id] [int] NOT NULL,
	[oxa_sob] [int] NOT NULL,
	[oxa_alm] [int] NOT NULL,
	[oxa_fecha] [datetime] NOT NULL,
	[oxa_texto] [varchar](500) NOT NULL,
	[oxa_usu] [int] NOT NULL,
	[oxa_alta_fecha] [datetime] NOT NULL,
	[oxa_modi_fecha] [datetime] NULL,
	[oxa_baja_fecha] [datetime] NULL,
	[oxa_usu_id] [int] NOT NULL,
	[oxa_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_obj_x_alm_his_trm add primary key nonclustered (oxa_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_obj_x_alm_trm]') AND type in (N'U'))
drop table dbo.mwf_obj_x_alm_trm
go
CREATE TABLE [dbo].[mwf_obj_x_alm_trm](
	[oxa_id] [int] NOT NULL,
	[oxa_sob] [int] NOT NULL,
	[oxa_alm] [int] NOT NULL,
	[oxa_fecha] [datetime] NOT NULL,
	[oxa_texto] [varchar](500) NOT NULL,
	[oxa_usu] [int] NOT NULL,
	[oxa_alta_fecha] [datetime] NOT NULL,
	[oxa_modi_fecha] [datetime] NULL,
	[oxa_baja_fecha] [datetime] NULL,
	[oxa_usu_id] [int] NOT NULL,
	[oxa_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_obj_x_alm_trm add primary key nonclustered (oxa_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_obj_x_cmp_trm]') AND type in (N'U'))
drop table dbo.mwf_obj_x_cmp_trm
go
CREATE TABLE [dbo].[mwf_obj_x_cmp_trm](
	[oxc_id] [int] NOT NULL,
	[oxc_sob] [int] NOT NULL,
	[oxc_cmp] [int] NOT NULL,
	[oxc_alta_fecha] [datetime] NOT NULL,
	[oxc_modi_fecha] [datetime] NULL,
	[oxc_baja_fecha] [datetime] NULL,
	[oxc_usu_id] [int] NOT NULL,
	[oxc_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_obj_x_cmp_trm add primary key nonclustered (oxc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mwf_sit_objetos_trm]') AND type in (N'U'))
drop table dbo.mwf_sit_objetos_trm
go
CREATE TABLE [dbo].[mwf_sit_objetos_trm](
	[sob_id] [int] NOT NULL,
	[sob_numero] [varchar](50) NULL,
	[sob_per] [int] NOT NULL,
	[sob_esc] [int] NOT NULL,
	[sob_etg] [int] NOT NULL,
	[sob_est] [int] NOT NULL,
	[sob_fec_esc] [datetime] NOT NULL,
	[sob_fec_etg] [datetime] NOT NULL,
	[sob_fec_est] [datetime] NOT NULL,
	[sob_fec_susp] [datetime] NULL,
	[sob_scr] [int] NOT NULL,
	[sob_fec_hora_trab] [datetime] NULL,
	[sob_wfl] [int] NOT NULL,
	[sob_uni] [int] NOT NULL,
	[sob_kit] [int] NOT NULL,
	[sob_lockeo_usu] [int] NOT NULL,
	[sob_lockeo_fec_hora] [datetime] NULL,
	[sob_lockeo_id_session] [varchar](255) NULL,
	[sob_reg_fec_hora] [datetime] NULL,
	[sob_agr] [int] NOT NULL,
	[sob_agr_nombre_corto] [varchar](10) NULL,
	[sob_alta_fecha] [datetime] NOT NULL,
	[sob_modi_fecha] [datetime] NULL,
	[sob_baja_fecha] [datetime] NULL,
	[sob_usu_id] [int] NOT NULL,
	[sob_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.mwf_sit_objetos_trm add primary key nonclustered (sob_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ng_lotes_det_adic]') AND type in (N'U'))
drop table dbo.ng_lotes_det_adic
go
CREATE TABLE [dbo].[ng_lotes_det_adic](
	[lad_lde] [int] NOT NULL,
	[lad_estado] [varchar](10) NULL,
	[lad_estado_fecha] [datetime] NULL,
	[lad_mov] [int] NOT NULL,
	[lad_porcentaje] [numeric](20, 6) NULL,
	[lad_importe_litis] [numeric](20, 6) NULL,
	[lad_importe_litis_iva] [numeric](20, 6) NULL,
	[lad_valormaximo] [numeric](20, 6) NULL,
	[lad_obs] [varchar](255) NULL,
	[lad_alta_fecha] [datetime] NOT NULL,
	[lad_baja_fecha] [datetime] NULL,
	[lad_modi_fecha] [datetime] NULL,
	[lad_usu_id] [int] NULL,
	[lad_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.ng_lotes_det_adic add primary key nonclustered (lad_lde)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[per_x_cta]') AND type in (N'U'))
drop table dbo.per_x_cta
go
CREATE TABLE [dbo].[per_x_cta](
	[pxc_id] [int] NOT NULL,
	[pxc_cta] [int] NOT NULL,
	[pxc_per] [int] NOT NULL,
	[pxc_ogc] [int] NOT NULL,
	[pxc_alta_fecha] [datetime] NOT NULL,
	[pxc_modi_fecha] [datetime] NULL,
	[pxc_baja_fecha] [datetime] NULL,
	[pxc_usu_id] [int] NOT NULL,
	[pxc_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.per_x_cta add primary key nonclustered (pxc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prestamos]') AND type in (N'U'))
drop table dbo.prestamos
go
CREATE TABLE [dbo].[prestamos](
	[ptm_id] [int] NOT NULL,
	[ptm_cta] [int] NOT NULL,
	[ptm_capital_inicial] [numeric](20, 6) NULL,
	[ptm_fecha_fin] [datetime] NULL,
	[ptm_cta_debito] [varchar](24) NULL,
	[ptm_obs] [varchar](255) NOT NULL,
	[ptm_p_alta_fecha] [datetime] NOT NULL,
	[ptm_p_modi_fecha] [datetime] NULL,
	[ptm_alta_fecha] [datetime] NOT NULL,
	[ptm_modi_fecha] [datetime] NULL,
	[ptm_baja_fecha] [datetime] NULL,
	[ptm_usu_id] [int] NOT NULL,
	[ptm_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.prestamos add primary key nonclustered (ptm_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prestamos_cuotas]') AND type in (N'U'))
drop table dbo.prestamos_cuotas
go
CREATE TABLE [dbo].[prestamos_cuotas](
	[pcu_id] [int] NOT NULL,
	[pcu_ptm] [int] NOT NULL,
	[pcu_numero] [int] NOT NULL,
	[pcu_importe] [numeric](20, 6) NULL,
	[pcu_venc_fecha] [datetime] NOT NULL,
	[pcu_pago_fecha] [datetime] NULL,
	[pcu_estado] [char](1) NOT NULL,
	[pcu_intereses] [numeric](20, 6) NULL,
	[pcu_obs] [varchar](255) NOT NULL,
	[pcu_p_alta_fecha] [datetime] NOT NULL,
	[pcu_p_modi_fecha] [datetime] NULL,
	[pcu_alta_fecha] [datetime] NOT NULL,
	[pcu_modi_fecha] [datetime] NULL,
	[pcu_baja_fecha] [datetime] NULL,
	[pcu_usu_id] [int] NOT NULL,
	[pcu_filler] [varchar](255) NULL,
	[pcu_importe_original] [numeric](20, 6) NULL,
	[pcu_tipo] [varchar](1) NULL,
	[pcu_intereses_original] [varchar](20) NULL,
	[pcu_seguro] [varchar](20) NULL,
	[pcu_comision] [varchar](20) NULL,
	[pcu_penales] [varchar](20) NULL) ON [PRIMARY]
GO
alter table dbo.prestamos_cuotas add primary key nonclustered (pcu_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_x_cta]') AND type in (N'U'))
drop table dbo.proc_x_cta
go
CREATE TABLE [dbo].[proc_x_cta](
	[ppc_id] [int] NOT NULL,
	[ppc_prc] [int] NOT NULL,
	[ppc_cta] [int] NOT NULL,
	[ppc_alta_fecha] [datetime] NOT NULL,
	[ppc_modi_fecha] [datetime] NULL,
	[ppc_baja_fecha] [datetime] NULL,
	[ppc_usu_id] [int] NOT NULL,
	[ppc_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.proc_x_cta add primary key nonclustered (ppc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[promesas]') AND type in (N'U'))
drop table dbo.promesas
go
CREATE TABLE [dbo].[promesas](
	[prm_id] [int] NOT NULL,
	[prm_per] [int] NOT NULL,
	[prm_cta] [int] NOT NULL,
	[prm_fecha] [datetime] NOT NULL,
	[prm_fec_prom] [datetime] NOT NULL,
	[prm_prr] [int] NOT NULL,
	[prm_det_prr] [int] NOT NULL,
	[prm_mon] [int] NOT NULL,
	[prm_monto] [numeric](20, 6) NULL,
	[prm_tpm] [int] NOT NULL,
	[prm_cta_deuda_venc] [numeric](20, 6) NULL,
	[prm_mov] [int] NOT NULL,
	[prm_obs] [varchar](255) NOT NULL,
	[prm_alta_fecha] [datetime] NOT NULL,
	[prm_modi_fecha] [datetime] NULL,
	[prm_baja_fecha] [datetime] NULL,
	[prm_usu_id] [int] NOT NULL,
	[prm_filler] [varchar](255) NULL) ON [PRIMARY]
GO

alter table dbo.promesas add primary key nonclustered (prm_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ref_prop_detalles]') AND type in (N'U'))
drop table dbo.ref_prop_detalles
go
CREATE TABLE [dbo].[ref_prop_detalles](
	[prd_id] [int] NOT NULL,
	[prd_cta] [int] NOT NULL,
	[prd_prp] [int] NOT NULL,
	[prd_mon] [int] NULL,
	[prd_monto] [numeric](20, 6) NULL,
	[prd_deuda_venc] [numeric](20, 6) NULL,
	[prd_deuda_a_venc] [numeric](20, 6) NULL,
	[prd_alta_fecha] [datetime] NOT NULL,
	[prd_modi_fecha] [datetime] NULL,
	[prd_baja_fecha] [datetime] NULL,
	[prd_obs] [varchar](255) NULL,
	[prd_usu_id] [int] NOT NULL,
	[prd_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.ref_prop_detalles add primary key nonclustered (prd_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tarjetas]') AND type in (N'U'))
drop table dbo.tarjetas
go
CREATE TABLE [dbo].[tarjetas](
	[taj_id] [int] NOT NULL,
	[taj_cta] [int] NOT NULL,
	[taj_numero] [varchar](19) NOT NULL,
	[taj_limite_compra] [numeric](12, 2) NULL,
	[taj_estado] [varchar](1) NOT NULL,
	[taj_obs] [varchar](255) NOT NULL,
	[taj_p_alta_fecha] [datetime] NOT NULL,
	[taj_p_modi_fecha] [datetime] NULL,
	[taj_alta_fecha] [datetime] NOT NULL,
	[taj_modi_fecha] [datetime] NULL,
	[taj_baja_fecha] [datetime] NULL,
	[taj_usu_id] [int] NOT NULL,
	[taj_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.tarjetas add primary key nonclustered (taj_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tarjetas_venc]') AND type in (N'U'))
drop table dbo.tarjetas_venc
go
CREATE TABLE [dbo].[tarjetas_venc](
	[tcv_id] [int] NOT NULL,
	[tcv_taj] [int] NOT NULL,
	[tcv_fecha] [datetime] NOT NULL,
	[tcv_fecha_cierre] [datetime] NOT NULL,
	[tcv_saldo_pesos] [numeric](20, 6) NULL,
	[tcv_saldo_dolares] [numeric](20, 6) NULL,
	[tcv_pago_min] [numeric](20, 6) NULL,
	[tcv_incluye_fec_cierre] [varchar](1) NOT NULL,
	[tcv_ult_forma_pago] [varchar](20) NOT NULL,
	[tcv_obs] [varchar](255) NOT NULL,
	[tcv_p_alta_fecha] [datetime] NOT NULL,
	[tcv_p_modi_fecha] [datetime] NULL,
	[tcv_alta_fecha] [datetime] NOT NULL,
	[tcv_modi_fecha] [datetime] NULL,
	[tcv_baja_fecha] [datetime] NULL,
	[tcv_usu_id] [int] NOT NULL,
	[tcv_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.tarjetas_venc add primary key nonclustered (tcv_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trm_tramites]') AND type in (N'U'))
drop table dbo.trm_tramites
go
CREATE TABLE [dbo].[trm_tramites](
	[trm_id] [int] NOT NULL,
	[trm_ttt] [int] NOT NULL,
	[trm_trs] [int] NOT NULL,
	[trm_per] [int] NOT NULL,
	[trm_cta] [int] NOT NULL,
	[trm_numero] [varchar](50) NOT NULL,
	[trm_usu_crea] [int] NOT NULL,
	[trm_instruccion] [varchar](500) NOT NULL,
	[trm_riesgo_oper] [varchar](1) NOT NULL,
	[trm_obs] [varchar](500) NOT NULL,
	[trm_alta_fecha] [datetime] NOT NULL,
	[trm_modi_fecha] [datetime] NULL,
	[trm_baja_fecha] [datetime] NULL,
	[trm_usu_id] [int] NOT NULL,
	[trm_filer] [varchar](255) NULL) ON [PRIMARY]
GO

alter table dbo.trm_tramites add primary key nonclustered (trm_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trm_x_dato_cbo]') AND type in (N'U'))
drop table dbo.[trm_x_dato_cbo]
go
CREATE TABLE [dbo].[trm_x_dato_cbo](
	[tdx_id] [int] NOT NULL,
	[tdx_trm] [int] NOT NULL,
	[tdx_tdt] [int] NOT NULL,
	[tdx_valor] [int] NOT NULL,
	[tdx_obs] [varchar](255) NOT NULL,
	[tdx_alta_fecha] [datetime] NOT NULL,
	[tdx_modi_fecha] [datetime] NULL,
	[tdx_baja_fecha] [datetime] NULL,
	[tdx_usu_id] [int] NOT NULL,
	[tdx_filer] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.trm_x_dato_cbo add primary key nonclustered (tdx_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trm_x_dato_char]') AND type in (N'U'))
drop table dbo.[trm_x_dato_char]
go
CREATE TABLE [dbo].[trm_x_dato_char](
	[tdk_id] [int] NOT NULL,
	[tdk_trm] [int] NOT NULL,
	[tdk_tdt] [int] NOT NULL,
	[tdk_valor] [varchar](1) NOT NULL,
	[tdk_obs] [varchar](255) NOT NULL,
	[tdk_alta_fecha] [datetime] NOT NULL,
	[tdk_modi_fecha] [datetime] NULL,
	[tdk_baja_fecha] [datetime] NULL,
	[tdk_usu_id] [int] NOT NULL,
	[tdk_filer] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.trm_x_dato_char add primary key nonclustered (tdk_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trm_x_dato_date]') AND type in (N'U'))
drop table dbo.[trm_x_dato_date]
go
CREATE TABLE [dbo].[trm_x_dato_date](
	[tdd_id] [int] NOT NULL,
	[tdd_trm] [int] NOT NULL,
	[tdd_tdt] [int] NOT NULL,
	[tdd_valor] [datetime] NOT NULL,
	[tdd_obs] [varchar](255) NOT NULL,
	[tdd_alta_fecha] [datetime] NOT NULL,
	[tdd_modi_fecha] [datetime] NULL,
	[tdd_baja_fecha] [datetime] NULL,
	[tdd_usu_id] [int] NOT NULL,
	[tdd_filer] [varchar](255) NULL) ON [PRIMARY]
GO

alter table dbo.trm_x_dato_date add primary key nonclustered (tdd_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trm_x_dato_int]') AND type in (N'U'))
drop table dbo.[trm_x_dato_int]
go
CREATE TABLE [dbo].[trm_x_dato_int](
	[tdi_id] [int] NOT NULL,
	[tdi_trm] [int] NOT NULL,
	[tdi_tdt] [int] NOT NULL,
	[tdi_valor] [int] NOT NULL,
	[tdi_obs] [varchar](255) NOT NULL,
	[tdi_alta_fecha] [datetime] NOT NULL,
	[tdi_modi_fecha] [datetime] NULL,
	[tdi_baja_fecha] [datetime] NULL,
	[tdi_usu_id] [int] NOT NULL,
	[tdi_filer] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.trm_x_dato_int add primary key nonclustered (tdi_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trm_x_dato_num]') AND type in (N'U'))
drop table dbo.[trm_x_dato_num]
go
CREATE TABLE [dbo].[trm_x_dato_num](
	[tdn_id] [int] NOT NULL,
	[tdn_trm] [int] NOT NULL,
	[tdn_tdt] [int] NOT NULL,
	[tdn_valor] [numeric](10, 2) NOT NULL,
	[tdn_obs] [varchar](255) NOT NULL,
	[tdn_alta_fecha] [datetime] NOT NULL,
	[tdn_modi_fecha] [datetime] NULL,
	[tdn_baja_fecha] [datetime] NULL,
	[tdn_usu_id] [int] NOT NULL,
	[tdn_filer] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.trm_x_dato_num add primary key nonclustered (tdn_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[trm_x_dato_varc]') AND type in (N'U'))
drop table dbo.[trm_x_dato_varc]
go
CREATE TABLE [dbo].[trm_x_dato_varc](
	[tdv_id] [int] NOT NULL,
	[tdv_trm] [int] NOT NULL,
	[tdv_tdt] [int] NOT NULL,
	[tdv_valor] [varchar](100) NOT NULL,
	[tdv_obs] [varchar](255) NOT NULL,
	[tdv_alta_fecha] [datetime] NOT NULL,
	[tdv_modi_fecha] [datetime] NULL,
	[tdv_baja_fecha] [datetime] NULL,
	[tdv_usu_id] [int] NOT NULL,
	[tdv_filer] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.trm_x_dato_varc add primary key nonclustered (tdv_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_cmb_objetos]') AND type in (N'U'))
drop table dbo.[wf_cmb_objetos]
go
CREATE TABLE [dbo].[wf_cmb_objetos](
	[cob_id] [int] NOT NULL,
	[cob_sob] [int] NOT NULL,
	[cob_cambio_fecha] [datetime] NOT NULL,
	[cob_tipo] [varchar](30) NOT NULL,
	[cob_dato_ant] [int] NOT NULL,
	[cob_dato_nue] [int] NOT NULL,
	[cob_nombre_ant] [varchar](100) NOT NULL,
	[cob_nombre_nue] [varchar](100) NOT NULL,
	[cob_reg] [int] NOT NULL,
	[cob_obs] [varchar](100) NOT NULL,
	[cob_alta_fecha] [datetime] NOT NULL,
	[cob_modi_fecha] [datetime] NULL,
	[cob_baja_fecha] [datetime] NULL,
	[cob_usu_id] [int] NOT NULL,
	[cob_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.wf_cmb_objetos add primary key nonclustered (cob_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_eventos]') AND type in (N'U'))
drop table dbo.[wf_eventos]
go
CREATE TABLE [dbo].[wf_eventos](
	[eve_id] [int] NOT NULL,
	[eve_sob] [int] NOT NULL,
	[eve_evento] [int] NOT NULL,
	[eve_param] [varchar](30) NOT NULL,
	[eve_dias_min] [int] NOT NULL,
	[eve_reg] [int] NOT NULL,
	[eve_alta_fecha] [datetime] NOT NULL,
	[eve_modi_fecha] [datetime] NULL,
	[eve_baja_fecha] [datetime] NULL,
	[eve_usu_id] [int] NOT NULL,
	[eve_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.wf_eventos add primary key nonclustered (eve_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_obj_x_alm]') AND type in (N'U'))
drop table dbo.[wf_obj_x_alm]
go
CREATE TABLE [dbo].[wf_obj_x_alm](
	[oxa_id] [int] NOT NULL,
	[oxa_sob] [int] NOT NULL,
	[oxa_alm] [int] NOT NULL,
	[oxa_fecha] [datetime] NOT NULL,
	[oxa_texto] [varchar](500) NOT NULL,
	[oxa_usu] [int] NOT NULL,
	[oxa_alta_fecha] [datetime] NOT NULL,
	[oxa_modi_fecha] [datetime] NULL,
	[oxa_baja_fecha] [datetime] NULL,
	[oxa_usu_id] [int] NOT NULL,
	[oxa_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.wf_obj_x_alm add primary key nonclustered (oxa_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_obj_x_cmp]') AND type in (N'U'))
drop table dbo.wf_obj_x_cmp
go
CREATE TABLE [dbo].[wf_obj_x_cmp](
	[oxc_id] [int] NOT NULL,
	[oxc_sob] [int] NOT NULL,
	[oxc_cmp] [int] NOT NULL,
	[oxc_alta_fecha] [datetime] NOT NULL,
	[oxc_modi_fecha] [datetime] NULL,
	[oxc_baja_fecha] [datetime] NULL,
	[oxc_usu_id] [int] NOT NULL,
	[oxc_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.wf_obj_x_cmp add primary key nonclustered (oxc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_sit_objetos]') AND type in (N'U'))
drop table dbo.wf_sit_objetos
go
CREATE TABLE [dbo].[wf_sit_objetos](
	[sob_id] [int] NOT NULL,
	[sob_esc] [int] NOT NULL,
	[sob_etg] [int] NOT NULL,
	[sob_est] [int] NOT NULL,
	[sob_fec_esc] [datetime] NOT NULL,
	[sob_fec_etg] [datetime] NOT NULL,
	[sob_fec_est] [datetime] NOT NULL,
	[sob_fec_susp] [datetime] NULL,
	[sob_scr] [int] NOT NULL,
	[sob_usu_res] [int] NOT NULL,
	[sob_fec_hora_trab] [datetime] NULL,
	[sob_alta_fecha] [datetime] NOT NULL,
	[sob_modi_fecha] [datetime] NULL,
	[sob_baja_fecha] [datetime] NULL,
	[sob_usu_id] [int] NOT NULL,
	[sob_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.wf_sit_objetos add primary key nonclustered (sob_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wf_sob_atributos]') AND type in (N'U'))
drop table dbo.wf_sob_atributos
go
CREATE TABLE [dbo].[wf_sob_atributos](
	[sot_id] [int] NOT NULL,
	[sot_atr] [int] NOT NULL,
	[sot_fecha1] [datetime] NULL,
	[sot_fecha2] [datetime] NULL,
	[sot_fecha3] [datetime] NULL,
	[sot_fecha4] [datetime] NULL,
	[sot_fecha5] [datetime] NULL,
	[sot_fecha6] [datetime] NULL,
	[sot_fecha7] [datetime] NULL,
	[sot_fecha8] [datetime] NULL,
	[sot_fecha9] [datetime] NULL,
	[sot_fecha10] [datetime] NULL,
	[sot_texto1] [varchar](255) NULL,
	[sot_texto2] [varchar](255) NULL,
	[sot_texto3] [varchar](255) NULL,
	[sot_texto4] [varchar](255) NULL,
	[sot_texto5] [varchar](255) NULL,
	[sot_texto6] [varchar](255) NULL,
	[sot_texto7] [varchar](255) NULL,
	[sot_texto8] [varchar](255) NULL,
	[sot_texto9] [varchar](255) NULL,
	[sot_texto10] [varchar](255) NULL,
	[sot_numero1] [numeric](20, 6) NULL,
	[sot_numero2] [numeric](20, 6) NULL,
	[sot_numero3] [numeric](20, 6) NULL,
	[sot_numero4] [numeric](20, 6) NULL,
	[sot_numero5] [numeric](20, 6) NULL,
	[sot_numero6] [numeric](20, 6) NULL,
	[sot_numero7] [numeric](20, 6) NULL,
	[sot_numero8] [numeric](20, 6) NULL,
	[sot_numero9] [numeric](20, 6) NULL,
	[sot_numero10] [numeric](20, 6) NULL,
	[sot_coeficiente1] [numeric](8, 4) NULL,
	[sot_coeficiente2] [numeric](8, 4) NULL,
	[sot_coeficiente3] [numeric](8, 4) NULL,
	[sot_coeficiente4] [numeric](8, 4) NULL,
	[sot_coeficiente5] [numeric](8, 4) NULL,
	[sot_coeficiente6] [numeric](8, 4) NULL,
	[sot_coeficiente7] [numeric](8, 4) NULL,
	[sot_coeficiente8] [numeric](8, 4) NULL,
	[sot_coeficiente9] [numeric](8, 4) NULL,
	[sot_coeficiente10] [numeric](8, 4) NULL,
	[sot_obs] [varchar](255) NOT NULL,
	[sot_alta_fecha] [datetime] NOT NULL,
	[sot_modi_fecha] [datetime] NULL,
	[sot_baja_fecha] [datetime] NULL,
	[sot_p_alta_fecha] [datetime] NULL,
	[sot_p_modi_fecha] [datetime] NULL,
	[sot_usu_id] [int] NOT NULL,
	[sot_filler] [varchar](255) NOT NULL) ON [PRIMARY]
GO
alter table dbo.wf_sob_atributos add primary key nonclustered (sot_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_prestamos]') AND type in (N'U'))
drop table dbo.add_prestamos
go
CREATE TABLE [dbo].[add_prestamos](
	[apr_id] [int] NOT NULL,
	[apr_feci] [varchar](1) NULL,
	[apr_fec_proyectada] [datetime] NULL,
	[apr_sobretasa_poliza] [varchar](1) NULL,
	[apr_sobretasa_morosidad] [varchar](1) NULL,
	[apr_operacion_migrada] [varchar](24) NULL,
	[apr_codigo_entidad_origen] [varchar](20) NULL,
	[apr_requiere_negociacion] [varchar](1) NULL,
	[apr_tipo_renovacion] [varchar](5) NULL,
	[apr_codigo_periodo_cuota] [varchar](20) NULL,
	[apr_monto_baloon] [numeric](20, 6) NULL,
	[apr_castigo_abogado] [varchar](1) NULL,
	[apr_obs] [varchar](100) NOT NULL,
	[apr_alta_fecha] [datetime] NOT NULL,
	[apr_modi_fecha] [datetime] NULL,
	[apr_baja_fecha] [datetime] NULL,
	[apr_usu_id] [int] NOT NULL,
	[apr_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.add_prestamos add primary key nonclustered (apr_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_prestamos_cuotas]') AND type in (N'U'))
drop table dbo.add_prestamos_cuotas
go
CREATE TABLE [dbo].[add_prestamos_cuotas](
	[apc_id] [int] NOT NULL,
	[apc_imo] [numeric](16, 2) NULL,
	[apc_fecimo] [numeric](16, 2) NULL,
	[apc_opcion_compra] [numeric](16, 2) NULL,
	[apc_obs] [varchar](100) NOT NULL,
	[apc_alta_fecha] [datetime] NOT NULL,
	[apc_modi_fecha] [datetime] NULL,
	[apc_baja_fecha] [datetime] NULL,
	[apc_usu_id] [int] NOT NULL,
	[apc_filler] [varchar](255) NULL) ON [PRIMARY]
GO

alter table dbo.add_prestamos_cuotas add primary key nonclustered (apc_id)

GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[add_tarjetas]') AND type in (N'U'))
drop table dbo.add_tarjetas
go
CREATE TABLE [dbo].[add_tarjetas](
	[ata_id] [int] NOT NULL,
	[ata_tarjeta_adic] [varchar](1) NULL,
	[ata_nro_tarjeta_adic] [varchar](20) NULL,
	[ata_intereses_diferidos] [numeric](16, 2) NULL,
	[ata_porc_utilizacion] [numeric](5, 2) NULL,
	[ata_fec_apertura] [datetime] NULL,
	[ata_fec_ult_pago] [datetime] NULL,
	[ata_fec_ult_compra] [datetime] NULL,
	[ata_promo_1] [varchar](5) NULL,
	[ata_promo_2] [varchar](5) NULL,
	[ata_promo_3] [varchar](5) NULL,
	[ata_promo_4] [varchar](5) NULL,
	[ata_tipo_tarjeta] [varchar](1) NULL,
	[ata_cod_bloqueo_1] [varchar](1) NULL,
	[ata_cod_bloqueo_2] [varchar](1) NULL,
	[ata_cod_colateral] [varchar](2) NULL,
	[ata_monto_xdays] [numeric](16, 2) NULL,
	[ata_monto_30_dias] [numeric](16, 2) NULL,
	[ata_monto_60_dias] [numeric](16, 2) NULL,
	[ata_monto_90_dias] [numeric](16, 2) NULL,
	[ata_monto_120_dias] [numeric](16, 2) NULL,
	[ata_monto_150_dias] [numeric](16, 2) NULL,
	[ata_monto_180_dias] [numeric](16, 2) NULL,
	[ata_cuenta_a_debitar] [varchar](17) NULL,
	[ata_tipo_debito] [varchar](1) NULL,
	[ata_obs] [varchar](100) NOT NULL,
	[ata_alta_fecha] [datetime] NOT NULL,
	[ata_modi_fecha] [datetime] NULL,
	[ata_baja_fecha] [datetime] NULL,
	[ata_usu_id] [int] NOT NULL,
	[ata_filler] [varchar](255) NULL) ON [PRIMARY]
GO
alter table dbo.add_tarjetas add primary key nonclustered (ata_id)