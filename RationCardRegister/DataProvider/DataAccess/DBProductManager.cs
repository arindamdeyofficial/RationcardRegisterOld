using BusinessObject;
using DataAccessSql;
using Helpers;
using Helpers.MasterDataManager;
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
        public static void ProductSave(Product prd, string action, out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj,
            out string saveStatus, out string saveStatusMessage, out string prdName)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            errObj = new Exception();
            saveStatus = string.Empty;
            saveStatusMessage = string.Empty;
            prdName = string.Empty;
            isSuccess = false;

            try
            {
                string prdXml = prd.SerializeXml<Product>();
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = RationCardUser.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@prdData", SqlDbType = SqlDbType.Xml, Value = prdXml });
                sqlParams.Add(new SqlParameter { ParameterName = "@action", SqlDbType = SqlDbType.VarChar, Value = action });

                DataSet ds = ConnectionManager.Exec("Sp_SavePrdToInventory", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
                {
                    isSuccess = true;
                    saveStatus = ds.Tables[0].Rows[0]["Status"].ToString();
                    saveStatusMessage = ds.Tables[0].Rows[0]["StatusMsg"].ToString();
                    prdName = ds.Tables[0].Rows[0]["Name"].ToString();
                }
            }
            catch (Exception ex)
            {
                isSuccess = false;
                Logger.LogError(ex);
            }
        }

        public static List<Product_Input_Master> OperateProductTablesAndReturnData(string distId, string tableName, string id, string action
            , out bool isSuccess, out string statusMsg)
        {
            DataSet ds = null;
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            statusMsg = string.Empty;
            Exception errObj = new Exception();

            List<Product_Input_Master> prdData = new List<Product_Input_Master>();
            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = distId });
                sqlParams.Add(new SqlParameter { ParameterName = "@table", SqlDbType = SqlDbType.VarChar, Value = tableName });
                sqlParams.Add(new SqlParameter { ParameterName = "@Id", SqlDbType = SqlDbType.VarChar, Value = id });
                sqlParams.Add(new SqlParameter { ParameterName = "@action", SqlDbType = SqlDbType.VarChar, Value = action });

                ds = ConnectionManager.Exec("Sp_ProductTablesData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
                {
                    statusMsg = ds.Tables[ds.Tables.Count - 1].Rows[0][0].ToString()
                                        + Environment.NewLine
                                        + ds.Tables[ds.Tables.Count - 1].Rows[0][1].ToString();
                    prdData = ds.Tables[0].AsEnumerable().Select(item => new Product_Input_Master
                    {
                        Product_Input_Identity = item["Product_Input_Identity"].ToString(),
                        Dist_Id = item["Dist_Id"].ToString(),
                        Created_Date = item["Created_Date"].ToString(),
                        Product_Xml = item["Product_Xml"].ToString()
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return prdData;
        }

        public static List<Product> ProductSearch(string barCode, string articleCode, string prdName, string description, bool isActive, bool isDefaultToGiveRation
            , bool isDefaultPrd, string dept, string subDept, string prdClass, string subClass , string mc, string mcCode, string brand
            , string brandCompany, string dtFrom, string dtTo)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();
            List<Product> prds = new List<Product>();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = RationCardUser.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@barCode", SqlDbType = SqlDbType.VarChar, Value = barCode });
                sqlParams.Add(new SqlParameter { ParameterName = "@articleCode", SqlDbType = SqlDbType.VarChar, Value = articleCode });
                sqlParams.Add(new SqlParameter { ParameterName = "@prdName", SqlDbType = SqlDbType.VarChar, Value = prdName });
                sqlParams.Add(new SqlParameter { ParameterName = "@description", SqlDbType = SqlDbType.VarChar, Value = description });
                sqlParams.Add(new SqlParameter { ParameterName = "@isActive", SqlDbType = SqlDbType.Bit, Value = isActive });
                sqlParams.Add(new SqlParameter { ParameterName = "@isDefaultToGiveRation", SqlDbType = SqlDbType.Bit, Value = isDefaultToGiveRation });
                sqlParams.Add(new SqlParameter { ParameterName = "@isDefaultPrd", SqlDbType = SqlDbType.Bit, Value = isDefaultPrd });
                sqlParams.Add(new SqlParameter { ParameterName = "@dept", SqlDbType = SqlDbType.VarChar, Value = dept });
                sqlParams.Add(new SqlParameter { ParameterName = "@subDept", SqlDbType = SqlDbType.VarChar, Value = subDept });
                sqlParams.Add(new SqlParameter { ParameterName = "@class", SqlDbType = SqlDbType.VarChar, Value = prdClass });
                sqlParams.Add(new SqlParameter { ParameterName = "@subClass", SqlDbType = SqlDbType.VarChar, Value = subClass });
                sqlParams.Add(new SqlParameter { ParameterName = "@mc", SqlDbType = SqlDbType.VarChar, Value = mc });
                sqlParams.Add(new SqlParameter { ParameterName = "@mcCode", SqlDbType = SqlDbType.VarChar, Value = mcCode });
                sqlParams.Add(new SqlParameter { ParameterName = "@brand", SqlDbType = SqlDbType.VarChar, Value = brand });
                sqlParams.Add(new SqlParameter { ParameterName = "@brandCompany", SqlDbType = SqlDbType.VarChar, Value = brandCompany });
                sqlParams.Add(new SqlParameter { ParameterName = "@dtFrom", SqlDbType = SqlDbType.DateTime, Value = dtFrom });
                sqlParams.Add(new SqlParameter { ParameterName = "@dtTo", SqlDbType = SqlDbType.DateTime, Value = dtTo });

                DataSet ds = ConnectionManager.Exec("Sp_Product_Search", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
                if ((ds != null) && (ds.Tables.Count > 1) && (ds.Tables[0].Rows.Count > 0))
                {
                    DataSet tmpDs = new DataSet();
                    tmpDs.Tables.Add(ds.Tables[0].Copy());
                    tmpDs.Tables.Add(ds.Tables[1].Copy());
                    tmpDs.Tables.Add(ds.Tables[2].Copy());
                    tmpDs.Tables.Add(ds.Tables[3].Copy());
                    prds = MasterDataHelper.ExtractProductFromDataset(tmpDs);
                    tmpDs.Reset();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return prds;
        }

        public static void DeleteProduct(string prdId, out bool isSuccess)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = RationCardUser.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@table", SqlDbType = SqlDbType.VarChar, Value = "Product_Master" });
                sqlParams.Add(new SqlParameter { ParameterName = "@Id", SqlDbType = SqlDbType.VarChar, Value = prdId });
                sqlParams.Add(new SqlParameter { ParameterName = "@action", SqlDbType = SqlDbType.VarChar, Value = "DELETE" });

                DataSet ds = ConnectionManager.Exec("Sp_ProductTablesData", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
                {
                    isSuccess = true;
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static List<ProductStockReport> GetStockReportDataFromDb(out int totalNumOfColumn, out int totalNumOfHeaderColumn, out List<string> columnHeaders, out bool isSuccess)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            Exception errObj = new Exception();
            totalNumOfColumn = totalNumOfHeaderColumn = 0;
            columnHeaders = new List<string>();

            List<ProductStockReport> stkToPrint = new List<ProductStockReport>();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = RationCardUser.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@dtFrom", SqlDbType = SqlDbType.DateTime, Value = DateTime.Parse("01-01-1900").ToString("MM-dd-yyyy HH:mm:ss") });
                sqlParams.Add(new SqlParameter { ParameterName = "@dtTo", SqlDbType = SqlDbType.DateTime, Value = DateTime.Now.ToString("dd-MM-yyyy HH:mm:ss") });
                sqlParams.Add(new SqlParameter { ParameterName = "@operation", SqlDbType = SqlDbType.VarChar, Value = string.Empty });

                DataSet ds = ConnectionManager.Exec("Sp_Stockreport", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 1))
                {
                    isSuccess = true;
                    totalNumOfColumn = ds.Tables[1].Columns.Count;
                    totalNumOfHeaderColumn = ds.Tables[0].Columns.Count;
                    columnHeaders = ds.Tables[0].Rows[0].ItemArray.Select(i => i.ToString()).ToList();
                    stkToPrint = ds.Tables[1].AsEnumerable().Select(i => new ProductStockReport
                    {
                        Product_Stock_Report_Identity = i["Product_Stock_Report_Identity"].ToString(),
                        Dist_Id = i["Dist_Id"].ToString(),
                        Prod_Id = i["Prod_Id"].ToString(),
                        Cat_Id = i["Cat_Id"].ToString(),
                        UOM_Id = i["UOM_Id"].ToString(),
                        OpenningBalance = DoFormat(Decimal.Parse(i["OpenningBalance"].ToString())),
                        StockRecieved = DoFormat(Decimal.Parse(i["StockRecieved"].ToString())),
                        TotalStock = DoFormat(Decimal.Parse(i["TotalStock"].ToString())),
                        StockSold = DoFormat(Decimal.Parse(i["StockSold"].ToString())),
                        HandlingLoss = DoFormat(Decimal.Parse(i["HandlingLoss"].ToString())),
                        ClosingBalance = DoFormat(Decimal.Parse(i["ClosingBalance"].ToString())),
                        Created_Date = DateTime.Parse(i["Created_Date"].ToString()).ToShortDateString()
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return stkToPrint;
        }
        public static string DoFormat(Decimal myNumber)
        {
            var s = string.Format("{0:0.00}", myNumber);

            if (s.EndsWith("00"))
            {
                return ((int)(myNumber)).ToString();
            }
            else
            {
                return s;
            }
        }
    }
}
