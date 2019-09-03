IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_RationCard_Search_By_Name]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_RationCard_Search_By_Name]
GO 
--EXEC Sp_RationCard_Search_By_Name 1, 'MILAN PRABHA DUTTA', '','06/03/2016','12/12/2018'
--EXEC Sp_RationCard_Search_By_Name 1, 'SAMIR DUTTA', '','01/01/1900','12/12/2018'

CREATE PROCEDURE [dbo].[Sp_RationCard_Search_By_Name]
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
DECLARE @CustInfo TABLE
(
	RATIONCARD_NO VARCHAR(50)
	,Adhar_No VARCHAR(20)
	,Mobile_No VARCHAR(20)
	,HOF_NAME VARCHAR(500)
	,Name VARCHAR(500)
	,Age INT
	,Address VARCHAR(500)
	,STATUS BIT
	,Created_Date VARCHAR(50)
	,Cat_Desc VARCHAR(30)
	,Customer_Id INT		
	,Hof_Flag BIT
	,Hof_Id	 INT	
	,RationCard_Id INT		
	,Cat_Id INT
	,Remarks VARCHAR(MAX)
	,Relation_With_Hof VARCHAR(40)
	,Gaurdian_Name VARCHAR(500)
	,Gaurdian_Relation VARCHAR(200)
	,Dist_Id VARCHAR(10)
	--,TOTAL_CARD_COUNT VARCHAR(10)
	--,ACTIVE_CARD_COUNT VARCHAR(10)
)

INSERT INTO @CustInfo 
(
	RATIONCARD_NO
	,Adhar_No
	,Mobile_No
	,HOF_NAME
	,Name
	,Age
	,Address
	,STATUS
	,Created_Date
	,Cat_Desc
	,Customer_Id		
	,Hof_Flag
	,Hof_Id	
	,RationCard_Id
	,Cat_Id
	,Remarks
	,Relation_With_Hof
	,Gaurdian_Name
	,Gaurdian_Relation
	,Dist_Id
	--,TOTAL_CARD_COUNT
	--,ACTIVE_CARD_COUNT
)
SELECT DISTINCT
		
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
		,C1.Hof_Id		
		,C.RationCard_Id		
		,CAT.Cat_Id
		,R.Remarks
		,C.Relation_With_Hof
		,C.Gaurdian_Relation
		,C.Gaurdian_Name
		,C.Dist_Id
		--,[dbo].Func_Hof_Member_Total_Count(C.Customer_Id, @distId) AS TOTAL_CARD_COUNT
		--,[dbo].Func_Hof_Member_Active_Count(C.Customer_Id, @distId) AS ACTIVE_CARD_COUNT

FROM Mst_Customer AS C	
LEFT JOIN Mst_Customer AS C1
ON C.Hof_Id = C1.Customer_Id
INNER JOIN Txn_RationCard AS R
ON R.Customer_Id = C.Customer_Id AND Card_Category_Id= CASE WHEN ISNULL(@searchCatId, '') = '' THEN Card_Category_Id ELSE @searchCatId END
LEFT JOIN Mst_Cat AS CAT
ON CAT.Cat_Id = R.Card_Category_Id
WHERE CASE WHEN @searchText= '' THEN 1 ELSE 
		CASE WHEN (C.Name LIKE '%' + @searchText + '%') THEN 1 ELSE 0 END 
	END = 1
AND C.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId)
AND ((C.Created_Date >= @dtFrom AND C.Created_Date <= @dtTo)
		 OR (C.Last_Updated_Date >= @dtFrom AND C.Last_Updated_Date <= @dtTo))

--SELECT * FROM @CustInfo

SELECT DISTINCT * FROM
(
--non Hof who doesn't have HOF
SELECT 

		RATIONCARD_NO
		,Adhar_No
		,Mobile_No
		,HOF_NAME
		,Name
		,Age
		,Address
		,STATUS
		,CONVERT(VARCHAR(19),C.Created_Date, 101) AS Created_Date
		,Cat_Desc
		,C.Customer_Id		
		,C.Hof_Flag
		,ISNULL(C.Hof_Id, 0) AS Hof_Id		
		,C.RationCard_Id		
		,Cat_Id
		,Remarks
		,Relation_With_Hof
		,Gaurdian_Name
		,Gaurdian_Relation
		,Dist_Id
		--,TOTAL_CARD_COUNT
		--,ACTIVE_CARD_COUNT

FROM @CustInfo AS C
WHERE ISNULL(C.Hof_Flag, 0) = 0 AND ISNULL(C.Hof_Id, 0) = 0

--non Hof who's HOF is not in search result
UNION ALL
SELECT 

		R.Number AS RATIONCARD_NO
		,C.Adhar_No
		,C.Mobile_No
		,C1.HOF_NAME
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
		--,[dbo].Func_Hof_Member_Total_Count(C.Customer_Id, @distId) AS TOTAL_CARD_COUNT
		--,[dbo].Func_Hof_Member_Active_Count(C.Customer_Id, @distId) AS ACTIVE_CARD_COUNT

FROM Mst_Customer AS C
INNER JOIN @CustInfo AS C1
ON C.Hof_Id = C1.Hof_Id AND C1.Hof_Flag = 0 AND C1.Hof_Id NOT IN (SELECT Customer_Id FROM @CustInfo)
INNER JOIN Txn_RationCard AS R
ON R.Customer_Id = C.Customer_Id AND Card_Category_Id= CASE WHEN ISNULL(@searchCatId, '') = '' THEN Card_Category_Id ELSE @searchCatId END
LEFT JOIN Mst_Cat AS CAT
ON CAT.Cat_Id = R.Card_Category_Id

UNION ALL
--Family member of HOF AND HOF
SELECT 

		R.Number AS RATIONCARD_NO
		,C.Adhar_No
		,C.Mobile_No
		,C1.HOF_NAME
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
		--,[dbo].Func_Hof_Member_Total_Count(C.Customer_Id, @distId) AS TOTAL_CARD_COUNT
		--,[dbo].Func_Hof_Member_Active_Count(C.Customer_Id, @distId) AS ACTIVE_CARD_COUNT

FROM Mst_Customer AS C
INNER JOIN @CustInfo as C1
ON C.Hof_Id = C1.Hof_Id AND C.Hof_Id IN (--only HOF
	SELECT Customer_Id FROM @CustInfo AS C
	WHERE C.Hof_Flag = 1
)
LEFT JOIN Mst_Customer AS C2
ON C1.Hof_Id = C2.Customer_Id
INNER JOIN Txn_RationCard AS R
ON R.Customer_Id = C.Customer_Id AND Card_Category_Id= CASE WHEN ISNULL(@searchCatId, '') = '' THEN Card_Category_Id ELSE @searchCatId END
LEFT JOIN Mst_Cat AS CAT
ON CAT.Cat_Id = R.Card_Category_Id
) ALL_RECORD

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
		,ISNULL(C1.Hof_Id, 0) AS Hof_Id	
		,C.RationCard_Id		
		,CAT.Cat_Id
		,R.Remarks
		,C.Relation_With_Hof
		,C.Gaurdian_Name
		,C.Gaurdian_Relation
		,C.Dist_Id
		--,[dbo].Func_Hof_Member_Total_Count(C.Customer_Id, @distId) AS TOTAL_CARD_COUNT
		--,[dbo].Func_Hof_Member_Active_Count(C.Customer_Id, @distId) AS ACTIVE_CARD_COUNT

		FROM Mst_Customer AS C
		LEFT JOIN Mst_Customer AS C1
		ON C.Hof_Id = C1.Customer_Id
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