USE emt_supervielle_desa_prueba
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tablas_depurar_SPV]') AND type in (N'U'))
	drop table [dbo].[tablas_depurar_SPV]

CREATE TABLE [dbo].[tablas_depurar_SPV](
	[atd_tabla] [varchar](30) NOT NULL,
	[atd_SP] [varchar](50) NOT NULL,
	[atd_orden] [int] NOT NULL,
	[atd_ultima_ejecucion] [datetime] NULL,
	[atd_periodicidad] [int] NOT NULL,
	[atd_obs] [varchar](255) NULL,
	[atd_alta_fecha] [datetime] NOT NULL,
	[atd_modi_fecha] [datetime] NULL,
	[atd_baja_fecha] [datetime] NULL,
	[atd_usu_id] [int] NULL,
	[atd_filler] [varchar](255) NULL
) ON [PRIMARY]
GO