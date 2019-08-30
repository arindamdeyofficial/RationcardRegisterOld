using BusinessObject;
using DataAccessSql;
using Helpers.MasterDataManager.MasterDataBo;
using LogManager;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
    public static partial class DBoperationsManager
    {
        public static DataSet SearchCard(string searchBy, string searchText, string searchCatId
            , out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj, bool fetchOnlyRecentData = false)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();

            var result = new DataSet();
            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();

                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@searchBy", SqlDbType = SqlDbType.VarChar, Value = searchBy });
                sqlParams.Add(new SqlParameter { ParameterName = "@searchText", SqlDbType = SqlDbType.VarChar, Value = searchText });
                sqlParams.Add(new SqlParameter { ParameterName = "@searchCatId", SqlDbType = SqlDbType.VarChar, Value = (string.IsNullOrEmpty(searchCatId) ? DBNull.Value.ToString() : searchCatId) });
                sqlParams.Add(new SqlParameter
                {
                    ParameterName = "@dtFrom",
                    SqlDbType = SqlDbType.VarChar,
                    Value = fetchOnlyRecentData
                                ? MasterData.DataFetchTime.ToString("MM-dd-yyyy HH:mm:ss")
                                : DateTime.Parse("01-01-1900").ToString("MM-dd-yyyy HH:mm:ss")
                });
                sqlParams.Add(new SqlParameter { ParameterName = "@dtTo", SqlDbType = SqlDbType.VarChar, Value = DateTime.Now.ToString("MM-dd-yyyy HH:mm:ss") });

                result = ConnectionManager.Exec("Sp_RationCard_Search", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return result;
        }

        public static DataSet FetchFamilyCount(string custId, out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@Id", SqlDbType = SqlDbType.VarChar, Value = custId });

                ds = ConnectionManager.Exec("Sp_GetCardCount", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }

        public static DataSet FetchMasterData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchConfig(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj
            , string distId = "", string keyText = "", string keyVal = "", int active = 1, string operation = "GET", string cloneFromDistId = "")
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            distId = (string.IsNullOrEmpty(distId.Trim())) ? User.DistId : distId;
            if (operation == "CLONE")
            {
                cloneFromDistId = (string.IsNullOrEmpty(cloneFromDistId.Trim())) ? User.DistId : cloneFromDistId;
            }
            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = distId });
                sqlParams.Add(new SqlParameter { ParameterName = "@configKey", SqlDbType = SqlDbType.VarChar, Value = keyText });
                sqlParams.Add(new SqlParameter { ParameterName = "@configVal", SqlDbType = SqlDbType.VarChar, Value = keyVal });
                sqlParams.Add(new SqlParameter { ParameterName = "@active", SqlDbType = SqlDbType.Bit, Value = active });
                sqlParams.Add(new SqlParameter { ParameterName = "@cloneFromDistId", SqlDbType = SqlDbType.VarChar, Value = cloneFromDistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@action", SqlDbType = SqlDbType.VarChar, Value = operation });

                ds = ConnectionManager.Exec("Sp_ConfigOperation", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchHofData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetHofMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }

        public static DataSet FetchCategoryData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetCategoryMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }

        public static DataSet FetchCardsOfThisFortnight(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_CardsInThisFortnight", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchRelationData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetRelationMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchProductData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetProductMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchUomData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetUomMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchDeptData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetDeptMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchSubDeptData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetSubDeptMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchClassData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetClassMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }

        public static DataSet FetchSubClassData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetSubClassMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchMcData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetMcMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchBrandData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetBrandMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
        public static DataSet FetchRoleData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = User.DistId });
                ds = ConnectionManager.Exec("Sp_GetRoleMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }        
        public static DataSet FetchDistributorData(out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            DataSet ds = new DataSet();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                ds = ConnectionManager.Exec("Sp_GetDistributorMasterData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return ds;
        }
    }
}
