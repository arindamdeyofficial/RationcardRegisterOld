using System;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class ProductQuantityMaster
    {
        [XmlAttribute]
        public string Product_Quantity_Master_Identity { get; set; }
        [XmlIgnore]
        public int ProductQuantityIdentityUi { get; set; }
        [XmlAttribute]
        public string ProductId { get; set; }
        [XmlElement]
        public Category CategoryDetails { get; set; }
        [XmlAttribute]
        public float DefaultQuantityInBaseUom { get; set; }
        [XmlAttribute]
        public bool IsQuantityForFamily { get; set; }
        [XmlAttribute]
        public bool Active { get; set; }
        [XmlIgnore]
        public string PrdQuantityListDisplay
        {
            get
            {
                string cat = "";
                if(CategoryDetails != null)
                {
                    cat = CategoryDetails.Cat_Desc;
                }
                return string.Concat(cat, " || ", DefaultQuantityInBaseUom, " || ", IsQuantityForFamily);
            }
          }
    }
}
