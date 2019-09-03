--SELECT [dbo].Func_Hof_Member_Active_Count(23, 'jayanta98314@gmail.com') AS MEMBER_COUNT
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].Func_Hof_Member_Active_Count') AND type in (N'FN'))
	DROP FUNCTION [dbo].Func_Hof_Member_Active_Count
GO

CREATE FUNCTION [dbo].Func_Hof_Member_Active_Count  (@Id VARCHAR(10), @distId VARCHAR(2))  
RETURNS VARCHAR(5)  
WITH EXECUTE AS CALLER  
AS  
BEGIN 

DECLARE @count VARCHAR(5)

SET @count = ''

SELECT @count = COUNT(*) 

FROM Mst_Customer AS C
WHERE C.Active = 1
AND C.Hof_Id = @Id AND C.Dist_Id IN (SELECT Dist_Id FROM Mst_Dist WHERE Dist_Id = @distId) 

RETURN @count

END;

--23
--3895
--4652

--select * from mst_customer where hof_id in (select hof_id from mst_customer 
--where active = 0
--group by hof_id
--having count(hof_id)>1)
--order by hof_id asc, active asc