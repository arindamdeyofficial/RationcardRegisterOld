using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class Bill
    {
        [XmlAttribute]
        public string Bill_Id_Identity { get; set; }
        [XmlAttribute]
        public string PrdDefaultQuantitySummary { get; set; }
        [XmlAttribute]
        public string BillSerialNumber { get; set; }
        [XmlAttribute]
        public string BillNumber { get; set; }
        [XmlAttribute]
        public int Fortnight { get; set; }
        [XmlAttribute]
        public int TotalCardServed { get; set; }
        [XmlAttribute]
        public string RationcardNumbers { get; set; }
        [XmlElement]
        public List<BillDetails> BillDetails { get; set; }

        [XmlAttribute]
        public float TotalPrice { get; set; }
        [XmlAttribute]
        public float TotalRoundedOff { get; set; }
        [XmlAttribute]
        public float TotalDiscount { get; set; }
        [XmlAttribute]
        public float CustomerPaid { get; set; }
        [XmlAttribute]
        public float BalanceReturn { get; set; }
        [XmlAttribute]
        public string CreatedDate { get; set; }
    }
}
