// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.coremodel.service.wfs.*;

import flamingo.coremodel.service.*;

import mx.xpath.XPathAPI;

class flamingo.coremodel.service.wfs.FeatureType extends ServiceLayer {
    
    private var namespacePrefix:String = "app";
    
    function FeatureType(rootNode:XMLNode) {
        var firstElementNode:XMLNode = XPathAPI.selectSingleNode(rootNode, "/xsd:schema/xsd:element");
        if (firstElementNode == null) {
            _global.flamingo.tracer("Exception in flamingo.coremodel.FeatureType.<<init>>: The featuretype schema cannot be parsed. The namespace prefix must be \"xsd\".\n" + rootNode);
            return;
        }
        name = firstElementNode.attributes["name"];
        if (name == null) {
            _global.flamingo.tracer("Exception in flamingo.coremodel.FeatureType.<<init>>: The featuretype has no name.\n" + firstElementNode);
            return;
        }
        name = namespacePrefix + ":" + name;
        
        var type:String = firstElementNode.attributes["type"].split(":")[1];
        var complexTypeNode:XMLNode = XPathAPI.selectSingleNode(rootNode, "/xsd:schema/xsd:complexType[@name=" + type + "]");
        var propertyNodes:Array = XPathAPI.selectNodeList(complexTypeNode, "/xsd:complexType/xsd:complexContent/xsd:extension/xsd:sequence/xsd:element");
        var property:WFSProperty = null;
        serviceProperties = new Array();
        geometryProperties = new Array();
        for (var i:Number = 0; i < propertyNodes.length; i++) {
            property = new WFSProperty(XMLNode(propertyNodes[i]), namespacePrefix);
            serviceProperties.push(property);
            if (property.getType() == "gml:GeometryPropertyType") {
                geometryProperties.push(property);
            }
        }
        
        if (serviceProperties.length == 0) {
            _global.flamingo.tracer("Exception in flamingo.coremodel.FeatureType.<<init>>: The featuretype \"" + name + "\" has no properties.");
            return;
        }
        if (geometryProperties.length == 0) {
            _global.flamingo.tracer("Exception in flamingo.coremodel.FeatureType.<<init>>: The featuretype \"" + name + "\" has no geometry property.");
            return;
        }
    }
    
    function getNamespace():String {
        return "app=\"http://www.deegree.org/app\"";
    }
    
    function getServiceFeatureFactory():ServiceFeatureFactory {
        return new WFSFeatureFactory();
    }
    
    function toString():String {
        return "FeatureType(" + name + ")";
    }
    
}
