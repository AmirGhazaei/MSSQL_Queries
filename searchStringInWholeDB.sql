USE DATABASE_NAME
GO

DECLARE @SQL VARCHAR(MAX) 
DECLARE @SearchString VARCHAR(100) 
SET @SQL='' 

-- ------------------------------------------ 
-- Enter the string to be searched for here : 
-- 
SET @SearchString='SearchString' 
-- ------------------------------------------ 

SELECT   @SQL = @SQL + 'SELECT CONVERT(VARCHAR(MAX),COUNT(*)) + '' matches in column ''+'''
         + C.name + '''+'' on table '' + ''' + SC.name + '.' + T.name + 
         ''' [Matches for '''+@SearchString+''':] FROM ' + 
         QUOTENAME(SC.name) + '.' + QUOTENAME(T.name) + ' WHERE ' + QUOTENAME(C.name) + 
         ' LIKE N''%' + @SearchString + 
         '%'' HAVING COUNT(*)>0 UNION ALL ' +CHAR(13) + CHAR(10) 
FROM     sys.columns C 
JOIN     sys.tables T 
ON       C.object_id=T.object_id 
JOIN     sys.schemas SC 
ON       SC.schema_id=T.schema_id 
JOIN     sys.types ST 
ON       C.user_type_id=ST.user_type_id 
JOIN     sys.types SYST 
ON       ST.system_type_id=SYST.user_type_id 
AND      ST.system_type_id=SYST.system_type_id 
WHERE    SYST.name IN ('varchar','nvarchar','text','ntext','char','nchar') 
ORDER BY T.name, C.name 

-- Strip off the last UNION ALL 
IF LEN(@SQL)>12 
  SELECT @SQL=LEFT(@SQL,LEN(@SQL)- 12) 

EXEC(@SQL) 
