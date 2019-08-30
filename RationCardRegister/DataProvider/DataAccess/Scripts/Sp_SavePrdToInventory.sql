IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SavePrdToInventory]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_SavePrdToInventory]
GO 

--EXEC Sp_SavePrdToInventory 
--'<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Name="RICE" BarCode="8901190101831" ArticleCode="253110702" 
--ProdDescription="RICE" Active="true" IsDefaultProduct="true" IsDefaultGiveRation="true" ConsumptionQuantity="0" 
--SellingRateInBaseUom="2" BuyingRateInBaseUom="1.75" MrpRateInBaseUom="2">
--<BaseUom UOMName="Kg" IsBaseUom="false" UOMType="weight" UOM_Id_Identity="1" ConversionFactorWithBaseUom="0" />
--<AllUom>
--	<Uom ProdId="20" UOMName="Kg" IsBaseUom="true" UOMType="weight" UOM_Id_Identity="1" ConversionFactorWithBaseUom="1" />
--	<Uom ProdId="20" UOMName="gm" IsBaseUom="false" UOMType="weight" UOM_Id_Identity="2" ConversionFactorWithBaseUom="0.001" />
--</AllUom>
--<PrdQuantityAllocated>
--	<ProductQuantityMaster Product_Quantity_Master_Identity="131" ProductId="20" DefaultQuantityInBaseUom="7.5" IsQuantityForFamily="true" Active="false">
--		<CategoryDetails Cat_Id="1" Cat_Desc="AAY" />
--	</ProductQuantityMaster>
--	<ProductQuantityMaster Product_Quantity_Master_Identity="132" ProductId="20" DefaultQuantityInBaseUom="1" IsQuantityForFamily="false" Active="false">
--		<CategoryDetails Cat_Id="2" Cat_Desc="PHH" />
--	</ProductQuantityMaster>
--</PrdQuantityAllocated>
--<ProductDept ProductDeptMasterId="14" ProductDeptMasterDesc="Cop" />
--<ProductSubDept ProductSubDeptMasterId="14" ProductDeptMasterId="14" ProductSubDeptMasterDesc="Staples" />
--<ProductClass ProductClassMasterId="14" ProductDeptMasterId="14" ProductSubDeptMasterId="14" ProductClassMasterDesc="Grocery" />
--<ProductSubClass ProductSubClassMasterId="14" ProductClassMasterId="14" ProductDeptMasterId="14" ProductSubDeptMasterId="14" ProductSubClassMasterDesc="rice" />
--<ProductMc ProductMcMasterId="14" ProductMcMasterCode="2351" ProductSubClassMasterId="14" ProductClassMasterId="14" ProductDeptMasterId="14" ProductSubDeptMasterId="14" ProductMcMasterDesc="cooking rice" />
--<ProductBrand ProductBrandMasterId="15" ProductBrandMasterDesc="govt" ProductMcMasterId="14" ProductSubClassMasterId="14" 
--ProductClassMasterId="14" ProductDeptMasterId="14" ProductSubDeptMasterId="14" ProductBrandMasterCompanyDesc="govt" />
--<StockInBaseUom Prod_Id="20" ProdQuantity="1" AllowedDamageQuantityPerUnit="78" TotalAllowedDamageQuantity="4" TotalDamageQuantityInReal="5" StockEntryTime="05-26-2018 09:26:11" EntryMode="ADDSTOCK">
--	<CategoryDetails Cat_Id="1" Cat_Desc="AAY" />
--	<StockUom UOMName="Kg" IsBaseUom="false" UOMType="weight" UOM_Id_Identity="1" ConversionFactorWithBaseUom="0" />
--</StockInBaseUom>
--<StockInBaseUom Prod_Id="20" ProdQuantity="40" AllowedDamageQuantityPerUnit="4" TotalAllowedDamageQuantity="8" TotalDamageQuantityInReal="2" EntryMode="ADDSTOCK" StockEntryTime="05-26-2018 09:26:11" >
--	<CategoryDetails Cat_Id="2" Cat_Desc="PHH" />
--	<StockUom UOMName="Kg" IsBaseUom="false" UOMType="weight" UOM_Id_Identity="1" ConversionFactorWithBaseUom="0" />
--</StockInBaseUom>
--<StockInBaseUom Prod_Id="20" ProdQuantity="500" AllowedDamageQuantityPerUnit="7" TotalAllowedDamageQuantity="74" TotalDamageQuantityInReal="12" EntryMode="ADDSTOCK" StockEntryTime="05-26-2018 09:26:11" >
--	<CategoryDetails Cat_Id="4" Cat_Desc="RKSY-II" />
--	<StockUom UOMName="Kg" IsBaseUom="false" UOMType="weight" UOM_Id_Identity="1" ConversionFactorWithBaseUom="0" />
--</StockInBaseUom>
--<StockInBaseUom Prod_Id="20" ProdQuantity="600" AllowedDamageQuantityPerUnit="8" TotalAllowedDamageQuantity="56" TotalDamageQuantityInReal="258" EntryMode="ADDSTOCK" StockEntryTime="05-26-2018 09:26:11" >
--	<CategoryDetails Cat_Id="5" Cat_Desc="SPHH" />
--	<StockUom UOMName="Kg" IsBaseUom="false" UOMType="weight" UOM_Id_Identity="1" ConversionFactorWithBaseUom="0" />
--</StockInBaseUom>
--<StockInBaseUom Prod_Id="20" ProdQuantity="70" AllowedDamageQuantityPerUnit="9" TotalAllowedDamageQuantity="753" TotalDamageQuantityInReal="742" EntryMode="ADDSTOCK" StockEntryTime="05-26-2018 09:26:11" >
--	<CategoryDetails Cat_Id="3" Cat_Desc="RKSY-I" />
--	<StockUom UOMName="Kg" IsBaseUom="false" UOMType="weight" UOM_Id_Identity="1" ConversionFactorWithBaseUom="0" />
--</StockInBaseUom>
--</Product>'
--,1, 'EDIT' -- 'EDIT'


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

--delete from Product_Input
--DELETE from Product_Master
--delete from Product_Quantity_Master
--delete from Product_Rate
--delete from Product_Stock
--delete from Product_Uom
--delete from Product_Dept_Master
--delete from Product_SubDept_Master
--delete from Product_Class_Master
--delete from Product_SubClass_Master
--delete from Product_MC_Master
--delete from Product_Brand_Master


CREATE PROCEDURE [dbo].[Sp_SavePrdToInventory]	
	@prdData XML,
	@distId VARCHAR(2),
	@action VARCHAR(10)
AS 
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @Product Table
	(
		RowNum INT,
		Name VARCHAR(800) PRIMARY KEY NOT NULL,
		Barcode VARCHAR(100),
		Article_Code VARCHAR(100),
		ProdDescription VARCHAR(1000),
		Active VARCHAR(10),
		IsDefaultProduct VARCHAR(10),
		IsDefaultGiveRation VARCHAR(10),
		Selling_Rate_In_Base_Uom VARCHAR(10),
		Mrp_Rate_In_Base_Uom VARCHAR(10),
		Buying_Rate_In_Base_Uom VARCHAR(10),

		--BaseUom
		BaseUOMName VARCHAR(100),
		BaseIsBaseUom VARCHAR(10),
		BaseUOMType VARCHAR(100),
		BaseUOM_Id_Identity VARCHAR(10),
		BaseConversionFactorWithBaseUom VARCHAR(10),

		--ProductDept
		ProductDeptMasterDesc VARCHAR(1000),

		--ProductSubDept
		ProductSubDeptMasterDesc VARCHAR(1000),

		--ProductClass
		ProductClassMasterDesc VARCHAR(1000),

		--ProductSubClass
		ProductSubClassMasterDesc VARCHAR(1000),

		--ProductMc
		ProductMcMasterCode VARCHAR(1000),
		ProductMcMasterDesc VARCHAR(1000),

		--ProductBrand
		ProductBrandMasterDesc VARCHAR(1000),
		ProductBrandMasterCompanyDesc VARCHAR(1000),
		
		--UnitOfMeasureDetail
		UOMName VARCHAR(100),
		IsBaseUom VARCHAR(10),
		UOMType VARCHAR(100),
		UOM_Id_Identity VARCHAR(10),
		ConversionFactorWithBaseUom VARCHAR(10)
	)

	DECLARE @AllUom TABLE
	(
		Name VARCHAR(1000),
		UOMName VARCHAR(100),
		IsBaseUom VARCHAR(10),
		UOMType VARCHAR(100),
		ConversionFactorWithBaseUom VARCHAR(10)
	)

	DECLARE @PrdQuantityAllocated TABLE
	(
		Name VARCHAR(1000),
		QuantityDefaultQuantityInBaseUom VARCHAR(10),
		QuantityIsQuantityForFamily VARCHAR(10),
		QuantityActive VARCHAR(10),
		QuantityCat_Id VARCHAR(10),
		QuantityCat_Desc VARCHAR(1000)
	)

	DECLARE @StockInBaseUom TABLE
	(
		Name VARCHAR(1000),
		StockProdQuantity VARCHAR(10),
		Cat_Id INT,
		UOM_Id INT,	
		Created_Date VARCHAR(100),
		StockAllowedDamageQuantityPerUnit VARCHAR(10),
		StockTotalAllowedDamageQuantity VARCHAR(10),
		StockTotalDamageQuantityInReal VARCHAR(10)
	)

	DECLARE @StatusTable TABLE
	(	[Status] VARCHAR(10),
		StatusMsg VARCHAR(1000),
		Name VARCHAR(1000)
	)

	INSERT INTO Product_Input
	(
		Dist_Id,
		Product_Xml,
		Created_Date,
		Last_Updated_Date,
		Updated_By
	)
	VALUES
	(@distId, @prdData, GETDATE(), GETDATE(), @distId)
	
	BEGIN TRY 

	INSERT INTO @Product
	SELECT 

	ROW_NUMBER() OVER(ORDER BY T1.L1.value('@Name', 'VARCHAR(1000)') ASC) AS RowNum
	,T1.L1.value('@Name', 'VARCHAR(1000)') AS Name
	,T1.L1.value('@BarCode', 'VARCHAR(100)') AS Barcode
	,T1.L1.value('@ArticleCode', 'VARCHAR(100)') AS Article_Code
	,T1.L1.value('@ProdDescription', 'VARCHAR(2000)') AS ProdDescription
	,T1.L1.value('@Active', 'VARCHAR(10)') AS Active
	,T1.L1.value('@IsDefaultProduct', 'VARCHAR(10)') AS IsDefaultProduct
	,T1.L1.value('@IsDefaultGiveRation', 'VARCHAR(10)') AS IsDefaultGiveRation
	,T1.L1.value('@SellingRateInBaseUom', 'VARCHAR(100)') AS Selling_Rate_In_Base_Uom	
	,T1.L1.value('@MrpRateInBaseUom', 'VARCHAR(100)') AS Mrp_Rate_In_Base_Uom
	,T1.L1.value('@BuyingRateInBaseUom', 'VARCHAR(100)') AS Buying_Rate_In_Base_Uom

	--BaseUom
	, T1.L1.value('(BaseUom/@UOMName)[1]', 'VARCHAR(100)') AS BaseUOMName
	, T1.L1.value('(BaseUom/@IsBaseUom)[1]', 'VARCHAR(10)') AS BaseIsBaseUom
	, T1.L1.value('(BaseUom/@UOMType)[1]', 'VARCHAR(100)') AS BaseUOMType
	, T1.L1.value('(BaseUom/@UOM_Id_Identity)[1]', 'VARCHAR(10)') AS BaseUOM_Id_Identity
	, T1.L1.value('(BaseUom/@ConversionFactorWithBaseUom)[1]', 'VARCHAR(10)') AS BaseConversionFactorWithBaseUom

	--ProductDept
	, T1.L1.value('(ProductDept/@ProductDeptMasterDesc)[1]', 'VARCHAR(100)') AS ProductDeptMasterDesc

	--ProductSubDept
	, T1.L1.value('(ProductSubDept/@ProductSubDeptMasterDesc)[1]', 'VARCHAR(100)') AS ProductSubDeptMasterDesc

	--ProductClass
	, T1.L1.value('(ProductClass/@ProductClassMasterDesc)[1]', 'VARCHAR(100)') AS ProductClassMasterDesc

	--ProductSubClass
	, T1.L1.value('(ProductSubClass/@ProductSubClassMasterDesc)[1]', 'VARCHAR(100)') AS ProductSubClassMasterDesc

	--ProductMc
	, T1.L1.value('(ProductMc/@ProductMcMasterCode)[1]', 'VARCHAR(100)') AS ProductMcMasterCode
	, T1.L1.value('(ProductMc/@ProductMcMasterDesc)[1]', 'VARCHAR(100)') AS ProductMcMasterDesc

	--ProductBrand
	, T1.L1.value('(ProductBrand/@ProductBrandMasterDesc)[1]', 'VARCHAR(100)') AS ProductBrandMasterDesc
	, T1.L1.value('(ProductBrand/@ProductBrandMasterCompanyDesc)[1]', 'VARCHAR(100)') AS ProductBrandMasterCompanyDesc

	--UnitOfMeasureDetail
	, T1.L1.value('(UnitOfMeasureDetail/@UOMName)[1]', 'VARCHAR(100)') AS UOMName
	, T1.L1.value('(UnitOfMeasureDetail/@IsBaseUom)[1]', 'VARCHAR(10)') AS IsBaseUom
	, T1.L1.value('(UnitOfMeasureDetail/@UOMType)[1]', 'VARCHAR(100)') AS UOMType
	, T1.L1.value('(UnitOfMeasureDetail/@UOM_Id_Identity)[1]', 'VARCHAR(10)') AS UOM_Id_Identity
	, T1.L1.value('(UnitOfMeasureDetail/@ConversionFactorWithBaseUom)[1]', 'VARCHAR(10)') AS ConversionFactorWithBaseUom

	FROM  @prdData.nodes('/Product') AS T1(L1)

	--test
	--select * from @Product

	INSERT INTO @AllUom
	SELECT 

	T1.L1.value('@Name', 'VARCHAR(1000)') AS Name

	--AllUom
	, T2.L2.value('@UOMName', 'VARCHAR(100)') AS UOMName
	, T2.L2.value('@IsBaseUom', 'VARCHAR(10)') AS IsBaseUom
	, T2.L2.value('@UOMType', 'VARCHAR(100)') AS UOMType
	, T2.L2.value('@ConversionFactorWithBaseUom', 'VARCHAR(10)') AS ConversionFactorWithBaseUom

	FROM  @prdData.nodes('/Product') AS T1(L1)
	CROSS APPLY L1.nodes('/Product/AllUom/Uom') AS T2(L2)
	
	
	--test
	--select * from @AllUom

	INSERT INTO @PrdQuantityAllocated
	SELECT 

	T1.L1.value('@Name', 'VARCHAR(1000)') AS Name

	--PrdQuantityAllocated
	, T2.L2.value('@DefaultQuantityInBaseUom', 'VARCHAR(10)') AS QuantityDefaultQuantityInBaseUom
	, T2.L2.value('@IsQuantityForFamily', 'VARCHAR(10)') AS QuantityIsQuantityForFamily
	, T2.L2.value('@Active', 'VARCHAR(10)') AS QuantityActive
	, T2.L2.value('(CategoryDetails/@Cat_Id)[1]', 'VARCHAR(10)') AS QuantityCat_Id
	, T2.L2.value('(CategoryDetails/@Cat_Desc)[1]', 'VARCHAR(100)') AS QuantityCat_Desc

	FROM  @prdData.nodes('/Product') AS T1(L1)
	CROSS APPLY L1.nodes('/Product/PrdQuantityAllocated/ProductQuantityMaster') AS T2(L2)

		
	--test
	--select * from @PrdQuantityAllocated

	INSERT INTO @StockInBaseUom
	SELECT 

	T1.L1.value('@Name', 'VARCHAR(1000)') AS Name

	--StockInBaseUom
	, T2.L2.value('@ProdQuantity', 'VARCHAR(10)') AS StockProdQuantity
	, T2.L2.value('(CategoryDetails/@Cat_Id)[1]', 'INT') AS Cat_Id
	, T2.L2.value('(StockUom/@UOM_Id_Identity)[1]', 'INT') AS UOM_Id
	, T2.L2.value('@StockEntryTime', 'VARCHAR(100)') AS Created_Date
	, T2.L2.value('@AllowedDamageQuantityPerUnit', 'VARCHAR(10)') AS StockAllowedDamageQuantityPerUnit
	, T2.L2.value('@TotalAllowedDamageQuantity', 'VARCHAR(10)') AS StockTotalAllowedDamageQuantity
	, T2.L2.value('@TotalDamageQuantityInReal', 'VARCHAR(10)') AS StockTotalDamageQuantityInReal
		
	FROM  @prdData.nodes('/Product') AS T1(L1)
	CROSS APPLY L1.nodes('/Product/StockInBaseUom') AS T2(L2)
	
	--test script
	--select * from @StockInBaseUom

	DECLARE @count INT
	DECLARE @Rowcount INT
	SET @count = 1
	SELECT @Rowcount = ROwNum From @Product
	WHILE (@count <= @Rowcount)
	BEGIN
		DECLARE @prdName VARCHAR(500)

		SELECT @prdName = Name FROM @Product WHERE RowNum = @count

		DECLARE @PrdDeptId INT
		DECLARE @PrdSubDeptId INT
		DECLARE @PrdClassId INT
		DECLARE @PrdSubClassId INT
		DECLARE @PrdMcId INT
		DECLARE @PrdBrandId INT
		DECLARE @Product_Rate_Id INT
		DECLARE @prdId INT
		DECLARE @prdToAdd BIT
		DECLARE @prdToEdit BIT

		IF (@action = 'ADD') AND EXISTS(SELECT Name FROM Product_Master WHERE 
					Name = @prdName 
					AND Dist_Id=@distId)
		BEGIN
			SET @prdToAdd = 0
			SET @prdToEdit = 0
			INSERT INTO @StatusTable SELECT 'FAILURE' AS [Status], 'Not able to Add. Product with Same name already exists' AS StatusMsg, @prdName AS Name
			SET @count = @count + 1		
			CONTINUE
		END
		ELSE IF (@action = 'ADD') AND NOT EXISTS(SELECT Name FROM Product_Master WHERE 
					Name = @prdName 
					AND Dist_Id=@distId)
		BEGIN
			SET @prdToAdd = 1
			SET @prdToEdit = 0
		END
		ELSE IF (@action = 'EDIT') AND NOT EXISTS(SELECT Name FROM Product_Master WHERE 
					Name = @prdName 
					AND Dist_Id=@distId)
		BEGIN
			SET @prdToAdd = 0
			SET @prdToEdit = 0
			INSERT INTO @StatusTable SELECT 'FAILURE' AS [Status], 'Not able to Edit. Product doesnot exists.' AS StatusMsg, @prdName AS Name
			SET @count = @count + 1		
			CONTINUE
		END
		ELSE IF (@action = 'EDIT') AND EXISTS(SELECT Name FROM Product_Master WHERE 
					Name = @prdName 
					AND Dist_Id=@distId)
		BEGIN
			SET @prdToAdd = 0
			SET @prdToEdit = 1
		END

		IF NOT EXISTS(SELECT 1 FROM Product_Dept_Master WHERE Dist_Id=@distId AND Product_Dept_Desc 
					IN (SELECT ProductDeptMasterDesc FROM @Product WHERE Name = @prdName))
		BEGIN
			--ProductDept
			INSERT INTO Product_Dept_Master
			(
				Dist_Id,
				Product_Dept_Desc,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			SELECT @distId, ProductDeptMasterDesc, GETDATE(),GETDATE(), 'ProdAddProc' FROM @Product WHERE Name = @prdName
		END			
		SELECT @PrdDeptId = Product_Dept_Master_Identity FROM Product_Dept_Master WHERE Dist_Id=@distId AND Product_Dept_Desc 
					IN (SELECT ProductDeptMasterDesc FROM @Product WHERE Name = @prdName)

		IF NOT EXISTS(SELECT 1 FROM Product_SubDept_Master WHERE Dist_Id=@distId AND Product_SubDept_Master_Desc 
					IN (SELECT ProductSubDeptMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId)
		BEGIN
			--ProductSubDept
			INSERT INTO Product_SubDept_Master
			(
				Dist_Id,
				Product_Dept_Master_Id,
				Product_SubDept_Master_Desc,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			SELECT @distId, @PrdDeptId, ProductSubDeptMasterDesc, GETDATE(),GETDATE(), 'ProdAddProc' FROM @Product WHERE Name = @prdName
		END			
		SELECT @PrdSubDeptId = Product_SubDept_Master_Identity FROM Product_SubDept_Master WHERE Dist_Id=@distId AND Product_SubDept_Master_Desc 
					IN (SELECT ProductSubDeptMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId

		IF NOT EXISTS(SELECT 1 FROM Product_Class_Master WHERE Dist_Id=@distId AND Product_Class_Master_Desc 
					IN (SELECT ProductClassMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId
					AND Product_SubDept_Master_Id = @PrdSubDeptId)
		BEGIN
			--ProductClass
			INSERT INTO Product_Class_Master
			(
				Dist_Id,
				Product_Dept_Master_Id,
				Product_SubDept_Master_Id,
				Product_Class_Master_Desc,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			SELECT @distId, @PrdDeptId, @PrdSubDeptId, ProductClassMasterDesc, GETDATE(),GETDATE(), 'ProdAddProc' FROM @Product WHERE Name = @prdName
		END			
		SELECT @PrdClassId = Product_Class_Master_Identity FROM Product_Class_Master WHERE Dist_Id=@distId AND Product_Class_Master_Desc 
					IN (SELECT ProductClassMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId
					AND Product_SubDept_Master_Id = @PrdSubDeptId

		IF NOT EXISTS(SELECT 1 FROM Product_SubClass_Master WHERE Dist_Id = @distId AND Product_SubClass_Master_Desc 
					IN (SELECT ProductSubClassMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId
					AND Product_SubDept_Master_Id = @PrdSubDeptId
					AND Product_Class_Master_Id = @PrdClassId)
		BEGIN
			--ProductSubClass
			INSERT INTO Product_SubClass_Master
			(
				Dist_Id,
				Product_Dept_Master_Id,
				Product_SubDept_Master_Id,
				Product_Class_Master_Id,
				Product_SubClass_Master_Desc,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			SELECT @distId, @PrdDeptId, @PrdSubDeptId, @PrdClassId, ProductSubClassMasterDesc, GETDATE(),GETDATE(), 'ProdAddProc' FROM @Product WHERE Name = @prdName
		END			
		SELECT @PrdSubClassId = Product_SubClass_Master_Identity FROM Product_SubClass_Master WHERE Dist_Id=@distId AND Product_SubClass_Master_Desc 
					IN (SELECT ProductSubClassMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId
					AND Product_SubDept_Master_Id = @PrdSubDeptId
					AND Product_Class_Master_Id = @PrdClassId

			
		IF NOT EXISTS(SELECT 1 FROM Product_MC_Master WHERE Dist_Id=@distId AND Product_MC_Master_Desc 
					IN (SELECT ProductMcMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId
					AND Product_SubDept_Master_Id = @PrdSubDeptId
					AND Product_Class_Master_Id = @PrdClassId
					AND Product_SubClass_Master_Id = @PrdSubClassId)
		BEGIN
			--ProductMc
			INSERT INTO Product_MC_Master
			(
				Dist_Id,
				Product_Dept_Master_Id,
				Product_SubDept_Master_Id,
				Product_Class_Master_Id,
				Product_SubClass_Master_Id,
				Product_MC_Master_Desc,
				Product_MC_Code,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			SELECT @distId, @PrdDeptId, @PrdSubDeptId, @PrdClassId, @PrdSubClassId, ProductMcMasterDesc, ProductMcMasterCode, GETDATE(),GETDATE(), 'ProdAddProc' FROM @Product WHERE Name = @prdName
		END			
		SELECT @PrdMcId = Product_MC_Master_Identity FROM Product_MC_Master WHERE Dist_Id=@distId AND Product_MC_Master_Desc 
					IN (SELECT ProductMcMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId
					AND Product_SubDept_Master_Id = @PrdSubDeptId
					AND Product_Class_Master_Id = @PrdClassId
					AND Product_SubClass_Master_Id = @PrdSubClassId

		IF NOT EXISTS(SELECT 1 FROM Product_Brand_Master WHERE Dist_Id=@distId AND Product_Brand_Desc 
					IN (SELECT ProductBrandMasterDesc FROM @Product WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId
					AND Product_SubDept_Master_Id = @PrdSubDeptId
					AND Product_Class_Master_Id = @PrdClassId
					AND Product_SubClass_Master_Id = @PrdSubClassId
					AND Product_MC_Master_Id = @PrdMcId)
		BEGIN
			--ProductBrand
			INSERT INTO Product_Brand_Master
			(
				Dist_Id,
				Product_Dept_Master_Id,
				Product_SubDept_Master_Id,
				Product_Class_Master_Id,
				Product_SubClass_Master_Id,
				Product_MC_Master_Id,
				Product_Brand_Desc,
				Product_Brand_Company_Desc,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			SELECT @distId, @PrdDeptId, @PrdSubDeptId, @PrdClassId, @PrdSubClassId, @PrdMcId, ProductBrandMasterDesc, ProductBrandMasterCompanyDesc, GETDATE(),GETDATE(), 'ProdAddProc' FROM @Product WHERE Name = @prdName
		END			
		SELECT @PrdBrandId = Product_Brand_Master_Identity FROM Product_Brand_Master WHERE Dist_Id=@distId AND Product_Brand_Desc 
					IN (SELECT ProductBrandMasterDesc FROM @Product
					 WHERE Name = @prdName)
					AND Product_Dept_Master_Id = @PrdDeptId
					AND Product_SubDept_Master_Id = @PrdSubDeptId
					AND Product_Class_Master_Id = @PrdClassId
					AND Product_SubClass_Master_Id = @PrdSubClassId
					AND Product_MC_Master_Id = @PrdMcId		
			
		IF(@prdToAdd = 1)
		BEGIN

			INSERT INTO Product_Master
			(
				Dist_Id,
				Name,
				Barcode,
				ProdDescription,
				UOMType,
				Base_UOM_Id,
				Product_Dept_Master_Identity,
				Product_SubDept_Master_Id,
				Product_Class_Master_Id,
				Product_SubClass_Master_Id,
				Product_MC_Master_Id,
				Product_Brand_Master_Id,
				Article_Code,
				IsDefaultProduct,
				IsDefaultGiveRation,	
				Active,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			
			SELECT
			
			@distId,
			Name,
			Barcode,
			ProdDescription,
			BaseUOMType,
			BaseUOM_Id_Identity,
			@PrdDeptId,
			@PrdSubDeptId,
			@PrdClassId,
			@PrdSubClassId,
			@PrdMcId,
			@PrdBrandId,			
			Article_Code,
			CASE WHEN (IsDefaultProduct = 'true') THEN 1 ELSE 0 END,
			CASE WHEN (IsDefaultGiveRation = 'true') THEN 1 ELSE 0 END,
			CASE WHEN (Active = 'true') THEN 1 ELSE 0 END,
			GETDATE(),
			GETDATE(),
			'PrdAddProc'
			
			FROM @Product WHERE Name = @prdName

		END
		ELSE IF(@prdToEdit = 1)
		BEGIN

			UPDATE Product_Master
			SET
				Barcode = tmpPrd.Barcode,
				ProdDescription = tmpPrd.ProdDescription,
				--UOMType,
				--Base_UOM_Id,
				Product_Dept_Master_Identity = @PrdDeptId,
				Product_SubDept_Master_Id = @PrdSubDeptId,
				Product_Class_Master_Id = @PrdClassId,
				Product_SubClass_Master_Id = @PrdSubClassId,
				Product_MC_Master_Id = @PrdMcId,
				Product_Brand_Master_Id = @PrdBrandId,
				Article_Code = tmpPrd.Article_Code,
				IsDefaultProduct = CASE WHEN (tmpPrd.IsDefaultProduct = 'true') THEN 1 ELSE 0 END,
				IsDefaultGiveRation = CASE WHEN (tmpPrd.IsDefaultGiveRation = 'true') THEN 1 ELSE 0 END,	
				Active = CASE WHEN (tmpPrd.Active = 'true') THEN 1 ELSE 0 END,
				Last_Updated_Date = GETDATE()

			FROM @Product AS tmpPrd
			INNER JOIN Product_Master AS P
			ON P.Name = tmpPrd.Name
			WHERE tmpPrd.Name = @prdName			

		END
			
		SELECT @prdId = Product_Master_Identity FROM Product_Master WHERE Name= @PrdName AND Dist_Id=@distId

		IF(@prdToEdit = 1)
		BEGIN

			DELETE FROM Product_Quantity_Master
			WHERE Prod_Id = @prdId

		END

		IF((@prdToAdd = 1) OR (@prdToEdit = 1))
		BEGIN
		
		INSERT INTO Product_Quantity_Master
		(
			Prod_Id,
			Cat_Id,
			DefaultQuantityInBaseUom,
			IsQuantityForFamily,--Default quantity is for family or individual 1-family 0-individual
			Active,
			Created_Date,
			Last_Updated_Date,
			Updated_By
		)
		SELECT 
			
		@prdId,
		QuantityCat_Id,
		QuantityDefaultQuantityInBaseUom,
		CASE WHEN (QuantityIsQuantityForFamily = 'true') THEN 1 ELSE 0 END,
		CASE WHEN (QuantityActive = 'true') THEN 1 ELSE 0 END,
		GETDATE(),
		GETDATE(),
		'PrdAddProc'

		FROM @PrdQuantityAllocated WHERE Name= @PrdName

		END

		IF(@prdToAdd = 1)
		BEGIN

		INSERT INTO Product_Rate
		(
			Prod_Id,
			Buying_Rate_In_Base_Uom,
			Selling_Rate_In_Base_Uom,
			Mrp_Rate_In_Base_Uom,
			Created_Date,
			Last_Updated_Date,
			Updated_By
		)
		SELECT

		@prdId,
		Buying_Rate_In_Base_Uom,
		Selling_Rate_In_Base_Uom,
		Mrp_Rate_In_Base_Uom,
		GETDATE(),
		GETDATE(),
		'PrdAddProc'

		FROM @Product WHERE Name= @PrdName

		END
		ELSE IF(@prdToEdit = 1)
		BEGIN

			UPDATE Product_Rate
			SET 
			Prod_Id = @prdId,
			Buying_Rate_In_Base_Uom = PQ.Buying_Rate_In_Base_Uom,
			Selling_Rate_In_Base_Uom = PQ.Selling_Rate_In_Base_Uom,
			Mrp_Rate_In_Base_Uom = PQ.Mrp_Rate_In_Base_Uom,
			Last_Updated_Date = GETDATE()

			FROM @Product AS PQ
			INNER JOIN Product_Master AS P
			ON P.Name = PQ.Name
			INNER JOIN Product_Rate AS PR
			ON PR.Prod_Id = P.Product_Master_Identity
			WHERE PQ.Name= @PrdName
			AND P.Product_Master_Identity = @prdId

		END

		SELECT @Product_Rate_Id = Product_Rate_Identity FROM Product_Rate WHERE Prod_Id = @prdId

		IF(@prdToAdd = 1) OR (@prdToEdit = 1)
		BEGIN

		INSERT INTO Product_Stock
		(
			Dist_Id,
			Prod_Id,
			Cat_Id,
			UOM_Id,	
			ProdQuantity,
			AllowedDamageQuantityPerUnit,
			TotalAllowedDamageQuantity,
			TotalDamageQuantityInReal,
			IsStockIn,
			Created_Date
		)
		SELECT

		@distId,
		@prdId,
		ST.Cat_Id,
		ST.UOM_Id,
		ST.StockProdQuantity,
		ST.StockAllowedDamageQuantityPerUnit,
		ST.StockTotalAllowedDamageQuantity,
		ST.StockTotalDamageQuantityInReal,
		1,
		ST.Created_Date

		FROM @StockInBaseUom AS ST
		WHERE ST.Name= @PrdName

		END
					
		UPDATE Product_Master
		SET Product_Rate_Id = @Product_Rate_Id
		WHERE Product_Master_Identity = @prdId
			
		IF(@prdToEdit = 1)
		BEGIN

			DELETE FROM Product_Uom
			WHERE Product_Id = @prdId

		END

		IF((@prdToAdd = 1) OR (@prdToEdit = 1))
		BEGIN
		
			INSERT INTO Product_Uom
			(
				Dist_Id,
				Product_Id,
				Uom_Id,
				IsBaseuom,
				ConversionFactorWithBaseUom,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			SELECT

			@distId,
			@prdId,
			U.UOM_Id_Identity,
			CASE WHEN (AU.IsBaseUom = 'true') THEN 1 ELSE 0 END,
			AU.ConversionFactorWithBaseUom,
			GETDATE(),
			GETDATE(),
			'PrdAddProc'

			FROM @AllUom AS AU
			INNER JOIN UOM AS U
			ON U.UOMName = AU.UOMName
			AND U.UOMType = AU.UOMType			
			WHERE AU.Name= @PrdName
			AND U.Dist_Id = @distId			

		END	

		INSERT INTO @StatusTable SELECT 'SUCCESS' AS [Status]
		, CASE WHEN (@action = 'ADD') THEN 'Product added successfully' ELSE 'Product Edited successfully' END AS StatusMsg, @prdName AS Name	


		SET @count = @count + 1		
	END -- while end		
		
	SELECT [Status], StatusMsg, Name FROM @StatusTable
	
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
