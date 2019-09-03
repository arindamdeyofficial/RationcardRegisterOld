IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetProductMasterData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetProductMasterData]
GO 
--EXEC Sp_GetProductMasterData 1
CREATE PROCEDURE [dbo].[Sp_GetProductMasterData]
	@distId VARCHAR(2)		
AS
BEGIN
	
	SET NOCOUNT ON;

	--product Master 5
	SELECT
	
	P.Product_Master_Identity,
	P.Name,
	P.Barcode,
	P.ProdDescription,
	P.UOMType,
	U.UOM_Id_Identity,
	U.UOMName,
	U.UOMType,

	PD.Product_Dept_Master_Identity,
	PD.Product_Dept_Desc,

	PSD.Product_SubDept_Master_Identity,
	PSD.Product_SubDept_Master_Desc,

	PC.Product_Class_Master_Identity,
	PC.Product_Class_Master_Desc,

	PSC.Product_SubClass_Master_Identity,
	PSC.Product_SubClass_Master_Desc,

	PMC.Product_MC_Code,
	PMC.Product_MC_Master_Desc,
	PMC.Product_MC_Master_Identity,

	PB.Product_Brand_Master_Identity,
	PB.Product_Brand_Desc,
	PB.Product_Brand_Company_Desc,

	P.Active,
	P.Article_Code,
	P.IsDefaultProduct,
	P.IsDefaultGiveRation,

	PR.Buying_Rate_In_Base_Uom,
	PR.Mrp_Rate_In_Base_Uom,
	PR.Selling_Rate_In_Base_Uom
	
	FROM Product_Master AS P
	LEFT JOIN Product_Rate AS PR
	ON P.Product_Master_Identity = PR.Prod_Id
	LEFT JOIN UOM AS U
	ON P.Base_UOM_Id = U.UOM_Id_Identity
	LEFT JOIN Product_Dept_Master AS PD
	ON P.Product_Dept_Master_Identity = PD.Product_Dept_Master_Identity
	AND P.Product_Dept_Master_Identity = PD.Product_Dept_Master_Identity

	LEFT JOIN Product_SubDept_Master AS PSD
	ON PD.Product_Dept_Master_Identity = PSD.Product_Dept_Master_Id
	AND P.Product_SubDept_Master_Id = PSD.Product_SubDept_Master_Identity

	LEFT JOIN Product_Class_Master AS PC
	ON PSD.Product_SubDept_Master_Identity = PC.Product_SubDept_Master_Id
	AND P.Product_Class_Master_Id = PC.Product_Class_Master_Identity

	LEFT JOIN Product_SubClass_Master AS PSC
	ON PC.Product_Class_Master_Identity = PSC.Product_Class_Master_Id
	AND P.Product_SubClass_Master_Id = PSC.Product_SubClass_Master_Identity

	LEFT JOIN Product_MC_Master AS PMC
	ON PSC.Product_SubClass_Master_Identity = PMC.Product_SubClass_Master_Id
	AND P.Product_MC_Master_Id = PMC.Product_Mc_Master_Identity

	LEFT JOIN Product_Brand_Master AS PB
	ON PMC.Product_MC_Master_Identity = PB.Product_MC_Master_Id
	AND P.Product_Brand_Master_Id = PB.Product_Brand_Master_Identity
	WHERE P.Active = 1 
	AND P.Dist_Id = @distId

	--Product_Quantity_Master 6
	SELECT
	
	P.Product_Master_Identity,
	PQ.Active,
	PQ.DefaultQuantityInBaseUom,
	PQ.IsQuantityForFamily,
	PQ.Product_Quantity_Master_Identity,
	C.Cat_Id,
	C.Cat_Desc

	FROM Product_Master AS P
	INNER JOIN Product_Quantity_Master AS PQ
	ON P.Product_Master_Identity = PQ.Prod_Id
	INNER JOIN Mst_Cat AS C
	ON C.Cat_Id = PQ.Cat_Id
	WHERE P.Active = 1 
	AND P.Dist_Id = @distId

	--Product_Uom 7
	SELECT
	
	P.Product_Master_Identity,
	PU.Product_Uom_Identity,
	PU.ConversionFactorWithBaseUom,
	U.UOM_Id_Identity,
	PU.IsBaseuom,
	U.UOMName,
	U.UOMType

	FROM Product_Master AS P
	INNER JOIN Product_Uom AS PU
	ON P.Product_Master_Identity = PU.Product_Id
	INNER JOIN Uom AS U
	ON PU.Uom_Id = U.UOM_Id_Identity
	WHERE P.Active = 1 
	AND P.Dist_Id = @distId

	--Product_Stock 8
	SELECT
		
	P.Product_Master_Identity,
	PS.Prod_Id,
	PS.ProdQuantity,
	PS.AllowedDamageQuantityPerUnit,	
	PS.TotalAllowedDamageQuantity,
	PS.TotalDamageQuantityInReal,
	PS.Product_Stock_Identity,
	PS.Created_Date,
	PS.UOM_Id,
	PS.IsStockIn,
	U.UOM_Id_Identity,
	U.UOMName,
	U.UOMType,
	C.Cat_Id,
	C.Cat_Desc

	FROM Product_Stock AS PS
	INNER JOIN Product_Master AS P
	ON P.Product_Master_Identity = PS.Prod_Id
	INNER JOIN Uom AS U
	ON PS.Uom_Id = U.UOM_Id_Identity
	LEFT JOIN Mst_Cat AS C
	ON PS.Cat_Id = C.Cat_Id
	WHERE P.Active = 1 
	AND P.Dist_Id = @distId

END 

--select * from Product_Master
--select * from Product_Quantity_Master
--select * from Product_Rate
--select * from Product_Stock
--select * from Product_Uom
--select * from Product_Dept_Master
--select * from Product_SubDept_Master
--select * from Product_Class_Master
--select * from Product_SubClass_Master
--select * from Product_MC_Master
--select * from Product_Brand_Master
--select * from Product_Input