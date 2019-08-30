IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetUomMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetUomMasterData]
GO 
--EXEC Sp_GetUomMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetUomMasterData]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	--UomMasterData 8
	SELECT

	UOM_Id_Identity,
	UOMName,
	UOMType

	FROM UOM WHERE Dist_Id = @distId

	--UomType 9
	SELECT DISTINCT

	UOMType

	FROM UOM WHERE DIst_Id = @distId

END 