SELECT object_name, created
FROM user_objects
WHERE object_type = 'TABLE'
AND created > TO_DATE('2025-09-20', 'YYYY-MM-DD');


