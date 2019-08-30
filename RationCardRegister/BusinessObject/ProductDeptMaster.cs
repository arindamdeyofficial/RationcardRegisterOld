using System.Xml.Serialization;

namespace BusinessObject
{
    public class ProductDeptMaster
    {
        [XmlAttribute]
        public string ProductDeptMasterId { get; set; }
        [XmlAttribute]
        public string ProductDeptMasterDesc { get; set; }
    }
}
