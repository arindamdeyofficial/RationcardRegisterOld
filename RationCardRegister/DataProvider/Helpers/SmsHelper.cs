using BusinessObject;
using Helpers.MasterDataManager.MasterDataBo;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Web;

namespace SmsManager
{
    public static class SmsHelper
    {
        public static bool _isSendSms = SendSmsCheck();
        private static string _msg = string.Empty;
        private static List<string> _uniqueMsgArr = new List<string>();
        static string _superAdminMobiles = string.Empty;
        static SmsHelper()
        {
            _superAdminMobiles = "9830609366";
        }
        private static bool SendSmsCheck()
        {
            return MasterData.Configs.Data.Find(i => i.KeyText.Equals("SmsSendAllowed")).ValueText == "TRUE";
        }
        private static bool SmsDuplicateCheck(string msg)
        {
            if (_uniqueMsgArr.Any(i => i.Equals(msg)))
            {
                return false;
            }            
            _uniqueMsgArr.Add(msg);
            return true;
        }
        public static bool SendSms(string msg, string numbers, out string statusMsg)
        {
            _msg = msg;            
            bool isSuccess = true;
            if (_isSendSms && SmsDuplicateCheck(msg))
            {                
                statusMsg = "";
                try
                {
                    //https://control.textlocal.in/
                    //biplabhome@gmail.com
                    //Nakshal!01051987

                    string msgText = HttpUtility.UrlEncode(msg);
                    using (var wb = new WebClient())
                    {
                        byte[] response = wb.UploadValues("https://api.textlocal.in/send/",
                            new NameValueCollection()
                            {
                            //{ "username", "biplabhome@gmail.com"},
                            //{ "password", "Nakshal!01051987"},
                            //{ "hash", "50b9a50d1bcaf6090f17daeed7ab5f76b79f023437fe556ff16a710a257e7827"},
                            {"apikey" , "DDem9k1obsM-YILTxYVltZ7HICsbaiZtmxVOfuGPev"},
                            {"numbers" , numbers},
                            {"message" , msgText},
                            {"sender" , "TXTLCL"}
                            });
                        string result = System.Text.Encoding.UTF8.GetString(response);
                    }
                }
                catch (Exception ex)
                {
                    //SerilogLogger.LogErrorAsync(ex);
                }
            }
            else
            {
                isSuccess = false;
                statusMsg = "Send SMS not allowed for this distributor";
            }
            return isSuccess;
        }
        public static bool NotifyDitributor(string msg)
        {
            string statusMsg = "";
            if ((MasterData.Distributors != null) && (MasterData.Distributors.Data != null))
            {
                var superadmin = MasterData.Distributors.Data.Find(i => i.IsSuperAdmin);
                _superAdminMobiles = superadmin.Dist_Mobile_No + (!string.IsNullOrEmpty(superadmin.MobileNoToNotifyViaSms) ? ("," + superadmin.MobileNoToNotifyViaSms) : "");
            }
            else
            {
                _superAdminMobiles = MasterData.Configs.Data.Find(i => i.KeyText.Equals("SuperadminMobileNumber")).ValueText;
            }
            msg = "Hello " + RationCardUser.Name + " !" + Environment.NewLine + msg + Environment.NewLine + "- RationcardRegister";
            return SmsHelper.SendSms(msg, _superAdminMobiles + "," + RationCardUser.MobileNo + (!string.IsNullOrEmpty(RationCardUser.MobileNoToNotifyViaSms) ? ("," + RationCardUser.MobileNoToNotifyViaSms) : ""), out statusMsg);
        }
        public static bool NotifyAdmin(string msg)
        {
            string statusMsg = "";
            if ((MasterData.Distributors != null) && (MasterData.Distributors.Data != null))
            {
                var superadmin = MasterData.Distributors.Data.Find(i => i.IsSuperAdmin);
                _superAdminMobiles = superadmin.Dist_Mobile_No + (!string.IsNullOrEmpty(superadmin.MobileNoToNotifyViaSms) ? ("," + superadmin.MobileNoToNotifyViaSms) : "");
            }
            else
            {
                _superAdminMobiles = MasterData.Configs.Data.Find(i => i.KeyText.Equals("SuperadminMobileNumber")).ValueText;
            }
            msg = "Hello " + RationCardUser.Name + " !" + Environment.NewLine + msg + Environment.NewLine + "- RationcardRegister";
            return SmsHelper.SendSms(msg, _superAdminMobiles, out statusMsg);
        }
    }
}
