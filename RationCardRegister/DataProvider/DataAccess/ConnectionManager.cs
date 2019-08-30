using BusinessObject;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace DataAccessSql
{
    public static class ConnectionManager
    {
        public static string _connStr = string.Empty;
        public static DataSet Exec(string procName, List<SqlParameter> sqlParams, out ErrorEnum errType, out string errMsg, out bool isSuccess, out Exception errObj)
        {
            isSuccess = false;
            errObj = new Exception();
            errMsg = "Error occured during procedure " + procName + Environment.NewLine + "Inputs of proc: " + Environment.NewLine;
            errType = ErrorEnum.Other;
            int count = 0;
            DataSet ds = new DataSet();
            using (var con = new SqlConnection(_connStr))
            {
                try
                {
                    using (var cmd = new SqlCommand(procName, con))
                    using (var da = new SqlDataAdapter(cmd))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        foreach (SqlParameter param in sqlParams)
                        {
                            errMsg += sqlParams[count].ParameterName + "  :  " + sqlParams[count].Value;
                            cmd.Parameters.Add(sqlParams[count]);
                            count++;
                        }

                        da.Fill(ds);
                        isSuccess = true;

                        if (procName.Contains("SP_App_Start"))
                        {
                            string msg = ds.Tables[0].Rows[0][1].ToString();
                            if (msg.Contains("Device is not registered. Please contact support"))
                            {
                                errType = ErrorEnum.MacNotAllowed;
                                isSuccess = false;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    errObj = ex;
                    errMsg = ex.Message;
                    if (errMsg.Contains("Client with IP address"))
                    {
                        errType = ErrorEnum.IpNotAllowed;
                    }
                    else
                    {
                        errType = ErrorEnum.ProcFailure;
                    }
                }
                finally
                {
                    con.Close();
                }
            }
            return ds;
        }
    }
}
