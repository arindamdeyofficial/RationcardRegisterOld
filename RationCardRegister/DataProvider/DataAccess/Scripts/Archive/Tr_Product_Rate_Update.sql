CREATE TRIGGER Tr_Product_Rate_Update
   ON Product_Rate
   AFTER UPDATE, INSERT
AS BEGIN
    SET NOCOUNT ON;
    IF UPDATE (Product_Rate) 
    BEGIN

	DECLARE @Action VARCHAR(2)
	SET @Action = (CASE WHEN EXISTS(SELECT * FROM INSERTED)
                         AND EXISTS(SELECT * FROM DELETED)
                        THEN 'U'  -- Set Action to Updated.
                        WHEN EXISTS(SELECT * FROM INSERTED)
                        THEN 'I'  -- Set Action to Insert.
                        WHEN EXISTS(SELECT * FROM DELETED)
                        THEN 'D'  -- Set Action to Deleted.
                        ELSE 'NA' -- Skip. It may have been a "failed delete".   
                    END)

	IF(@Action = 'I')
	BEGIN
        INSERT INTO Product_Rate_His
		(
			UserId,
			Prod_Id,
			UOM_Id,	
			Product_Rate,
			Created_Date,
			Last_Updated_Date,
			Updated_By
		)
		SELECT
			UserId,
			Prod_Id,
			UOM_Id,	
			Product_Rate,
			Created_Date,
			Last_Updated_Date,
			Updated_By
		FROM INSERTED
	END
	ELSE IF(@Action = 'U')
	BEGIN
		INSERT INTO Product_Rate_His
		(
			UserId,
			Prod_Id,
			UOM_Id,	
			Product_Rate,
			Created_Date,
			Last_Updated_Date,
			Updated_By
		)
		SELECT
			O.UserId,
			O.Prod_Id,
			O.UOM_Id,	
			O.Product_Rate,
			O.Created_Date,
			O.Last_Updated_Date,
			O.Updated_By
		FROM INSERTED AS N
		FULL OUTER JOIN DELETED AS O
		ON N.Product_Rate_Identity = O.Product_Rate_Identity
	END

    END 
END