using LogManager;
using System;
using System.IO;
using System.Xml;
using System.Xml.Serialization;

namespace Helpers
{
    public static class XmlHelper
    {
        public static string SerializeXml<T>(this T value)
        {
            var stringWriter = new StringWriter();
            if (value == null)
            {
                return string.Empty;
            }
            try
            {
                var xmlserializer = new XmlSerializer(typeof(T));                
                using (var writer = XmlWriter.Create(stringWriter))
                {
                    xmlserializer.Serialize(writer, value);                    
                }
            }
            catch (Exception ex)
            {
                Logger.LogError(ex);
            }
            return stringWriter.ToString();
        }
    }
    public class NoNamespaceXmlWriter : XmlTextWriter
    {
        //Provide as many contructors as you need
        public NoNamespaceXmlWriter(System.IO.TextWriter output)
            : base(output) { Formatting = System.Xml.Formatting.Indented; }

        public override void WriteStartDocument() { }

        public override void WriteStartElement(string prefix, string localName, string ns)
        {
            base.WriteStartElement("", localName, "");
        }
    }
}
