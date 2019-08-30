IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_RationCard_Search]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_RationCard_Search]
GO 
--EXEC Sp_RationCard_Search 1,'PHONE', '9831125464', '','01/01/1900','12/12/2018'
--EXEC Sp_RationCard_Search 1,'RATIONCARD', 'RKSY-I-1205736042', '','01/01/1900','12/12/2019'
--EXEC Sp_RationCard_Search 1,'ADHAR', '570108660540', '','01/01/1900','12/12/2019'
--EXEC Sp_RationCard_Search 1,'HOF', 'ARINDAM', '','01/01/1900','12/12/2019'
--EXEC Sp_RationCard_Search 1,'NAME', 'MAHADEB DAS', '','01/01/1900','12/12/2019'
--EXEC Sp_RationCard_Search 1,'', '', '1','06/03/2016','12/12/2018'
--EXEC Sp_RationCard_Search 1,'', '', '','01/01/1900','12/12/2018'

CREATE PROCEDURE [dbo].[Sp_RationCard_Search]
	@distId VARCHAR(2),
	@searchBy VARCHAR(500),
	@searchText VARCHAR(500),
	@searchCatId VARCHAR(50),
	@dtFrom DATETIME,
	@dtTo DATETIME
		
AS
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY
	
	IF(@searchBy = 'PHONE')
	BEGIN
		EXEC Sp_RationCard_Search_By_Phone @distId, @searchText, @searchCatId, @dtFrom, @dtTo		
	END
	ELSE IF(@searchBy = 'RATIONCARD')
	BEGIN
		EXEC Sp_RationCard_Search_By_CardNo @distId, @searchText, @searchCatId, @dtFrom, @dtTo
	END
	ELSE IF(@searchBy = 'ADHAR')
	BEGIN
		EXEC Sp_RationCard_Search_By_Adhar @distId, @searchText, @searchCatId, @dtFrom, @dtTo
	END
	ELSE IF(@searchBy = 'NAME')
	BEGIN
		EXEC Sp_RationCard_Search_By_Name @distId, @searchText, @searchCatId, @dtFrom, @dtTo
	END
	ELSE IF(ISNULL(@searchBy, '') = '')
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
		--,dbo.Func_Hof_Member_Total_Count(C.Customer_Id, @distId) AS TOTAL_CARD_COUNT
		--,dbo.Func_Hof_Member_Active_Count(C.Customer_Id, @distId) AS ACTIVE_CARD_COUNT

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
		AND C.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId)

		SELECT @@ROWCOUNT AS RECORD_COUNT
	END		
	END TRY
	BEGIN CATCH
		SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END