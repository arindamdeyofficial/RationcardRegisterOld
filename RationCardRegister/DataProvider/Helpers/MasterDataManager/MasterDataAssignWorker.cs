using BusinessObject;
using DataAccess;
using DataAccessSql;
using Helpers.MasterDataManager.MasterDataBo;
using LogManager;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Businessworker
{
    public static partial class MasterDataWorker
    {
        public static void AssignConfigData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.Configs = new ConfigWrapper();
                try
                {
                    //Master Category
                    MasterData.Configs.Data = ds.Tables[0].AsEnumerable().Select(i => new Config
                    {
                        KeyText = i["KeyText"].ToString(),
                        ValueText = i["ValueText"].ToString(),
                        Active = i["Active"].ToString() == "True",
                        Created_Date = DateTime.Parse(i["Created_Date"].ToString()),
                        Updated_Date = DateTime.Parse(i["Updated_Date"].ToString())

                    }).ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }
        public static void AssignHofData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 2))
            {
                MasterData.Hofs = new HofMasterDataTypeWrapper();
                try
                {
                    //HofMasterData
                    MasterData.Hofs.Data = ds.Tables[0].AsEnumerable().Select(i => new Hof
                    {
                        Hof_Id = i["Customer_Id"].ToString(),
                        Customer_Id = i["Customer_Id"].ToString(),
                        Name = i["Name"].ToString(),
                        CardNo = i["Number"].ToString(),
                        Mobile_No = i["Mobile_No"].ToString(),
                        Address = i["Address"].ToString(),
                        TotalCardCount = Int32.Parse(i["Total_Count"].ToString()),
                        TotalActiveCardCount = Int32.Parse(i["Active_Count"].ToString()),
                        ShowVal = i["Name"].ToString() + " || " + i["Number"].ToString() + " || " + i["Mobile_No"].ToString(),
                        Hof_Flag = "1",
                    }).ToList();

                    //Total Hof Count
                    MasterData.TotalHofCount = Int32.Parse(ds.Tables[1].Rows[0][0].ToString());

                    //Active Hof Count
                    MasterData.ActiveHofCount = Int32.Parse(ds.Tables[2].Rows[0][0].ToString());
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignCategoryData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.Categories = new CategoryMasterDataTypeWrapper();
                try
                {
                    //Master Category
                    MasterData.Categories.Data = ds.Tables[0].AsEnumerable().Select(i => new Category
                    {
                        Cat_Id = i["Cat_Id"].ToString(),
                        Cat_Desc = i["Cat_Desc"].ToString()
                    }).ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignRelationData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.Relations = new RelationMasterDataTypeWrapper();
                try
                {
                    //Master Relation
                    MasterData.Relations.Data = ds.Tables[0].AsEnumerable().Select(i => new RelationMaster
                    {
                        Mst_Rel_With_Hof_Id = i["Mst_Rel_With_Hof_Id"].ToString(),
                        Relation = i["Relation"].ToString()
                    }).ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static List<Product> ExtractProductFromDataset(DataSet ds)
        {
            var prds = new List<Product>();
            float convertedNum = 1;
            int counter = 0;
            try
            {
                prds = ds.Tables[0].AsEnumerable().Select(i => new Product
                {
                    Product_Master_Identity = i["Product_Master_Identity"].ToString(),
                    Name = i["Name"].ToString(),
                    ProdDescription = i["ProdDescription"].ToString(),
                    BaseUom = new Uom
                    {
                        UOM_Id_Identity = i["UOM_Id_Identity"].ToString(),
                        UOMType = i["UOMType"].ToString(),
                        UOMName = i["UOMName"].ToString(),
                        ConversionFactorWithBaseUom = 1,
                        IsBaseUom = true
                    },
                    ProductDept = new ProductDeptMaster
                    {
                        ProductDeptMasterId = i["Product_Dept_Master_Identity"].ToString(),
                        ProductDeptMasterDesc = i["Product_Dept_Desc"].ToString()
                    },
                    ProductSubDept = new ProductSubDeptMaster
                    {
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Identity"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Identity"].ToString(),
                        ProductSubDeptMasterDesc = i["Product_SubDept_Master_Desc"].ToString()
                    },
                    ProductClass = new ProductClassMaster
                    {
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Identity"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Identity"].ToString(),
                        ProductClassMasterId = i["Product_Class_Master_Identity"].ToString(),
                        ProductClassMasterDesc = i["Product_Class_Master_Desc"].ToString()
                    },
                    ProductSubClass = new ProductSubClassMaster
                    {
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Identity"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Identity"].ToString(),
                        ProductClassMasterId = i["Product_Class_Master_Identity"].ToString(),
                        ProductSubClassMasterDesc = i["Product_SubClass_Master_Desc"].ToString(),
                        ProductSubClassMasterId = i["Product_SubClass_Master_Identity"].ToString()
                    },
                    ProductMc = new ProductMcMaster
                    {
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Identity"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Identity"].ToString(),
                        ProductClassMasterId = i["Product_Class_Master_Identity"].ToString(),
                        ProductSubClassMasterId = i["Product_SubClass_Master_Identity"].ToString(),
                        ProductMcMasterId = i["Product_MC_Master_Identity"].ToString(),
                        ProductMcMasterDesc = i["Product_MC_Master_Desc"].ToString(),
                        ProductMcMasterCode = i["Product_MC_Code"].ToString()
                    },
                    ProductBrand = new ProductBrandMaster
                    {
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Identity"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Identity"].ToString(),
                        ProductClassMasterId = i["Product_Class_Master_Identity"].ToString(),
                        ProductSubClassMasterId = i["Product_SubClass_Master_Identity"].ToString(),
                        ProductMcMasterId = i["Product_MC_Master_Identity"].ToString(),
                        ProductBrandMasterId = i["Product_Brand_Master_Identity"].ToString(),
                        ProductBrandMasterDesc = i["Product_Brand_Desc"].ToString(),
                        ProductBrandMasterCompanyDesc = i["Product_Brand_Company_Desc"].ToString()
                    },
                    ArticleCode = i["Article_Code"].ToString(),
                    IsDefaultGiveRation = i["IsDefaultGiveRation"].ToString() == "True",
                    IsDefaultProduct = i["IsDefaultProduct"].ToString() == "True",
                    BuyingRateInBaseUom = float.TryParse(i["Buying_Rate_In_Base_Uom"].ToString(), out convertedNum) ? convertedNum : 0,
                    SellingRateInBaseUom = float.TryParse(i["Selling_Rate_In_Base_Uom"].ToString(), out convertedNum) ? convertedNum : 0,
                    MrpRateInBaseUom = float.TryParse(i["Mrp_Rate_In_Base_Uom"].ToString(), out convertedNum) ? convertedNum : 0,
                    BarCode = i["Barcode"].ToString(),
                    StockInBaseUom = ds.Tables[3].AsEnumerable().Select(p =>
                    {
                        var pr = new ProductStock
                        {
                            Product_Stock_Id_Ui = counter,
                            Product_Stock_Identity = p["Product_Stock_Identity"].ToString(),
                            StockEntryTimeInDateFormat = Convert.ToDateTime(p["Created_Date"].ToString()),
                            StockEntryTime = p["Created_Date"].ToString(),
                            Prod_Id = p["Prod_Id"].ToString(),
                            StockUom = new Uom
                            {
                                UOM_Id_Identity = p["UOM_Id_Identity"].ToString(),
                                UOMType = p["UOMType"].ToString(),
                                UOMName = p["UOMName"].ToString(),
                                IsBaseUom = true
                            },
                            CategoryDetails = new Category
                            {
                                Cat_Id = p["Cat_Id"].ToString(),
                                Cat_Desc = p["Cat_Desc"].ToString()
                            },
                            AllowedDamageQuantityPerUnit = float.TryParse(p["AllowedDamageQuantityPerUnit"].ToString(), out convertedNum) ? convertedNum : 0,
                            TotalAllowedDamageQuantity = float.TryParse(p["TotalAllowedDamageQuantity"].ToString(), out convertedNum) ? convertedNum : 0,
                            TotalDamageQuantityInReal = float.TryParse(p["TotalDamageQuantityInReal"].ToString(), out convertedNum) ? convertedNum : 0,
                            ProdQuantity = float.TryParse(p["ProdQuantity"].ToString(), out convertedNum) ? convertedNum : 0,
                            EntryMode = StockEntryMode.NONE,
                            IsStockIn = p["IsStockIn"].ToString() == "True"
                        };
                        counter++;
                        return pr;
                    })
                    .Where(p=>p.Prod_Id.Equals(i["Product_Master_Identity"].ToString()))
                    .ToList(),
                    PrdQuantityAllocated = ds.Tables[1].AsEnumerable().Select(a => new ProductQuantityMaster
                    {
                        ProductId = a["Product_Master_Identity"].ToString(),
                        Product_Quantity_Master_Identity = a["Product_Quantity_Master_Identity"].ToString(),
                        CategoryDetails = new Category
                        {
                            Cat_Id = a["Cat_Id"].ToString(),
                            Cat_Desc = a["Cat_Desc"].ToString()
                        },
                        DefaultQuantityInBaseUom = float.TryParse(a["DefaultQuantityInBaseUom"].ToString(), out convertedNum) ? convertedNum : 0,
                        IsQuantityForFamily = a["IsQuantityForFamily"].ToString() == "True",
                        Active = a["Active"].ToString() == "True",
                    })
                            .Where(a => a.ProductId == i["Product_Master_Identity"].ToString())
                            .ToList(),
                    AllUom = ds.Tables[2].AsEnumerable().Select(a => new Uom
                    {
                        ProdId = a["Product_Master_Identity"].ToString(),
                        UOMName = a["UOMName"].ToString(),
                        IsBaseUom = a["IsBaseuom"].ToString() == "True",
                        ConversionFactorWithBaseUom = float.TryParse(a["ConversionFactorWithBaseUom"].ToString(), out convertedNum) ? convertedNum : 0,
                        UOMType = a["UOMType"].ToString(),
                        UOM_Id_Identity = a["UOM_Id_Identity"].ToString()
                    })
                            .Where(a => a.ProdId == i["Product_Master_Identity"].ToString())
                            .ToList(),
                    Active = i["Active"].ToString() == "True"
                }).ToList();
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return prds;
        }

        public static void AssignProductData(DataSet ds)
        {            
            if ((ds != null) && (ds.Tables.Count > 2))
            {                
                MasterData.PrdData = new ProductMasterDataTypeWrapper();
                try
                {
                    //product Master
                    MasterData.PrdData.Data = ExtractProductFromDataset(ds);
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignUomData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 1))
            {
                MasterData.Uoms = new UomMasterDataTypeWrapper();
                MasterData.UomType = new UomTypeMasterDataTypeWrapper();
                try
                {
                    //UomMasterData
                    MasterData.Uoms.Data = ds.Tables[0].AsEnumerable().Select(i => new Uom
                    {
                        UOM_Id_Identity = i["UOM_Id_Identity"].ToString(),
                        UOMName = i["UOMName"].ToString(),
                        UOMType = i["UOMType"].ToString()
                    }).ToList();

                    //UomType
                    MasterData.UomType.Data = ds.Tables[1].AsEnumerable().Select((i, index) => new UomType
                    {
                        UOMTypeId = index.ToString(),
                        UOMType = i["UOMType"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignProductDeptData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                try
                {
                    MasterData.ProductDepts = new ProductDeptMasterDataTypeWrapper();
                    //ProductDepts
                    MasterData.ProductDepts.Data = ds.Tables[0].AsEnumerable().Select((i, index) => new ProductDeptMaster
                    {
                        ProductDeptMasterId = i["Product_Dept_Master_Identity"].ToString(),
                        ProductDeptMasterDesc = i["Product_Dept_Desc"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignProductSubDeptData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                try
                {
                    MasterData.ProductSubDepts = new ProductSubDeptMasterDataTypeWrapper();
                    //ProductSubDepts
                    MasterData.ProductSubDepts.Data = ds.Tables[0].AsEnumerable().Select((i, index) => new ProductSubDeptMaster
                    {
                        ProductDeptMasterId = i["Product_Dept_Master_Id"].ToString(),
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Identity"].ToString(),
                        ProductSubDeptMasterDesc = i["Product_SubDept_Master_Desc"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignProductClassData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.ProductClasses = new ProductClassMasterDataTypeWrapper();
                try
                {
                    //ProductClasses
                    MasterData.ProductClasses.Data = ds.Tables[0].AsEnumerable().Select((i, index) => new ProductClassMaster
                    {
                        ProductClassMasterId = i["Product_Class_Master_Identity"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Id"].ToString(),
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Id"].ToString(),
                        ProductClassMasterDesc = i["Product_Class_Master_Desc"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignProductSubClassData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.ProductSubClasses = new ProductSubClassMasterDataTypeWrapper();
                try
                {
                    //ProductSubClasses
                    MasterData.ProductSubClasses.Data = ds.Tables[0].AsEnumerable().Select((i, index) => new ProductSubClassMaster
                    {
                        ProductSubClassMasterId = i["Product_SubClass_Master_Identity"].ToString(),
                        ProductClassMasterId = i["Product_Class_Master_Id"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Id"].ToString(),
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Id"].ToString(),
                        ProductSubClassMasterDesc = i["Product_SubClass_Master_Desc"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignProductMcData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                try
                {
                    MasterData.ProductMcs = new ProductMcMasterDataTypeWrapper();
                    //ProductMcs
                    MasterData.ProductMcs.Data = ds.Tables[0].AsEnumerable().Select((i, index) => new ProductMcMaster
                    {
                        ProductSubClassMasterId = i["Product_SubClass_Master_Id"].ToString(),
                        ProductClassMasterId = i["Product_Class_Master_Id"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Id"].ToString(),
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Id"].ToString(),
                        ProductMcMasterId = i["Product_MC_Master_Identity"].ToString(),
                        ProductMcMasterCode = i["Product_MC_Code"].ToString(),
                        ProductMcMasterDesc = i["Product_MC_Master_Desc"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignProductBrandData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.ProductBrands = new ProductBrandMasterDataTypeWrapper();
                try
                {
                    //ProductBrands
                    MasterData.ProductBrands.Data = ds.Tables[0].AsEnumerable().Select((i, index) => new ProductBrandMaster
                    {
                        ProductSubClassMasterId = i["Product_SubClass_Master_Id"].ToString(),
                        ProductClassMasterId = i["Product_Class_Master_Id"].ToString(),
                        ProductDeptMasterId = i["Product_Dept_Master_Id"].ToString(),
                        ProductSubDeptMasterId = i["Product_SubDept_Master_Id"].ToString(),
                        ProductMcMasterId = i["Product_MC_Master_Id"].ToString(),
                        ProductBrandMasterCompanyDesc = i["Product_Brand_Company_Desc"].ToString(),
                        ProductBrandMasterDesc = i["Product_Brand_Desc"].ToString(),
                        ProductBrandMasterId = i["Product_Brand_Master_Identity"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignRoleData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.Roles = new RoleMasterDataTypeWrapper();
                try
                {
                    //ProductRoles
                    MasterData.Roles.Data = ds.Tables[0].AsEnumerable().Select((i, index) => new Role
                    {
                        RoleId = i["Role_Id"].ToString(),
                        ControlIdToHide = i["Role_Desc"].ToString(),
                        RoleDesc = i["ControlIdToHide"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }

        public static void AssignDistributorData(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.Distributors = new DistMasterDataTypeWrapper();
                try
                {
                    //ProductRoles
                    MasterData.Distributors.Data = ds.Tables[0].AsEnumerable().Select((i, index) => new Distributor
                    {
                        Dist_Id = i["Dist_Id"].ToString(),
                        Dist_Name = i["Dist_Name"].ToString(),
                        Dist_Mobile_No = i["Dist_Mobile_No"].ToString(),
                        MobileNoToNotifyViaSms= ((i["MobileNoToNotifyViaSms"].ToString() != "0") ? i["MobileNoToNotifyViaSms"].ToString() : ""),
                        EmailToNotify = i["EmailToNotify"].ToString(),
                        Dist_Address = i["Dist_Address"].ToString(),
                        Dist_Email = i["Dist_Email"].ToString(),
                        Dist_Profile_Pic_Path = i["Dist_Profile_Pic_Path"].ToString(),
                        Dist_Login = i["Dist_Login"].ToString(),
                        Dist_Password = i["Dist_Password"].ToString(),
                        Dist_Backdoor = i["Dist_Backdoor"].ToString(),
                        Dist_Mac_Check = i["Dist_Mac_Check"].ToString(),
                        Dist_Locked = i["Dist_Locked"].ToString(),
                        Dist_Fps_Code = i["Dist_Fps_Code"].ToString(),
                        Dist_Fps_Liscence_No = i["Dist_Fps_Liscence_No"].ToString(),
                        Dist_Mr_Shop_No = i["Dist_Mr_Shop_No"].ToString(),
                        Dist_Allowed_Mac_Id = string.Join("," , (ds.Tables[1].AsEnumerable()
                                                .Where(a => a["Dist_Id"].ToString() == i["Dist_Id"].ToString())).Select(b=>b["Mac_Id"].ToString())
                                                .ToList()),
                        IsSuperAdmin = i["IsSuperAdmin"].ToString() == "True",
                        Active = i["Active"].ToString(),
                        Created_Date = i["Created_Date"].ToString()
                    })
                    .ToList();
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }
        public static void AssignCardsOfThisFortnight(DataSet ds)
        {
            if ((ds != null) && (ds.Tables.Count > 0))
            {
                MasterData.AllCardsOfThisFortnight = new CardsOfThisFortnightWrapper();
                try
                {
                    //Master CardsOfThisFortnight
                    MasterData.AllCardsOfThisFortnight.Data = ds.Tables[0].AsEnumerable().Select(i => i["RationcardNumbers"].ToString().Trim()).ToList();
                    //MasterData.AllCardsOfThisFortnight.Data.Add("RKSY-I-1209339175");
                }
                catch (Exception ex)
                {
                    Logger.LogError(ex);
                }
            }
        }
    }
}
