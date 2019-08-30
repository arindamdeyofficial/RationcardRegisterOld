IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetActiveCardCount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetActiveCardCount]
GO 
--EXEC Sp_GetActiveCardCount 1, '1587'
CREATE PROCEDURE [dbo].[Sp_GetActiveCardCount]
	@distId VARCHAR(2),
	@Id VARCHAR(10)
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @hof_Id VARCHAR(5)
	SELECT @hof_Id = Hof_Id FROM Mst_Customer 
	WHERE Customer_Id = @Id
	AND Dist_Id = @distId

	SELECT [dbo].Func_Hof_Member_Active_Count(@hof_Id, @distId) AS ACTIVE_MEMBER_COUNT 

END 