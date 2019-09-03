IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Logger]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Logger]
GO 
--EXEC Sp_Logger 'jayanta98314@gmail.com', 
--'<ArrayOfKeyValueOfstringstring>
--  <KeyValueOfstringstring>
--    <Key>04-24-2018 02:49:54</Key>
--    <Value>d</Value>
--  </KeyValueOfstringstring>
--</ArrayOfKeyValueOfstringstring>', '', 'VIEW'

CREATE PROCEDURE [dbo].[Sp_Logger]
	@distId VARCHAR(2),
	@logText  XML,
	@macId VARCHAR(50),
	@action VARCHAR(50)
		
AS
BEGIN
	
	SET NOCOUNT ON;
	
	IF(@action = 'ADD')
	BEGIN

		DECLARE @Logs Table
		(
			--RowNum INT,
			LogTime DATETIME,
			LogText VARCHAR(MAX)
		)

		INSERT INTO @Logs
		SELECT 

		CONVERT(DATETIME, T1.L1.value('(./Key)[1]', 'VARCHAR(50)')) AS LogTime
		,T1.L1.value('(./Value)[1]', 'VARCHAR(MAX)') AS LogText

		FROM  @logText.nodes('/ArrayOfKeyValueOfstringstring/KeyValueOfstringstring') AS T1(L1)
		select * from @Logs

		INSERT INTO Logger
		(
		Dist_Id,
		LogText,
		Mac_Id,
		created_Date)
		
		SELECT
		 @distId, LogText, @macId, LogTime
		 FROM @Logs
	
	END

	SELECT TOP 50
		Logger_Identity,
		Dist_Id,
		LogText,
		Mac_Id,
		Created_Date

	FROM Logger WHERE Dist_Id = @distId
	ORDER BY Created_Date DESC


END