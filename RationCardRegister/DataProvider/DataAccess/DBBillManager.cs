using BusinessObject;
using DataAccessSql;
using Helpers;
using Helpers.MasterDataManager.MasterDataBo;
using LogManager;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace DataAccess
{
    public static partial class DBoperationsManager
    {
        static List<Task> _tasksBillToSave = new List<Task>();
        public static void AddTaskToBillSaveQueue(Bill billObj)
        {
            _tasksBillToSave.Add(Task.Factory.StartNew(() => SaveBillToDbQueueManage(billObj)));
        }
        private static void SaveBillToDbQueueManage(Bill billObj)
        {
            string billXml = billObj.SerializeXml<Bill>().ToString();

            try
            {
                ErrorEnum errType = ErrorEnum.Other;
                string errMsg = string.Empty;
                bool isSuccess = false;

                SaveBillToDb(billXml, out errType, out errMsg, out isSuccess);
                if (!isSuccess && (errType.Equals(ErrorEnum.Networkfailure)))
                {
                    SaveBillToDb(billXml, out errType, out errMsg, out isSuccess);
                    if (!isSuccess)
                    {
                        Logger.LogError("Bill couldn't be saved due to network failure: " + Environment.NewLine + billXml);
                    }
                }                
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        private static void SaveBillToDb(string billXml, out ErrorEnum errType, out string errMsg, out bool isSuccess)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = RationCardUser.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@billData", SqlDbType = SqlDbType.Xml, Value = billXml });

                DataSet ds = ConnectionManager.Exec("Sp_Save_Bill", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[2].Rows.Count > 0) && (ds.Tables[2].Rows[0][0].Equals("SUCCESS")))
                {
                    MasterData.AllCardsOfThisFortnight.Refresh();
                    isSuccess = true;
                    Logger.LogInfo("Bill saved to Db Successfully. Bill XML : " + Environment.NewLine + billXml);
                }
                else
                {
                    Logger.LogError("Bill save to Db Failure.Bill XML: " + Environment.NewLine + billXml);
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }
        public static List<BillCounter> FetchBillCounter(out ErrorEnum errType, out string errMsg, out bool isSuccess)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            Exception errObj = new Exception();
            var billCounter = new List<BillCounter>();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = RationCardUser.DistId });
                sqlParams.Add(new SqlParameter { ParameterName = "@action", SqlDbType = SqlDbType.VarChar, Value = "VIEW" });

                DataSet ds = ConnectionManager.Exec("Sp_Fetch_Bill_Counter", sqlParams, out errType, out errMsg, out isSuccess, out errObj);
                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        int count = 1;
                        foreach (DataRow r in ds.Tables[0].Rows)
                        {
                            billCounter.Add(new BillCounter
                            {
                                Bill_Counter_Identity = r["Bill_Counter_Identity"].ToString(),
                                Dist_Id = r["Dist_Id"].ToString(),
                                TotalBillCOunter = r["TotalBillCounter"].ToString(),
                                DailyBillCOunterOrCount = r["DayBillCounterOrCount"].ToString(),
                                BillDate = r["BillDate"].ToString()
                            });
                            count++;
                        }
                        isSuccess = true;
                    }
                }
            }
            catch (Exception ex)
            {
                isSuccess = false;
                Logger.LogError(ex);
            }
            return billCounter;
        }
    }
}
