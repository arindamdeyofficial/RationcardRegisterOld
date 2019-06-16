
using BusinessObjects.Common;
using DataAccess;
using Helper;
using HelperManagers;
using MasterDataManager;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace BusinessObjects
{
    public sealed class BWInstance
    {
        private static readonly Lazy<BWInstance> lazy =
            new Lazy<BWInstance>(() => new BWInstance());

        public static BWInstance Instance { get { return lazy.Value; } }

        private BWInstance()
        {
        }
        //public int myTask(int a)
        //{
        //    var r = dummy(a);
        //    r.Wait();
        //    return r.Result;
        //}
        //public async Task<int> dummy(int a)
        //{
        //    await Task.Delay(1000);
        //    return a;
        //}

        public void FetchMasterData()
        {
            try
            {
                MasterDataHelper.FetchMasterData();

                //AddStaticData();
            }
            catch (Exception ex)
            {
                LoggerHelper.LogError(ex);
            }
        }
        public void FetchMasterDataByThread()
        {
            try
            {
                MasterDataHelper.FetchDelayedMasterData();
            }
            catch (Exception ex)
            {
                LoggerHelper.LogError(ex);
            }
        }
        //private void AddStaticData()
        //{
            
        //}
        public void Login(string userName)
        {
            Messages.ClearMessages();
            try
            {
                DALInstance.Instance.Login(userName);

                if (UserDetails.IsAuthenticateUser)
                {
                    FetchMasterData();
                    //fetch Master Data
                    ThreadStart threadDelegate = new ThreadStart(FetchMasterDataByThread);
                    Thread newThread = new Thread(threadDelegate);
                    newThread.Start();
                }
            }
            catch (Exception ex)
            {
                LoggerHelper.LogError(ex);
            }
        }
        
        public void FetchUserPrimaryInfo()
        {
            try
            {
                string macAddr = Network.GetActiveMACAddress();
                string ipAddrInternal = Network.GetActiveIP();
                string ipAddrPublic = Network.GetPublicIpAddress();
                string gateWay = Network.GetActiveGateway();

                LoggerHelper.LogInfo("Mac id: " + macAddr + " ipAddr: " + ipAddrInternal + " Gateway: " + gateWay + "Public Ip: " + ipAddrPublic);
                

                //if ((ds != null) && (ds.Tables.Count > 0) && (ds.Tables[0].Rows.Count > 0) && (ds.Tables[0].Rows[0]["Status"].ToString() == "SUCCESS"))
                //{
                //    DataSet tmpDs = new DataSet();
                //    tmpDs.Tables.Add(ds.Tables[1].Copy());
                //    MasterDataHelper.AssignRoleData(tmpDs);
                //    tmpDs.Reset();

                //    User.LoginId = ds.Tables[0].Rows[0]["Dist_Login"].ToString();
                //    User.EmailId = ds.Tables[0].Rows[0]["Dist_Email"].ToString();
                //    User.MacId = Network.GetActiveMACAddress();
                //    User.AllowedMacId = ds.Tables[0].Rows[0]["Dist_Mac_Id"].ToString();
                //    User.Name = ds.Tables[0].Rows[0]["Dist_Name"].ToString();
                //    User.MobileNo = ds.Tables[0].Rows[0]["Dist_Mobile_No"].ToString();
                //    User.DistId = ds.Tables[0].Rows[0]["Dist_Id"].ToString();
                //    User.Address = ds.Tables[0].Rows[0]["Dist_Address"].ToString();
                //    User.ProfilePicPath = ds.Tables[0].Rows[0]["Dist_Profile_Pic_Path"].ToString();
                //    User.Roles = MasterData.Roles.Data;
                //    User.LiscenceNo = ds.Tables[0].Rows[0]["Dist_Fps_Liscence_No"].ToString();
                //    User.MrShopNo = ds.Tables[0].Rows[0]["Dist_Mr_Shop_No"].ToString();
                //    User.FpsCode = ds.Tables[0].Rows[0]["Dist_Fps_Code"].ToString();
                //    User.IsSuperadmin = ds.Tables[0].Rows[0]["IsSuperAdmin"].ToString() == "True";
                //    User.Password = ds.Tables[0].Rows[0]["Dist_Password"].ToString();
                //    User.MobileNoToNotifyViaSms = ((ds.Tables[0].Rows[0]["MobileNoToNotifyViaSms"].ToString() != "0") ? ds.Tables[0].Rows[0]["MobileNoToNotifyViaSms"].ToString() : "");
                //    User.EmailToNotify = ds.Tables[0].Rows[0]["EmailToNotify"].ToString();

                //    LoggerHelper.LogInfo("LoginId: " + User.LoginId + " EmailId: " + User.EmailId + " MacId: " + User.MacId + " AllowedMacId: " + User.AllowedMacId + " Name: " + User.Name
                //        + " MobileNo: " + User.MobileNo + " DistId: " + User.DistId + " Address: " + User.Address + " ProfilePicPath: " + User.ProfilePicPath + " Role Count: " + User.Roles.Count
                //        + " LiscenceNo: " + User.LiscenceNo + " MrShopNo: " + User.MrShopNo + " FpsCode: " + User.FpsCode);

                //    if (User.IsSuperadmin)
                //    {
                //        Application.Run(new FrmUserSelector());
                //    }
                //    else
                //    {
                //        Application.Run(new FrmLogin());
                //    }
                //}
                //else
                //{
                //    Application.Run(new FrmSetup());
                //}
            }
            catch (Exception ex)
            {
                LoggerHelper.LogError(ex);
            }
        }
    }
}
