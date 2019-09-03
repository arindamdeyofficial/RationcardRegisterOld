IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetHofMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetHofMasterData]
GO 
--EXEC Sp_GetHofMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetHofMasterData]
	@distId VARCHAR(50)	
AS
BEGIN
	
	SET NOCOUNT ON;

	--HofMasterData 0
	SELECT 
	
	C2.Customer_Id,
	C2.Name,
	R.Number,
	C2.Mobile_No,
	C2.Address,
	COUNT(*) AS Total_Count,
	SUM(CASE C1.Active WHEN  1 THEN 1 ELSE 0 END) AS Active_Count

	FROM Mst_Customer AS C1 -- Member
	INNER JOIN Mst_Customer As C2 -- Hof
	ON C1.Hof_Id = C2.Customer_Id
	LEFT JOIN Txn_Rationcard AS R
	ON C2.Rationcard_Id = R.Rationcard_Id
	WHERE C2.Hof_Flag = 1 AND C2.Active = 1 
	AND C2.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId)
	GROUP BY C2.Hof_Id,
	C2.Customer_Id,
	C2.Name,
	R.Number,
	C2.Mobile_No,
	C2.Address,
	R.Number

	--Total Hof Count 1
	SELECT COUNT(*) AS Hof_Total_Count FROM Mst_Customer WHERE Hof_Flag = 1

	--Active Hof Count 2
	SELECT COUNT(*) AS Hof_Active_Count FROM Mst_Customer WHERE Hof_Flag = 1 AND Active = 1

END 