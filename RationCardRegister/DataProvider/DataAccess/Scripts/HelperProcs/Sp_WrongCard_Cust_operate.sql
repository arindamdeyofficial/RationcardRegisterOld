IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_WrongCard_Cust_operate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_WrongCard_Cust_operate]
GO 
--EXEC Sp_WrongCard_Cust_operate 1, 'VIEW'
--EXEC Sp_WrongCard_Cust_operate 1, 'DELETE'
CREATE PROCEDURE [dbo].[Sp_WrongCard_Cust_operate]
	@distId VARCHAR(50),
	@operation VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	BEGIN TRY
	DECLARE @txn_RationCard TABLE
	(
		RationCard_Id INT,
		Number VARCHAR(100) NULL,
		Card_Category_Id INT,
		Customer_Id INT,
		Dist_Id INT,
		Remarks VARCHAR(MAX),
		Active BIT,
		Created_Date DATETIME,
		Last_Updated_Date DATETIME,
		Inactivated_Date DATETIME,
		Updated_By VARCHAR(20)
	)

	DECLARE @mst_Customer TABLE
	(
		Customer_Id INT,
		Name VARCHAR(1000) NULL,
		Hof_Flag BIT,
		Age INT,
		Address VARCHAR(MAX),
		RationCard_Id VARCHAR(30),
		Hof_Id INT, --customer_id of the Hof
		Dist_Id INT,
		Adhar_No VARCHAR(50),
		Relation_With_Hof VARCHAR(100),
		Gaurdian_Name VARCHAR(1000),
		Gaurdian_Relation VARCHAR(100),
		Mobile_No VARCHAR(20),
		Active BIT,
		Created_Date DATETIME,
		Inactivated_Date DATETIME,
		Last_Updated_Date DATETIME,
		Updated_By VARCHAR(20)
	)

	INSERT INTO @txn_RationCard
	(
		RationCard_Id,
		Number,
		Card_Category_Id,
		Customer_Id,
		Dist_Id,
		Remarks,
		Active,
		Created_Date,
		Last_Updated_Date,
		Inactivated_Date,
		Updated_By
	)
	SELECT
		RationCard_Id,
		Number,
		Card_Category_Id,
		Customer_Id,
		Dist_Id,
		Remarks,
		Active,
		Created_Date,
		Last_Updated_Date,
		Inactivated_Date,
		Updated_By
	FROM Txn_RationCard 
	WHERE TRIM(Substring(Number, CHARINDEX('-', Number)+1, LEN(Number))) = '' 
	ORDER BY Number

	INSERT INTO @mst_Customer
	(
		Customer_Id,
		Name,
		Hof_Flag,
		Age,
		Address,
		RationCard_Id,
		Hof_Id,
		Dist_Id,
		Adhar_No,
		Relation_With_Hof,
		Gaurdian_Name,
		Gaurdian_Relation,
		Mobile_No,
		Active,
		Created_Date,
		Inactivated_Date,
		Last_Updated_Date,
		Updated_By
	)
	SELECT
		Customer_Id,
		Name,
		Hof_Flag,
		Age,
		Address,
		RationCard_Id,
		Hof_Id,
		Dist_Id,
		Adhar_No,
		Relation_With_Hof,
		Gaurdian_Name,
		Gaurdian_Relation,
		Mobile_No,
		Active,
		Created_Date,
		Inactivated_Date,
		Last_Updated_Date,
		Updated_By
	FROM Mst_Customer
	WHERE Customer_Id IN (SELECT Customer_Id FROM @txn_RationCard)
	ORDER BY Customer_Id

	IF(@operation = 'VIEW')
	BEGIN
		SELECT * FROM @txn_RationCard
		SELECT 
		dbo.Func_Hof_Name_By_Hof_Id(Hof_Id, @distId) AS HOF_NAME,
		CASE WHEN EXISTS(SELECT 1 FROM Mst_Customer WHERE Customer_Id = Hof_Id) THEN 'Under Family' ELSE 'Orphan' END AS IsUnderFamily,
		* FROM @mst_Customer
	END
	ELSE
	BEGIN
	SELECT * FROM @txn_RationCard
		SELECT 
		dbo.Func_Hof_Name_By_Hof_Id(Hof_Id, @distId) AS HOF_NAME,
		CASE WHEN EXISTS(SELECT 1 FROM Mst_Customer WHERE Customer_Id = Hof_Id) THEN 'Under Family' ELSE 'Orphan' END AS IsUnderFamily,
		* FROM @mst_Customer

		DELETE  FROM Txn_RationCard WHERE RationCard_Id IN (SELECT RationCard_Id FROM @txn_RationCard)
		DELETE FROM Mst_Customer WHERE Customer_Id IN (SELECT Customer_Id FROM @mst_Customer)

		SELECT 'All wrong record deleted'
	END

	END TRY
	BEGIN CATCH
		SELECT 'FAILURE' 
		, ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END