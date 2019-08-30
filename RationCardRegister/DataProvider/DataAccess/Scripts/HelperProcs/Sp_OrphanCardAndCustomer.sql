IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_OrphanCardAndCustomer]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_OrphanCardAndCustomer]
GO 
--EXEC Sp_OrphanCardAndCustomer 'jayanta98314@gmail.com', 'VIEW'
CREATE PROCEDURE [dbo].[Sp_OrphanCardAndCustomer]
@distId VARCHAR(50),
@action VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;

	IF(@action = 'VIEW')
	BEGIN

		SELECT * FROM Txn_Rationcard WHERE Rationcard_Id IN
		(SELECT R.RationCard_Id
		FROM Txn_RationCard AS R
		WHERE Dist_Id = @distId
		EXCEPT
		SELECT C.RationCard_Id
		FROM Mst_Customer AS C
		WHERE Dist_Id = @distId)

		SELECT * FROM Mst_Customer WHERE Customer_Id IN
		(SELECT C.Customer_Id
		FROM Mst_Customer AS C
		WHERE Dist_Id = @distId
		EXCEPT
		SELECT R.Customer_Id
		FROM Txn_RationCard AS R
		WHERE Dist_Id = @distId)

	END
	ELSE IF(@action = 'DELETE')
	BEGIN

		DELETE FROM Txn_Rationcard WHERE Rationcard_Id IN
		(SELECT R.RationCard_Id
		FROM Txn_RationCard AS R
		WHERE Dist_Id = @distId
		EXCEPT
		SELECT C.RationCard_Id
		FROM Mst_Customer AS C
		WHERE Dist_Id = @distId)

		DELETE FROM Mst_Customer WHERE Customer_Id IN
		(SELECT C.Customer_Id
		FROM Mst_Customer AS C
		WHERE Dist_Id = @distId
		EXCEPT
		SELECT R.Customer_Id
		FROM Txn_RationCard AS R
		WHERE Dist_Id = @distId)

	END

END