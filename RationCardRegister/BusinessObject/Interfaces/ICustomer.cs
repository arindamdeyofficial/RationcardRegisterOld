namespace BusinessObject.Interface
{
    interface ICustomer
    {
        string Customer_Id { get; set; }
        string Name { get; set; }
        string Hof_Flag { get; set; }
        string Age { get; set; }
        string Address { get; set; }
        string Hof_Id { get; set; }
        string Hof_Name { get; set; }
        string Dist_Id { get; set; }
        string Adhar_No { get; set; }
        string Relation_With_Hof { get; set; }
        string Gaurdian_Name { get; set; }
        string Mobile_No { get; set; }
        bool ActiveCustomer { get; set; }
        string Customer_Created_Date { get; set; }
    }
}
