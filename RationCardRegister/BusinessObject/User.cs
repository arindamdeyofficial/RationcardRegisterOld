using System.Collections.Generic;

namespace BusinessObject
{
    public static class User
    {
        public static string LoginId { get; set; }
        public static string EmailId { get; set; }
        public static string Password { get; set; }
        public static string MacId { get; set; }
        public static string AllowedMacId { get; set; }
        public static string Name { get; set; }
        public static string MobileNo { get; set; }
        public static string MobileNoToNotifyViaSms { get; set; }
        public static string EmailToNotify { get; set; }
        public static string DistId { get; set; }
        public static string Address { get; set; }
        public static string ProfilePicPath { get; set; }
        public static List<Role> Roles { get; set; }
        public static bool IsSuperadmin { get; set; }
        public static string LiscenceNo { get; set; }
        public static string MrShopNo { get; set; }
        public static string FpsCode { get; set; }        
    }
}
