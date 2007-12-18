/*
 * WfsUtil.java
 *
 * Created on 17 december 2007, 13:58
 *
 * Autor: Roy Braam
 */

package nl.b3p.gis.viewer.services;

import java.util.ArrayList;
import java.util.List;
import nl.b3p.gis.viewer.db.Connecties;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.ogc.utils.OGCConstants;
import nl.b3p.ogc.utils.OGCRequest;
import nl.b3p.ogc.utils.OgcWfsClient;
import nl.b3p.xml.wfs.WFS_Capabilities;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 *
 * @author Roy Braam
 */
public class WfsUtil {
    private static final Log log = LogFactory.getLog(WfsUtil.class);
    /** Creates a new instance of WfsUtil */
    public WfsUtil() {
    }
    public static ArrayList getFeatureNameList(WFS_Capabilities cap){                 
        if (cap==null)
            return null;
        nl.b3p.xml.wfs.FeatureTypeList ftl = cap.getFeatureTypeList();        
        ArrayList tns = null;
        if (ftl != null) {
            tns = new ArrayList();
            for (int i = 0; i < ftl.getFeatureTypeCount(); i++) {
                nl.b3p.xml.wfs.FeatureType ft = ftl.getFeatureType(i);
                if(ft.getName()!=null && ft.getName().length()>0){
                    tns.add(ft.getName());
                }
            }                        
        }        
        return tns;    
    }
    
    static public List getFeatureAttributes(Themas t, String version) throws Exception{
        ArrayList returnvalue=null;
        if (t.getConnectie()!=null && t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)){
            OGCRequest or = new OGCRequest(t.getConnectie().getConnectie_url());
            if (version!=null)
                or.addOrReplaceParameter(OGCRequest.WMS_VERSION,version);
            String dbtn = t.getAdmin_tabel();  
            if (dbtn==null)
                return null;
            or.addOrReplaceParameter(OGCRequest.WFS_PARAM_TYPENAME,dbtn);
            Element el=OgcWfsClient.getDescribeFeatureType(or);
            if (el==null)
                return null;
            NodeList nlist=el.getElementsByTagName("complexType");
            if (!(nlist.getLength()>0)){
                log.error("no complexType element found");
                return null;
            }
            NodeList nl=((Element)nlist.item(0)).getElementsByTagName("element");
            returnvalue = new ArrayList();
            for (int i=0; i < nl.getLength(); i++){
                Node n=nl.item(i);
                if (n.getLocalName()!=null && n.getLocalName().equalsIgnoreCase("element")){ 
                    Element e= (Element) n;
                    String name=e.getAttribute("name");
                    returnvalue.add(name);                    
                }
            }           
        }
        else{
            return null;
        }
        return returnvalue;
    }
}
