IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Unique_Check]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_Unique_Check]
GO 
--EXEC Sp_Unique_Check 1,'RATIONCARD','PHH-0053000476'
--EXEC Sp_Unique_Check 1,'RATIONCARD',''
--EXEC Sp_Unique_Check 1,'MOBILENO','7278481425'
--EXEC Sp_Unique_Check 1,'MOBILENO',''
--EXEC Sp_Unique_Check 1,'ADHARCARD','CKW4056677'
--EXEC Sp_Unique_Check ,'ADHARCARD',''
CREATE PROCEDURE [dbo].[Sp_Unique_Check]
	@distId VARCHAR(2),
	@checkName VARCHAR(10),
	@param VARCHAR(40)
		
AS
BEGIN
	
	SET NOCOUNT ON;
	IF((@checkName = 'RATIONCARD') AND EXISTS(SELECT 1 FROM Txn_RationCard WHERE Number=@param AND Dist_Id = @distId) AND (@param <> ''))
	BEGIN
		SELECT 'RATIONCARD_DUPLICATE' AS DUPLICATE_TYPE
		SELECT 'RationCard ' + R.Number + ' already exists in the name of ' + C.Name + '. Adhar No. is ' + C.Adhar_No + ' and Mobile No. is ' + C.Mobile_No AS MSG
		,R.Number , C.Name, C.Adhar_No, C.Mobile_No

		FROM Txn_RationCard AS R
		INNER JOIN Mst_Customer AS C
		ON C.RationCard_Id = R.RationCard_Id
		WHERE R.Number=@param
		 AND C.Dist_Id = @distId
		 AND R.Dist_Id = @distId

		RETURN;
	END
	ELSE IF((@checkName = 'ADHARCARD') AND EXISTS(SELECT 1 FROM Mst_Customer WHERE Adhar_No=@param AND Dist_Id = @distId) AND (@param <> ''))
	BEGIN
		SELECT 'ADHARCARD_DUPLICATE' AS DUPLICATE_TYPE
		SELECT 'RationCard ' + R.Number + ' already exists in the name of ' + C.Name + '. Adhar No. is ' + C.Adhar_No + ' and Mobile No. is ' + C.Mobile_No AS MSG
		,R.Number , C.Name, C.Adhar_No, C.Mobile_No

		FROM Mst_Customer AS C
		INNER JOIN Txn_RationCard AS R
		ON C.RationCard_Id = R.RationCard_Id
		WHERE C.Adhar_No=@param
		 AND C.Dist_Id = @distId
		 AND R.Dist_Id = @distId

		RETURN;
	END
	ELSE IF((@checkName = 'MOBILENO') AND EXISTS(SELECT 1 FROM Mst_Customer WHERE Mobile_No=@param AND Dist_Id = @distId) AND (@param <> ''))
	BEGIN
		SELECT 'MOBILENO_DUPLICATE' AS DUPLICATE_TYPE
		SELECT 'RationCard ' + R.Number + ' already exists in the name of ' + C.Name + '. Adhar No. is ' + C.Adhar_No + ' and Mobile No. is ' + C.Mobile_No AS MSG
		,R.Number , C.Name, C.Adhar_No, C.Mobile_No

		FROM Mst_Customer AS C
		INNER JOIN Txn_RationCard AS R
		ON C.RationCard_Id = R.RationCard_Id
		WHERE C.Mobile_No=@param
		 AND C.Dist_Id = @distId
		 AND R.Dist_Id = @distId

		RETURN;
	END

	SELECT 'NO_DUPLICATE' AS DUPLICATE_TYPE
	SELECT 'SUCCESS' AS MSG

END