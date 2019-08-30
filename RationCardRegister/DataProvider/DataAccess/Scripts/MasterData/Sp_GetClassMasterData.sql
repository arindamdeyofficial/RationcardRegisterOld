IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetClassMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetClassMasterData]
GO 
--EXEC Sp_GetClassMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetClassMasterData]
	@distId VARCHAR(50)	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	--Product_Class_Master 12
	SELECT

	Product_Class_Master_Identity,
	Product_SubDept_Master_Id,
	Product_Dept_Master_Id,
	Product_Class_Master_Desc

	FROM Product_Class_Master WHERE Dist_Id = @distId

END 