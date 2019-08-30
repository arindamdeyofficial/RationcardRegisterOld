IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_AppStart_Details]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_AppStart_Details]
GO 
--EXEC Sp_AppStart_Details '40-B0-34-09-ED-98'
CREATE PROCEDURE [dbo].[Sp_AppStart_Details]
AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT * FROM App_Start_His	ORDER BY Created_Date Desc

END