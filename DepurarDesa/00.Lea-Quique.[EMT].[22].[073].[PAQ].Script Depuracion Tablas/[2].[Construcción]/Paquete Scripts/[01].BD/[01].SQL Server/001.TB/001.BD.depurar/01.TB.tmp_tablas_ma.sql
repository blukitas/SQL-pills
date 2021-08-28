IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tmp_tablas_ma]') AND type in (N'U'))
drop table dbo.tmp_tablas_ma
create table dbo.tmp_tablas_ma (tabla_ma varchar(50))
go
insert into tmp_tablas_ma values('ng_acu_operaciones')
insert into tmp_tablas_ma values('ng_cuotas')
insert into tmp_tablas_ma values('ng_lote_conceptos_x_deudor')
insert into tmp_tablas_ma values('ng_movimientos')
insert into tmp_tablas_ma values('ng_lote_compon_deuda')
insert into tmp_tablas_ma values('ng_lotes_det')
insert into tmp_tablas_ma values('ng_lotes_det_adic')
insert into tmp_tablas_ma values('ng_acuerdos')
go