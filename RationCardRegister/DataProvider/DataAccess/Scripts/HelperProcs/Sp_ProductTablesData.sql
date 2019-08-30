IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_ProductTablesData]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_ProductTablesData]
GO 
--EXEC Sp_ProductTablesData 'jayanta98314@gmail.com', '','','DELETE'                    
--EXEC Sp_ProductTablesData 'jayanta98314@gmail.com', 'Product_Master','104','DELETE'                                                                                               

CREATE PROCEDURE [dbo].[Sp_ProductTablesData]
	@distId VARCHAR(50),
	@table VARCHAR(50),
	@Id VARCHAR(10),
	@action VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY

	DECLARE @tablesReturning VARCHAR(200)
	DECLARE @prdsToBeTreated TABLE
	(Prod_Id VARCHAR(50))
	SET @tablesReturning = ''

	IF((@table = 'Product_Master') AND (ISNULL(@id, '') <> ''))
	BEGIN
		INSERT INTO @prdsToBeTreated VALUES (@id)		
	END
	ELSE
	BEGIN
		INSERT INTO @prdsToBeTreated
		SELECT Product_Master_Identity FROM Product_Master
		WHERE Active = 1 
		AND Dist_Id = @distId
	END

	

	IF(@action = 'GET')
	BEGIN
		
		IF((ISNULL(@table, '') = '') OR @table = 'Product_Master')
		BEGIN
		--table 0
			SELECT * FROM Product_Master
			WHERE Active = 1 
			AND Dist_Id = @distId

			SET @tablesReturning += 'Product_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Rate')
		BEGIN
		--table 1
			SELECT * FROM Product_Rate WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated)
			SET @tablesReturning += 'Product_Rate,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Stock')
		BEGIN
		--table 2
			SELECT * FROM Product_Stock  WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated) AND Dist_Id = @distId
			SET @tablesReturning += 'Product_Stock,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Uom')
		BEGIN
		--table 3
			SELECT * FROM Product_Uom  WHERE Product_Id IN (SELECT Prod_Id FROM @prdsToBeTreated) AND Dist_Id = @distId
			SET @tablesReturning += 'Product_Uom,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Quantity_Master')
		BEGIN
		--table 4
			SELECT * FROM Product_Quantity_Master WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated)
			SET @tablesReturning += 'Product_Quantity_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Dept_Master')
		BEGIN
		--table 5
			SELECT * FROM Product_Dept_Master
			WHERE Dist_Id = @distId

			SET @tablesReturning += 'Product_Dept_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_SubDept_Master')
		BEGIN
		--table 6
			SELECT * FROM Product_SubDept_Master
			WHERE Dist_Id = @distId

			SET @tablesReturning += 'Product_SubDept_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Class_Master')
		BEGIN
		--table 7
			SELECT * FROM Product_Class_Master
			WHERE Dist_Id = @distId

			SET @tablesReturning += 'Product_Class_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_SubClass_Master')
		BEGIN
		--table 8
			SELECT * FROM Product_SubClass_Master
			WHERE Dist_Id = @distId

			SET @tablesReturning += 'Product_SubClass_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_MC_Master')
		BEGIN
		--table 9
			SELECT * FROM Product_MC_Master
			WHERE Dist_Id = @distId

			SET @tablesReturning += 'Product_MC_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Brand_Master')
		BEGIN
		--table 10
			SELECT * FROM Product_Brand_Master
			WHERE Dist_Id = @distId

			SET @tablesReturning += 'Product_Brand_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Input')
		BEGIN
		--table 11
			SELECT * FROM Product_Input
			WHERE Dist_Id = @distId

			SET @tablesReturning += 'Product_Input,'
		END
				
		IF((ISNULL(@table, '') = '') OR @table = 'ALL')
		BEGIN
		--table 12
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
			PR.Selling_Rate_In_Base_Uom,

			PS.Product_Stock_Identity,
			PS.UOM_Id,
			PS.ProdQuantity,
			PS.AllowedDamageQuantityPerUnit,
			PS.TotalAllowedDamageQuantity,
			PS.TotalDamageQuantityInReal


			
			FROM Product_Master AS P
			LEFT JOIN Product_Rate AS PR
			ON P.Product_Master_Identity = PR.Prod_Id
			LEFT JOIN Product_Stock AS PS
			ON P.Product_Master_Identity = PS.Prod_Id
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
			AND P.Product_Class_Master_Id = PC.Product_SubDept_Master_Id

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

			SET @tablesReturning += 'Product_Master_Combi,'

			--table 13
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

			SET @tablesReturning += 'Product_Quantity_Master_Combi,'

			--table 14
			SELECT
	
			P.Product_Master_Identity,
			PU.Product_Uom_Identity,
			PU.ConversionFactorWithBaseUom,
			U.UOM_Id_Identity,
			U.UOMName,
			U.UOMType

			FROM Product_Master AS P
			INNER JOIN Product_Uom AS PU
			ON P.Product_Master_Identity = PU.Product_Id
			INNER JOIN Uom AS U
			ON PU.Uom_Id = U.UOM_Id_Identity
			WHERE P.Active = 1 
			AND P.Dist_Id = @distId
			
			SET @tablesReturning += 'Product_Uom_Combi,'
		END
		--table 15
		SELECT 'SUCCESSFULY FETCHED', @tablesReturning
	END
	ELSE IF(@action = 'DELETE')
	BEGIN

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Master')
		BEGIN

		DELETE FROM Product_Master
		WHERE Product_Master_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Master_Identity ELSE @id END
		AND Active = 1 
		AND Dist_Id = @distId

		SET @tablesReturning += 'Product_Master,'

		DELETE FROM Product_Rate
		WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated) 
		SET @tablesReturning += 'Product_Rate,'

		DELETE FROM Product_Stock 
		WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated) AND Dist_Id = @distId
		SET @tablesReturning += 'Product_Stock,'

		DELETE FROM Product_Uom
		WHERE Product_Id IN (SELECT Prod_Id FROM @prdsToBeTreated) AND Dist_Id = @distId
		SET @tablesReturning += 'Product_Uom,'

		DELETE FROM Product_Quantity_Master
		WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated)
		SET @tablesReturning += 'Product_Quantity_Master,'

		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Rate')
		BEGIN
		DELETE FROM Product_Rate
		WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated) 
		AND Product_Rate_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Rate_Identity ELSE @id END
		SET @tablesReturning += 'Product_Rate,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Stock')
		BEGIN
		DELETE FROM Product_Stock 
		WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated) AND Dist_Id = @distId
		AND Product_Stock_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Stock_Identity ELSE @id END
		SET @tablesReturning += 'Product_Stock,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Uom')
		BEGIN
		DELETE FROM Product_Uom
		WHERE Product_Id IN (SELECT Prod_Id FROM @prdsToBeTreated) AND Dist_Id = @distId
		AND Product_Uom_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Uom_Identity ELSE @id END
		SET @tablesReturning += 'Product_Uom,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Quantity_Master')
		BEGIN
		DELETE FROM Product_Quantity_Master
		WHERE Prod_Id IN (SELECT Prod_Id FROM @prdsToBeTreated)
		AND Product_Quantity_Master_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Quantity_Master_Identity ELSE @id END
		SET @tablesReturning += 'Product_Quantity_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Dept_Master')
		BEGIN
		DELETE FROM Product_Dept_Master
		WHERE Dist_Id = @distId
		AND Product_Dept_Master_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Dept_Master_Identity ELSE @id END
		SET @tablesReturning += 'Product_Dept_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_SubDept_Master')
		BEGIN
		DELETE FROM Product_SubDept_Master
		WHERE Dist_Id = @distId
		AND Product_SubDept_Master_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_SubDept_Master_Identity ELSE @id END
		SET @tablesReturning += 'Product_SubDept_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Class_Master')
		BEGIN
		DELETE FROM Product_Class_Master
		WHERE Dist_Id = @distId
		AND Product_Class_Master_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Class_Master_Identity ELSE @id END
		SET @tablesReturning += 'Product_Class_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_SubClass_Master')
		BEGIN
		DELETE FROM Product_SubClass_Master
		WHERE Dist_Id = @distId
		AND Product_SubClass_Master_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_SubClass_Master_Identity ELSE @id END
		SET @tablesReturning += 'Product_SubClass_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_MC_Master')
		BEGIN
		DELETE FROM Product_MC_Master
		WHERE Dist_Id = @distId
		AND Product_MC_Master_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_MC_Master_Identity ELSE @id END
		SET @tablesReturning += 'Product_MC_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Brand_Master')
		BEGIN
		DELETE FROM Product_Brand_Master
		WHERE Dist_Id = @distId
		AND Product_Brand_Master_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Brand_Master_Identity ELSE @id END
		SET @tablesReturning += 'Product_Brand_Master,'
		END

		IF((ISNULL(@table, '') = '') OR @table = 'Product_Input')
		BEGIN
		DELETE FROM Product_Input
		WHERE Dist_Id = @distId
		AND Product_Input_Identity = CASE WHEN ISNULL(@id, '')='' THEN Product_Input_Identity ELSE @id END
		SET @tablesReturning += 'Product_Input,'
		END

		SELECT 'SUCCESSFULLY DELETED', @tablesReturning AS TablesTreated
	END

	END TRY
	BEGIN CATCH

	SELECT  'FAILURE'
		,ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;

	END CATCH
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