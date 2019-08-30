IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_ConfigOperation]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_ConfigOperation]
GO
--EXEC Sp_ConfigOperation 2, '','', 1, 1, 'CLONE'
--EXEC Sp_ConfigOperation '2','','',0,0, 'GET'

CREATE PROCEDURE [dbo].[Sp_ConfigOperation]
	@distId INT,
	@configKey VARCHAR(200),
	@configVal VARCHAR(2000),
	@active BIT,
	@cloneFromDistId INT,
	@action VARCHAR(20)
AS
BEGIN
	
	SET NOCOUNT ON;	
	BEGIN TRY
		
		IF(@action <> 'GET')
		BEGIN
			IF(@action = 'CLONE')
			BEGIN
				DELETE FROM App_Config WHERE Dist_Id = @distId
				INSERT INTO App_Config
				(
						Dist_Id,
						KeyText,
						ValueText,
						Active,
						Created_Date,
						Updated_Date
				)
				SELECT 
								
						@distId,
						KeyText,
						ValueText,
						Active,
						Created_Date,
						Updated_Date
				
				FROM App_Config WHERE Dist_Id = @cloneFromDistId
					
			END
			ELSE
			BEGIN
				IF EXISTS(SELECT 1 FROM App_Config WHERE Dist_Id = @distId AND Active = 1 AND KeyText = @configKey)
				BEGIN
					UPDATE App_Config
					SET	KeyText = @configKey, ValueText = @configVal, Active = @active, Updated_Date = GETDATE()
					WHERE Dist_Id = @distId AND KeyText = @configKey
				END
				ELSE
				BEGIN
					INSERT INTO App_Config
					(
						Dist_Id,
						KeyText,
						ValueText,
						Active,
						Created_Date,
						Updated_Date
					)
					VALUES(@distId, @configKey, @configVal, 1, GETDATE(), GETDATE())
				END
			END
		END

		SELECT 
		
			App_Config_Identity,
			Dist_Id,
			KeyText,
			ValueText,
			Active,
			Created_Date,
			Updated_Date 

		FROM App_Config WHERE Dist_Id = @distId AND Active = 1

	END TRY
	BEGIN CATCH
		SELECT  
		ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;  
	END CATCH
END

