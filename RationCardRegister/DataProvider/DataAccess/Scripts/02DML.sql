INSERT INTO Mst_Cat
(
	Cat_Key,
	Cat_Desc,
	Created_Date,
	Last_Updated_Date,
	Updated_By
)
VALUES
('AAY', 'AAY', GETDATE(),GETDATE(),'SUPERADMIN'),
('PHH', 'PHH', GETDATE(),GETDATE(),'SUPERADMIN'),
('RKSY-I', 'RKSY-I', GETDATE(),GETDATE(),'SUPERADMIN'),
('RKSY-II', 'RKSY-II', GETDATE(),GETDATE(),'SUPERADMIN'),
('SPHH', 'SPHH', GETDATE(),GETDATE(),'SUPERADMIN')

GO
INSERT INTO Mst_Role
(
	Dist_Id,
	Role_Desc,
	ControlIdToHide,
	Created_Date
)
VALUES
(1,'Admin button in Home Page', 'btnAdmin', GETDATE())

GO
INSERT INTO Mst_Dist
(
	Dist_Name,
	Dist_Mobile_No,
	Dist_Address,
	Dist_Email,
	Dist_Profile_Pic_Path,
	Dist_Login,
	Dist_Password,
	Dist_Backdoor,
	Dist_Mac_Check,
	Dist_Locked,
	Dist_Fps_Code,
	Dist_Fps_Liscence_No,
	Dist_Mr_Shop_No,
	IsSuperAdmin,
	Active,
	Created_Date,
	Last_Updated_Date,
	Updated_By
)
VALUES
('Jayanta Ghosh', '9073403116', '27, RNC Road(West), Subhasgram,Kolkara 700147', 'jayanta98314@gmail.com', '\image\jayantaghosh.png','jayanta98314@gmail.com', 'jayanta9831', 'passwordbckp'
,1, 0,'134301100020', '24 P(S)- BRP-RPSP-134301100020', '11', 0,1, GETDATE(), GETDATE(),'SUPERADMIN'),
('Arindam Dey', '9830609366', '102, Gandi Para Road East, Subhasgram,Kolkara 700147', 'biplabhome@gmail.com', '\image\arindamdey.png','biplabhome@gmail.com', 'nakshal', 'passwordbckp'
,0, 0,'admin', 'admin', 'admin', 1,1, GETDATE(), GETDATE(),'SUPERADMIN')

GO
INSERT INTO Mst_Rel
(
	Relation,
	Created_Date,
	Last_Updated_Date,
	Updated_By
)
VALUES
('Self', GETDATE(), GETDATE(),'SUPERADMIN'),
('Father', GETDATE(), GETDATE(),'SUPERADMIN'),
('Mother', GETDATE(), GETDATE(),'SUPERADMIN'),
('Wife', GETDATE(), GETDATE(),'SUPERADMIN'),
('Brother', GETDATE(), GETDATE(),'SUPERADMIN'),
('Daughter', GETDATE(), GETDATE(),'SUPERADMIN'),
('Son', GETDATE(), GETDATE(),'SUPERADMIN'),
('Daughter In Law', GETDATE(), GETDATE(),'SUPERADMIN'),
('Sister In Law', GETDATE(), GETDATE(),'SUPERADMIN'),
('Father In Law', GETDATE(), GETDATE(),'SUPERADMIN'),
('Mother in Law', GETDATE(), GETDATE(),'SUPERADMIN'),
('Brother In Law', GETDATE(), GETDATE(),'SUPERADMIN'),
('Brother', GETDATE(), GETDATE(),'SUPERADMIN'),
('Nice', GETDATE(), GETDATE(),'SUPERADMIN'),
('Elder Sister', GETDATE(), GETDATE(),'SUPERADMIN'),
('Uncle', GETDATE(), GETDATE(),'SUPERADMIN'),
('Aunt', GETDATE(), GETDATE(),'SUPERADMIN'),
('Husband', GETDATE(), GETDATE(),'SUPERADMIN'),
('Other', GETDATE(), GETDATE(),'SUPERADMIN')
GO

INSERT INTO UOM
(
	Dist_Id,
	UOMName,
	UOMType,
	Created_Date,
	Last_Updated_Date,
	Updated_By
)
VALUES
(1, 'Kg', 'weight', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'gm', 'weight', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'mg', 'weight', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'm', 'length', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'cm', 'length', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'mm', 'length', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'ltr', 'volume', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'galon', 'volume', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'ml', 'volume', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'pack', 'count', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'cartoon', 'count', GETDATE(), GETDATE(), 'SUPERADMIN'),
(1, 'unit', 'count', GETDATE(), GETDATE(), 'SUPERADMIN')

GO

INSERT INTO Mac_List
(
	Dist_Id,
	Mac_Id,
	Remarks,
	Created_Date
)
VALUES
(2,'D4258BF47531', 'dell 7757 me', GETDATE()),
(1,'2C56DC3DDC30', 'JAYANTA DESKTOP', GETDATE()),
(1,'A44CC874472C', 'jayanta laptop', GETDATE())