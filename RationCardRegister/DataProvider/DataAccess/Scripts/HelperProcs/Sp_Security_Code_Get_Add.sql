IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Security_Code_Get_Add]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Security_Code_Get_Add]
GO 
--EXEC Sp_Security_Code_Get_Add 'fefefef@sssx.com', '', 'GET'
CREATE PROCEDURE [dbo].[Sp_Security_Code_Get_Add]
	@Dist_Email VARCHAR(50),
	@Code VARCHAR(MAX),
	@operation VARCHAR(10)
AS
BEGIN
	
	SET NOCOUNT ON;
	IF(@operation = 'GET')
	BEGIN
	SELECT

		Security_Code_Identity,
		Security_Code_In_Mail,
		Mail_Id,
		Created_Date,
		Last_Updated_Date,
		Updated_By

	FROM Security_Code WHERE Mail_Id = CASE WHEN (@Dist_Email = '') THEN Mail_Id ELSE @Dist_Email END
	END
	ELSE IF (@operation = 'ADD')
	BEGIN
		INSERT INTO Security_Code
		(
		Security_Code_In_Mail,
		Mail_Id,
		Created_Date,
		Last_Updated_Date,
		Updated_By
		)
		VALUES
		(@Code, @Dist_Email, GETDATE(),GETDATE(),'Sp_Security_Code') 

		SELECT

		Security_Code_Identity,
		Security_Code_In_Mail,
		Mail_Id,
		Created_Date,
		Last_Updated_Date,
		Updated_By

	FROM Security_Code

	END
	ELSE IF (@operation = 'REMOVE')
	BEGIN
		DELETE FROM Security_Code WHERE Mail_Id = @Dist_Email

		SELECT

		Security_Code_Identity,
		Security_Code_In_Mail,
		Mail_Id,
		Created_Date,
		Last_Updated_Date,
		Updated_By

	FROM Security_Code

	END
END