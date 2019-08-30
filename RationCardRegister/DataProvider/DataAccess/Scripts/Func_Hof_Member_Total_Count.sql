--SELECT [dbo].Func_Hof_Member_Total_Count(23, 'jayanta98314@gmail.com') AS MEMBER_COUNT
--SELECT [dbo].Func_Hof_Member_Total_Count(24, 'jayanta98314@gmail.com') AS MEMBER_COUNT

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].Func_Hof_Member_Total_Count') AND type in (N'FN'))
	DROP FUNCTION [dbo].Func_Hof_Member_Total_Count
GO

CREATE FUNCTION [dbo].Func_Hof_Member_Total_Count  (@Id VARCHAR(10), @distId VARCHAR(2))  
RETURNS VARCHAR(5)  
WITH EXECUTE AS CALLER  
AS  
BEGIN 

DECLARE @count INT, @IsHof BIT

SET @count = 0
SET @IsHof = 0
 

SELECT @count = COUNT(*) 

FROM Mst_Customer AS C
WHERE  C.Hof_Id = @Id AND C.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId) 

RETURN @count

END;