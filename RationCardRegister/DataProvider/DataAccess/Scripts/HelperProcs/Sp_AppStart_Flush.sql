IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_AppStart_Flush]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_AppStart_Flush]
GO 
--EXEC Sp_AppStart_Flush
CREATE PROCEDURE [dbo].[Sp_AppStart_Flush]
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @recCount INT
	DELETE FROM App_Start_His	

	SELECT @recCount = COUNT(*) FROM App_Start_His
	IF(@recCount =0)
	BEGIN
		SELECT 'App_Start_His successfully flashed'
	END
	ELSE
	BEGIN
		SELECT 'App_Start_His flashing UnSuccessful'
	END

END