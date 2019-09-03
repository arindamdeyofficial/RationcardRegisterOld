IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_RationCard_Delete]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_RationCard_Delete]
GO 
--EXEC Sp_RationCard_Delete 'biplabhome@gmail.com','3', '3'
CREATE PROCEDURE [dbo].[Sp_RationCard_Delete]
	@distId VARCHAR(2),
	@rationCardId INT,
	@customerId INT
		
AS
BEGIN
	
	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM Txn_RationCard WHERE RationCard_Id=@rationCardId AND Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id= @distId))
	BEGIN
		DELETE FROM Txn_RationCard WHERE RationCard_Id=@rationCardId AND Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id= @distId)
		DELETE FROM Mst_Customer WHERE Customer_Id=@customerId AND Dist_Id = @distId
		SELECT 'SUCCESS', 'RATIONCARD DELETED'
	END
	ELSE
	BEGIN
		SELECT 'FAILURE', 'RATIONCARD NOT FOUND'
	END

END