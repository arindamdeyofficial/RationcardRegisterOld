IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_CardsInThisFortnight]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_CardsInThisFortnight]
GO 
--EXEC Sp_CardsInThisFortnight 1
CREATE PROCEDURE [dbo].[Sp_CardsInThisFortnight]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @fortnightDivider INT
	DECLARE @count INT, @maxRecords INT
	DECLARE @finalCards TABLE
	(
		RationcardNumbers VARCHAR(50)
	)

	SELECT @fortnightDivider = ValueText FROM App_Config WHERE KeyText = 'FortNightDevideDay' AND Dist_Id = @distId
	
	SELECT RANK () OVER (ORDER BY RationcardNumbers) AS RowNum,
	RationcardNumbers
	INTO #CardsWithDuplicate
	FROM Bill_Master 
	WHERE Dist_Id = @distId
	AND 1 = CASE WHEN (DATEPART(day, GETDATE()) <= @fortnightDivider) 
		THEN  
			CASE WHEN (DATEPART(day, Created_Date) <= @fortnightDivider) THEN 1 ELSE 0 END
		ELSE 
			CASE WHEN (DATEPART(day, Created_Date) > @fortnightDivider) THEN 1 ELSE 0 END
		END
	AND DATEPART(year, Created_Date) = DATEPART(year, GETDATE())
	AND DATEPART(month, Created_Date) = DATEPART(month, GETDATE())

	SET @maxRecords = @@ROWCOUNT

	--select * from #CardsWithDuplicate

	SET @count = 1
	WHILE(@count <= @maxRecords)
	BEGIN
		DECLARE @strToSplit VARCHAR(1000)
		SELECT @strToSplit = RationcardNumbers
		FROM #CardsWithDuplicate
		WHERE RowNum = @count

		INSERT INTO @finalCards
		SELECT * FROM [dbo].Func_SplitString(@strToSplit, ',')

		SET @count = @count + 1
	END

	SELECT TRIM(RationcardNumbers) AS RationcardNumbers FROM @finalCards
	
	DROP TABLE #CardsWithDuplicate

END 