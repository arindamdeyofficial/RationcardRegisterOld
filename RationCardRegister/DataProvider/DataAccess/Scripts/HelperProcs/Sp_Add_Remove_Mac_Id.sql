IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Add_Remove_Mac_Id]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Add_Remove_Mac_Id]
GO 
--EXEC Sp_Add_Remove_Mac_Id 'jayanta98314@gmail.com', '','','','', 'READ'
CREATE PROCEDURE [dbo].[Sp_Add_Remove_Mac_Id]
	@distId VARCHAR(2),
	@mac VARCHAR(20),
	@remark VARCHAR(100),
	@action VARCHAR(10)	
AS
BEGIN

	SET NOCOUNT ON;
	IF(@action = 'ADD')
	BEGIN
		INSERT INTO Mac_List
		(
			Dist_Id,
			Mac_Id,
			Remarks,
			Created_Date
		)
		VALUES
		(@DistId, @mac, @remark, GETDATE())
	END

	ELSE IF(@action = 'REMOVE')
	BEGIN
		DELETE FROM Mac_List WHERE Dist_Id = @DistId AND Mac_Id = @mac
	END

	SELECT * FROM Mac_List WHERE Dist_Id = @DistId
END
