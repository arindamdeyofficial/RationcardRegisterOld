DROP TABLE Login_His
CREATE TABLE Login_His
(
	Login_His_Id INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Login VARCHAR(100),
	Login_Time DATETIME,
	Login_Success BIT,
	Mac_Id VARCHAR(50),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
DROP TABLE App_Start_His
CREATE TABLE App_Start_His
(
	App_Start_His_Id INT IDENTITY PRIMARY KEY NOT NULL,
	Mac_Id VARCHAR(50),	
	Internal_Ip VARCHAR(20),
	Public_Ip VARCHAR(20),
	Gateway_Addr VARCHAR(100),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
DROP TABLE Txn_Card_Input_Data
CREATE TABLE Txn_Card_Input_Data
(
	Id INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	MacId VARCHAR(100),
	Customer_Id VARCHAR(40),
	Name VARCHAR(1000),
	Hof_Flag VARCHAR(4),
	Age  VARCHAR(40),
	Address VARCHAR(MAX),
	RationCard_Id VARCHAR(30),
	Hof_Id  VARCHAR(40),
	Hof_Name VARCHAR(1000),
	Adhar_No VARCHAR(50),
	Relation_With_Hof_Id VARCHAR(1000),
	Relation_With_Hof_Desc VARCHAR(100),
	Gaurdian_Name VARCHAR(1000),
	Gaurdian_Relation_Id VARCHAR(100),
	Gaurdian_Relation_Desc VARCHAR(100),
	Mobile_No VARCHAR(20),
	Number VARCHAR(100),
	Card_Category_Id  VARCHAR(40),
	Card_Category_Desc  VARCHAR(40),
	Remarks VARCHAR(MAX),
	Active  VARCHAR(4),
	Active_Inactivated_Date  VARCHAR(40),
	Created_Date DATETIME
)
DROP TABLE Bill_Input
CREATE TABLE Bill_Input
(
	Bill_Inputt_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	DistId INT,
	Bill_Xml XML,
	Created_Date DATETIME
)
DROP TABLE Product_Input
CREATE TABLE Product_Input
(
	Product_Input_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Product_Xml XML,
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(100)
)
DROP TABLE Product_Search_Input
CREATE TABLE Product_Search_Input
(
	Product_Search_Input_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	BarCode VARCHAR(500),
	ArticleCode VARCHAR(100),
	PrdName VARCHAR(1000),
	Description VARCHAR(500),
	IsActive BIT,
	IsDefaultToGiveRation BIT,
	IsDefaultPrd BIT,
	Dept VARCHAR(50),
	SubDept VARCHAR(50),
	Class VARCHAR(50),
	SubClass VARCHAR(50),
	Mc VARCHAR(50),
	McCode VARCHAR(50),
	Brand VARCHAR(50),
	BrandCompany VARCHAR(50),
	DtFrom DATETIME,
	DtTo DATETIME,
	Created_Date DATETIME
)
DROP TABLE Logger
CREATE TABLE Logger
(
	Logger_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	LogText VARCHAR(MAX),
	Mac_Id VARCHAR(50),
	Created_Date DATETIME
)
DROP TABLE Card_Search_Input
CREATE TABLE Card_Search_Input
(
	Card_Search_Input_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	SearchBy VARCHAR(50),
	SearchText VARCHAR(500),
	CatId VARCHAR(5),
	DtFrom VARCHAR(40),
	DTo VARCHAR(40),
	Created_Date DATETIME
)