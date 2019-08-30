IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetTotalCardCount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetTotalCardCount]
GO 
--EXEC Sp_GetTotalCardCount 'jayanta98314@gmail.com', '1587'
CREATE PROCEDURE [dbo].[Sp_GetTotalCardCount]
	@distId VARCHAR(2),
	@Id VARCHAR(10)
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @hof_Id VARCHAR(5)
	SELECT @hof_Id = Hof_Id FROM Mst_Customer 
	WHERE Customer_Id = @Id
	AND Dist_Id = @distId

	SELECT [dbo].Func_Hof_Member_Total_Count(@hof_Id, @distId) AS TOTAL_MEMBER_COUNT 

END 