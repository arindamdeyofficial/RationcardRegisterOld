
namespace BusinessObjects
{
    public class Result
    {
        public Address_Components[] address_components { get; set; }
        public string formatted_address { get; set; }
        public Geometry geometry { get; set; }
        public string place_id { get; set; }
        public Plus_Code1 plus_code { get; set; }
        public string[] types { get; set; }
    }
}
