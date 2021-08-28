

SELECT 
       SCHEMA_NAME(t.schema_id)
     , t.name
     , t.object_id
     , i.type_desc
     , *
  FROM sys.tables t
    INNER JOIN SYS.INDEXES i ON t.object_id = i.object_id;