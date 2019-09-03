IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetSubClassMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetSubClassMasterData]
GO 
--EXEC Sp_GetSubClassMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetSubClassMasterData]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;

	--Product_SubClass_Master 13
	SELECT

	Product_SubClass_Master_Identity,
	Product_Class_Master_Id,
	Product_SubDept_Master_Id,
	Product_Dept_Master_Id,
	Product_SubClass_Master_Desc

	FROM Product_SubClass_Master WHERE Dist_Id = @distId

END 