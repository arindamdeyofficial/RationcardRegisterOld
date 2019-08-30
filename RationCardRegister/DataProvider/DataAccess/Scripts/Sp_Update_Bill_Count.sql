IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Update_Bill_Count]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Update_Bill_Count]
GO
--EXEC Sp_Update_Bill_Count 1, 5

CREATE PROCEDURE [dbo].[Sp_Update_Bill_Count]
	@distId VARCHAR(2),
	@Counter INT
AS
BEGIN
	
	SET NOCOUNT ON;
	IF EXISTS(SELECT 1 FROM Bill_Counter WHERE Dist_Id = @distId)
	BEGIN
		UPDATE Bill_Counter 
		SET TotalBillCounter = @Counter
		WHERE Dist_Id = @distId
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
		VALUES(@distId, @Counter, 1, GETDATE())
	END
END

