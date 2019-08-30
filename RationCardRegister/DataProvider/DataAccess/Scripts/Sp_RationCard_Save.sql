--EXEC [dbo].[Sp_RationCard_Save] 2, 'D4258BF47531', '0', '3', 'RKSY-I', 'RKSY-I-1204156044', '0', '325406410942', 'MAHADEB DAS'
--, '1', '0', 'MAHADEB DAS', '1', 'Self', 'M DAS', '2', 'Father', '04-28-2018 18:23:30', '8697033839', '48', '1', 'NATUN PALLY SUBHASRAM,SOUTH 24 PGS,WEST BENGAL 700147', ''

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sp_RationCard_Save]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[Sp_RationCard_Save]
GO 
CREATE PROCEDURE [dbo].[Sp_RationCard_Save]
	@distId VARCHAR(2),
	@mac VARCHAR(20),
	@rationCardId INT,
	@categoryId VARCHAR(50),
	@categoryDesc VARCHAR(50),
	@CardNo VARCHAR(50),
	@customerId INT,
	@adhar VARCHAR(30),
	@cardHolderName VARCHAR(200),
	@isHof BIT,
	@hofId INT,
	@hofName VARCHAR(200),
	@RelWithHofId VARCHAR(50),
	@RelWithHofDesc VARCHAR(50),
	@FatherName VARCHAR(200),
	@typeOfRelationId VARCHAR(200),
	@typeOfRelationDesc VARCHAR(200),
	@activeOrInactiveDt VARCHAR(40),
	@mobileNo VARCHAR(20),
	@age VARCHAR(3),
	@isActive BIT,
	@address VARCHAR(MAX),
	@remarks VARCHAR(MAX)
		
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @isCardSuccessMsg VARCHAR(50)
	DECLARE @isCustSuccessMsg VARCHAR(50)
	DECLARE @isInputSuccessMsg VARCHAR(50)

	BEGIN TRY
		
	--inserting raw data audit purpose
	INSERT INTO Txn_Card_Input_Data
	(
		Dist_Id,
		MacId,
		Customer_Id,
		Name,
		Hof_Flag,
		Age,
		Address,
		RationCard_Id,
		Hof_Id,
		Hof_Name,		
		Adhar_No,
		Relation_With_Hof_Id,
		Relation_With_Hof_Desc,
		Gaurdian_Name,
		Gaurdian_Relation_Id,
		Gaurdian_Relation_Desc,
		Mobile_No,
		Number,
		Card_Category_Id,
		Card_Category_Desc,
		Remarks,
		Active,
		Active_Inactivated_Date
	)
	VALUES(@distId, @mac, @customerId, @cardHolderName, @isHof, @age, @address, @rationCardId, @hofId, @hofName
	, @adhar, @RelWithHofId, @RelWithHofDesc, @FatherName, @typeOfRelationId, @typeOfRelationDesc, @mobileNo, @CardNo
	, @categoryId, @categoryDesc, @remarks, @isActive, @activeOrInactiveDt)

	SET @isInputSuccessMsg = 'SUCCESS'	
	
	IF(@categoryId = '')
	BEGIN
		SELECT @categoryId = Cat_Id FROM Mst_Cat WHERE Cat_Desc = @categoryDesc
		IF(@categoryId = '')
		BEGIN
			INSERT INTO Mst_Cat (Cat_Key, Cat_Desc, Created_Date, Last_Updated_Date, Updated_By) 
			VALUES (@categoryDesc, @categoryDesc, GETDATE(), GETDATE(), 'Sp_RationCard_Save')
		END
		SELECT @categoryId = Cat_Id FROM Mst_Cat WHERE Cat_Desc = @categoryDesc
	END

	IF(@RelWithHofId = '')
	BEGIN
		SELECT @RelWithHofId = Mst_Rel_With_Hof_Id FROM Mst_Rel WHERE Relation = @RelWithHofDesc
		IF(@RelWithHofId = '')
		BEGIN
			INSERT INTO Mst_Rel (Relation, Created_Date, Last_Updated_Date, Updated_By) 
			VALUES (@RelWithHofDesc, GETDATE(), GETDATE(), 'Sp_RationCard_Save')
		END
		SELECT @RelWithHofId = Mst_Rel_With_Hof_Id FROM Mst_Rel WHERE Relation = @RelWithHofDesc
	END

	IF(@typeOfRelationId = '')
	BEGIN
		SELECT @typeOfRelationId = Mst_Rel_With_Hof_Id FROM Mst_Rel WHERE Relation = @typeOfRelationDesc
		IF(@typeOfRelationId = '')
		BEGIN
			INSERT INTO Mst_Rel (Relation, Created_Date, Last_Updated_Date, Updated_By) 
			VALUES (@typeOfRelationDesc, GETDATE(), GETDATE(), 'Sp_RationCard_Save')
		END
		SELECT @typeOfRelationId = Mst_Rel_With_Hof_Id FROM Mst_Rel WHERE Relation = @typeOfRelationDesc
	END

	IF(@hofId = '')
	BEGIN
		SELECT @hofId = Hof_Id FROM Mst_Customer WHERE Name = @hofName
		IF((@hofId = '') AND (@hofName = ''))
		BEGIN
			SET @isInputSuccessMsg = 'FAILURE: HOF NOT FOUND'
		END
	END

	IF(@customerId = '')
	BEGIN
		SELECT @customerId = Customer_Id FROM Txn_RationCard WHERE RationCard_Id = @rationCardId AND Dist_Id = @distId		
	END
	
	IF(@isInputSuccessMsg = 'SUCCESS')
	BEGIN
		IF EXISTS(SELECT 1 FROM Txn_RationCard WHERE RationCard_Id = @rationCardId AND Dist_Id = @distId)
		BEGIN
			UPDATE Txn_RationCard
			SET Number = @CardNo
				,Card_Category_Id = @categoryId
				,Customer_Id = @customerId
				,Remarks = @remarks
				,Active = @isActive
				,Created_Date = CASE WHEN @isActive = '1' THEN  @activeOrInactiveDt ELSE '' END
				,Inactivated_Date = CASE WHEN @isActive = '1' THEN  '' ELSE @activeOrInactiveDt END
				,Last_Updated_Date = GETDATE()
				,Updated_By = 'Sp_RationCard_Save'
			WHERE RationCard_Id=@rationCardId AND Dist_Id = @distId

			SET @isCardSuccessMsg = 'SUCCESS: RATIONCARD DEAILS UPDATED' + CHAR(10) + CHAR(13)

		END
		ELSE
		BEGIN
			INSERT INTO Txn_RationCard 
			(				
				Number,
				Card_Category_Id,
				Customer_Id,
				Dist_Id,
				Remarks,
				Active,
				Created_Date,
				Last_Updated_Date,
				Updated_By)
			VALUES(@CardNo, @categoryId, @customerId, @distId, @remarks, @isActive, @activeOrInactiveDt, GETDATE(), 'Sp_RationCard_Save')

			SELECT @rationCardId = RationCard_Id FROM Txn_RationCard WHERE Number = @CardNo

			SET @isCardSuccessMsg = 'SUCCESS: RATIONCARD DEAILS ADDED' + CHAR(10) + CHAR(13)

		END

		IF EXISTS(SELECT 1 FROM Mst_Customer WHERE Customer_Id = @customerId)
		BEGIN
			UPDATE Mst_Customer
			SET Name = @cardHolderName
				,Hof_Flag = @isHof
				,Age = @age
				,Address = @address
				,RationCard_Id = @rationCardId
				,Hof_Id = @hofId
				,Dist_Id = @distId
				,Adhar_No = @adhar
				,Relation_With_Hof = @RelWithHofDesc
				,Gaurdian_Name = @FatherName
				,Gaurdian_Relation = @typeOfRelationDesc
				,Mobile_No = @mobileNo
				,Active = @isActive
				,Created_Date = CASE WHEN @isActive = '1' THEN  @activeOrInactiveDt ELSE '' END
				,Inactivated_Date = CASE WHEN @isActive = '1' THEN  '' ELSE @activeOrInactiveDt END
				,Last_Updated_Date = GETDATE()
				,Updated_By = 'Sp_RationCard_Save'
			WHERE Customer_Id=@customerId AND Dist_Id = @distId

			SET @isCustSuccessMsg = 'SUCCESS: CUSTOMER DEAILS UPDATED' + CHAR(10) + CHAR(13)
		END
		ELSE
		BEGIN
			INSERT INTO Mst_Customer 
			(	
				Name,
				Hof_Flag,
				Age,
				Address,
				RationCard_Id,
				Hof_Id,
				Dist_Id,
				Adhar_No,
				Relation_With_Hof,
				Gaurdian_Name,
				Gaurdian_Relation,
				Mobile_No,
				Active,
				Created_Date,
				Last_Updated_Date,
				Updated_By
			)
			VALUES(@cardHolderName, @isHof, @age, @address, @rationCardId, @hofId, @distId, @adhar, @RelWithHofDesc, @FatherName, @typeOfRelationDesc, @mobileNo, @isActive, @activeOrInactiveDt, GETDATE(), 'Sp_RationCard_Save')

			SET @isCustSuccessMsg = 'SUCCESS: CUSTOMER DEAILS ADDED' + CHAR(10) + CHAR(13)

			SELECT @customerId = Customer_Id FROM Mst_Customer WHERE RationCard_Id = @rationCardId AND Dist_Id = @distId

			IF(@isHof = 1)
			BEGIN
				UPDATE Mst_Customer
				SET Hof_Id=@customerId
				WHERE Customer_Id=@customerId
			END

			UPDATE Txn_RationCard
			SET Customer_Id = @customerId		
			WHERE RationCard_Id=@rationCardId AND Dist_Id = @distId

		END
	END

	SELECT @isInputSuccessMsg, @isCardSuccessMsg, @isCustSuccessMsg

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

---------------------------------
--test cases

--DECLARE @userId VARCHAR(50),
--	@mac VARCHAR(20),
--	@rationCardId INT,
--	@categoryId VARCHAR(50),
--	@categoryDesc VARCHAR(50),
--	@CardNo VARCHAR(50),
--	@customerId INT,
--	@adhar VARCHAR(30),
--	@cardHolderName VARCHAR(200),
--	@isHof BIT,
--	@hofId INT,
--	@hofName VARCHAR(200),
--	@RelWithHofId VARCHAR(50),
--	@RelWithHofDesc VARCHAR(50),
--	@FatherName VARCHAR(200),
--	@typeOfRelationId VARCHAR(200),
--	@typeOfRelationDesc VARCHAR(200),
--	@activeOrInactiveDt VARCHAR(40),
--	@mobileNo VARCHAR(20),
--	@age VARCHAR(3),
--	@isActive BIT,
--	@address VARCHAR(MAX),
--	@remarks VARCHAR(MAX)

--SET @userId  = 'jayanta98314@gmail.com'
--SET	@mac = '40B03409ED98'
--SET	@rationCardId =''
--SET	@categoryId =''
--SET	@categoryDesc = 'testcat'
--SET	@CardNo = 'testcardNo'
--SET	@customerId = ''
--SET	@adhar = 'adhartest'
--SET	@cardHolderName = 'nametest'
--SET	@isHof = ''
--SET	@hofId = '1'
--SET	@hofName = ''
--SET	@RelWithHofId = ''
--SET	@RelWithHofDesc = 'testHofRel'
--SET	@FatherName = 'fatherttestname'
--SET	@typeOfRelationId = ''
--SET	@typeOfRelationDesc = 'typereltest'
--SET	@activeOrInactiveDt = '2017-07-03 07:42:40.000'
--SET	@mobileNo = '976445566'
--SET	@age  = '28'
--SET	@isActive = '1'
--SET	@address = 'testaddress'
--SET	@remarks = 'remarks'

--EXEC Sp_RationCard_Save @userId,@mac,@rationCardId,@categoryId,@categoryDesc,@CardNo,@customerId,@adhar,@cardHolderName,@isHof,@hofId,
--@hofName,@RelWithHofId,@RelWithHofDesc,@FatherName,@typeOfRelationId,@typeOfRelationDesc,@activeOrInactiveDt,@mobileNo,@age,@isActive,@address,@remarks

--select * from Mst_Customer where Name='nametest'
--select * from Txn_RationCard where RationCard_Id in (select RationCard_Id from Mst_Customer where Name='nametest')
--select * from Mst_Cat
--select * from Mst_Rel

--select TOP 1 * from Mst_Customer ORDER BY Customer_Id DESC
--select TOP 1 * from Txn_RationCard ORDER BY RationCard_Id DESC
--select TOP 1 * from Txn_Card_Input_Data ORDER BY Id DESC
--select * from Mst_Dist


--------------------------------