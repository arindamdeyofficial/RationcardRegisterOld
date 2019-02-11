
namespace BusinessObjects
{
    public class Address
    {
        public string formatted_address { get; set; }
        public string street_number { get; set; }
        public string locality { get; set; }
        public string country { get; set; }
        public string postal_code { get; set; }
        public string lattitude { get; set; }
        public string longitude { get; set; }
        public string accuracy { get; set; }
    }
}
