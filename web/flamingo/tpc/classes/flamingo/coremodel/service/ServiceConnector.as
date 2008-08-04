// This file is part of Flamingo MapComponents.
// Author: Michiel J. van Heek.

import flamingo.coremodel.service.*;

import flamingo.coremodel.service.wfs.WFSConnector;
import flamingo.event.ActionEvent;
import flamingo.event.ActionEventListener;
import flamingo.gismodel.Property;
import flamingo.gismodel.Feature;
import flamingo.geometrymodel.Envelope;
import flamingo.tools.XMLTools;

class flamingo.coremodel.service.ServiceConnector {
    
    static private var instances:Object = new Object(); // Associative array;
    
    static function getInstance(url):ServiceConnector {
        if (url == null) {
            _global.flamingo.tracer("Exception in WFSConnector.getInstance()\nNo url given.");
            return;
        }
        if (url.indexOf("::") == -1) {
            _global.flamingo.tracer("Exception in WFSConnector.getInstance()\nThe given url does not contain \"::\". Required format example: \"wfs::http://localhost:8080/\"");
            return;
        }
        
        var connectorType:String = url.split("::")[0];
        if (connectorType != "wfs") {
            _global.flamingo.tracer("Exception in WFSConnector.getInstance()\nThe given connector type \"" + connectorType + "\" is not supported.");
            return;
        }
        
        url = url.split("::")[1];
        if (instances[url] == null) {
            if (connectorType == "wfs") {
                instances[url] = new WFSConnector(url);
            }
        }
        return instances[url];
    }
    
    private var url:String = null;
    
    private function ServiceConnector(url:String) {
        this.url = url;
    }
    
    function getURL():String {
        return url;
    }
    
    function performDescribeFeatureType(featureTypeName:String, actionEventListener:ActionEventListener):Void { }
    
    function performGetFeature(serviceLayer:ServiceLayer, extent:Envelope, whereClauses:Array, notWhereClause:WhereClause, hitsOnly:Boolean, actionEventListener:ActionEventListener):Void { }
    
    function performTransaction(transaction:Transaction, actionEventListener:ActionEventListener):Void { }
    
    function request(url:String, requestString:String, processMethod:Function, serviceLayer:ServiceLayer, actionEventListener:ActionEventListener, tryIndex:Number):Void {
        var env:ServiceConnector = this;
        var responseXML:XML = new XML();
        responseXML.ignoreWhite = true;
        responseXML.onLoad = function(successful:Boolean):Void {
            if (!successful) {
                tryIndex++;
                if (tryIndex < 5) {
                    trace("Retrying for time number: " + tryIndex);
                    env.request(url, requestString, processMethod, serviceLayer, actionEventListener, tryIndex);
                } else {
                    trace("Giving up; no more tries.");
                }
            } else {
                var exceptionNode:XMLNode = null;
                var exceptionMessage:String = null;
                exceptionNode = XMLTools.getChild("Exception", this.firstChild);
                if (exceptionNode != null) {
                    exceptionMessage = "Exception in ServiceConnector.request(" + url + ")\n" + exceptionNode.firstChild.firstChild.nodeValue;
                }
                exceptionNode = XMLTools.getChild("ServiceException", this.firstChild);
                if (exceptionNode != null) {
                    exceptionMessage = "Kan de bewerkingen niet opslaan, om een of meer van de volgende redenen:\n\n-verplicht veld niet ingevuld\n-tekst in numeriek veld ingevuld\n-te lange tekst ingevuld\n\n" + url + "\n\n" + exceptionNode.firstChild.nodeValue;
                }
                
                if (actionEventListener != null) {
                    if (exceptionMessage == null) {
                        processMethod.call(env, this, serviceLayer, actionEventListener);
                    } else {
                        var actionEvent:ActionEvent = new ActionEvent(this, "ServiceConnector", ActionEvent.LOAD);
                        actionEvent["exceptionMessage"] = exceptionMessage;
                        actionEventListener.onActionEvent(actionEvent);
                    }
                }
            }
        }
        
        if (requestString == null) {
            responseXML.load(url);
        } else {
            var requestXML:XML = new XML(requestString);
            //requestXML.xmlDecl = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
            //requestXML.addRequestHeader("Content-Type", "text/xml");	
			requestXML.contentType="text/xml";
            //requestXML.addRequestHeader("Accept", "text/xml");
            requestXML.sendAndLoad(url, responseXML);
        }
    }
    
    function processDescribeFeatureType(responseXML:XML, serviceLayer:ServiceLayer, actionEventListener:ActionEventListener):Void { }
    
    function processGetFeature(responseXML:XML, serviceLayer:ServiceLayer, actionEventListener:ActionEventListener):Void { }
    
    function processTransaction(responseXML:XML, serviceLayer:ServiceLayer, actionEventListener:ActionEventListener):Void { }
    
}
