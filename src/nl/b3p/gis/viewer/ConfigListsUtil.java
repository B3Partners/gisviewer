/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package nl.b3p.gis.viewer;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import nl.b3p.gis.viewer.db.Connecties;
import nl.b3p.gis.viewer.services.GisPrincipal;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.gis.viewer.services.WfsUtil;
import nl.b3p.xml.wfs.WFS_Capabilities;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.w3c.dom.Element;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;

/**
 *
 * @author Roy
 */
public class ConfigListsUtil {
    private static final Log log = LogFactory.getLog(ConfigListsUtil.class);

    public static List getPossibleFeaturesById(Integer connId){
        List returnValue = null;
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        try{
            sess.beginTransaction();
            Connecties c=null;
            if (connId!=null){
                c = (Connecties) sess.get(Connecties.class, connId);
            }else{
                WebContext ctx = WebContextFactory.get();
                HttpServletRequest request = ctx.getHttpServletRequest();
                GisPrincipal user = GisPrincipal.getGisPrincipal(request);
                c= user.getKbWfsConnectie();
            }
            if (c!=null)
                returnValue= getPossibleFeatures(c);
        }catch (Exception e){
            log.error("getPossibleFeaturesById error: ",e);
        }finally{
            sess.close();
        }
        return returnValue;
    }

    public static List getPossibleAttributesById(Integer connId, String feature){
        List returnValue = null;
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        try{
            sess.beginTransaction();
            Connecties c=null;
            if (connId!=null){
                c = (Connecties) sess.get(Connecties.class, connId);
            }else{
                WebContext ctx = WebContextFactory.get();
                HttpServletRequest request = ctx.getHttpServletRequest();
                GisPrincipal user = GisPrincipal.getGisPrincipal(request);
                c= user.getKbWfsConnectie();
            }
            if (c!=null)
                returnValue= getPossibleAttributes(c,feature);
        }catch (Exception e){
            log.error("getPossibleAttributesById error: ",e);
        }finally{
            sess.close();
        }
        return returnValue;
    }
    /**
     * Maakt een lijst met mogelijke features voor de gegeven connectie en gebruiker
     * Zowel jdbc en wfs
     */
    public static List getPossibleFeatures(Connecties c) throws Exception{
        if (SpatialUtil.validJDBCConnection(c)) {
            Connection conn=null;
            List returnValue=null;
            try{
                conn = c.getJdbcConnection();
                returnValue=SpatialUtil.getTableNames(conn);
            }finally{
                if (conn!=null)
                    conn.close();
            }
            return returnValue;
        }else if (WfsUtil.validWfsConnection(c)) {
            WFS_Capabilities cap = WfsUtil.getCapabilities(c);
            return WfsUtil.getFeatureNameList(cap);
        }else{
            return null;
        }
    }
    /**
     * Maakt een lijst met mogelijke attributen van een meegegeven feature.
     * Zowel jdbc en wfs
     */
    public static List getPossibleAttributes(Connecties c, String feature) throws Exception {
        if (feature == null) {
            return null;
        }else if (SpatialUtil.validJDBCConnection(c)) {
            Connection conn=null;
            List returnValue=null;
            try{
                conn = c.getJdbcConnection();
                returnValue=SpatialUtil.getColumnNames(feature, conn);
            }finally{
                if (conn!=null)
                    conn.close();
            }
            return returnValue;
        }else if (WfsUtil.validWfsConnection(c)) {
            List elements = WfsUtil.getFeatureElements(c, feature);
            if (elements == null) {
                return null;
            }
            ArrayList elementsNames = new ArrayList();
            for (int i = 0; i < elements.size(); i++) {
                Element e = (Element) elements.get(i);
                elementsNames.add(e.getAttribute("name"));
            }
            return elementsNames;
        }else{
            return null;
        }
    }


}
