IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetRoleMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetRoleMasterData]
GO 
--EXEC Sp_GetRoleMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetRoleMasterData]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	--Mst_Role 16
	SELECT

	Role_Id,
	Role_Desc,
	ControlIdToHide

	FROM Mst_Role WHERE Dist_Id = @distId
END 