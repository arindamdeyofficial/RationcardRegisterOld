using BusinessObject.Interface;

namespace BusinessObject
{
    public class RationCardDetail: IRationCard
    {
        public int SlNo { get; set; }
        public string RationCard_Id { get; set; }
        public string Number { get; set; }
        public string Card_Category_Id { get; set; }
        public string Remarks { get; set; }
        public bool ActiveCard { get; set; }
        public string CardStatus { get; set; }
        public string Card_Created_Date { get; set; }
        public string Customer_Created_Date { get; set; }
        public string Customer_Id { get; set; }
        public string Name { get; set; }
        public string Hof_Flag { get; set; }
        public string Age { get; set; }
        public string Address { get; set; }
        public string Hof_Id { get; set; }
        public string Hof_Name { get; set; }
        public string Dist_Id { get; set; }
        public string Adhar_No { get; set; }
        public string Relation_With_Hof { get; set; }
        public string Gaurdian_Relation { get; set; }
        public string Gaurdian_Name { get; set; }
        public string Mobile_No { get; set; }
        public bool ActiveCustomer { get; set; }
        public string Cat_Id { get; set; }
        public string Cat_Key { get; set; }
        public string Cat_Desc { get; set; }
        public string CardCount { get; set; }
        public string FamilyCount { get; set; }
    }
}
