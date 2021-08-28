IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmp_dependencias_SPV]') AND type in (N'U'))
drop table dbo.tmp_dependencias_SPV
go

create table dbo.tmp_dependencias_SPV (	tabla_ori	varchar	(50),
										tabla	varchar	(50),
										columna	varchar	(50))
go