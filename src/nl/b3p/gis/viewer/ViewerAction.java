/**
 * @(#)ViewerAction.java
 * @author Roy Braam
 * @version 1.00 2006/11/29
 *
 * Purpose: a class handling the different actions which come from classes extending this class.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.gis.viewer.db.Clusters;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.services.GisPrincipal;
import nl.b3p.gis.viewer.services.SpatialUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ViewerAction extends BaseGisAction {
    
    private static final Log log = LogFactory.getLog(ViewerAction.class);
    
    protected static final String KNOP = "knop";
    
    /**
     * Return een hashmap die een property koppelt aan een Action.
     *
     * @return Map hashmap met action properties.
     */
    // <editor-fold defaultstate="" desc="protected Map getActionMethodPropertiesMap()">
    protected Map getActionMethodPropertiesMap() {
        Map map = new HashMap();
        
        ExtendedMethodProperties hibProp = null;
        
        hibProp = new ExtendedMethodProperties(KNOP);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        map.put(KNOP, hibProp);
        
        return map;
    }
    // </editor-fold>
    
    /**
     * Dit is een voorbeeld knop zoals deze in de jsp zou kunnen staan.
     * De property van die knop is dan 'knop'.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param dynaForm The DynaValidatorForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     *
     * @return an Actionforward object.
     *
     * @throws Exception
     */
    // <editor-fold defaultstate="" desc="public ActionForward knop(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward knop(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        ActionErrors errors = dynaForm.validate(mapping, request);
        if(!errors.isEmpty()) {
            addMessages(request, errors);
            addAlternateMessage(mapping, request, VALIDATION_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        createLists(dynaForm, request);
        
        addDefaultMessage(mapping, request);
        return getDefaultForward(mapping, request);
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param dynaForm The DynaValidatorForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     *
     * @return an Actionforward object.
     *
     * @throws Exception
     */
    // <editor-fold defaultstate="" desc="public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        createLists(dynaForm, request);
        return mapping.findForward(SUCCESS);
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
     *
     * @param dynaForm The DynaValidatorForm bean for this request.
     * @param request The HTTP Request we are processing.
     *
     * @throws Exception
     */
    // <editor-fold defaultstate="" desc="protected void createLists(DynaValidatorForm dynaForm, HttpServletRequest request)">
    protected void createLists(DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        List ctl = SpatialUtil.getValidClusters();
        List themalist = getValidThemas(false, request);
        
        addUnknownLayers(ctl, themalist, request);
        
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
                    
                    getChildren(themalist, childrenCluster, cluster);
                    getSubClusters(themalist, childrenCluster, cluster, ctl);
                }
            }
        }
        request.setAttribute("tree", root);
        
        // zet kaartenbalie url
        MessageResources messages = getResources(request);
        String kburl = messages.getMessage("config.kburl");
        request.setAttribute("kburl", kburl);
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
     *
     * @param root JSONArray
     * @param rootCluster Clusters
     * @param list List
     *
     * @throws JSONException
     *
     * @see Clusters
     */
    // <editor-fold defaultstate="" desc="private void getSubClusters(JSONArray root, Clusters rootCluster, List list)">
    private void getSubClusters(List themalist, JSONArray root, Clusters rootCluster, List list) throws JSONException, Exception {
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
                
                getChildren(themalist, childrenCluster, cl);
                getSubClusters(themalist, childrenCluster, cl, list);
            }
        }
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
     *
     * @param root JSONArray
     * @param rootCluster Clusters
     *
     * @throws JSONException
     *
     * @see Clusters
     */
    // <editor-fold defaultstate="" desc="private void getChildren(JSONArray root, Clusters rootCluster)">
    private void getChildren(List themalist, JSONArray root, Clusters rootCluster) throws JSONException, Exception {
        if(themalist == null)
            return;
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
                
                if(th.getWms_layers_real() != null) {
                    jsonCluster
                            .put("wmslayers", th.getWms_layers_real())
                            .put("wmsquerylayers", th.getWms_querylayers_real())
                            .put("wmslegendlayer", th.getWms_legendlayer_real());
                } else {
                    jsonCluster
                            .put("wmslayers",th.getWms_layers())
                            .put("wmsquerylayers",th.getWms_querylayers())
                            .put("wmslegendlayer",th.getWms_legendlayer());
                }
                root.put(jsonCluster);
            }
        }
    }
    // </editor-fold>
    
    public void addUnknownLayers(List ctl, List themalist, HttpServletRequest request) {
        Principal user = request.getUserPrincipal();
        if (user==null || !(user instanceof GisPrincipal))
            return;
        // Als het een GisPrincipal is, dan kunnen we de rollen inspekteren voor
        // extra lagen
        GisPrincipal gisUser = (GisPrincipal)user;
        Set roles = gisUser.getRoles();
        if (roles==null || roles.isEmpty())
            return;
        
        Clusters c = new Clusters();
        c.setNaam("extra");
        c.setParent(null);
        int size = themalist.size();
        
        Iterator it = roles.iterator();
        int tid = 100000;
        while (it.hasNext()) {
            String role = (String)it.next();
            if (!role.startsWith("layer_"))
                continue;
            String layer = role.substring(6);
            boolean found = false;
            Iterator it2 = themalist.iterator();
            while (it2.hasNext()) {
                Themas t = (Themas)it2.next();
                // als layer al gevonden in themas dan overslaan
                if (layer.equals(t.getWms_layers_real()) ||
                        layer.equals(t.getWms_layers())) {
                    found = true;
                    break;
                }
            }
            if (!found) {
                Themas t = new Themas();
                t.setId(tid++);
                t.setNaam(layer);
//                t.setWms_layers(layer);
                t.setWms_layers_real(layer);
//                t.setWms_legendlayer(layer);
                t.setWms_legendlayer_real(layer);
                t.setCluster(c);
                // voeg extra laag als nieuw thema toe
                themalist.add(t);
            }
        }
        // voeg cluster toe als extra lagen gevonden zijn
        if (size<themalist.size())
            ctl.add(c);
        
    }
    
}
