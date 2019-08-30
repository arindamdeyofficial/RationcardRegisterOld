using BusinessObject.Interface;
using System;
using System.Xml.Serialization;

namespace BusinessObject
{
    [Serializable]
    public class Category: ICategory
    {
        [XmlAttribute]
        public string Cat_Id { get; set; }
        [XmlAttribute]
        public string Cat_Key { get; set; }
        [XmlAttribute]
        public string Cat_Desc { get; set; }
        [XmlAttribute]
        public string CardCount { get; set; }
        [XmlAttribute]
        public string FamilyCount { get; set; }
    }
}
