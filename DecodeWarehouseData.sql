USE [kn_online]
GO

/****** Object:  StoredProcedure [dbo].[DecodeWarehouseData]    Script Date: 27.06.2024 10:26:04    Author: erthejosea ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DecodeWarehouseData]
    @StrUserID VARCHAR(30)
AS
BEGIN
    DECLARE @DynamicColumnName NVARCHAR(MAX);
    SET @DynamicColumnName = 'Items of ' + @StrUserID;

    DECLARE @SQL NVARCHAR(MAX);
    
    SET @SQL = '
    WITH WarehouseCTE AS (
        SELECT 
            strAccountID,
            WarehouseData,
            1 AS StartPos,
            DATALENGTH(WarehouseData) AS DataLength
        FROM WAREHOUSE
        WHERE strAccountID = ''' + @StrUserID + '''
        UNION ALL
        SELECT 
            strAccountID,
            WarehouseData,
            StartPos + 8,
            DataLength
        FROM WarehouseCTE
        WHERE StartPos + 8 <= DataLength
    )
    SELECT         
        ItemDetails.ItemNumber,
		I.strName AS [' + @DynamicColumnName + '],
        ItemDetails.Duration,
        ItemDetails.StackSize
        
    FROM (
        SELECT 
            strAccountID,
            CAST(CONVERT(INT, 
                SUBSTRING(WarehouseData, StartPos + 3, 1) + 
                SUBSTRING(WarehouseData, StartPos + 2, 1) + 
                SUBSTRING(WarehouseData, StartPos + 1, 1) + 
                SUBSTRING(WarehouseData, StartPos, 1)) AS INT) AS ItemNumber,
            CAST(CONVERT(SMALLINT, 
                SUBSTRING(WarehouseData, StartPos + 5, 1) + 
                SUBSTRING(WarehouseData, StartPos + 4, 1)) AS SMALLINT) AS Duration,
            CAST(CONVERT(SMALLINT, 
                SUBSTRING(WarehouseData, StartPos + 7, 1) + 
                SUBSTRING(WarehouseData, StartPos + 6, 1)) AS SMALLINT) AS StackSize
        FROM WarehouseCTE
        WHERE StartPos + 7 <= DataLength
    ) AS ItemDetails
    INNER JOIN ITEM I ON ItemDetails.ItemNumber = I.Num
    INNER JOIN WAREHOUSE W ON W.strAccountID = ItemDetails.strAccountID
    OPTION (MAXRECURSION 0);';

    EXEC sp_executesql @SQL;
END;
GO


