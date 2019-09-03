using System;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class Uom
    {
        [XmlAttribute]
        public string ProdId { get; set; }
        [XmlAttribute]
        public string UOMName { get; set; }
        [XmlAttribute]
        public bool IsBaseUom { get; set; }
        [XmlAttribute]
        public string UOMType { get; set; }
        [XmlAttribute]
        public string Active { get; set; }
        [XmlAttribute]
        public string UOM_Id_Identity { get; set; }
        [XmlAttribute]
        public float ConversionFactorWithBaseUom { get; set; }
        [XmlIgnore]
        public string UomDisplay { get
            {
                return string.Concat(UOMType + " || "
                + UOMName + " || "
                + IsBaseUom + " || "
                + ConversionFactorWithBaseUom);
            }
        }
    }
}
