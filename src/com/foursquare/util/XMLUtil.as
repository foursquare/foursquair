package com.foursquare.util{
	import mx.rpc.xml.SimpleXMLDecoder;
    import mx.rpc.xml.SimpleXMLEncoder;
    import flash.xml.XMLDocument;
    import flash.xml.XMLNode;
            
    public class XMLUtil{
        public function XMLUtil(){}	
        public static function objectToXML(obj:Object):XML {
            var qName:QName = new QName("foursquare");
            var xmlDocument:XMLDocument = new XMLDocument();
            var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
            var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
            var xml:XML = new XML(xmlDocument.toString());
            return xml;
        }
            
        public static function XMLToObject(xmlStr:String):Object{
            var xmlDoc:XMLDocument = new XMLDocument(xmlStr);
            var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
            return decoder.decodeXML(xmlDoc);
        }
    }	
}