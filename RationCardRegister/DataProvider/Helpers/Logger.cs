using CustomLogger;
using EmailManager;
using SmsManager;
using System;
using System.Collections.Generic;

namespace LogManager
{
    public static class Logger
    {
        // Create Logger
        private static Dictionary<string, string> _errorLogsForDb = new Dictionary<string, string>();
        private static int _period = 5000;

        public static void LogError(Exception ex, string additionalMsg = "", bool notifyDistributor = false)
        {
            string msgToLogShort = ex.Message + Environment.NewLine + additionalMsg;
            string msgToLogLong = "Message: " + ex.Message + "InnerException: " + ex.InnerException + "StackTrace: " + ex.StackTrace + Environment.NewLine + additionalMsg;

            SerilogLogger.LogErrorAsync(msgToLogLong);
            SmsHelper.NotifyAdmin(msgToLogShort);
            if (notifyDistributor)
            {
                SmsHelper.NotifyDitributor(msgToLogShort);
            }
            EmailHelper.SendErrorMail(msgToLogLong);
        }     
        public static void LogError(string ex, bool notifyDistributor = false)
        {
            string msgToLogLong = "Message: " + ex;

            SerilogLogger.LogErrorAsync(msgToLogLong);
            SmsHelper.NotifyAdmin(msgToLogLong);
            if(notifyDistributor)
            {
                SmsHelper.NotifyDitributor(msgToLogLong);
            }
            EmailHelper.SendErrorMail(msgToLogLong);
        }
        public static void LogInfo(string ex)
        {
            SerilogLogger.LogInfoAsync(ex);
        }
    }
}
