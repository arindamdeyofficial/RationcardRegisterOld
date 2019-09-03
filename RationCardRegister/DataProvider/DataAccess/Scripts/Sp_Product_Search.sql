IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Product_Search]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Product_Search]
GO 
--EXEC Sp_Product_Search 1,'', '', 'Rice','', '1', '1','0', '0', '0', '0','0', '0', '','0', '','2016-05-30 00:00:00.000','2018-05-30 00:00:00.000'
--select * from Product_Search_Input
--delete from Product_Search_Input

CREATE PROCEDURE [dbo].[Sp_Product_Search]
	@distId VARCHAR(2),
	@barCode VARCHAR(500),
	@articleCode VARCHAR(100),
	@prdName VARCHAR(1000),
	@description VARCHAR(500),
	@isActive BIT,
	@isDefaultToGiveRation BIT,
	@isDefaultPrd BIT,
	@dept VARCHAR(50),
	@subDept VARCHAR(50),
	@class VARCHAR(50),
	@subClass VARCHAR(50),
	@mc VARCHAR(50),
	@mcCode VARCHAR(50),
	@brand VARCHAR(50),
	@brandCompany VARCHAR(50),
	@dtFrom DATETIME,
	@dtTo DATETIME
		
AS
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY
	DECLARE @noOfRecords INT

	INSERT INTO Product_Search_Input
	(
		Dist_Id,
		BarCode,
		ArticleCode,
		PrdName,
		[Description],
		IsActive,
		IsDefaultToGiveRation,
		IsDefaultPrd,
		Dept,
		SubDept,
		Class,
		SubClass,
		Mc,
		McCode,
		Brand,
		BrandCompany,
		DtFrom,
		DtTo,
		Created_Date
	)
	SELECT 
		@distId,
		@barCode,
		@articleCode,
		@prdName,
		@description,
		@isActive,
		@isDefaultToGiveRation,
		@isDefaultPrd,
		@dept,
		@subDept,
		@class,
		@subClass,
		@mc,
		@mcCode,
		@brand,
		@brandCompany,
		@dtFrom,
		@dtTo,
		GETDATE()
		
	
	SELECT
	--CONVERT(DATE,@dtTo) AS A,CONVERT(DATE,@dtFrom) AS B,CONVERT(DATE,P.Created_Date) AS C,
	--CASE WHEN (CONVERT(DATE,P.Created_Date) >= CONVERT(DATE,@dtFrom)) THEN 1 ELSE 0 END AS D,
	--CASE WHEN (CONVERT(DATE,P.Created_Date) <= CONVERT(DATE,@dtTo)) THEN 1 ELSE 0 END AS E,
	--CASE WHEN (CONVERT(DATE,P.Created_Date) >= CONVERT(DATE,@dtFrom) AND CONVERT(DATE,P.Created_Date) <= CONVERT(DATE,@dtTo)) THEN 1 ELSE 0 END AS F,
	P.Product_Master_Identity,
	P.Name,
	P.Barcode,
	P.ProdDescription,
	P.UOMType,
	U.UOM_Id_Identity,
	U.UOMName,

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
	
	INTO #tmpPrd
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

	--search criteria filters start

	AND P.Barcode like '%' + CASE WHEN (ISNULL(@barcode, '') = '') THEN P.Barcode ELSE @barCode END + '%'
	AND P.Article_Code like '%' + CASE WHEN (ISNULL(@articleCode, '') = '') THEN P.Article_Code ELSE @articleCode END + '%'
	AND P.Name like '%' + CASE WHEN (ISNULL(@prdName, '') = '') THEN P.Name ELSE @prdName END + '%'
	AND P.ProdDescription like '%' + CASE WHEN (ISNULL(@description, '') = '') THEN P.ProdDescription ELSE @description END + '%'
	AND P.Active = @isActive
	AND P.IsDefaultGiveRation = @isDefaultToGiveRation
	AND P.IsDefaultProduct = @isDefaultPrd
	AND (CONVERT(DATE,P.Created_Date) >= CONVERT(DATE,@dtFrom)) AND (CONVERT(DATE,P.Created_Date) <= CONVERT(DATE,@dtTo))

	AND PD.Product_Dept_Master_Identity = CASE WHEN (ISNULL(@dept, '0') = '0') THEN PD.Product_Dept_Master_Identity ELSE @dept END
	AND PSD.Product_SubDept_Master_Identity = CASE WHEN (ISNULL(@subDept, '0') = '0') THEN PSD.Product_SubDept_Master_Identity ELSE @subDept END
	AND PC.Product_Class_Master_Identity = CASE WHEN (ISNULL(@class, '0') = '0') THEN PC.Product_Class_Master_Identity ELSE @class END
	AND PSC.Product_SubClass_Master_Identity = CASE WHEN (ISNULL(@subClass, '0') = '0') THEN PSC.Product_SubClass_Master_Identity ELSE @subClass END
	AND PMC.Product_Mc_Master_Identity = CASE WHEN (ISNULL(@mc, '0') = '0') THEN PMC.Product_Mc_Master_Identity ELSE @mc END
	AND PMC.Product_MC_Code = CASE WHEN (ISNULL(@mcCode, '') = '') THEN PMC.Product_MC_Code ELSE @mcCode END
	AND PB.Product_Brand_Master_Identity = CASE WHEN (ISNULL(@brand, '0') = '0') THEN PB.Product_Brand_Master_Identity ELSE @brand END	
	AND PB.Product_Brand_Company_Desc = CASE WHEN (ISNULL(@brandCompany, '') = '') THEN PB.Product_Brand_Company_Desc ELSE @brandCompany END

	SELECT * FROM #tmpPrd

	--search criteria filters end

	SELECT @noOfRecords = @@ROWCOUNT

	--Product_Quantity_Master
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
	AND P.Product_Master_Identity IN (SELECT Product_Master_Identity FROM #tmpPrd)

	--Product_Uom
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
	AND P.Product_Master_Identity IN (SELECT Product_Master_Identity FROM #tmpPrd)

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
	INNER JOIN Mst_Cat AS C
	ON PS.Cat_Id = C.Cat_Id
	WHERE P.Active = 1 
	AND P.Dist_Id = @distId
	AND P.Product_Master_Identity IN (SELECT Product_Master_Identity FROM #tmpPrd)
	
	--SELECT @noOfRecords AS RECORD_COUNT

	END TRY
	BEGIN CATCH
		SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END