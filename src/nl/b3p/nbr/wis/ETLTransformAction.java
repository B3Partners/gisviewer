/*
 * ETLTransformAction.java
 *
 * Created on 30 november 2006, 12:54
 */

package nl.b3p.nbr.wis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.nbr.wis.db.Clusters;
import nl.b3p.nbr.wis.db.Themas;
import nl.b3p.nbr.wis.services.HibernateUtil;
import nl.b3p.nbr.wis.struts.BaseHibernateAction;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Category;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Query;
import org.hibernate.Session;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
/**
 *
 * @author Geert
 * @version
 */

public class ETLTransformAction extends BaseHibernateAction {
    
    /* forward name="success" path="" */
    private final static String SUCCESS = "success";
    private static final Log log = LogFactory.getLog(ViewerAction.class);
    
    protected static final String KNOP = "knop";
    private List themalist = null;
    
    /**
     * This is the action called from the Struts framework.
     * @param mapping The ActionMapping used to select this instance.
     * @param form The optional ActionForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @throws java.lang.Exception
     * @return
     *
     **/
    public ActionForward execute(ActionMapping mapping, DynaValidatorForm  dynaForm,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        ArrayList geoafwijking = new ArrayList();
        geoafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 235", "g1", "oud"));
        geoafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 129", "g2", "nieuw"));
        geoafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 394", "g3", "nieuw"));
        geoafwijking.add(new AfwijkingsItem("Gedempte sloot", "g4", "nieuw"));
        
        ArrayList adminafwijking = new ArrayList();
        adminafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 235", "a1", "oud"));
        adminafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 235", "a2", "nieuw"));
        adminafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 45", "a3", "parkeren"));
        adminafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 573", "a4", "definitief_ontkoppeld"));
        
        request.setAttribute("geoafwijking", geoafwijking);
        request.setAttribute("adminafwijking", adminafwijking);
        
        return mapping.findForward(SUCCESS);
        
    }
    
    /**
     * This is the action called from the Struts framework.
     * @param mapping The ActionMapping used to select this instance.
     * @param form The optional ActionForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @throws java.lang.Exception
     * @return
     */
    public ActionForward edit(ActionMapping mapping, DynaValidatorForm  dynaForm,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        ArrayList geoafwijking = new ArrayList();
        geoafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 235", "g1", "oud"));
        geoafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 129", "g2", "nieuw"));
        geoafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 394", "g3", "nieuw"));
        geoafwijking.add(new AfwijkingsItem("Gedempte sloot", "g4", "nieuw"));
        
        ArrayList adminafwijking = new ArrayList();
        adminafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 235", "a1", "oud"));
        adminafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 235", "a2", "nieuw"));
        adminafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 45", "a3", "parkeren"));
        adminafwijking.add(new AfwijkingsItem("Sloot langs wegnummer 573", "a4", "definitief_ontkoppeld"));
        
        request.setAttribute("geoafwijking", geoafwijking);
        request.setAttribute("adminafwijking", adminafwijking);
        
        return mapping.findForward("success");
        
    }
    
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        createLists(dynaForm, request);
        return mapping.findForward(SUCCESS);
    }
    
    protected void createLists(DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        List ctl = null;
        String hquery = "FROM Clusters WHERE id != 9";
        Query q = sess.createQuery(hquery);
        ctl = q.list();
        
        hquery = "FROM Themas WHERE cluster != 9 AND (moscow = 1 OR moscow = 2 OR moscow = 3) and code < 3";
        q = sess.createQuery(hquery);
        themalist = q.list();
        
        JSONObject root = new JSONObject().put("id", "root").put("type", "root").put("title", "root");
        
        JSONArray children = new JSONArray();
        root.put("children", children);
        
        
        
        if (ctl!=null) {
            Iterator it = ctl.iterator();
            while (it.hasNext()) {
                Clusters cluster = (Clusters)it.next();
                if(cluster.getParent() == null) {
                    JSONObject jsonCluster = new JSONObject().put("id", "c" + cluster.getId()).put("type", "child").put("title", cluster.getNaam()).put("cluster", true);
                    children.put(jsonCluster);
                    
                    JSONArray childrenCluster = new JSONArray();
                    jsonCluster.put("children", childrenCluster);
                    
                    getChildren(childrenCluster, cluster);
                    getSubClusters(childrenCluster, cluster, ctl);
                }
            }
        }
        request.setAttribute("tree", root);
    }
    
    private void getSubClusters(JSONArray root, Clusters rootCluster, List list) throws JSONException {
        ArrayList subclusters = new ArrayList();
        Iterator it = list.iterator();
        while (it.hasNext()) {
            Clusters cluster = (Clusters)it.next();
            if(rootCluster == cluster.getParent()) {
                subclusters.add(cluster);
            }
        }
        if(!subclusters.isEmpty()) {
            it = subclusters.iterator();
            while(it.hasNext()) {
                Clusters cl = (Clusters) it.next();
                JSONObject jsonCluster = new JSONObject().put("id", "c" + cl.getId()).put("type", "child").put("title", cl.getNaam()).put("cluster", true);
                root.put(jsonCluster);
                
                JSONArray childrenCluster = new JSONArray();
                jsonCluster.put("children", childrenCluster);
                
                getChildren(childrenCluster, cl);
                getSubClusters(childrenCluster, cl, list);
            }
        }
    }
    
    private void getChildren(JSONArray root, Clusters rootCluster) throws JSONException {
        if(themalist == null) return;
        ArrayList childs = new ArrayList();
        Iterator it = themalist.iterator();
        while(it.hasNext()) {
            Themas thema = (Themas) it.next();
            if(thema.getCluster() == rootCluster) {
                childs.add(thema);
            }
        }
        if(!childs.isEmpty()) {
            it = childs.iterator();
            while(it.hasNext()) {
                Themas th = (Themas) it.next();
                String ttitel = th.getNaam();
                JSONObject jsonCluster = new JSONObject().put("id", th.getId()).put("type", "child").put("title", ttitel).put("cluster", false);
                //put wms data
                jsonCluster.put("wmsurl",th.getWms_url()).put("wmslayers",th.getWms_layers()).put("wmsquerylayers",th.getWms_querylayers());
                root.put(jsonCluster);
            }
        }
    }
    
    protected static final String ADMINDATA = "admindata";
    protected static final String EDIT = "edit";
    
    protected Map getActionMethodPropertiesMap() {
        Map map = new HashMap();
        
        ExtendedMethodProperties hibProp = null;
        hibProp = new ExtendedMethodProperties(ADMINDATA);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.admindata.failed");
        map.put(ADMINDATA, hibProp);
        
        
        hibProp = new ExtendedMethodProperties(EDIT);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.admindata.failed");
        map.put(EDIT, hibProp);
        
        return map;
    }
}

