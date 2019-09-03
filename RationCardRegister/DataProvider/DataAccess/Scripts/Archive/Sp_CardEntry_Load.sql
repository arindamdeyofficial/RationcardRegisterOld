IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_CardEntry_Load]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_CardEntry_Load]
GO 
--EXEC Sp_CardEntry_Load 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_CardEntry_Load]
	@userId VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @dist_Id INT
	SELECT @dist_Id = Dist_Id FROM Mst_Dist WHERE Dist_Login=@userId

	DECLARE @hof TABLE 
	(
		Customer_Id INT,
		Name VARCHAR(200),
		Mobile_No VARCHAR(20),
		Address VARCHAR(MAX),
		CardNo VARCHAR(50),
		Total_Count INT,
		Active_Count INT
	)

	INSERT INTO @hof (Customer_Id, Name, Mobile_No, Address,CardNo,Total_Count,Active_Count)
	SELECT

		ISNULL(C1.Customer_Id,''), ISNULL(C1.Name,''), ISNULL(C1.Mobile_No,''), ISNULL(C1.Address, '')
		, ISNULL(R.Number,''), ISNULL(NON_HOF.Total_Count,''), ISNULL(NON_HOF.Active_Count,'')

		FROM Mst_Customer AS C1
		LEFT JOIN (

			SELECT 
			COUNT(C2.Hof_Id) +1 AS Total_Count
			,COUNT(CASE WHEN R.Active = 1 THEN 1 ELSE 0 END) + 1 AS Active_Count
			, C2.Hof_Id 

			FROM Mst_Customer  C1
			INNER JOIN Mst_Customer C2
			ON C2.Hof_Id = C1.Customer_Id
			INNER JOIN Txn_RationCard AS R
			ON R.Customer_Id = C1.Customer_Id 
			WHERE C2.Hof_Flag = 0 AND C2.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Login = @userId)
			GROUP BY C2.Hof_Id
		) AS NON_HOF
		ON NON_HOF.Hof_Id = C1.Customer_Id
		INNER JOIN Txn_RationCard AS R
		ON R.Customer_Id = C1.Customer_Id
		WHERE C1.Hof_Flag = 1

	SELECT COUNT(*) AS Hof_Count FROM @hof
	SELECT Customer_Id, Name,CardNo,Mobile_No, Address,Total_Count,Active_Count FROM @hof ORDER BY Name
	SELECT Cat_Id, Cat_Desc FROM Mst_Cat
	SELECT Mst_Rel_With_Hof_Id, Relation FROM Mst_Rel
	
END