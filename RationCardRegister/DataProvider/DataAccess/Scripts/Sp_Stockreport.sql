IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Stockreport]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Stockreport]
GO 
--EXEC Sp_Stockreport 1, 'Jan  1 1900 12:00AM', 'Jul 29 2018  1:07PM',''
CREATE PROCEDURE [dbo].[Sp_Stockreport]
	@distId VARCHAR(50),
	@dtFrom DATETIME,
	@dtTo DATETIME,
	@operation VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	BEGIN TRY
		INSERT INTO Product_Stock_Report_Input
		(
			Dist_Id,DtFrom, DtTo, Created_Date
		)
		VALUES(@distId, @dtFrom, @dtTo, GETDATE())

		DECLARE @lastUpdateDate DATETIME
		, @openningBalance DECIMAL(10,4)
		, @stockRecieved DECIMAL(10,4)
		, @totalStock DECIMAL(10,4)
		, @stockSold DECIMAL(10,4)
		, @handlingLoss DECIMAL(10,4)
		, @closingBalance DECIMAL(10,4)

		DECLARE @Product_Stock_Report_Tmp TABLE
		(
			RowNum INT,
			Dist_Id INT,
			Prod_Id INT,
			Cat_Id INT,
			UOM_Id INT,	
			OpenningBalance DECIMAL(10,4),
			StockRecieved DECIMAL(10,4),
			TotalStock DECIMAL(10,4),
			StockSold DECIMAL(10,4),
			HandlingLoss DECIMAL(10,4),
			ClosingBalance DECIMAL(10,4),
			Created_Date DATETIME
		)

		DECLARE @Product_Stock_Report_All_Tmp TABLE
		(			
			Dist_Id INT,
			Prod_Id INT,
			Cat_Id INT,
			UOM_Id INT,	
			Stock DECIMAL(10,4),
			HandlingLoss DECIMAL(10,4),
			IsStockIn BIT,
			Created_Date DATETIME
		)

		SELECT @lastUpdateDate = MAX(Created_Date) FROM Product_Stock_Report

		INSERT INTO @Product_Stock_Report_All_Tmp
		(
			Dist_Id,
			Prod_Id,
			Cat_Id,
			UOM_Id,	
			Stock,
			HandlingLoss,
			IsStockIn,
			Created_Date
		)
		SELECT
		Dist_Id,
		Prod_Id,
		Cat_Id,
		UOM_Id,
		ProdQuantity,
		TotalDamageQuantityInReal,
		IsStockIn,
		Created_Date

		FROM Product_Stock
		WHERE Created_Date > ISNULL(@lastUpdateDate, '01-01-1900') AND Created_Date < CONVERT(DATE, GETDATE())
		AND Dist_Id = 1

		INSERT INTO @Product_Stock_Report_Tmp
		(
			RowNum,
			Dist_Id,
			Prod_Id,
			Cat_Id,
			StockRecieved,
			StockSold,
			HandlingLoss,
			Created_Date
		)
		SELECT
		ROW_NUMBER() OVER(ORDER BY Created_Date ASC) AS RowNum,
		Dist_Id,
		Prod_Id,
		Cat_Id,
		SUM(CASE WHEN (IsStockIn = 1) THEN Stock ELSE 0 END) AS StockRecieved,
		SUM(CASE WHEN (IsStockIn = 0) THEN Stock ELSE 0 END) AS StockSold,
		SUM(HandlingLoss) AS HandlingLoss,
		Created_Date

		FROM @Product_Stock_Report_All_Tmp
		GROUP BY Dist_Id,Prod_Id, Cat_Id,Created_Date		
		
		DECLARE @count INT, @rowCount INT
		SET @count = 1
		SELECT @rowCount = COUNT(*) FROM @Product_Stock_Report_Tmp
		WHILE(@count <= @rowCount)
		BEGIN
			SET @openningBalance = 0
			
			DECLARE @prdId INT, @catId INT
			SET @catId = 0

			SELECT @prdId = Prod_Id, @catId = Cat_Id FROM @Product_Stock_Report_Tmp WHERE RowNum = @count
			IF(@count = 1)
			BEGIN
				SELECT @openningBalance = ClosingBalance FROM Product_Stock_Report WHERE Created_Date = @lastUpdateDate AND Prod_Id = @prdId AND Cat_Id = @catId
			END
			ELSE
			BEGIN
				SELECT @openningBalance = ClosingBalance FROM @Product_Stock_Report_Tmp WHERE RowNum = @count - 1 AND Prod_Id = @prdId AND Cat_Id = @catId
			END
			DECLARE @uomId INT
			SELECT @uomId = UOM_Id FROM @Product_Stock_Report_All_Tmp WHERE Prod_Id = @prdId

			UPDATE @Product_Stock_Report_Tmp
			SET OpenningBalance = ISNULL(@openningBalance, 0)
			, TotalStock = ISNULL(@openningBalance, 0) + StockRecieved
			, ClosingBalance = ISNULL(@openningBalance, 0) + StockRecieved - StockSold - HandlingLoss
			, UOM_Id = @uomId
			WHERE RowNum = @count

			SET @count = @count + 1
		END

		--select * from @Product_Stock_Report_Tmp

		INSERT INTO Product_Stock_Report
		(
			Dist_Id,
			Prod_Id,
			Cat_Id,
			UOM_Id,	
			OpenningBalance,
			StockRecieved,
			TotalStock,
			StockSold,
			HandlingLoss,
			ClosingBalance,
			Created_Date
		)
		SELECT 
		
			O.Dist_Id,
			O.Prod_Id,
			O.Cat_Id,
			O.UOM_Id,
			O.OpenningBalance,
			O.StockRecieved,
			O.TotalStock,
			O.StockSold,
			O.HandlingLoss,
			O.ClosingBalance,
			O.Created_Date

		FROM @Product_Stock_Report_Tmp AS O

		IF(@operation <> 'UPDATE')
		BEGIN
			--Report column header
			SELECT 
			'Date',
			'Commodity',
			'Category',			
			'Openning Stock',
			'Stock Recieved',
			'Total Stock',
			'Stock Sold',
			'Handling Loss',
			'Closing Balance',
			'Signature & Remarks of F & S'

			--Report Data
			SELECT * FROM Product_Stock_Report
			WHERE Created_Date >= ISNULL(@dtFrom, '01-01-1900') AND Created_Date <= ISNULL(@dtTo, CONVERT(DATE, GETDATE()))
			ORDER BY Dist_Id ASC, Created_Date ASC, Prod_Id ASC, Cat_Id ASC
		END
		--DELETE Product_Stock_Report


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