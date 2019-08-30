IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetBrandMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetBrandMasterData]
GO 
--EXEC Sp_GetBrandMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetBrandMasterData]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;

	--Product_Brand_Master 15
	SELECT

	Product_Brand_Master_Identity,
	Product_MC_Master_Id,
	Product_SubClass_Master_Id,
	Product_Class_Master_Id,
	Product_SubDept_Master_Id,
	Product_Dept_Master_Id,
	Product_Brand_Desc,
	Product_Brand_Company_Desc

	FROM Product_Brand_Master WHERE Dist_Id = @distId

END 