-- =========================================
-- Create table template Windows Azure SQL Database 
-- =========================================

CREATE TABLE Mst_Cat
(
	Cat_Id INT IDENTITY PRIMARY KEY NOT NULL,
	Cat_Key VARCHAR(50) NULL,
	Cat_Desc VARCHAR(100) NULL,
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Txn_RationCard
(
	RationCard_Id INT IDENTITY PRIMARY KEY NOT NULL,
	Number VARCHAR(100) NULL,
	Card_Category_Id INT,
	Customer_Id INT,
	Dist_Id INT,
	Remarks VARCHAR(MAX),
	Active BIT,
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Inactivated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Mst_Customer
(
	Customer_Id INT IDENTITY PRIMARY KEY NOT NULL,
	Name VARCHAR(1000) NULL,
	Hof_Flag BIT,
	Age INT,
	Address VARCHAR(MAX),
	RationCard_Id VARCHAR(30),
	Hof_Id INT, --customer_id of the Hof
	Dist_Id INT,
	Adhar_No VARCHAR(50),
	Relation_With_Hof VARCHAR(100),
	Gaurdian_Name VARCHAR(1000),
	Gaurdian_Relation VARCHAR(100),
	Mobile_No VARCHAR(20),
	Active BIT,
	Created_Date DATETIME,
	Inactivated_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO


CREATE TABLE Mst_Role
(
	Role_Id INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Role_Desc VARCHAR(50),
	ControlIdToHide VARCHAR(50),
	Created_Date DATETIME
)
GO

CREATE TABLE Mst_Dist
(
	Dist_Id INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Name VARCHAR(500),
	Dist_Mobile_No VARCHAR(20),
	Dist_Address VARCHAR(MAX),
	Dist_Email VARCHAR(50),
	Dist_Profile_Pic_Path VARCHAR(200),
	Dist_Login VARCHAR(50),
	Dist_Password VARCHAR(500),
	Dist_Backdoor VARCHAR(500),
	Dist_Mac_Check BIT,
	Dist_Locked BIT,
	Dist_Fps_Code VARCHAR(50),
	Dist_Fps_Liscence_No VARCHAR(50),
	Dist_Mr_Shop_No VARCHAR(50),
	IsSuperAdmin BIT,
	Active BIT,
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO


--ALTER TABLE Mst_Dist 
--ADD MobileNoToNotifyViaSms VARCHAR(500), EmailToNotify VARCHAR(500)
--DROP COLUMN MobileNoToNotifyViaSms, EmailToNotify

--DROP TABLE Login_His
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
GO
--DROP TABLE App_Start_His
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
GO

CREATE TABLE Mst_Rel
(
	Mst_Rel_With_Hof_Id INT IDENTITY PRIMARY KEY NOT NULL,
	Relation VARCHAR(50),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

--DROP TABLE Txn_Card_Input_Data
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
GO

CREATE TABLE Mac_List
(
	Mac_Id_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Mac_Id VARCHAR(50),
	Remarks VARCHAR(1000),
	Created_Date DATETIME
)
GO

CREATE TABLE Bill_Counter
(
	Bill_Counter_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	TotalBillCounter INT,
	DayBillCounterOrCount INT,
	BillDate DATETIME
)
GO

CREATE TABLE Bill_Master
(
	Bill_Id_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	BillAmount DECIMAL(15),
	BillAmountRoundedOff DECIMAL(15),
	Discount DECIMAL(15),
	PaidAmount DECIMAL(15),
	BalanceAmount DECIMAL(15),
	BillSerialNumber VARCHAR(100),
	BillNumber VARCHAR(100),
	Fortnight INT,
	TotalCardServed INT,
	RationcardNumbers VARCHAR(1000),
	PrdDefaultQuantitySummary VARCHAR(2000),
	IsCalculated BIT,
	Created_Date DATETIME
)
GO

CREATE TABLE Bill_Details
(
	Bill_Details_Id_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Bill_Id INT,
	Prod_Id INT,
	Cat_Id INT,
	Quantity DECIMAL(15),
	QuantityUOM_Id INT,
	Name VARCHAR(1000),
	Barcode VARCHAR(100),
	ProdDescription VARCHAR(1000),
	UOMType VARCHAR(100),
	Base_UOM_Id INT,
	Product_Dept VARCHAR(100),
	Product_SubDept VARCHAR(100),
	Product_Class VARCHAR(100),
	Product_SubClass VARCHAR(100),
	Product_MC VARCHAR(100),
	Product_Brand VARCHAR(100),
	Product_Stock DECIMAL(10,2),
	Product_Selling_Rate DECIMAL(10,2),
	Product_Buying_Rate DECIMAL(10,2),
	Product_Mrp_Rate DECIMAL(10,2),
	Article_Code VARCHAR(50),	
	IsDefaultProduct BIT,
	IsDefaultGiveRation BIT,
	IsCalculated BIT
)
GO

--DROP TABLE Bill_Input
CREATE TABLE Bill_Input
(
	Bill_Inputt_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	DistId INT,
	Bill_Xml XML,
	Created_Date DATETIME
)
GO

CREATE TABLE UOM
(
	UOM_Id_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	UOMName VARCHAR(100),
	UOMType VARCHAR(100),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_Master
(
	Product_Master_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Name VARCHAR(1000),
	Barcode VARCHAR(100),
	ProdDescription VARCHAR(1000),
	UOMType VARCHAR(100),
	Base_UOM_Id INT,
	Product_Dept_Master_Identity INT,
	Product_SubDept_Master_Id INT,
	Product_Class_Master_Id INT,
	Product_SubClass_Master_Id INT,
	Product_MC_Master_Id INT,
	Product_Brand_Master_Id INT,
	Product_Rate_Id INT,
	Article_Code VARCHAR(50),	
	IsDefaultProduct BIT,
	IsDefaultGiveRation BIT,	
	Active BIT,
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO


CREATE TABLE Product_Quantity_Master
(
	Product_Quantity_Master_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Prod_Id INT,
	Cat_Id INT,
	DefaultQuantityInBaseUom DECIMAL(10,4),
	IsQuantityForFamily BIT,--Default quantity is for family or individual 1-family 0-individual
	Active BIT,
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_Rate
(
	Product_Rate_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Prod_Id INT,
	Buying_Rate_In_Base_Uom DECIMAL(10,4),
	Selling_Rate_In_Base_Uom DECIMAL(10,4),
	Mrp_Rate_In_Base_Uom DECIMAL(10,4),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_Stock
(
	Product_Stock_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Prod_Id INT,
	Cat_Id INT,
	UOM_Id INT,	
	ProdQuantity DECIMAL(10,4),
	AllowedDamageQuantityPerUnit DECIMAL(10,4),
	TotalAllowedDamageQuantity DECIMAL(10,4),
	TotalDamageQuantityInReal DECIMAL(10,4),
	IsStockIn BIT,
	Created_Date DATETIME
)
GO

CREATE TABLE Product_Stock_Report
(
	Product_Stock_Report_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Prod_Id INT,
	Cat_Id INT,
	UOM_Id INT,	
	OpenningBalance DECIMAL(10,4),
	StockRecieved DECIMAL(10,4),
	TotalStock DECIMAL(10,4),
	StockSold DECIMAL(10,4),
	HandlingLoss DECIMAL(10,4),
	ClosingBalance DECIMAL(10,4),
	Created_Date DATETIME
)
GO

CREATE TABLE Product_Stock_Report_Input
(
	Product_Stock_Report_Input_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	DtFrom VARCHAR(50),
	DtTo VARCHAR(50),
	Created_date DATETIME
)
GO

CREATE TABLE Product_Uom
(
	Product_Uom_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Product_Id INT,
	Uom_Id  INT,
	IsBaseuom  BIT,
	ConversionFactorWithBaseUom DECIMAL(10,4),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_Dept_Master
(
	Product_Dept_Master_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Product_Dept_Desc VARCHAR(500),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_SubDept_Master
(
	Product_SubDept_Master_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Product_Dept_Master_Id INT,
	Product_SubDept_Master_Desc  VARCHAR(500),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_Class_Master
(
	Product_Class_Master_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Product_Dept_Master_Id INT,
	Product_SubDept_Master_Id  INT,
	Product_Class_Master_Desc VARCHAR(500),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_SubClass_Master
(
	Product_SubClass_Master_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Product_Dept_Master_Id INT,
	Product_SubDept_Master_Id  INT,
	Product_Class_Master_Id INT,
	Product_SubClass_Master_Desc VARCHAR(500),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_MC_Master
(
	Product_MC_Master_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Product_MC_Code VARCHAR(20),
	Dist_Id INT,
	Product_Dept_Master_Id INT,
	Product_SubDept_Master_Id  INT,
	Product_Class_Master_Id INT,
	Product_SubClass_Master_Id INT,
	Product_MC_Master_Desc  VARCHAR(500),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

CREATE TABLE Product_Brand_Master
(
	Product_Brand_Master_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Product_Dept_Master_Id INT,
	Product_SubDept_Master_Id  INT,
	Product_Class_Master_Id INT,
	Product_SubClass_Master_Id INT,
	Product_MC_Master_Id INT,
	Product_Brand_Desc VARCHAR(500),
	Product_Brand_Company_Desc VARCHAR(500),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(20)
)
GO

--DROP TABLE Product_Input
CREATE TABLE Product_Input
(
	Product_Input_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	Product_Xml XML,
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(100)
)
GO

--DROP TABLE Product_Search_Input
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
GO

CREATE TABLE Security_Code
(
	Security_Code_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Security_Code_In_Mail VARCHAR(MAX),
	Mail_Id VARCHAR(100),
	Created_Date DATETIME,
	Last_Updated_Date DATETIME,
	Updated_By VARCHAR(100)
)
GO
--DROP TABLE Logger
CREATE TABLE Logger
(
	Logger_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	LogText VARCHAR(MAX),
	Mac_Id VARCHAR(50),
	Created_Date DATETIME
)
GO

CREATE TABLE App_Config
(
	App_Config_Identity INT IDENTITY PRIMARY KEY NOT NULL,
	Dist_Id INT,
	KeyText VARCHAR(100),
	ValueText VARCHAR(200),
	Active BIT,
	Created_Date DATETIME,
	Updated_Date DATETIME
)

--DROP TABLE Card_Search_Input
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

