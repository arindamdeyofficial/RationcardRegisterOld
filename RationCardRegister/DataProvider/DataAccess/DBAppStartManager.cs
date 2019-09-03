using BusinessObject;
using DataAccessSql;
using Helpers.MasterDataManager;
using Helpers.MasterDataManager.MasterDataBo;
using LogManager;
using NetworkManager;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace DataAccess
{
    public static partial class DBoperationsManager
    {
        public static void ApplicationStartDbFetch(out ErrorEnum errType, out string errMsg, out bool isSuccess)
        {
            errType = ErrorEnum.Other;
            errMsg = string.Empty;
            isSuccess = false;
            Exception errObj = new Exception();

            string macAddr = Network.GetActiveMACAddress();
            string ipAddrInternal = Network.GetActiveIP();
            string ipAddrPublic = Network.GetPublicIpAddress();
            string gateWay = Network.GetActiveGateway();
            try
            {
                Logger.LogInfo("Mac id: " + macAddr + " ipAddr: " + ipAddrInternal + " Gateway: " + gateWay + "Public Ip: " + ipAddrPublic);
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@mac", SqlDbType = SqlDbType.VarChar, Value = macAddr });
                sqlParams.Add(new SqlParameter { ParameterName = "@Internal_Ip", SqlDbType = SqlDbType.VarChar, Value = ipAddrInternal });
                sqlParams.Add(new SqlParameter { ParameterName = "@Public_Ip", SqlDbType = SqlDbType.VarChar, Value = ipAddrPublic });
                sqlParams.Add(new SqlParameter { ParameterName = "@Gateway_Addr", SqlDbType = SqlDbType.VarChar, Value = gateWay });

                DataSet ds = ConnectionManager.Exec("SP_App_Start", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if (isSuccess && ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0) && (ds.Tables[0].Rows[0]["Status"].ToString() == "SUCCESS")))
                {
                    DataSet tmpDs = new DataSet();
                    tmpDs.Tables.Add(ds.Tables[1].Copy());
                    MasterDataHelper.AssignRoleData(tmpDs);
                    tmpDs.Reset();

                    RationCardUser.LoginId = ds.Tables[0].Rows[0]["Dist_Login"].ToString();
                    RationCardUser.EmailId = ds.Tables[0].Rows[0]["Dist_Email"].ToString();
                    RationCardUser.MacId = Network.GetActiveMACAddress();
                    RationCardUser.AllowedMacId = ds.Tables[0].Rows[0]["Dist_Mac_Id"].ToString();
                    RationCardUser.Name = ds.Tables[0].Rows[0]["Dist_Name"].ToString();
                    RationCardUser.MobileNo = ds.Tables[0].Rows[0]["Dist_Mobile_No"].ToString();
                    RationCardUser.DistId = ds.Tables[0].Rows[0]["Dist_Id"].ToString();
                    RationCardUser.Address = ds.Tables[0].Rows[0]["Dist_Address"].ToString();
                    RationCardUser.ProfilePicPath = ds.Tables[0].Rows[0]["Dist_Profile_Pic_Path"].ToString();
                    RationCardUser.Roles = MasterData.Roles.Data;
                    RationCardUser.LiscenceNo = ds.Tables[0].Rows[0]["Dist_Fps_Liscence_No"].ToString();
                    RationCardUser.MrShopNo = ds.Tables[0].Rows[0]["Dist_Mr_Shop_No"].ToString();
                    RationCardUser.FpsCode = ds.Tables[0].Rows[0]["Dist_Fps_Code"].ToString();
                    RationCardUser.IsSuperadmin = ds.Tables[0].Rows[0]["IsSuperAdmin"].ToString() == "True";
                    RationCardUser.Password = ds.Tables[0].Rows[0]["Dist_Password"].ToString();
                    RationCardUser.MobileNoToNotifyViaSms = ((ds.Tables[0].Rows[0]["MobileNoToNotifyViaSms"].ToString() != "0") ? ds.Tables[0].Rows[0]["MobileNoToNotifyViaSms"].ToString() : "");
                    RationCardUser.EmailToNotify = ds.Tables[0].Rows[0]["EmailToNotify"].ToString();

                    Logger.LogInfo("LoginId: " + RationCardUser.LoginId + " EmailId: " + RationCardUser.EmailId + " MacId: " + RationCardUser.MacId + " AllowedMacId: " + RationCardUser.AllowedMacId + " Name: " + RationCardUser.Name
                        + " MobileNo: " + RationCardUser.MobileNo + " DistId: " + RationCardUser.DistId + " Address: " + RationCardUser.Address + " ProfilePicPath: " + RationCardUser.ProfilePicPath + " Role Count: " + RationCardUser.Roles.Count
                        + " LiscenceNo: " + RationCardUser.LiscenceNo + " MrShopNo: " + RationCardUser.MrShopNo + " FpsCode: " + RationCardUser.FpsCode);
                    isSuccess = true;
                } 
            }
            catch (Exception ex)
            {
                errType = ErrorEnum.Other;
                Logger.LogError(ex);
            }
        }

        public static List<AppStart> LoadAppStartHis()
        {
            List<AppStart> appStartData = new List<AppStart>();
            try
            {
                ErrorEnum errType = ErrorEnum.Other;
                string errMsg = string.Empty;
                bool isSuccess = false;
                Exception errObj = new Exception();

                List<SqlParameter> sqlParams = new List<SqlParameter>();
                DataSet ds = ConnectionManager.Exec("Sp_AppStart_Details", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    appStartData = ds.Tables[0].AsEnumerable().Select(i => new AppStart
                    {
                        App_Start_His_Id = i.Field<int>("App_Start_His_Id").ToString(),
                        Mac_Id = i["Mac_Id"].ToString(),
                        Ip = i["Internal_Ip"].ToString(),
                        PublicIp = i["Public_Ip"].ToString(),
                        Gateway = i["Gateway_Addr"].ToString(),
                        Created_Date = i["Created_Date"].ToString(),
                        Last_Updated_Date = i["Last_Updated_Date"].ToString(),
                        Updated_by = i["Updated_by"].ToString()
                    }).ToList();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return appStartData;
        }

        public static void FlushAppHistory(out string statusMsg, out bool isSuccess)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            statusMsg = string.Empty;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                DataSet ds = ConnectionManager.Exec("Sp_AppStart_Flush", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    isSuccess = true;
                    statusMsg = ds.Tables[0].Rows[0][0].ToString();
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static bool DoLogin(string userId, string password, string macId, out string msg, out bool isSuccess)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            isSuccess = false;
            msg = string.Empty;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@userId", SqlDbType = SqlDbType.VarChar, Value = userId });
                sqlParams.Add(new SqlParameter { ParameterName = "@pass", SqlDbType = SqlDbType.VarChar, Value = password });
                sqlParams.Add(new SqlParameter { ParameterName = "@mac", SqlDbType = SqlDbType.VarChar, Value = macId });

                DataSet ds = ConnectionManager.Exec("Sp_Login", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0))
                {
                    if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")
                    {
                        Logger.LogInfo("Login successful.");
                        isSuccess = true;
                    }
                    else if (ds.Tables[0].Rows[0][0].ToString() == "FAILURE")
                    {
                        msg = ds.Tables[0].Rows[0][1].ToString();
                        Logger.LogError(msg);
                        isSuccess = false;
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return isSuccess;
        }

        public static void RemoveUser(string userId, out bool isSuccess)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            List<MacIdAssigned> mcs = new List<MacIdAssigned>();
            isSuccess = true;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Login", SqlDbType = SqlDbType.VarChar, Value = userId });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Name", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Mobile_No", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Address", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Email", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Profile_Pic_Path", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Password", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Mac_Check", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Fps_Code", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Fps_Liscence_No", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Mr_Shop_No", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@mac", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@remark", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@code", SqlDbType = SqlDbType.VarChar, Value = string.Empty });
                sqlParams.Add(new SqlParameter { ParameterName = "@operation", SqlDbType = SqlDbType.VarChar, Value = "REMOVE" });

                DataSet ds = ConnectionManager.Exec("Sp_Distributor_Operate", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    isSuccess = true;
                }
                else
                    isSuccess = false;
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static void RegisterNewUser(string name, string mobileNo, string address, string email, string profilePicPath
            , string login, string password, bool macChekRequired, string fpsCode, string fpsLiscenceNo, string mrShopNo
            , string mac, string remark, string code
            , out string successMsg)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            bool isSuccess = false;
            List<MacIdAssigned> mcs = new List<MacIdAssigned>();
            successMsg = "";
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Name", SqlDbType = SqlDbType.VarChar, Value = name });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Mobile_No", SqlDbType = SqlDbType.VarChar, Value = mobileNo });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Address", SqlDbType = SqlDbType.VarChar, Value = address });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Email", SqlDbType = SqlDbType.VarChar, Value = email });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Profile_Pic_Path", SqlDbType = SqlDbType.VarChar, Value = profilePicPath });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Password", SqlDbType = SqlDbType.VarChar, Value = password });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Mac_Check", SqlDbType = SqlDbType.Bit, Value = macChekRequired ? 1 : 0 });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Fps_Code", SqlDbType = SqlDbType.VarChar, Value = fpsCode });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Fps_Liscence_No", SqlDbType = SqlDbType.VarChar, Value = fpsLiscenceNo });
                sqlParams.Add(new SqlParameter { ParameterName = "@Dist_Mr_Shop_No", SqlDbType = SqlDbType.VarChar, Value = mrShopNo });
                sqlParams.Add(new SqlParameter { ParameterName = "@mac", SqlDbType = SqlDbType.VarChar, Value = mac });
                sqlParams.Add(new SqlParameter { ParameterName = "@remark", SqlDbType = SqlDbType.VarChar, Value = remark });
                sqlParams.Add(new SqlParameter { ParameterName = "@code", SqlDbType = SqlDbType.VarChar, Value = code });
                sqlParams.Add(new SqlParameter { ParameterName = "@operation", SqlDbType = SqlDbType.VarChar, Value = "ADD" });

                DataSet ds = ConnectionManager.Exec("Sp_Distributor_Operate", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    if (ds.Tables[0].Rows[0][0].ToString().Equals("SUCCESS"))
                    {
                        successMsg = ds.Tables[0].Rows[0][1].ToString();
                    }
                    else if (ds.Tables[0].Rows[0][0].ToString().Equals("FAILURE"))
                    {
                        successMsg = ds.Tables[0].Rows[0][1].ToString();
                    }
                }
                else
                    successMsg = "Not able to register new user. Please contact admin.";
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
        }

        public static List<MacIdAssigned> GetMacAddrsFromDb(string distId, string mac, string macIdType, string startFormName
            , string remark, string operation, out bool isSuccess)
        {
            ErrorEnum errType = ErrorEnum.Other;
            string errMsg = string.Empty;
            List<MacIdAssigned> mcs = new List<MacIdAssigned>();
            isSuccess = false;
            Exception errObj = new Exception();

            try
            {
                List<SqlParameter> sqlParams = new List<SqlParameter>();
                sqlParams.Add(new SqlParameter { ParameterName = "@distId", SqlDbType = SqlDbType.VarChar, Value = distId });
                sqlParams.Add(new SqlParameter { ParameterName = "@mac", SqlDbType = SqlDbType.VarChar, Value = mac });
                sqlParams.Add(new SqlParameter { ParameterName = "@remark", SqlDbType = SqlDbType.VarChar, Value = remark });
                sqlParams.Add(new SqlParameter { ParameterName = "@action", SqlDbType = SqlDbType.VarChar, Value = operation });
                DataSet ds = ConnectionManager.Exec("Sp_Add_Remove_Mac_Id", sqlParams, out errType, out errMsg, out isSuccess, out errObj);

                if ((ds != null) && (ds.Tables.Count > 0))
                {
                    mcs.AddRange(ds.Tables[0].AsEnumerable().Select(i => new MacIdAssigned
                    {
                        Mac_Id_Identity = i["Mac_Id_Identity"].ToString(),
                        Mac_Id = i["Mac_Id"].ToString(),
                        Remarks = i["Remarks"].ToString(),
                        Created_Date = i["Created_Date"].ToString()
                    }));
                    isSuccess = true;
                }
                else
                    isSuccess = false;
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return mcs;
        }
    }
}

