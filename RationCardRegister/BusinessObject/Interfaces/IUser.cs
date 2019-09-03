namespace BusinessObject.Interface
{
    interface IUser
    {
        string LoginId { get; set; }
        string EmailId { get; set; }
        string MacId { get; set; }
        string AllowedMacId { get; set; }
        string Name { get; set; }
        string MobileNo { get; set; }
        string DistId { get; set; }
        string Address { get; set; }
        string ProfilePicPath { get; set; }
        string RoleId { get; set; }
    }
}
