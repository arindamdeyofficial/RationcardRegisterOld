IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_App_Start]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[SP_App_Start]
GO
--EXEC SP_App_Start 'D4258BF47531', '','',''
--EXEC SP_App_Start '802BF966815B', '192.168.225.22','157.40.125.127','fe804::4b4963960::77107:012%125'
CREATE PROCEDURE [dbo].[SP_App_Start]
	@mac VARCHAR(50),
	@Internal_Ip VARCHAR(50), 
	@Public_Ip VARCHAR(50), 
	@Gateway_Addr VARCHAR(100)
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @IsMacBind BIT	
	DECLARE @IsMacExists BIT
	DECLARE @MacIdInput VARCHAR(20)
	DECLARE @distId VARCHAR(2)
	SET @Gateway_Addr = REPLACE(@Gateway_Addr, ':', '')
	SET @Gateway_Addr = REPLACE(@Gateway_Addr, '%', '')

	INSERT INTO App_Start_His(Mac_Id, Internal_Ip, Public_Ip, Gateway_Addr, Created_Date, Last_Updated_Date, Updated_By)
	VALUES(@mac, @Internal_Ip, @Public_Ip, @Gateway_Addr, GETDATE(), GETDATE(), 'SP_App_Start')

	SET @IsMacExists = 0
	SET @IsMacBind = 1
	set @MacIdInput = REPLACE(@mac, '-', '')

	SELECT @IsMacBind = D.Dist_Mac_Check, @IsMacExists = 1 
	FROM Mst_Dist AS D
	INNER JOIN Mac_List AS M
	ON D.Dist_Id = M.Dist_Id
	WHERE REPLACE(M.Mac_Id, '-', '') LIKE '%' + @MacIdInput + '%' AND D.Active=1
	
	IF ((@IsMacExists = 1))
	BEGIN
		SELECT @distId = D.Dist_Id 
		FROM Mst_Dist AS D
		INNER JOIN Mac_List AS M
		ON D.Dist_Id = M.Dist_Id
		WHERE REPLACE(M.Mac_Id, '-', '') LIKE '%' + @MacIdInput + '%' AND D.Active=1

		SELECT 'SUCCESS' AS [Status]
		,CASE WHEN (@IsMacBind = 0) THEN'Mac exists but Mac bind is not required'
		ELSE ''
		END AS [Desc]
		, D.*, M.Mac_Id AS Dist_Mac_Id

		FROM Mst_Dist AS D
		INNER JOIN Mac_List AS M
		ON D.Dist_Id = M.Dist_Id
		WHERE REPLACE(M.Mac_Id, '-', '') LIKE '%' + @MacIdInput + '%' AND D.Active=1

		--Role
		Select Role_Id,Role_Desc,ControlIdToHide FROM Mst_Role WHERE Dist_Id = @distId

		--UserList
		SELECT * FROM Mst_Dist
	END
	ELSE IF((@IsMacExists = 0) AND (@IsMacBind = 1))
	BEGIN
		SELECT 'FAILURE' AS [Status], 'Device is not registered. Please contact support.' AS [Desc], * FROM Mst_Dist
	END
	
END

