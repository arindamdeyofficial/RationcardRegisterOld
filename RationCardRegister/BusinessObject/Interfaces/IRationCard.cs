namespace BusinessObject.Interface
{
    interface IRationCard : ICustomer, ICategory
    {
        string RationCard_Id { get; set; }
        string Number { get; set; }
        string Card_Category_Id { get; set; }
        string Remarks { get; set; }
        bool ActiveCard { get; set; }
        string Card_Created_Date { get; set; }
    }
}
