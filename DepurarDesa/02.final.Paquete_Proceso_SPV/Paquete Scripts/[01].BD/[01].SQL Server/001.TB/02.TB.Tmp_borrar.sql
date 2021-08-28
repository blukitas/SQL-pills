IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmp_borrar]') AND type in (N'U'))
	drop table [dbo].[tmp_borrar]

CREATE TABLE [dbo].[tmp_borrar](
	[tabla] [varchar](30) NULL,
	[id] [int] NULL
) ON [PRIMARY]
GO