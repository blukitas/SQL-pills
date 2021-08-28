IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmp_dependencias_BGP]') AND type in (N'U'))
drop table dbo.tmp_dependencias_BGP
go

create table dbo.tmp_dependencias_BGP (	tabla_ori	varchar	(50),
										tabla	varchar	(50),
										columna	varchar	(50))
go