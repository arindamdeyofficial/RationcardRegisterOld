using System;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class ProductStock
    {
        [XmlIgnore]
        public int Product_Stock_Id_Ui { get; set; }
        [XmlAttribute]
        public string Product_Stock_Identity { get; set; }
        [XmlAttribute]
        public string Prod_Id { get; set; }
        [XmlElement]
        public Category CategoryDetails { get; set; }
        [XmlElement]
        public Uom StockUom { get; set; }
        [XmlAttribute]
        public float ProdQuantity { get; set; }
        [XmlAttribute]
        public float AllowedDamageQuantityPerUnit { get; set; }
        [XmlAttribute]
        public float TotalAllowedDamageQuantity { get; set; }
        [XmlAttribute]
        public float TotalDamageQuantityInReal { get; set; }
        [XmlAttribute]
        public string StockEntryTime { get; set; }
        [XmlIgnore]
        public DateTime StockEntryTimeInDateFormat { get; set; }
        [XmlAttribute]
        public StockEntryMode EntryMode { get; set; }
        [XmlAttribute]
        public bool IsStockIn { get; set; }
        [XmlIgnore]
        public string CategoryDesc
        { 
            get
            {
                string toRet = "";
                if (CategoryDetails != null)
                {
                    toRet = CategoryDetails.Cat_Desc;
                }
                else
                {
                    toRet = "";
                }
                return toRet;
            }
        }

        [XmlIgnore]
        public string UomDesc
        {
            get
            {
                string toRet = "";
                if (StockUom != null)
                {
                    toRet = StockUom.UOMName;
                }
                else
                {
                    toRet = "";
                }
                return toRet;
            }
        }

        [XmlIgnore]
        public string StockToShow
        { get

            {
                string toRet = "";
                if(CategoryDetails != null)
                {
                    toRet = CategoryDetails.Cat_Desc + " || Quantity: " + ProdQuantity + " || Damages:- PerUnit: " + AllowedDamageQuantityPerUnit
                        + " || Total: " + TotalAllowedDamageQuantity + " || InReal: " + TotalDamageQuantityInReal;
                }
                else
                {
                    toRet = " || Quantity: " + ProdQuantity + " || Damages:- PerUnit: " + AllowedDamageQuantityPerUnit
                        + " || Total: " + TotalAllowedDamageQuantity + " || InReal: " + TotalDamageQuantityInReal;
                }
                return toRet;
            }
        }
    }
    public enum StockEntryMode
    {
        EDITSTOCK,ADDSTOCK,NONE
    }
}
