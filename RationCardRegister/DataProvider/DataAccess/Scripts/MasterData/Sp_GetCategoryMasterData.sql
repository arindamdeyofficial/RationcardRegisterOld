IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetCategoryMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetCategoryMasterData]
GO 
--EXEC Sp_GetCategoryMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetCategoryMasterData]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;

	--Master Category 3
	SELECT Cat_Id, Cat_Desc FROM Mst_Cat
END 