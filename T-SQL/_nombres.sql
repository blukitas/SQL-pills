SELECT OBJECT_NAME(object_id)
    FROM sys.sql_modules
    WHERE --OBJECTPROPERTY(object_id, 'IsProcedure') = 1
    --AND 
	definition LIKE '%bulk%'

	P_VuelcoCENDEU
--P_DataScience_ProcesoDiario
--P_OperacionesCambio --DataScience_OPECAM_TMP
--P_SituacionOperaciones --DataScience_SITOPE_TMP
--P_ReporteTransferencias --DataScience_TRANSF_TMP