IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Register_New_Distributor]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Register_New_Distributor]
GO 
--EXEC Sp_Register_New_Distributor 'Test Dist', '6596696464', 'addre', 'sdwsd@sssx.com', 'scws.png', 'password1', 1, 'fps01', 'fpse011', 'h54897', 'DFGHTYS54', 'Diamond Harbor', 'ff'
CREATE PROCEDURE [dbo].[Sp_Register_New_Distributor]
	@Dist_Name VARCHAR(500),
	@Dist_Mobile_No VARCHAR(20),
	@Dist_Address VARCHAR(MAX),
	@Dist_Email VARCHAR(50),
	@Dist_Profile_Pic_Path VARCHAR(200),
	@Dist_Password VARCHAR(500),
	@Dist_Mac_Check BIT,
	@Dist_Fps_Code VARCHAR(50),
	@Dist_Fps_Liscence_No VARCHAR(50),
	@Dist_Mr_Shop_No VARCHAR(50),
	@mac VARCHAR(20),
	@remark VARCHAR(20),
	@code VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @macId VARCHAR(20)
	IF NOT EXISTS(SELECT 1 FROM Security_Code WHERE Security_Code_In_Mail = @code AND Mail_Id = @Dist_Email) AND (@code <> 'ADDUSERBYSUPERADMIN')
	BEGIN
		SELECT 'FAILURE', 'Please give correct security code from email.' AS Msg
		RETURN
	END
	IF EXISTS(SELECT Dist_Id FROM Mst_Dist WHERE Dist_Login = @Dist_Email)
	BEGIN		
		IF NOT EXISTS(SELECT Mac_Id FROM Mac_List WHERE Mac_Id = @mac)
		BEGIN			
			EXEC Sp_Add_Remove_Mac_Id @Dist_Email, @mac,'DIRECT', 'RATIONCARDHOME', @remark, 'ADD'
		END
		SELECT 'SUCCESS', 'User already exists. '+CHAR(10)+CHAR(13)+'Please Use your Email provided as Login Id.' AS Msg
		RETURN
	END
	IF EXISTS(SELECT Mac_Id FROM Mac_List WHERE Mac_Id = @mac)
	BEGIN
		SELECT 'SUCCESS', 'Mac already exists.'+CHAR(10)+CHAR(13)+' Please Use your Email provided as Login Id' AS Msg
		RETURN
	END

	INSERT INTO Mst_Dist
	(
		Dist_Name,
		Dist_Mobile_No,
		Dist_Address,
		Dist_Email,
		Dist_Profile_Pic_Path,
		Dist_Login,
		Dist_Password,
		Dist_Backdoor,
		Dist_Mac_Check,
		Dist_Locked,
		Dist_Fps_Code,
		Dist_Fps_Liscence_No,
		Dist_Mr_Shop_No,
		IsSuperAdmin,
		Active,
		Created_Date,
		Last_Updated_Date,
		Updated_By
	)
	VALUES
	(
		@Dist_Name,
		@Dist_Mobile_No,
		@Dist_Address,
		@Dist_Email,
		@Dist_Profile_Pic_Path,
		@Dist_Email,
		@Dist_Password, 
		'backup01',
		@Dist_Mac_Check,
		0,
		@Dist_Fps_Code,
		@Dist_Fps_Liscence_No,
		@Dist_Mr_Shop_No,
		0,
		1,
		GETDATE(),
		GETDATE(),
		'Sp_Register_New_Dist'
	)

	SELECT * FROM Mst_Dist WHERE Dist_Login = @Dist_Email

	EXEC Sp_Add_Remove_Mac_Id @Dist_Email, @mac,'DIRECT', 'RATIONCARDHOME', @remark, 'ADD'
	DELETE FROM Security_Code WHERE Security_Code_In_Mail = @code AND Mail_Id = @Dist_Email
	SELECT 'SUCCESS', 'User registered successfully.'+CHAR(10)+CHAR(13)+' Please Use your Email provided as Login Id' AS Msg

END