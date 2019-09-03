--SELECT dbo.Func_Hof_Name(23, 'jayanta98314@gmail.com') AS HOF_NAME
--SELECT dbo.Func_Hof_Name(24, 'jayanta98314@gmail.com') AS HOF_NAME

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Hof_Name]') AND type in (N'FN'))
	DROP FUNCTION [dbo].[Func_Hof_Name]
GO
CREATE FUNCTION dbo.Func_Hof_Name (@Id VARCHAR(10), @distId VARCHAR(2))  
RETURNS VARCHAR(MAX)  
WITH EXECUTE AS CALLER  
AS  
BEGIN 
DECLARE @name VARCHAR(MAX)

SET @name = ''

SELECT 

@name = C2.Name

FROM Mst_Customer AS C1 -- Customer
INNER JOIN Mst_Customer AS C2 --Hof
ON C2.Customer_Id = C1.Hof_Id
WHERE C1.Customer_Id = @Id
AND C2.Hof_Flag = 1
AND C1.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId)

RETURN @name

END;