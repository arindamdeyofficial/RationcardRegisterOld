using BusinessObject.Interface;

namespace BusinessObject
{
    public class Customer: ICustomer
    {

        public string Customer_Id { get; set; }
        public string Name { get; set; }
        public string Hof_Flag { get; set; }
        public string Age { get; set; }
        public string Address { get; set; }
        public string RationCard_Id { get; set; }
        public string Hof_Id { get; set; }
        public string Hof_Name { get; set; }
        public string Dist_Id { get; set; }
        public string Adhar_No { get; set; }
        public string Relation_With_Hof { get; set; }
        public string Gaurdian_Name { get; set; }
        public string Mobile_No { get; set; }
        public bool ActiveCustomer { get; set; }
        public string Customer_Created_Date { get; set; }
    }
}
