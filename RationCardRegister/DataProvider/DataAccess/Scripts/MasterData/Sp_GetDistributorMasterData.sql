IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetDistributorMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetDistributorMasterData]
GO 
--EXEC Sp_GetDistributorMasterData 
CREATE PROCEDURE [dbo].[Sp_GetDistributorMasterData]

AS
BEGIN
	
	SET NOCOUNT ON;

	--UserList
		SELECT *
		FROM Mst_Dist

		SELECT * FROM Mac_List
END 