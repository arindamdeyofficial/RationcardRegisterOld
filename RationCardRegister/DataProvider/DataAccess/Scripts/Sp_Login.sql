IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_Login]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[SP_Login]
GO 
--EXEC SP_Login 'biplabhome@gmail.com','nakshal', '40-B0-34-09-ED-98'
CREATE PROCEDURE [dbo].[SP_Login]
	@userId VARCHAR(50),
	@pass VARCHAR(20),
	@mac VARCHAR(20)		
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @LoginFailedAttempt INT
	DECLARE @LastSuccessLogin DATETIME

	SELECT @LastSuccessLogin = MAX(Last_Updated_Date) FROM Login_His WHERE Dist_Login=@userId AND Login_Success = 1
	SELECT @LoginFailedAttempt = COUNT(*) + 1 FROM Login_His WHERE Dist_Login=@userId AND Login_Success = 0 AND Last_Updated_Date> @LastSuccessLogin 
	
	IF(@LastSuccessLogin IS NULL)
		SELECT @LoginFailedAttempt = COUNT(*) + 1 FROM Login_His WHERE Dist_Login=@userId AND Login_Success = 0
	
	IF EXISTS(SELECT 1 FROM Mst_Dist WHERE Dist_Login=@userId AND Active =1)
	BEGIN 
		IF EXISTS(SELECT 1 FROM Mst_Dist WHERE Dist_Login=@userId AND Active =1 AND (Dist_Password=@pass OR Dist_Backdoor=@pass) AND Dist_Locked=0)
		BEGIN
			SELECT 'SUCCESS' AS [Status], '' AS [Desc], * FROM Mst_Dist WHERE Dist_Login=@userId AND (Dist_Password=@pass OR Dist_Backdoor=@pass) AND Active=1

			UPDATE Mst_Dist SET Dist_Locked =0 WHERE Dist_Login=@userId AND Active=1

			INSERT INTO Login_His (Dist_Login,Login_Time,Login_Success, Mac_Id,Created_Date,Last_Updated_Date,Updated_By)
			VALUES (@userId, GETDATE(), 1, @mac, GETDATE(),GETDATE(), 'SUPERADMIN')
		END
		ELSE
		BEGIN
			INSERT INTO Login_His (Dist_Login,Login_Time,Login_Success, Mac_Id,Created_Date,Last_Updated_Date,Updated_By)
			VALUES (@userId, GETDATE(), 0, @mac, GETDATE(),GETDATE(), 'SUPERADMIN')

			IF(@LoginFailedAttempt > 5 )
			BEGIN	
				SELECT 'FAILURE' AS [Status], 'User locked for security purpose. Login Attepmt exceded max limit of 5. Please call for support.' AS [Desc], * FROM Mst_Dist WHERE Dist_Login=@userId AND Active=1
				UPDATE Mst_Dist SET Dist_Locked =1 WHERE Dist_Login=@userId
			END
			ELSE IF(@LoginFailedAttempt < 5 )
			BEGIN 				
				SELECT 'FAILURE' AS [Status], 'UserId or Password is wrong. User will be locked after ' + CONVERT(VARCHAR(2),(5 - @LoginFailedAttempt)) + ' more unsuccessful attempt.' AS [Desc], * FROM Mst_Dist WHERE Dist_Login=@userId AND Active=1
			END
			ELSE IF(@LoginFailedAttempt = 5 )
			BEGIN 
				SELECT 'FAILURE' AS [Status], 'UserId or Password is wrong. This is your last attempt. User will be locked afterwards.' AS [Desc], * FROM Mst_Dist WHERE Dist_Login=@userId AND Active=1
			END
		END
	END
	ELSE IF EXISTS(SELECT 1 FROM Mst_Dist WHERE Dist_Login=@userId AND Active <>1)
	BEGIN
		SELECT 'FAILURE' AS [Status], 'UserId not Active. Please contact support'
	END
	ELSE
	BEGIN
		SELECT 'FAILURE' AS [Status], 'UserId is wrong.'
	END
	

END