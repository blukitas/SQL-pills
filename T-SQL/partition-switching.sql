-- Replace live with staging
BEGIN TRAN
TRUNCATE TABLE DataTable;
ALTER TABLE DataTable_Staging SWITCH TO DataTable;
COMMIT
 
-- Swap live and staging
/* Note: An extra table, DataTable_Old, is required to temporarily hold the data being replaced before it is moved into DataTable_Staging. The rename-based approach did not require this extra table. */
BEGIN TRAN
ALTER TABLE DataTable SWITCH TO DataTable_Old;
ALTER TABLE DataTable_Staging SWITCH TO DataTable;
ALTER TABLE DataTable_Old SWITCH TO DataTable_Staging;
COMMIT