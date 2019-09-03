IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Fetch_Bill_Counter]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Fetch_Bill_Counter]
GO
--EXEC Sp_Fetch_Bill_Counter 1, 'VIEW'
--EXEC Sp_Fetch_Bill_Counter 'jayanta98314@gmail.com', 'UPDATE'

CREATE PROCEDURE [dbo].[Sp_Fetch_Bill_Counter]
	@distId VARCHAR(2),
	@action VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;	
	BEGIN TRY
		
		IF EXISTS(SELECT 1 FROM Bill_Counter WHERE Dist_Id = @distId)
		BEGIN
			IF EXISTS(SELECT 1 FROM Bill_Counter WHERE Dist_Id = @distId AND (BillDate > GETDATE() - 1) AND (BillDate < GETDATE() + 1))
			BEGIN		
				IF(@action = 'UPDATE')
				BEGIN	
					UPDATE Bill_Counter
					SET TotalBillCounter = TotalBillCounter + 1
					, DayBillCounterOrCount = DayBillCounterOrCount + 1
						WHERE Dist_Id = @distId AND (BillDate > GETDATE() - 1) AND (BillDate < GETDATE() + 1)
				END
			END
			ELSE
			BEGIN
				INSERT INTO Bill_Counter
				(
					Dist_Id,
					TotalBillCounter,
					DayBillCounterOrCount,
					BillDate
				)
				SELECT TOP 1
				@distId, TotalBillCounter, 0, GETDATE()
				FROM Bill_Counter WHERE Dist_Id = @distId
				ORDER BY BillDate DESC
			END
		END
		ELSE
		BEGIN
			INSERT INTO Bill_Counter
			(
				Dist_Id,
				TotalBillCounter,
				DayBillCounterOrCount,
				BillDate
			)
			VALUES(@distId, 0, 0, GETDATE())
		END

		--Return result in view or updation
		SELECT 
		
		Bill_Counter_Identity,
		Dist_Id,
		(TotalBillCounter + 1) AS TotalBillCounter,
		(DayBillCounterOrCount + 1) AS DayBillCounterOrCount,
		BillDate

		FROM Bill_Counter WHERE Dist_Id = @distId AND (BillDate > GETDATE() - 1) AND (BillDate < GETDATE() + 1)
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

