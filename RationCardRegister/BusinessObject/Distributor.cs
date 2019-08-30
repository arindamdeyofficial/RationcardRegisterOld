namespace BusinessObject
{
    public class Distributor
    {
        public string Dist_Id { get; set; }
        public string Dist_Name { get; set; }
        public string Dist_Mobile_No { get; set; }
        public string MobileNoToNotifyViaSms { get; set; }
        public string EmailToNotify { get; set; }
        public string Dist_Address { get; set; }
        public string Dist_Email { get; set; }
        public string Dist_Profile_Pic_Path { get; set; }
        public string Dist_Login { get; set; }
        public string Dist_Password { get; set; }
        public string Dist_Backdoor { get; set; }
        public string Dist_Mac_Check { get; set; }
        public string Dist_Allowed_Mac_Id { get; set; }
        public string Dist_Locked { get; set; }
        public string Dist_Fps_Code { get; set; }
        public string Dist_Fps_Liscence_No { get; set; }
        public string Dist_Mr_Shop_No { get; set; }
        public bool IsSuperAdmin { get; set; }
        public string Active { get; set; }
        public string Created_Date { get; set; }
    }
}
