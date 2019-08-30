IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetCardCount]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_GetCardCount]
GO 
--EXEC Sp_GetCardCount 'jayanta98314@gmail.com', '25'
CREATE PROCEDURE [dbo].[Sp_GetCardCount]
	@distId VARCHAR(2),
	@Id VARCHAR(10)
AS
BEGIN
	
	SET NOCOUNT ON;

	EXEC Sp_GetTotalCardCount @distId, @Id
	EXEC Sp_GetActiveCardCount @distId, @Id

END 