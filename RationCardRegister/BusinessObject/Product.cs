using System;
using System.Collections.Generic;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class Product: ProductMaster
    {
        [XmlElement]
        public Uom UnitOfMeasureDetail { get; set; }
        [XmlIgnore]
        public string UnitOfMeasure { get; set; }
        [XmlAttribute]
        public float ConsumptionQuantity { get; set; }
        [XmlIgnore]
        public string ConsumptionQuantityToDisplay
        {
            get
            {
                if (UnitOfMeasure != null)
                    return string.Concat(ConsumptionQuantity, " ", UnitOfMeasureDetail.UOMName.Substring(0, 2));
                else
                    return "";
            }
            set { ConsumptionQuantityToDisplay = value; }
        }
        [XmlAttribute]
        public float SellingRateInBaseUom { get; set; }
        [XmlAttribute]
        public float BuyingRateInBaseUom { get; set; }
        [XmlAttribute]
        public float MrpRateInBaseUom { get; set; }
        [XmlIgnore]
        public float SellingRateInCurrentUom { get
            {
                if (UnitOfMeasure != null)
                    return CalculateCurrentUomRate(SellingRateInBaseUom, UnitOfMeasureDetail.ConversionFactorWithBaseUom);
                else
                    return 0;
            }
            set { SellingRateInCurrentUom = value; } }
        [XmlIgnore]
        public string SellingRateInCurrentUomDisplay { get
            {
                if (UnitOfMeasure != null)
                    return SellingRateInCurrentUom.ToString() + " Rs/" + UnitOfMeasureDetail.UOMName.Substring(0, 2);
                else
                    return "";
            }
            set { SellingRateInCurrentUomDisplay = value; } }
        [XmlIgnore]
        public float BuyingRateInCurrentUom
        {
            get
            {
                if (UnitOfMeasure != null)
                    return CalculateCurrentUomRate(BuyingRateInBaseUom, UnitOfMeasureDetail.ConversionFactorWithBaseUom);
                else
                    return 0;
            }
            set { BuyingRateInCurrentUom = value; }
        }
        [XmlIgnore]
        public string BuyingRateInCurrentUomDisplay
        {
            get
            {
                if (UnitOfMeasure != null)
                    return BuyingRateInCurrentUom.ToString() + " Rs/" + UnitOfMeasureDetail.UOMName.Substring(0, 2);
                else
                    return "";
            }
            set { BuyingRateInCurrentUomDisplay = value; }
        }
        [XmlIgnore]
        public float MrpRateInCurrentUom
        {
            get
            {
                if (UnitOfMeasure != null)
                    return CalculateCurrentUomRate(MrpRateInBaseUom, UnitOfMeasureDetail.ConversionFactorWithBaseUom);
                else
                    return 0;
            }
            set { MrpRateInCurrentUom = value; }
        }
        [XmlIgnore]
        public string MrpRateInCurrentUomDisplay
        {
            get
            {
                if (UnitOfMeasure != null)
                    return MrpRateInCurrentUom.ToString() + " Rs/" + UnitOfMeasureDetail.UOMName.Substring(0, 2);
                else
                    return "";
            }
            set { MrpRateInCurrentUomDisplay = value; }
        }
        [XmlIgnore]
        public float Discount
        {
            get
            {
                return Total - Price;
            }
        }
        [XmlIgnore]
        public string DiscountToDisplay
        {
            get
            {
                if (UnitOfMeasure != null)
                    return Discount.ToString() + " Rs/" + UnitOfMeasureDetail.UOMName.Substring(0, 2);
                else
                    return "";
            }
        }

        [XmlIgnore]
        public float Total
        {
            get
            {
                return MrpRateInCurrentUom * ConsumptionQuantity;
            }
        }
        [XmlIgnore]
        public string TotalToDisplay
        {
            get
            {
                if (UnitOfMeasure != null)
                    return Total.ToString() + " Rs/" + UnitOfMeasureDetail.UOMName.Substring(0, 2);
                else
                    return "";
            }
        }
        [XmlIgnore]
        public float Price
        {
            get
            {
                return SellingRateInCurrentUom * ConsumptionQuantity;
            }
        }
        [XmlIgnore]
        public string PriceToDisplay
        {
            get
            {
                if (UnitOfMeasure != null)
                    return Price.ToString() + " Rs/" + UnitOfMeasureDetail.UOMName.Substring(0, 2);
                else
                    return "";
            }
        }
        [XmlElement]
        public List<ProductStock> StockInBaseUom { get; set; }
        private float CalculateCurrentUomRate(float rateInBaseUom, float conversionFactor)
        {
            //Here one can apply promotion and offer
            return rateInBaseUom * conversionFactor;
        }
    }
}
