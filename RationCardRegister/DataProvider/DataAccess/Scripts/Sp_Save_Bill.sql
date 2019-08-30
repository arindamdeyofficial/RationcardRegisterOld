IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Save_Bill]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Save_Bill]
GO
--EXEC Sp_Save_Bill 1, 
--'<Bill xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" PrdDefaultQuantitySummary="RKSY-I || 122 || False," BillSerialNumber="1" BillNumber="22" Fortnight="1" TotalCardServed="3" RationcardNumbers="RKSY-I-206265734, RKSY-I-206265735, RKSY-I-206265736" TotalPrice="5138" TotalRoundedOff="5138" TotalDiscount="1835" CustomerPaid="5140" BalanceReturn="2" CreatedDate="06-04-2018 21:44:22">
--  <BillDetails NumberOfCards="3" CardNumbers="RKSY-I-206265734,RKSY-I-206265735,RKSY-I-206265736">
--    <CardCategory Cat_Id="3" Cat_Desc="RKSY-I" />
--    <ProductsSold Product_Master_Identity="35" Name="RICE" BarCode="daf" ArticleCode="fe" ProdDescription="WF" Active="true" 
--	IsDefaultProduct="true" IsDefaultGiveRation="true" ConsumptionQuantity="366" SellingRateInBaseUom="15" BuyingRateInBaseUom="14" MrpRateInBaseUom="19">
--      <BaseUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--      <AllUom>
--        <Uom ProdId="35" UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--        <Uom ProdId="35" UOMName="unit" IsBaseUom="false" UOMType="count" UOM_Id_Identity="12" ConversionFactorWithBaseUom="2" />
--      </AllUom>
--      <PrdQuantityAllocated>
--        <ProductQuantityMaster Product_Quantity_Master_Identity="208" ProductId="35" DefaultQuantityInBaseUom="1" IsQuantityForFamily="true" Active="false">
--          <CategoryDetails Cat_Id="1" Cat_Desc="AAY" />
--        </ProductQuantityMaster>
--        <ProductQuantityMaster Product_Quantity_Master_Identity="209" ProductId="35" DefaultQuantityInBaseUom="122" IsQuantityForFamily="false" Active="false">
--          <CategoryDetails Cat_Id="3" Cat_Desc="RKSY-I" />
--        </ProductQuantityMaster>
--      </PrdQuantityAllocated>
--      <ProductDept ProductDeptMasterId="26" ProductDeptMasterDesc="wwf" />
--      <ProductSubDept ProductSubDeptMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterDesc="wfef" />
--      <ProductClass ProductClassMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterId="26" ProductClassMasterDesc="rgrg" />
--      <ProductSubClass ProductSubClassMasterId="27" ProductClassMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterId="26" ProductSubClassMasterDesc="fvfv" />
--      <ProductMc ProductMcMasterId="27" ProductMcMasterCode="egr" ProductSubClassMasterId="27" ProductClassMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterId="26" ProductMcMasterDesc="dfa" />
--      <ProductBrand ProductBrandMasterId="28" ProductBrandMasterDesc="rgrg" ProductMcMasterId="27" ProductSubClassMasterId="27" ProductClassMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterId="26" ProductBrandMasterCompanyDesc="rgrg" />
--      <UnitOfMeasureDetail UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--      <StockInBaseUom Product_Stock_Identity="70" Prod_Id="35" ProdQuantity="25" AllowedDamageQuantityPerUnit="1" TotalAllowedDamageQuantity="5" TotalDamageQuantityInReal="8" StockEntryTime="04-06-2018 09:03:50" EntryMode="NONE">
--        <CategoryDetails Cat_Id="1" Cat_Desc="AAY" />
--        <StockUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="0" />
--      </StockInBaseUom>
--      <StockInBaseUom Product_Stock_Identity="71" Prod_Id="35" ProdQuantity="89" AllowedDamageQuantityPerUnit="1" TotalAllowedDamageQuantity="8" TotalDamageQuantityInReal="8" StockEntryTime="04-06-2018 09:03:58" EntryMode="NONE">
--        <CategoryDetails Cat_Id="3" Cat_Desc="RKSY-I" />
--        <StockUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="0" />
--      </StockInBaseUom>
--    </ProductsSold>
--  </BillDetails>
--  <BillDetails NumberOfCards="3" CardNumbers="RKSY-I-206265734,RKSY-I-206265735,RKSY-I-206265736">
--    <CardCategory Cat_Id="5" Cat_Desc="RKSY-II" />
--    <ProductsSold Product_Master_Identity="35" Name="RICE" BarCode="daf" ArticleCode="fe" ProdDescription="WF" Active="true" 
--	IsDefaultProduct="true" IsDefaultGiveRation="true" ConsumptionQuantity="366" SellingRateInBaseUom="15" BuyingRateInBaseUom="14" MrpRateInBaseUom="19">
--      <BaseUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--      <AllUom>
--        <Uom ProdId="35" UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--        <Uom ProdId="35" UOMName="unit" IsBaseUom="false" UOMType="count" UOM_Id_Identity="12" ConversionFactorWithBaseUom="2" />
--      </AllUom>
--      <PrdQuantityAllocated>
--        <ProductQuantityMaster Product_Quantity_Master_Identity="208" ProductId="35" DefaultQuantityInBaseUom="1" IsQuantityForFamily="true" Active="false">
--          <CategoryDetails Cat_Id="1" Cat_Desc="AAY" />
--        </ProductQuantityMaster>
--        <ProductQuantityMaster Product_Quantity_Master_Identity="209" ProductId="35" DefaultQuantityInBaseUom="122" IsQuantityForFamily="false" Active="false">
--          <CategoryDetails Cat_Id="3" Cat_Desc="RKSY-I" />
--        </ProductQuantityMaster>
--      </PrdQuantityAllocated>
--      <ProductDept ProductDeptMasterId="26" ProductDeptMasterDesc="wwf" />
--      <ProductSubDept ProductSubDeptMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterDesc="wfef" />
--      <ProductClass ProductClassMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterId="26" ProductClassMasterDesc="rgrg" />
--      <ProductSubClass ProductSubClassMasterId="27" ProductClassMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterId="26" ProductSubClassMasterDesc="fvfv" />
--      <ProductMc ProductMcMasterId="27" ProductMcMasterCode="egr" ProductSubClassMasterId="27" ProductClassMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterId="26" ProductMcMasterDesc="dfa" />
--      <ProductBrand ProductBrandMasterId="28" ProductBrandMasterDesc="rgrg" ProductMcMasterId="27" ProductSubClassMasterId="27" ProductClassMasterId="26" ProductDeptMasterId="26" ProductSubDeptMasterId="26" ProductBrandMasterCompanyDesc="rgrg" />
--      <UnitOfMeasureDetail UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--      <StockInBaseUom Product_Stock_Identity="70" Prod_Id="35" ProdQuantity="25" AllowedDamageQuantityPerUnit="1" TotalAllowedDamageQuantity="5" TotalDamageQuantityInReal="8" StockEntryTime="04-06-2018 09:03:50" EntryMode="NONE">
--        <CategoryDetails Cat_Id="1" Cat_Desc="AAY" />
--        <StockUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="0" />
--      </StockInBaseUom>
--      <StockInBaseUom Product_Stock_Identity="71" Prod_Id="35" ProdQuantity="89" AllowedDamageQuantityPerUnit="1" TotalAllowedDamageQuantity="8" TotalDamageQuantityInReal="8" StockEntryTime="04-06-2018 09:03:58" EntryMode="NONE">
--        <CategoryDetails Cat_Id="3" Cat_Desc="RKSY-I" />
--        <StockUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="0" />
--      </StockInBaseUom>
--    </ProductsSold>
--  </BillDetails>
--  <BillDetails NumberOfCards="3" CardNumbers="BusinessObjects.RationCard.Model.RationCardDetailExtended,BusinessObjects.RationCard.Model.RationCardDetailExtended,BusinessObjects.RationCard.Model.RationCardDetailExtended">
--    <CardCategory />
--    <ProductsSold Product_Master_Identity="36" Name="DAL" BarCode="efr" ArticleCode="rg" ProdDescription="DE" Active="true" IsDefaultProduct="false" IsDefaultGiveRation="true" ConsumptionQuantity="1" SellingRateInBaseUom="18" BuyingRateInBaseUom="14" MrpRateInBaseUom="19">
--      <BaseUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--      <AllUom>
--        <Uom ProdId="36" UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--        <Uom ProdId="36" UOMName="unit" IsBaseUom="false" UOMType="count" UOM_Id_Identity="12" ConversionFactorWithBaseUom="2" />
--      </AllUom>
--      <PrdQuantityAllocated />
--      <ProductDept ProductDeptMasterId="27" ProductDeptMasterDesc="rhj" />
--      <ProductSubDept ProductSubDeptMasterId="27" ProductDeptMasterId="27" ProductSubDeptMasterDesc="rdfdf" />
--      <ProductClass ProductClassMasterId="27" ProductDeptMasterId="27" ProductSubDeptMasterId="27" ProductClassMasterDesc="5y5" />
--      <ProductSubClass ProductSubClassMasterId="28" ProductClassMasterId="27" ProductDeptMasterId="27" ProductSubDeptMasterId="27" ProductSubClassMasterDesc="dwd" />
--      <ProductMc ProductMcMasterId="28" ProductMcMasterCode="egrvd" ProductSubClassMasterId="28" ProductClassMasterId="27" ProductDeptMasterId="27" ProductSubDeptMasterId="27" ProductMcMasterDesc="ftjy" />
--      <ProductBrand ProductBrandMasterId="29" ProductBrandMasterDesc="gju" ProductMcMasterId="28" ProductSubClassMasterId="28" ProductClassMasterId="27" ProductDeptMasterId="27" ProductSubDeptMasterId="27" ProductBrandMasterCompanyDesc="ghk" />
--      <UnitOfMeasureDetail ProdId="36" UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="1" />
--      <StockInBaseUom Product_Stock_Identity="72" Prod_Id="36" ProdQuantity="12" AllowedDamageQuantityPerUnit="1" TotalAllowedDamageQuantity="2" TotalDamageQuantityInReal="4" StockEntryTime="04-06-2018 10:24:54" EntryMode="NONE">
--        <CategoryDetails Cat_Id="" Cat_Desc="" />
--        <StockUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="0" />
--      </StockInBaseUom>
--      <StockInBaseUom Product_Stock_Identity="73" Prod_Id="36" ProdQuantity="45" AllowedDamageQuantityPerUnit="1" TotalAllowedDamageQuantity="4" TotalDamageQuantityInReal="4" StockEntryTime="04-06-2018 10:25:06" EntryMode="NONE">
--        <CategoryDetails Cat_Id="" Cat_Desc="" />
--        <StockUom UOMName="pack" IsBaseUom="true" UOMType="count" UOM_Id_Identity="10" ConversionFactorWithBaseUom="0" />
--      </StockInBaseUom>
--    </ProductsSold>
--  </BillDetails>
--</Bill>'

--select * from Bill_Input
--select * from Bill_Details
--select * from Bill_Master

--DELETE from Bill_Input
--DELETE from Bill_Details
--DELETE from Bill_Master

CREATE PROCEDURE [dbo].[Sp_Save_Bill]
	@distId VARCHAR(2),
	@billData XML
AS
BEGIN
	
	SET NOCOUNT ON;	
	BEGIN TRY
		
		DECLARE @billId VARCHAR(100)

		INSERT INTO Bill_Input
		(
			DistId,
			Bill_Xml,
			Created_Date
		)
		VALUES(@distid, @billData, GETDATE())

		DECLARE @Bill Table
		(
			RowNum INT,
			BillAmount DECIMAL(15),
			BillAmountRoundedOff DECIMAL(15),
			Discount DECIMAL(15),
			PaidAmount DECIMAL(15),
			BalanceAmount DECIMAL(15),
			BillSerialNumber VARCHAR(100),
			BillNumber VARCHAR(100),
			Fortnight INT,
			TotalCardServed INT,
			RationcardNumbers VARCHAR(1000),
			PrdDefaultQuantitySummary VARCHAR(2000),
			Created_Date VARCHAR(40)
		)

		DECLARE @BillDetails Table
		(
			RowNum INT,
			Prod_Id INT,
			Cat_Id INT,
			Quantity DECIMAL(15,2),
			ConversionFactorWithBaseUom DECIMAL(10,2),
			QuantityUOM_Id INT,
			Name VARCHAR(1000),
			Barcode VARCHAR(100),
			ProdDescription VARCHAR(1000),
			UOMType VARCHAR(100),
			Base_UOM_Id INT,
			Product_Dept VARCHAR(100),
			Product_SubDept VARCHAR(100),
			Product_Class VARCHAR(100),
			Product_SubClass VARCHAR(100),
			Product_MC VARCHAR(100),
			Product_Brand VARCHAR(100),
			Product_Stock DECIMAL(10,2),
			Product_Selling_Rate DECIMAL(10,2),
			Product_Buying_Rate DECIMAL(10,2),
			Product_Mrp_Rate DECIMAL(10,2),
			Article_Code VARCHAR(50),	
			IsDefaultProduct VARCHAR(10),
			IsDefaultGiveRation VARCHAR(10)
		)

		INSERT INTO @Bill
		SELECT 

		ROW_NUMBER() OVER(ORDER BY T1.L1.value('@BillSerialNumber', 'VARCHAR(10)') ASC) AS RowNum
		,T1.L1.value('@TotalPrice', 'VARCHAR(10)') AS BillAmount
		,T1.L1.value('@TotalRoundedOff', 'VARCHAR(10)') AS BillAmountRoundedOff
		,T1.L1.value('@TotalDiscount', 'VARCHAR(10)') AS Discount
		,T1.L1.value('@CustomerPaid', 'VARCHAR(10)') AS PaidAmount
		,T1.L1.value('@BalanceReturn', 'VARCHAR(10)') AS BalanceAmount
		,T1.L1.value('@BillSerialNumber', 'VARCHAR(10)') AS BillSerialNumber
		,T1.L1.value('@BillNumber', 'VARCHAR(10)') AS BillNumber
		,T1.L1.value('@Fortnight', 'VARCHAR(100)') AS Fortnight
		,T1.L1.value('@TotalCardServed', 'VARCHAR(100)') AS TotalCardServed	
		,T1.L1.value('@RationcardNumbers', 'VARCHAR(100)') AS RationcardNumbers
		,T1.L1.value('@PrdDefaultQuantitySummary', 'VARCHAR(100)') AS PrdDefaultQuantitySummary
		,T1.L1.value('@CreatedDate', 'VARCHAR(40)') AS Created_Date

		FROM  @billData.nodes('/Bill') AS T1(L1)

		INSERT INTO @BillDetails
		(
			RowNum,
			Prod_Id,
			Cat_Id,
			Quantity,
			ConversionFactorWithBaseUom,
			QuantityUOM_Id,
			Name,
			Barcode,
			ProdDescription,
			UOMType,
			Base_UOM_Id,
			Product_Dept,
			Product_SubDept,
			Product_Class,
			Product_SubClass,
			Product_MC,
			Product_Brand,
			Product_Stock,
			Product_Selling_Rate,
			Product_Buying_Rate,
			Product_Mrp_Rate,
			Article_Code,	
			IsDefaultProduct,
			IsDefaultGiveRation
		)
		SELECT 

		ROW_NUMBER() OVER(ORDER BY T1.L1.value('(ProductsSold/@Product_Master_Identity)[1]', 'VARCHAR(10)') ASC) AS RowNum
		,T1.L1.value('(ProductsSold/@Product_Master_Identity)[1]', 'VARCHAR(1000)') AS Prod_Id
		,T1.L1.value('(CardCategory/@Cat_Id)[1]', 'VARCHAR(1000)') AS Cat_Id
		,T1.L1.value('(ProductsSold/@ConsumptionQuantity)[1]', 'VARCHAR(100)') AS Quantity
		,T1.L1.value('(ProductsSold/UnitOfMeasureDetail/@ConversionFactorWithBaseUom)[1]', 'VARCHAR(10)') AS ConversionFactorWithBaseUom
		,T1.L1.value('(ProductsSold/UnitOfMeasureDetail/@UOM_Id_Identity)[1]', 'VARCHAR(100)') AS QuantityUOM_Id
		,T1.L1.value('(ProductsSold/@Name)[1]', 'VARCHAR(1000)') AS Name
		,T1.L1.value('(ProductsSold/@BarCode)[1]', 'VARCHAR(100)') AS Barcode
		,T1.L1.value('(ProductsSold/@ProdDescription)[1]', 'VARCHAR(100)') AS ProdDescription
		,T1.L1.value('(ProductsSold/@Product_Master_Identity)[1]', 'VARCHAR(1000)') AS UOMType
		,T1.L1.value('(ProductsSold/BaseUom/@UOM_Id_Identity)[1]', 'VARCHAR(100)') AS Base_UOM_Id
		,T1.L1.value('(ProductsSold/ProductDept/@ProductDeptMasterDesc)[1]', 'VARCHAR(100)') AS Product_Dept
		,T1.L1.value('(ProductsSold/ProductSubDept/@ProductSubDeptMasterDesc)[1]', 'VARCHAR(1000)') AS Product_SubDept
		,T1.L1.value('(ProductsSold/ProductClass/@ProductClassMasterDesc)[1]', 'VARCHAR(100)') AS Product_Class
		,T1.L1.value('(ProductsSold/ProductSubClass/@ProductSubClassMasterDesc)[1]', 'VARCHAR(100)') AS Product_SubClass
		,T1.L1.value('(ProductsSold/ProductMc/@ProductMcMasterDesc)[1]', 'VARCHAR(100)') AS Product_MC
		,T1.L1.value('(ProductsSold/ProductBrand/@ProductBrandMasterDesc)[1]', 'VARCHAR(100)') AS Product_Brand
		,T1.L1.value('(ProductsSold/StockInBaseUom/@ProdQuantity)[1]', 'VARCHAR(100)') AS Product_Stock
		,T1.L1.value('(ProductsSold/@SellingRateInBaseUom)[1]', 'VARCHAR(100)') AS Product_Selling_Rate
		,T1.L1.value('(ProductsSold/@BuyingRateInBaseUom)[1]', 'VARCHAR(100)') AS Product_Buying_Rate
		,T1.L1.value('(ProductsSold/@MrpRateInBaseUom)[1]', 'VARCHAR(100)') AS Product_Mrp_Rate
		,T1.L1.value('(ProductsSold/@ArticleCode)[1]', 'VARCHAR(100)') AS Article_Code
		,T1.L1.value('(ProductsSold/@IsDefaultProduct)[1]', 'VARCHAR(10)') AS IsDefaultProduct
		,T1.L1.value('(ProductsSold/@IsDefaultGiveRation)[1]', 'VARCHAR(100)') AS IsDefaultGiveRation

		FROM  @billData.nodes('/Bill/BillDetails') AS T1(L1)
				
		INSERT INTO Bill_Master
		(
			Dist_Id,
			BillAmount,
			BillAmountRoundedOff,
			Discount,
			PaidAmount,
			BalanceAmount,
			BillSerialNumber,
			BillNumber,
			Fortnight,
			TotalCardServed,
			RationcardNumbers,
			PrdDefaultQuantitySummary,
			IsCalculated,
			Created_Date
		)
		SELECT
		
			@distId,
			BillAmount,
			BillAmountRoundedOff,
			Discount,
			PaidAmount,
			BalanceAmount,
			BillSerialNumber,
			BillNumber,
			Fortnight,
			TotalCardServed,
			RationcardNumbers,
			PrdDefaultQuantitySummary,
			0,
			Created_Date
		
		FROM @Bill

		SELECT @billId = Bill_Id_Identity FROM Bill_Master WHERE BillSerialNumber IN (SELECT BillSerialNumber FROM @Bill)

		INSERT INTO Bill_Details
		(
			Bill_Id,
			Prod_Id,
			Cat_Id,
			Quantity,
			QuantityUOM_Id,
			Name,
			Barcode,
			ProdDescription,
			UOMType,
			Base_UOM_Id,
			Product_Dept,
			Product_SubDept,
			Product_Class,
			Product_SubClass,
			Product_MC,
			Product_Brand,
			Product_Stock,
			Product_Selling_Rate,
			Product_Buying_Rate,
			Product_Mrp_Rate,
			Article_Code,	
			IsDefaultProduct,
			IsDefaultGiveRation,
			IsCalculated
		)
		SELECT
		
		@billId,
		Prod_Id,
		Cat_Id,
		Quantity,
		QuantityUOM_Id,
		Name,
		Barcode,
		ProdDescription,
		UOMType,
		Base_UOM_Id,
		Product_Dept,
		Product_SubDept,
		Product_Class,
		Product_SubClass,
		Product_MC,
		Product_Brand,
		Product_Stock,
		Product_Selling_Rate,
		Product_Buying_Rate,
		Product_Mrp_Rate,
		Article_Code,	
		IsDefaultProduct,
		IsDefaultGiveRation,
		0
		
		FROM @BillDetails

		SELECT

		@distId,
		Prod_Id,
		Cat_Id,
		QuantityUOM_Id,
		Quantity,
		0,
		0,
		0,
		0,
		GETDATE()

		FROM @BillDetails

		--manage Stock

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
		Prod_Id,
		Cat_Id,
		QuantityUOM_Id,
		Quantity,
		0,
		0,
		0,
		0,
		GETDATE()

		FROM @BillDetails		

		DECLARE @dt DATETIME
		SET @dt = GETDATE()
		--Update Daily Stock Report
		EXEC Sp_Stockreport 1, '01-01-1900', @dt, 'UPDATE'

		--update bill Count and serial number
		EXEC Sp_Fetch_Bill_Counter @distId, 'UPDATE'

		SELECT 'SUCCESS'

	END TRY
	BEGIN CATCH
		SELECT 'FAILURE' 
		, ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END

