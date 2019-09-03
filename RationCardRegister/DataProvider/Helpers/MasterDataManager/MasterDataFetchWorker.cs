using BusinessObject;
using DataAccess;
using DataAccessSql;
using Helpers.MasterDataManager;
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
        public static CategoryWiseSearchResult SearchCard(string searchBy, string searchText, string searchCatId, bool fetchOnlyRecentData = false)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();
            int convertedNum = 0;
            var result = new CategoryWiseSearchResult();
            result.CardSearchResult = new List<RationCardDetail>();
            try
            {
                DataSet ds = DBoperationsManager.SearchCard(searchBy, searchText, searchCatId, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
                {
                    int count = 1;
                    result.CardCountOfCategory = int.TryParse(ds.Tables[1].Rows[0]["RECORD_COUNT"].ToString(), out convertedNum) ? convertedNum : 0;
                    result.CategoryOfCard = MasterData.Categories.Data.FirstOrDefault(i => i.Cat_Id == searchCatId);
                    foreach (DataRow r in ds.Tables[0].Rows)
                    {
                        result.CardSearchResult.Add(new RationCardDetail
                        {
                            SlNo = count,
                            Number = r["RATIONCARD_NO"].ToString(),
                            Adhar_No = r["Adhar_No"].ToString(),
                            Mobile_No = r["Mobile_No"].ToString(),
                            Hof_Name = r["HOF_NAME"].ToString(),
                            Name = r["Name"].ToString(),
                            Age = r["Age"].ToString(),
                            Address = r["Address"].ToString(),
                            CardStatus = (r["STATUS"].ToString() == "True") ? "Active" : "",
                            ActiveCard = r["STATUS"].ToString() == "True",
                            Card_Created_Date = r["Created_Date"].ToString(),
                            Cat_Desc = r["Cat_Desc"].ToString(),
                            Customer_Id = r["Customer_Id"].ToString(),
                            Hof_Flag = r["Hof_Flag"].ToString(),
                            Hof_Id = r["Hof_Id"].ToString(),
                            RationCard_Id = r["RationCard_Id"].ToString(),
                            Cat_Id = r["Cat_Id"].ToString(),
                            Card_Category_Id = r["Cat_Id"].ToString(),
                            Remarks = r["Remarks"].ToString(),
                            Relation_With_Hof = r["Relation_With_Hof"].ToString(),
                            Gaurdian_Relation = r["Gaurdian_Relation"].ToString(),
                            Gaurdian_Name = r["Gaurdian_Name"].ToString(),
                            FamilyCount = ds.Tables[0].AsEnumerable().Count(
                                                i=> i["Hof_Id"].ToString() == r["Hof_Id"].ToString()).ToString(),
                            CardCount = ds.Tables[0].AsEnumerable().Count(
                                                i => i["Hof_Id"].ToString() == r["Hof_Id"].ToString()
                                                        && (r["STATUS"].ToString() == "True")).ToString()
                        });
                        count++;
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return result;
        }
        public static RationCardDetail FetchFamilyCount(string custId)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();
            int convertedNum = 0;
            RationCardDetail card = new RationCardDetail();
            try
            {
                DataSet ds = DBoperationsManager.FetchFamilyCount(custId, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 1))
                {
                    card.FamilyCount = (( //TOTAL_CARD_COUNT
                        (ds.Tables[0].Rows.Count > 0) && Int32.TryParse(ds.Tables[0].Rows[0][0].ToString(), out convertedNum))
                        ? convertedNum : 0).ToString();
                    card.CardCount = (( //Active_CARD_COUNT
                        (ds.Tables[1].Rows.Count > 0) && Int32.TryParse(ds.Tables[1].Rows[0][0].ToString(), out convertedNum))
                        ? convertedNum : 0).ToString();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return card;
        }

        public static void FetchMasterData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchMasterData(out errType, out errMsg, out isSuccess, out errObj);

                DataSet tmpDs = new DataSet();
                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    tmpDs.Tables.Add(ds.Tables[0].Copy());
                    tmpDs.Tables.Add(ds.Tables[1].Copy());
                    tmpDs.Tables.Add(ds.Tables[2].Copy());
                    AssignHofData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[3].Copy());
                    AssignCategoryData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[4].Copy());
                    AssignRelationData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[5].Copy());
                    tmpDs.Tables.Add(ds.Tables[6].Copy());
                    tmpDs.Tables.Add(ds.Tables[7].Copy());
                    tmpDs.Tables.Add(ds.Tables[8].Copy());
                    AssignProductData(tmpDs);
                    tmpDs.Reset();


                    tmpDs.Tables.Add(ds.Tables[9].Copy());
                    tmpDs.Tables.Add(ds.Tables[10].Copy());
                    AssignUomData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[11].Copy());
                    AssignProductDeptData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[12].Copy());
                    AssignProductSubDeptData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[13].Copy());
                    AssignProductClassData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[14].Copy());
                    AssignProductSubClassData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[15].Copy());
                    AssignProductMcData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[16].Copy());
                    AssignProductBrandData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[17].Copy());
                    AssignRoleData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[18].Copy());
                    tmpDs.Tables.Add(ds.Tables[19].Copy());
                    AssignDistributorData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[20].Copy());
                    AssignConfigData(tmpDs);
                    tmpDs.Reset();

                    tmpDs.Tables.Add(ds.Tables[21].Copy());
                    AssignCardsOfThisFortnight(tmpDs);
                    tmpDs.Reset();

                    //DataFetchTime
                    MasterData.DataFetchTime = DateTime.Now;
                    MasterDataHelper.FetchCategoryWiseSearchResult();
                }
                Logger.LogInfo(Environment.NewLine + "masterdata fetch completed on " + DateTime.Now);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void ApplicationStartDbFetch()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DBoperationsManager.ApplicationStartDbFetch(out errType, out errMsg, out isSuccess);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchCatData(string cat, bool isLastCatId)
        {
            MasterData.CategoryWiseSearchResult.Data.Add(SearchCard("", "", cat));
            if (isLastCatId)
            {
                MasterData.MasterDataFetchComplete = true;
            }
            Logger.LogInfo(Environment.NewLine + "Search result for catid " + cat + " fetch complete on " + DateTime.Now);
        }
        public static void FetchConfig(string distId = "", string keyText = "", string keyVal = "", int active = 1, string operation = "GET", string cloneFromDistId = "")
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();
            isSuccess = false;

            distId = (string.IsNullOrEmpty(distId.Trim())) ? RationCardUser.DistId : distId;
            if (operation == "CLONE")
            {
                cloneFromDistId = (string.IsNullOrEmpty(cloneFromDistId.Trim())) ? RationCardUser.DistId : cloneFromDistId;
            }
            try
            {
                DataSet ds = DBoperationsManager.FetchConfig(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignConfigData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchHofData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchHofData(out errType, out errMsg, out isSuccess, out errObj);
                
                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignHofData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static void FetchCategoryData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchCategoryData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignCategoryData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static void FetchCardsOfThisFortnight()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchCardsOfThisFortnight(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignCardsOfThisFortnight(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchRelationData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchRelationData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignRelationData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchProductData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchProductData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignProductData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchUomData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchUomData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignUomData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchDeptData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchDeptData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignProductDeptData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchSubDeptData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchSubDeptData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignProductSubDeptData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchClassData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchClassData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignProductClassData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static void FetchSubClassData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchSubClassData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignProductSubClassData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchMcData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchMcData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignProductMcData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchBrandData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchBrandData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignProductBrandData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchRoleData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchRoleData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignRoleData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static void FetchDistributorData()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                DataSet ds = DBoperationsManager.FetchDistributorData(out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    AssignDistributorData(ds);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
    }
}
