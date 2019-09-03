IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Catwise_Count]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Catwise_Count]
GO 
--EXEC Sp_Catwise_Count 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_Catwise_Count]
	@distId VARCHAR(50)
		
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @finalCount TABLE
	(
		Cat_Id VARCHAR(20)
		,Cat_Desc VARCHAR(20)
		,CARD_COUNT INT
		,FAMILY_COUNT INT
	)
	
	INSERT INTO @finalCount
	SELECT 
	
	CAT.Cat_Id
	,CAT.Cat_Desc
	,COUNT(R.RationCard_Id) AS CARD_COUNT
	,COUNT(C.Customer_Id) AS FAMILY_COUNT
	
	FROM Mst_Cat AS CAT
	LEFT JOIN Txn_RationCard AS R
	ON R.Card_Category_Id = CAT.Cat_Id
	AND R.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId)

	LEFT JOIN Mst_Customer AS C
	ON C.Customer_Id = R.Customer_Id AND C.Hof_Flag=1
	GROUP BY CAT.Cat_Id, CAT.Cat_Desc

	INSERT INTO @finalCount
	SELECT

	'0'
	,'TOTAL'
	,SUM(CARD_COUNT)
	,SUM(FAMILY_COUNT)

	FROM @finalCount

	SELECT * FROM @finalCount

END