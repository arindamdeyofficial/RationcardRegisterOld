IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetMcMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetMcMasterData]
GO 
--EXEC Sp_GetMcMasterData 1
CREATE PROCEDURE [dbo].[Sp_GetMcMasterData]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	--Product_MC_Master 14
	SELECT

	Product_MC_Master_Identity,
	Product_MC_Code,
	Product_SubClass_Master_Id,
	Product_Class_Master_Id,
	Product_SubDept_Master_Id,
	Product_Dept_Master_Id,
	Product_MC_Master_Desc

	FROM Product_MC_Master WHERE Dist_Id = @distId

END 