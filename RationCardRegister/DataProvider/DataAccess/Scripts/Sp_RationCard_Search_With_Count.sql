IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_RationCard_Search_With_Count]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_RationCard_Search_With_Count]
GO 
--EXEC Sp_RationCard_Search_With_Count 'jayanta98314@gmail.com', 'PHH-0050718333', '','06/03/2016','12/12/2018'
--EXEC Sp_RationCard_Search_With_Count 'jayanta98314@gmail.com', '', '1','01/01/1900','12/12/2018'

CREATE PROCEDURE [dbo].[Sp_RationCard_Search_With_Count]
	@distId VARCHAR(2),
	@searchText VARCHAR(500),
	@searchCatId VARCHAR(50),
	@dtFrom DATETIME,
	@dtTo DATETIME
		
AS
BEGIN
	
SET NOCOUNT ON;
	
IF(@searchText <> '')
BEGIN	
--DECLARE @CustInfo TABLE
--(
--	RATIONCARD_NO VARCHAR(50)
--	,Adhar_No VARCHAR(20)
--	,Mobile_No VARCHAR(20)
--	,HOF_NAME VARCHAR(500)
--	,Name VARCHAR(500)
--	,Age INT
--	,Address VARCHAR(500)
--	,STATUS BIT
--	,Created_Date VARCHAR(50)
--	,Cat_Desc VARCHAR(30)
--	,Customer_Id INT		
--	,Hof_Flag BIT
--	,Hof_Id	 INT	
--	,RationCard_Id INT		
--	,Cat_Id INT
--	,Remarks VARCHAR(MAX)
--	,Relation_With_Hof VARCHAR(40)
--	,Gaurdian_Name VARCHAR(500)
--	,Gaurdian_Relation VARCHAR(200)
--	,Dist_Id VARCHAR(10)
--	,TOTAL_CARD_COUNT VARCHAR(10)
--	,ACTIVE_CARD_COUNT VARCHAR(10)
--)


SELECT
		
		R.Number AS RATIONCARD_NO
		,C.Adhar_No
		,C.Mobile_No
		,dbo.Func_Hof_Name_By_Hof_Id(C.Hof_Id, @distId) AS HOF_NAME
		,C.Name
		,C.Age
		,C.Address
		,R.Active AS STATUS
		,CASE WHEN (R.Active = 1) THEN CONVERT(VARCHAR(19),C.Created_Date, 101) 
		ELSE CONVERT(VARCHAR(19),C.Inactivated_Date, 101) 
		END AS Created_Date
		,CAT.Cat_Desc
		,C.Customer_Id		
		,C.Hof_Flag
		,ISNULL(C.Hof_Id, 0) AS Hof_Id	
		,C.RationCard_Id		
		,CAT.Cat_Id
		,R.Remarks
		,C.Relation_With_Hof
		,C.Gaurdian_Name
		,C.Gaurdian_Relation
		,C.Dist_Id
		,[dbo].Func_Hof_Member_Total_Count(Hof_Id, @distId) AS TOTAL_COUNT
		,[dbo].Func_Hof_Member_Active_Count(Hof_Id, @distId) AS ACTIVE_COUNT

FROM Mst_Customer AS C	
INNER JOIN Txn_RationCard AS R
ON R.Customer_Id = C.Customer_Id AND Card_Category_Id= CASE WHEN ISNULL(@searchCatId, '') = '' THEN Card_Category_Id ELSE @searchCatId END
LEFT JOIN Mst_Cat AS CAT
ON CAT.Cat_Id = R.Card_Category_Id
WHERE CASE WHEN @searchText= '' THEN 1 ELSE 
		CASE WHEN (R.Number like ('%' + @searchText)) THEN 1 ELSE 0 END 
	END = 1
AND C.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId)
AND ((C.Created_Date >= @dtFrom AND C.Created_Date <= @dtTo)
		 OR (C.Last_Updated_Date >= @dtFrom AND C.Last_Updated_Date <= @dtTo))

END
ELSE
BEGIN
	
	SELECT  
		
		R.Number AS RATIONCARD_NO
		,C.Adhar_No
		,C.Mobile_No
		,dbo.Func_Hof_Name_By_Hof_Id(C.Hof_Id, @distId) AS HOF_NAME
		,C.Name
		,C.Age
		,C.Address
		,R.Active AS STATUS
		,CASE WHEN (R.Active = 1) THEN CONVERT(VARCHAR(19),C.Created_Date, 101) 
		ELSE CONVERT(VARCHAR(19),C.Inactivated_Date, 101) 
		END AS Created_Date
		,CAT.Cat_Desc
		,C.Customer_Id		
		,C.Hof_Flag
		,ISNULL(C.Hof_Id, 0) AS Hof_Id		
		,C.RationCard_Id		
		,CAT.Cat_Id
		,R.Remarks
		,C.Relation_With_Hof
		,C.Gaurdian_Name
		,C.Gaurdian_Relation
		,C.Dist_Id
		,[dbo].Func_Hof_Member_Total_Count(C.Hof_Id, @distId) AS TOTAL_COUN
		,[dbo].Func_Hof_Member_Active_Count(Hof_Id, @distId) AS ACTIVE_COUNT

		FROM Mst_Customer AS C
		INNER JOIN Txn_RationCard AS R
		ON R.Customer_Id = C.Customer_Id
		AND R.Card_Category_Id= CASE WHEN ISNULL(@searchCatId, '') = '' THEN Card_Category_Id ELSE @searchCatId END
		LEFT JOIN Mst_Cat AS CAT
		ON CAT.Cat_Id = R.Card_Category_Id
		WHERE ((C.Created_Date >= @dtFrom AND C.Created_Date <= @dtTo)
		 OR (C.Last_Updated_Date >= @dtFrom AND C.Last_Updated_Date <= @dtTo))
END

SELECT @@ROWCOUNT AS RECORD_COUNT

END