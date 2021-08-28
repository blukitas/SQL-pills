USE emt_supervielle_desa
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tablas_depurar_SPV]') AND type in (N'U'))
drop table [dbo].[tablas_depurar_SPV]

CREATE TABLE [dbo].[tablas_depurar_SPV](
	[atd_tabla] [varchar](30) NULL,
	[atd_SP] [varchar](50) NULL,
	[atd_orden] [int] NULL,
	[atd_obs] [varchar](255) NULL,
	[atd_alta_fecha] [datetime] NOT NULL,
	[atd_modi_fecha] [datetime] NULL,
	[atd_baja_fecha] [datetime] NULL,
	[atd_usu_id] [int] NULL,
	[atd_filler] [varchar](255) NULL
) ON [PRIMARY]
GO