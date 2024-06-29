USE db

DROP TABLE IF EXISTS #getset

    -- Instantiating the initial table.
    SELECT
        '' AS cpf,
        '' AS nome,
        '' AS email,
        '' AS phone
    INTO #getset

-- Generating code for defining keys in C# (always removing the first comma)
SELECT ', e.' + [name] 
FROM tempdb.sys.columns
WHERE OBJECT_ID = 
    (
        SELECT OBJECT_ID('tempdb..#getset') 
    )
ORDER BY column_id

-- Generating code to iterate the base if it is a dataframe
SELECT ', df["' + LOWER([name])  + '"][i]'
FROM tempdb.sys.columns
WHERE OBJECT_ID = 
    (
        SELECT OBJECT_ID('tempdb..#getset') 
    )
ORDER BY column_id

-- Generating create table syntax for MySQL, Hive, among others that use this syntax
SELECT ', `' + LOWER([name])  + '` string'
FROM tempdb.sys.columns
WHERE OBJECT_ID = 
    (
        SELECT OBJECT_ID('tempdb..#getset') 
    )
ORDER BY column_id

-- Generating create table syntax for SQL Server and others that use this syntax
SELECT ', [' + LOWER([name])  + '] varchar(1000)'
FROM tempdb.sys.columns
WHERE OBJECT_ID = 
    (
        SELECT OBJECT_ID('tempdb..#getset') 
    )
ORDER BY column_id

-- Generating a C# class (100% string) with the given data.
SELECT 'public String ' + [name] + ' {get; set;}'
FROM tempdb.sys.all_columns
WHERE object_id = (SELECT object_id('tempdb..#getset'))

-- (Modelable): generate different treatments for each datatype in C#.
SELECT 
    CASE
        WHEN B.system_type_id IN (61, 167) THEN 'if (string.IsNullOrEmpty(list.' + A.[name] + ')) {list.' + A.[name] + ' = ""; }'
        WHEN B.system_type_id IN (106, 127) THEN 'if (lead.' + A.[name] + ' == null) {list.' + A.[name] + ' = 0; }'
        ELSE ''
    END AS [C#Structure],
    B.[name],
    B.system_type_id
FROM sys.all_columns A
INNER JOIN sys.types B ON A.system_type_id = B.system_type_id
WHERE object_id = 
    (
        SELECT object_id('TableName')
    )
