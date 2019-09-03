using BusinessObject;
using DataAccessSql;
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
        public static void OperateOrphanRecords(string distId, string action, out bool isSuccess
            , out List<RationCardDetail> rationCards, out List<Customer> customers)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            Exception errObj = new Exception();
            rationCards = new List<RationCardDetail>();
            customers = new List<Customer>();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = distId });
                sqlParams.Add(new SqlParameter { ParameterName = "@action", SqlDbType = SqlDbType.VarChar, Value = action });
                DataSet ds = ConnectionManager.Exec("Sp_OrphanCardAndCustomer", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 1))
                {
                    rationCards = ds.Tables[0].AsEnumerable().Select(i => new RationCardDetail
                    {
                        RationCard_Id = i.Field<int>("RationCard_Id").ToString(),
                        Number = i.Field<string>("Number"),
                        Card_Category_Id = i.Field<int>("Card_Category_Id").ToString(),
                        Customer_Id = i.Field<int>("Customer_Id").ToString(),
                        Dist_Id = i.Field<int>("Dist_Id").ToString(),
                        Remarks = i.Field<string>("Remarks"),
                        ActiveCard = i.Field<bool>("Active"),
                        Card_Created_Date = i.Field<DateTime>("Created_Date").ToString()
                    }).ToList();

                    customers = ds.Tables[1].AsEnumerable().Select(i => new Customer
                    {
                        Customer_Id = i.Field<int>("Customer_Id").ToString(),
                        Name = i.Field<string>("Name"),
                        Hof_Flag = i.Field<bool>("Hof_Flag").ToString(),
                        Age = i.Field<int>("Age").ToString(),
                        Address = i.Field<string>("Address"),
                        RationCard_Id = i.Field<string>("RationCard_Id").ToString(),
                        Hof_Id = i.Field<int>("Hof_Id").ToString(),
                        Dist_Id = i.Field<int>("Dist_Id").ToString(),
                        Adhar_No = i.Field<string>("Adhar_No"),
                        Relation_With_Hof = i.Field<string>("Relation_With_Hof"),
                        Gaurdian_Name = i.Field<string>("Gaurdian_Name"),
                        Mobile_No = i.Field<string>("Mobile_No"),
                        ActiveCustomer = i.Field<bool>("Active"),
                        Customer_Created_Date = i.Field<DateTime>("Created_Date").ToString()
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static List<SecurityCode> OprateSecurityCodes(string email, string code, string operation)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            Exception errObj = new Exception();

            List<SecurityCode> codes = new List<SecurityCode>();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Email", SqlDbType = SqlDbType.VarChar, Value = email });
                sqlParams.Add(new SqlParameter { ParameterName = "@Code", SqlDbType = SqlDbType.VarChar, Value = code });
                sqlParams.Add(new SqlParameter { ParameterName = "@operation", SqlDbType = SqlDbType.VarChar, Value = operation });

                DataSet ds = ConnectionManager.Exec("Sp_Security_Code_Get_Add", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    codes.AddRange(ds.Tables[0].AsEnumerable().Select(i => new SecurityCode
                    {
                        Security_Code_Identity = i["Security_Code_Identity"].ToString(),
                        Security_Code_In_Mail = i["Security_Code_In_Mail"].ToString(),
                        Mail_Id = i["Mail_Id"].ToString(),
                        Created_Date = i["Created_Date"].ToString()
                    }));
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return codes;
        }
    }
}
