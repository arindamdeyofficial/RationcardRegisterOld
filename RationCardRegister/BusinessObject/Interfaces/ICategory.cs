namespace BusinessObject.Interface
{
    interface ICategory
    {
        string Cat_Id { get; set; }
        string Cat_Key { get; set; }
        string Cat_Desc { get; set; }
        string CardCount { get; set; }
        string FamilyCount { get; set; }
    }
}
