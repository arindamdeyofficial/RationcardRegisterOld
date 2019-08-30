using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class ProductMaster
    {
        [XmlAttribute]
        public string Product_Master_Identity { get; set; }
        [XmlAttribute]
        public string Name { get; set; }
        [XmlAttribute]
        public string BarCode { get; set; }
        [XmlAttribute]
        public string ArticleCode { get; set; }
        [XmlAttribute]
        public string ProdDescription { get; set; }
        [XmlAttribute]
        public bool Active { get; set; }
        [XmlElement]
        public Uom BaseUom { get; set; }
        [XmlArray]
        public List<Uom> AllUom { get; set; }
        [XmlArray]
        public List<ProductQuantityMaster> PrdQuantityAllocated { get; set; }
        [XmlAttribute]
        public bool IsDefaultProduct { get; set; }
        [XmlAttribute]
        public bool IsDefaultGiveRation { get; set; }
        [XmlElement]
        public ProductDeptMaster ProductDept { get; set; }
        [XmlElement]
        public ProductSubDeptMaster ProductSubDept { get; set; }
        [XmlElement]
        public ProductClassMaster ProductClass { get; set; }
        [XmlElement]
        public ProductSubClassMaster ProductSubClass { get; set; }
        [XmlElement]
        public ProductMcMaster ProductMc { get; set; }
        [XmlElement]
        public ProductBrandMaster ProductBrand { get; set; }
    }
}
