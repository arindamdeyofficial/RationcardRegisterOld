using BusinessObject;
using DataAccessSql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DataAccess
{
    public static partial class DBoperationsManager
    {
        public static void DeleteAuditRecords(string tableName, string fromDate, string toDate, out bool isSuccess)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            Exception errObj = new Exception();

            List<SqlParameter> sqlParams = new List<SqlParameter>();

            sqlParams.Add(new SqlParameter { ParameterName = "@tableName", SqlDbType = SqlDbType.VarChar, Value = tableName });
            sqlParams.Add(new SqlParameter
            {
                ParameterName = "@dtFrom",
                SqlDbType = SqlDbType.VarChar,
                Value = fromDate
            });
            sqlParams.Add(new SqlParameter
            {
                ParameterName = "@dtTo",
                SqlDbType = SqlDbType.VarChar,
                Value = toDate
            });
            DataSet ds = ConnectionManager.Exec("Sp_Clean_Audit_Tables", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

            if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
            {
                isSuccess = ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS");
            }
        }
    }
}
