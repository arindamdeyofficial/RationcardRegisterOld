using System;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class ProductMcMaster
    {
        [XmlAttribute]
        public string ProductMcMasterId { get; set; }
        [XmlAttribute]
        public string ProductMcMasterCode { get; set; }
        [XmlAttribute]
        public string ProductSubClassMasterId { get; set; }
        [XmlAttribute]
        public string ProductClassMasterId { get; set; }
        [XmlAttribute]
        public string ProductDeptMasterId { get; set; }
        [XmlAttribute]
        public string ProductSubDeptMasterId { get; set; }
        [XmlAttribute]
        public string ProductMcMasterDesc { get; set; }
    }
}
