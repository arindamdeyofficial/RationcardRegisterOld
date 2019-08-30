IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetSubDeptMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetSubDeptMasterData]
GO 
--EXEC Sp_GetSubDeptMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetSubDeptMasterData]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;

	--Product_SubDept_Master 11
	SELECT

	Product_SubDept_Master_Identity,
	Product_Dept_Master_Id,
	Product_SubDept_Master_Desc

	FROM Product_SubDept_Master WHERE Dist_Id = @distId

END 