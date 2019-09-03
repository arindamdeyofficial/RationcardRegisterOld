IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetDeptMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetDeptMasterData]
GO 
--EXEC Sp_GetDeptMasterData 'jayanta98314@gmail.com'
CREATE PROCEDURE [dbo].[Sp_GetDeptMasterData]
	@distId VARCHAR(50)	
AS
BEGIN
	
	SET NOCOUNT ON;

	--Product_Dept_Master 10
	SELECT

	Product_Dept_Master_Identity,
	Product_Dept_Desc

	FROM Product_Dept_Master WHERE Dist_Id = @distId

END 