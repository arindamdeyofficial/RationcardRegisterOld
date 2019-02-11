using System;
using BusinessObjects;
using BusinessObjects.Common;
using Serilog;

namespace Helper
{
    public static class LoggerHelper
    {
        static LoggerHelper()
        {
            Log.Logger = new LoggerConfiguration()
                    .MinimumLevel.Information()
                    .Enrich.With(new SeriloggerThreadIdEnricher())
                    .WriteTo.File("logs\\myapp.txt"                    
                        , outputTemplate: Environment.NewLine 
                                + "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level}] ({ThreadId}) {Message}{NewLine}{Exception}"
                        , rollingInterval: RollingInterval.Day)
                    .WriteTo.MongoDB("mongodb+srv://logUser:Nakshal!01051987@azuremongobiplabhomecloud-0ncjk.azure.mongodb.net/test?retryWrites=true", period: TimeSpan.Zero)
                    .CreateLogger();
                //Mongodb query selector
                //https://docs.mongodb.com/manual/reference/operator/query/?_ga=2.247431684.180059386.1533270388-449267180.1532931380

        }

        public static void LogError(string exMsg)
        {
            LogEntry logObj = new LogEntry
            {
                Date = DateTime.Now.ToString(),
                LogType = LogTypeEnum.ErrorLog,
                Text = exMsg
            };
            Log.Error(exMsg, "Error Log for {0}", UserDetails.UserName);
        }
        public static void LogError(Exception ex)
        {
            LogEntry logObj = new LogEntry
            {
                Date = DateTime.Now.ToString()
                , LogType=LogTypeEnum.ErrorLog
                , Text=ex.Message
                , Stacktrace=ex.StackTrace
                , InnerException=ex.InnerException ? .Message
            };
            Log.Error(ex, "Error Log for {0}", UserDetails.UserName);
            //MongoDbHelper.InsertLog(logObj);
        }
        public static void LogInfo(string msg)
        {
            Log.Information(msg, "Info Log for {0}", UserDetails.UserName);
        }
    }
}
