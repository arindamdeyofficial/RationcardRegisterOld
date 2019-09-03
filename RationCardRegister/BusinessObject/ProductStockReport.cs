using System;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class ProductStockReport
    {
        [XmlAttribute]
        public string Product_Stock_Report_Identity { get; set; }
        [XmlAttribute]
        public string Prod_Id { get; set; }
        [XmlIgnore]
        public string ProdName { get; set; }
        [XmlAttribute]
        public string Dist_Id { get; set; }
        [XmlAttribute]
        public string Cat_Id { get; set; }
        [XmlIgnore]
        public string Cat_Desc { get; set; }
        [XmlAttribute]
        public string UOM_Id { get; set; }
        [XmlAttribute]
        public string OpenningBalance { get; set; }
        [XmlAttribute]
        public string StockRecieved { get; set; }
        [XmlAttribute]
        public string TotalStock { get; set; }
        [XmlAttribute]
        public string StockSold { get; set; }
        [XmlIgnore]
        public string HandlingLoss { get; set; }
        [XmlAttribute]
        public string ClosingBalance { get; set; }
        [XmlAttribute]
        public string Created_Date { get; set; }
    }
}
