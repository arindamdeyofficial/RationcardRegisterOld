--SELECT dbo.Func_Hof_Name_By_Hof_Id(23, 'jayanta98314@gmail.com') AS HOF_NAME
--SELECT dbo.Func_Hof_Name_By_Hof_Id(24, 'jayanta98314@gmail.com') AS HOF_NAME

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Hof_Name_By_Hof_Id]') AND type in (N'FN'))
	DROP FUNCTION [dbo].[Func_Hof_Name_By_Hof_Id]
GO
CREATE FUNCTION dbo.Func_Hof_Name_By_Hof_Id (@Id VARCHAR(10), @distId VARCHAR(2))  
RETURNS VARCHAR(MAX)  
WITH EXECUTE AS CALLER  
AS  
BEGIN 
DECLARE @name VARCHAR(MAX)

SET @name = ''

SELECT 

@name = C.Name

FROM Mst_Customer AS C
WHERE C.Customer_Id = @Id
AND C.Hof_Flag = 1
AND C.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId)

RETURN @name

END;