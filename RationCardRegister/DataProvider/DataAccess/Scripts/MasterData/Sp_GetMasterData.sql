IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetMasterData]
GO 
--EXEC Sp_GetMasterData 1
CREATE PROCEDURE [dbo].[Sp_GetMasterData]
	@distId VARCHAR(2)	
AS
BEGIN
	
	SET NOCOUNT ON;

	--HofMasterData 0
	--Total Hof Count 1
	--Active Hof Count 2
	EXEC Sp_GetHofMasterData @distId

	--Master Category 3
	EXEC Sp_GetCategoryMasterData @distId

	--Master Relation 4
	EXEC Sp_GetRelationMasterData @distId

	--product Master 5
	--Product_Quantity_Master 6
	--Product_Uom 7
	--Product_Stock 8
	EXEC Sp_GetProductMasterData @distId

	--UomMasterData 9
	--UomType 10
	EXEC Sp_GetUomMasterData @distId

	--Product_Dept_Master 11
	EXEC Sp_GetDeptMasterData @distId

	--Product_SubDept_Master 12
	EXEC Sp_GetSubDeptMasterData @distId

	--Product_Class_Master 13
	EXEC Sp_GetClassMasterData @distId

	--Product_SubClass_Master 14
	EXEC Sp_GetSubClassMasterData @distId

	--Product_MC_Master 15
	EXEC Sp_GetMcMasterData @distId

	--Product_Brand_Master 16
	EXEC Sp_GetBrandMasterData @distId

	--Mst_Role 17
	EXEC Sp_GetRoleMasterData @distId

	--dist master data Userlist 18 & 19
	EXEC Sp_GetDistributorMasterData 

	--dist master data Configs 20
	EXEC Sp_ConfigOperation @distId,'','',0,0, 'GET'

	--Rationcards in this fortnight 21
	EXEC Sp_CardsInThisFortnight @distId
END 