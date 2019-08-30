using System;

namespace Helpers
{
    public static class TimeStampHelper
    {
        public static string GetDateTimeStamp()
        {
            var dtTime = DateTime.Now;
            return GetDateStamp() + GetTimeStamp();
        }
        public static string GetDateStamp()
        {
            var dtTime = DateTime.Now;
            return dtTime.Year.ToString() + dtTime.Month.ToString() + dtTime.Day.ToString();
        }
        public static string GetTimeStamp()
        {
            var dtTime = DateTime.Now;
            return dtTime.Hour.ToString() + dtTime.Minute.ToString()
                            + dtTime.Second.ToString() + dtTime.Millisecond.ToString();
        }
        public static int GetFortNight(DateTime dt, int fortNightDevideDay)
        {
            int fortnight = 0;
            try
            {
                //int fortNightDevideDay = int.Parse(ConfigManager.GetConfigValue("FortNightDevideDay"));
                fortnight = (dt.Day <= fortNightDevideDay) ? 1 : 2;
            }
            catch (Exception ex)
            {
                //Logger.LogError(ex);
            }
            return fortnight;
        }

        public static int GetFortNight(string dt, int fortNightDevideDay)
        {
            int fortnight = 0;
            try
            {
                fortnight = GetFortNight(DateTime.ParseExact(dt, "MM-dd-yyyy HH:mm:ss", null), fortNightDevideDay);
            }
            catch (Exception ex)
            {
                //Logger.LogError(ex);
            }
            return fortnight;
        }

        public static string GetFortNightString(string dt, int fortNightDevideDay)
        {
            string fortnight = "";
            if(GetFortNight(dt, fortNightDevideDay) == 1)
            {
                fortnight = "1st Fortnight";
            }
            else
            {
                fortnight = "2nd Fortnight";
            }
            return fortnight;
        }

        public static DateTime GetBackDateByMonth(int month)
        {
            return DateTime.Now.AddMonths(-month);
        }
    }
}
