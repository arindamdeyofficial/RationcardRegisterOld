IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Distributor_Operate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Distributor_Operate]
GO 
--EXEC Sp_Distributor_Operate 'Test Dist', '6596696464', 'addre', 'sdwsd@sssx.com', 'scws.png', 'password1', 1, 'fps01', 'fpse011', 'h54897', 'DFGHTYS54', 'Diamond Harbor', 'ff', 'ADD'
CREATE PROCEDURE [dbo].[Sp_Distributor_Operate]
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
	@code VARCHAR(MAX),
	@operation VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;
	IF(@operation = 'ADD')
	BEGIN
		EXEC Sp_Register_New_Distributor @Dist_Name, @Dist_Mobile_No, @Dist_Address, @Dist_Email, @Dist_Profile_Pic_Path, @Dist_Password
		, @Dist_Mac_Check, @Dist_Fps_Code, @Dist_Fps_Liscence_No, @Dist_Mr_Shop_No,	@mac, @remark, @code
	END
	ELSE IF(@operation = 'GET')
	BEGIN
		SELECT
		
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
			Created_Date
		
		FROM Mst_Dist
	END
	ELSE IF(@operation = 'REMOVE')
	BEGIN
		DELETE FROM Mst_Dist WHERE Dist_Login = @Dist_Email
	END
END