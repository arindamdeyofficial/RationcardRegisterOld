using BusinessObject;
using Serilog;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CustomLogger
{
    public static class SerilogLogger
    {
        static List<Task> _errLogingTask = new List<Task>();
        static List<Task> _infoLogingTask = new List<Task>();
        static SerilogLogger()
        {
            try
            {
                Log.Logger = new LoggerConfiguration()
                    .WriteTo.Console()
                    .WriteTo.MongoDB("mongodb://logUser:Nakshal%2101051987@azuremongobiplabhomecloud-shard-00-00-0ncjk.azure.mongodb.net:27017,azuremongobiplabhomecloud-shard-00-01-0ncjk.azure.mongodb.net:27017,azuremongobiplabhomecloud-shard-00-02-0ncjk.azure.mongodb.net:27017/biplabhomeLogDb?ssl=true&replicaSet=AzureMongobiplabhomeCloud-shard-0&authSource=admin&retryWrites=true&w=majority"
                    , "RationCardRegisterLogs")
                    //.WriteTo.File("RationCardegisterLog-.txt", fileSizeLimitBytes: 4000000, rollOnFileSizeLimit: true, rollingInterval: RollingInterval.Day) //size in bytes
                    .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj}{NewLine}{Exception}")
                    .WriteTo.ColoredConsole(outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj}{NewLine}{Exception}")
                    //.WriteTo.Email("biplabhome@gmail.com", "jayanta98314@gmail.com"
                    //, outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj}{NewLine}{Exception}"
                    //, mailSubject: string.Format("RationCardRegister Error {0}", DateTime.Now)
                    //)
                    .CreateLogger();

            }
            catch (Exception ex)
            {

            }
        }
        public static void LogErrorAsync(Exception ex)
        {
            _errLogingTask.Add(Task.Factory.StartNew(() => LogError(ex)));
        }
        public static void LogErrorAsync(string errMsg)
        {
            _errLogingTask.Add(Task.Factory.StartNew(() => LogError(errMsg)));
        }
        public static void LogInfoAsync(string msg)
        {
            _infoLogingTask.Add(Task.Factory.StartNew(() => LogInfo(msg)));
        }
        public static void LogError(Exception ex)
        {
            Log.Error(ex, "Distributor: {0}", RationCardUser.Name);
        }
        public static void LogError(string errMsg)
        {
            Log.Error("Distributor: {0} Error: {1}", RationCardUser.Name, errMsg);
        }
        public static void LogInfo(string msg)
        {
            Log.Information("Distributor: {0} Info: {1}", RationCardUser.Name, msg);
        }
    }
}
