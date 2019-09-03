using System;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class ProductBrandMaster
    {
        [XmlAttribute]
        public string ProductBrandMasterId { get; set; }
        [XmlAttribute]
        public string ProductBrandMasterDesc { get; set; }
        [XmlAttribute]
        public string ProductMcMasterId { get; set; }
        [XmlAttribute]
        public string ProductSubClassMasterId { get; set; }
        [XmlAttribute]
        public string ProductClassMasterId { get; set; }
        [XmlAttribute]
        public string ProductDeptMasterId { get; set; }
        [XmlAttribute]
        public string ProductSubDeptMasterId { get; set; }
        [XmlAttribute]
        public string ProductBrandMasterCompanyDesc { get; set; }
    }
}
