
SELECT 
       COLUMN_NAME AS  'ColumnName'
     , TABLE_SCHEMA AS 'Schema'
     , TABLE_NAME AS   'TableName'
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE COLUMN_NAME LIKE '%username%' OR COLUMN_NAME LIKE '%document%'
  ORDER BY 
           TableName
         , Table_SCHEMA;