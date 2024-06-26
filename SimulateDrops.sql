USE [kn_online]
GO

/****** Object:  StoredProcedure [dbo].[SimulateDrops]    Script Date: 25.06.2024 22:23:04  ******/
/*Author: erthejosea*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SimulateDrops2]
    @MonsterSSID INT,
    @NumKills INT = 10000
AS
BEGIN
    
    SELECT DISTINCT TOP(5)
        K_NPCPOS.ZoneID,
        K_NPCPOS.NPCId,
        k_monster.strName,
        k_monster_item.iItem01,
        k_monster_item.sPersent01,
        k_monster_item.iItem02,
        k_monster_item.sPersent02,
        k_monster_item.iItem03,
        k_monster_item.sPersent03,
        k_monster_item.iItem04,
        k_monster_item.sPersent04,
        k_monster_item.iItem05,
        k_monster_item.sPersent05
    INTO #TempKDrops
    FROM K_NPCPOS
    JOIN k_monster ON K_NPCPOS.NPCId = k_monster.ssid
    JOIN k_monster_item ON K_NPCPOS.NPCId = k_monster_item.sindex
    WHERE k_monster.ssid = @MonsterSSID;

    SELECT 
        g.iItemGroupNum,
        g.iItem_1, g.iItem_2, g.iItem_3, g.iItem_4, g.iItem_5,
        g.iItem_6, g.iItem_7, g.iItem_8, g.iItem_9, g.iItem_10,
        g.iItem_11, g.iItem_12, g.iItem_13, g.iItem_14, g.iItem_15,
        g.iItem_16, g.iItem_17, g.iItem_18, g.iItem_19, g.iItem_20,
        g.iItem_21, g.iItem_22, g.iItem_23, g.iItem_24, g.iItem_25,
        g.iItem_26, g.iItem_27, g.iItem_28, g.iItem_29, g.iItem_30
    INTO #TempItemGroups
    FROM MAKE_ITEM_Group g
    JOIN #TempKDrops d ON g.iItemGroupNum IN (
        d.iItem01, d.iItem02, d.iItem03, d.iItem04, d.iItem05
    );

    
    CREATE TABLE #SimulatedDrops (
        ItemID INT,
        DropCount INT
    );

    
    DECLARE @KillCount INT = 0;
    DECLARE @RandValue FLOAT;
    DECLARE @DropChance INT;
    DECLARE @GroupNum INT;
    DECLARE @ItemID INT;

    
    WHILE @KillCount < @NumKills
    BEGIN
        
        SET @KillCount = @KillCount + 1;

        
        DECLARE DropCursor CURSOR FOR
        SELECT iItem01, sPersent01 FROM #TempKDrops
        UNION ALL
        SELECT iItem02, sPersent02 FROM #TempKDrops
        UNION ALL
        SELECT iItem03, sPersent03 FROM #TempKDrops
        UNION ALL
        SELECT iItem04, sPersent04 FROM #TempKDrops
        UNION ALL
        SELECT iItem05, sPersent05 FROM #TempKDrops;

        OPEN DropCursor;
        FETCH NEXT FROM DropCursor INTO @GroupNum, @DropChance;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            
            SET @RandValue = RAND() * 10000;

            
            IF @RandValue <= @DropChance
			 PRINT 'RandomValue: ' + CAST(@RandValue AS VARCHAR(10));
             PRINT 'DropChance: ' + CAST(@DropChance AS VARCHAR(10));
            BEGIN
                
                SELECT TOP 1 @ItemID = CASE WHEN @GroupNum = iItemGroupNum THEN
                    CASE FLOOR(RAND() * 30)
                        WHEN 0 THEN iItem_1
                        WHEN 1 THEN iItem_2
                        WHEN 2 THEN iItem_3
                        WHEN 3 THEN iItem_4
                        WHEN 4 THEN iItem_5
                        WHEN 5 THEN iItem_6
                        WHEN 6 THEN iItem_7
                        WHEN 7 THEN iItem_8
                        WHEN 8 THEN iItem_9
                        WHEN 9 THEN iItem_10
                        WHEN 10 THEN iItem_11
                        WHEN 11 THEN iItem_12
                        WHEN 12 THEN iItem_13
                        WHEN 13 THEN iItem_14
                        WHEN 14 THEN iItem_15
                        WHEN 15 THEN iItem_16
                        WHEN 16 THEN iItem_17
                        WHEN 17 THEN iItem_18
                        WHEN 18 THEN iItem_19
                        WHEN 19 THEN iItem_20
                        WHEN 20 THEN iItem_21
                        WHEN 21 THEN iItem_22
                        WHEN 22 THEN iItem_23
                        WHEN 23 THEN iItem_24
                        WHEN 24 THEN iItem_25
                        WHEN 25 THEN iItem_26
                        WHEN 26 THEN iItem_27
                        WHEN 27 THEN iItem_28
                        WHEN 28 THEN iItem_29
                        WHEN 29 THEN iItem_30
                    END
                END
                FROM #TempItemGroups;

                
                INSERT INTO #SimulatedDrops (ItemID, DropCount)
                VALUES (@ItemID, 1);
            END;

            FETCH NEXT FROM DropCursor INTO @GroupNum, @DropChance;
        END;

        CLOSE DropCursor;
        DEALLOCATE DropCursor;
    END;

    
    SELECT 
        sd.ItemID, 
		i.strName,
        COUNT(*) AS TotalDropCount        
    FROM 
        #SimulatedDrops sd
    JOIN 
        ITEM i ON sd.ItemID = i.Num
    GROUP BY 
        sd.ItemID, i.strName
    ORDER BY 
        TotalDropCount DESC;

	--SELECT * FROM #TempKDrops

    
    DROP TABLE #TempKDrops;
    DROP TABLE #TempItemGroups;
    DROP TABLE #SimulatedDrops;
END;
GO


