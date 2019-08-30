using BusinessObject;
using DataAccessSql;
using Helpers.MasterDataManager.MasterDataBo;
using LogManager;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DataAccess
{
    public static partial class DBoperationsManager
    {
        private static List<Category> _catWiseCountData = null;
        public static List<Category> CatWiseCardCountData
        {
            get
            {
                if(_catWiseCountData == null)
                {
                    _catWiseCountData = new List<Category>();
                    RefreshCatWiseCountFromDb();
                }
                return _catWiseCountData;
            }
        }
        public static void SaveRationCard(string rationCardId, string categoryId, string categoryDesc, string CardNo, string customerId, string adhar
            , string cardHolderName, string isHof, string hofId, string hofName, string RelWithHofId, string RelWithHofDesc, string FatherName, string typeOfRelationId
            , string typeOfRelationDesc, string activeOrInactiveDt, string mobileNo, string age, string isActive, string address, string remarks
            , out bool isSuccess, out string msgToShow)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            string isInputSuccess = string.Empty;
            string cardMsg = string.Empty;
            string custMsg = string.Empty;
            msgToShow = string.Empty;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@mac", SqlDbType = SqlDbType.VarChar, Value = User.MacId });
                sqlParams.Add(new SqlParameter { ParameterName = "@rationCardId", SqlDbType = SqlDbType.VarChar, Value = rationCardId });
                sqlParams.Add(new SqlParameter { ParameterName = "@categoryId", SqlDbType = SqlDbType.VarChar, Value = categoryId });
                sqlParams.Add(new SqlParameter { ParameterName = "@categoryDesc", SqlDbType = SqlDbType.VarChar, Value = categoryDesc });
                sqlParams.Add(new SqlParameter { ParameterName = "@CardNo", SqlDbType = SqlDbType.VarChar, Value = CardNo });
                sqlParams.Add(new SqlParameter { ParameterName = "@customerId", SqlDbType = SqlDbType.VarChar, Value = customerId });
                sqlParams.Add(new SqlParameter { ParameterName = "@adhar", SqlDbType = SqlDbType.VarChar, Value = adhar });
                sqlParams.Add(new SqlParameter { ParameterName = "@cardHolderName", SqlDbType = SqlDbType.VarChar, Value = cardHolderName });
                sqlParams.Add(new SqlParameter { ParameterName = "@isHof", SqlDbType = SqlDbType.VarChar, Value = isHof });
                sqlParams.Add(new SqlParameter { ParameterName = "@hofId", SqlDbType = SqlDbType.VarChar, Value = hofId });
                sqlParams.Add(new SqlParameter { ParameterName = "@hofName", SqlDbType = SqlDbType.VarChar, Value = hofName });
                sqlParams.Add(new SqlParameter { ParameterName = "@RelWithHofId", SqlDbType = SqlDbType.VarChar, Value = RelWithHofId });
                sqlParams.Add(new SqlParameter { ParameterName = "@RelWithHofDesc", SqlDbType = SqlDbType.VarChar, Value = RelWithHofDesc });
                sqlParams.Add(new SqlParameter { ParameterName = "@FatherName", SqlDbType = SqlDbType.VarChar, Value = FatherName });
                sqlParams.Add(new SqlParameter { ParameterName = "@typeOfRelationId", SqlDbType = SqlDbType.VarChar, Value = typeOfRelationId });
                sqlParams.Add(new SqlParameter { ParameterName = "@typeOfRelationDesc", SqlDbType = SqlDbType.VarChar, Value = typeOfRelationDesc });
                sqlParams.Add(new SqlParameter { ParameterName = "@activeOrInactiveDt", SqlDbType = SqlDbType.VarChar, Value = activeOrInactiveDt });
                sqlParams.Add(new SqlParameter { ParameterName = "@mobileNo", SqlDbType = SqlDbType.VarChar, Value = mobileNo });
                sqlParams.Add(new SqlParameter { ParameterName = "@age", SqlDbType = SqlDbType.VarChar, Value = age });
                sqlParams.Add(new SqlParameter { ParameterName = "@isActive", SqlDbType = SqlDbType.VarChar, Value = isActive });
                sqlParams.Add(new SqlParameter { ParameterName = "@address", SqlDbType = SqlDbType.VarChar, Value = address });
                sqlParams.Add(new SqlParameter { ParameterName = "@remarks", SqlDbType = SqlDbType.VarChar, Value = remarks });

                DataSet ds = ConnectionManager.Exec("Sp_RationCard_Save", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
                {
                    isInputSuccess = ds.Tables[0].Rows[0][0].ToString();
                    cardMsg = ds.Tables[0].Rows[0][1].ToString();
                    custMsg = ds.Tables[0].Rows[0][2].ToString();
                    msgToShow = string.Empty;
                    if (isInputSuccess.Contains("FAILURE"))
                    {
                        msgToShow = isInputSuccess;
                        isSuccess = false;
                    }
                    if (cardMsg.Contains("FAILURE"))
                    {
                        msgToShow = cardMsg;
                        isSuccess = false;
                    }
                    if (custMsg.Contains("FAILURE"))
                    {
                        msgToShow = custMsg;
                        isSuccess = false;
                    }
                    if (!string.IsNullOrEmpty(msgToShow))
                    {
                        Logger.LogError(msgToShow);
                    }

                    if (isSuccess)
                    {
                        //Refresh related Masterdata
                        MasterData.Hofs.Refresh();
                        MasterData.Relations.Refresh();
                        RefreshCatWiseCountFromDb();
                    }
                    isSuccess = true;
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static void RefreshCatWiseCountFromDb()
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                //refresh catwise count
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                DataSet ds = ConnectionManager.Exec("Sp_Catwise_Count", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
                {
                    _catWiseCountData = ds.Tables[0].AsEnumerable().Select(i => new Category { Cat_Desc = i[1].ToString(), CardCount = i[2].ToString(), FamilyCount = i[3].ToString() }).ToList();
                }
                else
                {
                    _catWiseCountData = new List<Category>();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static string RationcardDelete(string rationCardId, string customerId, out bool isSuccess)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            string finalMsg = string.Empty;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@rationCardId", SqlDbType = SqlDbType.VarChar, Value = rationCardId });
                sqlParams.Add(new SqlParameter { ParameterName = "@customerId", SqlDbType = SqlDbType.VarChar, Value = customerId });
                DataSet ds = ConnectionManager.Exec("Sp_RationCard_Delete", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
                {
                    isSuccess = true;
                    finalMsg = ds.Tables[0].Rows[0][1].ToString();
                    RefreshCatWiseCountFromDb();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return finalMsg;
        }

        public static string DuplicateCheck(string val, string checkBy, out bool isDuplicate, out bool isRecordExists, out bool cardExists, out bool adharExists, out bool mobileNoexists)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess;
            isDuplicate = isRecordExists = false;
            string finalMsg = string.Empty;
            cardExists = adharExists = mobileNoexists = false;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@checkName", SqlDbType = SqlDbType.VarChar, Value = checkBy });
                sqlParams.Add(new SqlParameter { ParameterName = "@param", SqlDbType = SqlDbType.VarChar, Value = val });
                DataSet ds = ConnectionManager.Exec("Sp_Unique_Check", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[1].Rows.Count > 0))
                {
                    isRecordExists = true;
                    if (!(ds.Tables[1].Rows[0][0].ToString().Contains("SUCCESS")))
                    {
                        isDuplicate = true;
                        foreach (DataRow r in ds.Tables[1].Rows)
                        {
                            finalMsg += r["MSG"].ToString() + Environment.NewLine;
                        }
                        switch (ds.Tables[0].Rows[0]["DUPLICATE_TYPE"].ToString())
                        {
                            case "RATIONCARD_DUPLICATE":
                                cardExists = true;
                                break;
                            case "ADHARCARD_DUPLICATE":
                                adharExists = true;
                                break;
                            case "MOBILENO_DUPLICATE":
                                mobileNoexists = true;
                                break;
                            default:
                                break;
                        }
                    }
                    else
                    {
                        switch (checkBy)
                        {
                            case "RATIONCARD":
                                cardExists = false;
                                break;
                            case "ADHARCARD":
                                adharExists = false;
                                break;
                            case "MOBILENO":
                                mobileNoexists = false;
                                break;
                            default:
                                break;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return finalMsg;
        }  
    }
}
