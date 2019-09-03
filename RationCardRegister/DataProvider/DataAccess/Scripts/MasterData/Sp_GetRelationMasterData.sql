IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetRelationMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetRelationMasterData]
GO 
--EXEC Sp_GetRelationMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetRelationMasterData]
	@distId VARCHAR(2)		
AS
BEGIN
	
	SET NOCOUNT ON;

	--Master Relation 4
	SELECT Mst_Rel_With_Hof_Id, Relation FROM Mst_Rel

END 