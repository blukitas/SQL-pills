select s.name as schema_name, 
    s.schema_id,
    u.name as schema_owner
from sys.schemas s
    inner join sys.sysusers u
        on u.uid = s.principal_id
where u.name = 'dbo' --Sin esto trae los distintos esquemas
order by s.name
