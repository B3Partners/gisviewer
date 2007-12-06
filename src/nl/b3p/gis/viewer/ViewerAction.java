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

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.services.FormUtils;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.gis.viewer.db.Clusters;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.services.GisPrincipal;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.wms.capabilities.SrsBoundingBox;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.validator.DynaValidatorForm;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ViewerAction extends BaseGisAction {
    
    private static final Log log = LogFactory.getLog(ViewerAction.class);
    
    protected static final String KNOP = "knop";
    protected static final String LOGIN = "login";
    
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
        //als er geen user principal is (ook geen anoniem) dan forwarden naar de login.
        GisPrincipal user = GisPrincipal.getGisPrincipal(request);
        if (user==null){
            log.info("Geen user beschikbaar, ook geen anoniem. Forward naar login om te proberen een user te maken met login gegevens.");
            return mapping.findForward(LOGIN);
        }
        createLists(dynaForm, request);
        return mapping.findForward(SUCCESS);
    }
    // </editor-fold>
    
    protected void createLists(DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        super.createLists(dynaForm, request);
        List ctl = SpatialUtil.getValidClusters();
        List themalist = getValidThemas(false, ctl, request);
        Map rootClusterMap = getClusterMap(themalist, ctl, null);
        
        request.setAttribute("tree", createJasonObject(rootClusterMap));
         // zet kaartenbalie url
        request.setAttribute("kburl", HibernateUtil.KBURL);
        
        //stukje voor BBox toevoegen.
        GisPrincipal user = GisPrincipal.getGisPrincipal(request);        
        Set bboxen=user.getSp().getTopLayer().getSrsbb();
        Iterator it=bboxen.iterator();
        while(it.hasNext()){
            SrsBoundingBox bbox= (SrsBoundingBox)it.next();
            if(FormUtils.nullIfEmpty(bbox.getMaxx())!=null && FormUtils.nullIfEmpty(bbox.getMaxy())!=null &&FormUtils.nullIfEmpty(bbox.getMinx())!=null &&FormUtils.nullIfEmpty(bbox.getMiny())!=null){
                if (bbox.getSrs()!=null && bbox.getSrs().equalsIgnoreCase("epsg:28992")){
                    request.setAttribute("startExtent",bbox.getMinx()+","+bbox.getMiny()+","+bbox.getMaxx()+","+bbox.getMaxy());
                    break;
                }
            }            
        }
       
    }
    
    private Map getClusterMap(List themalist, List clusterlist, Clusters rootCluster) throws JSONException, Exception {
        if(themalist == null || clusterlist == null)
            return null;
        
        List childrenList = getThemaList(themalist, rootCluster);
        
        List subclusters = null;
        Iterator it = clusterlist.iterator();
        while (it.hasNext()) {
            Clusters cluster = (Clusters)it.next();
            if(rootCluster == cluster.getParent()) {
                Map clusterMap = getClusterMap(themalist, clusterlist, cluster);
                if (clusterMap == null || clusterMap.isEmpty())
                    continue;
                if (subclusters==null)
                    subclusters = new ArrayList();
                subclusters.add(clusterMap);
            }
        }
        
        if ((childrenList==null || childrenList.isEmpty()) && ((subclusters==null || subclusters.isEmpty())))
            return null;
        
        Map clusterNode = new HashMap();
        clusterNode.put("subclusters", subclusters);
        clusterNode.put("children", childrenList);
        clusterNode.put("cluster", rootCluster);
        
        return clusterNode;
    }
    
    private List getThemaList(List themalist, Clusters rootCluster) throws JSONException, Exception {
        if(themalist == null)
            return null;
        ArrayList children = null;
        Iterator it = themalist.iterator();
        while(it.hasNext()) {
            Themas thema = (Themas) it.next();
            if(thema.getCluster() == rootCluster) {
                if (children==null)
                    children = new ArrayList();
                children.add(thema);
            }
        }
        if (children!=null)
            Collections.reverse(children);
        return children;
    }
    
    protected JSONObject createJasonObject(Map rootClusterMap) throws JSONException {
        if (rootClusterMap==null || rootClusterMap.isEmpty())
            return null;
        
        List clusterMaps = (List)rootClusterMap.get("subclusters");
        if (clusterMaps==null || clusterMaps.isEmpty())
            return null;
        
        JSONObject root = new JSONObject().put("id", "root").put("type", "root").put("title", "root");
        root.put("children", getSubClusters(clusterMaps, null));
        
        return root;
    }
    
    private JSONArray getSubClusters(List subclusterMaps, JSONArray clusterArray) throws JSONException {
        if(subclusterMaps == null)
            return clusterArray;
        
        Iterator it = subclusterMaps.iterator();
        while(it.hasNext()) {
            Map clMap = (Map) it.next();
            
            Clusters cluster = (Clusters)clMap.get("cluster");
            JSONObject jsonCluster = new JSONObject().put("id",
                    "c" + cluster.getId()).put("type", "child").put("title", cluster.getNaam()).put("cluster", true);
            
            List childrenList = (List)clMap.get("children");
            JSONArray childrenArray = getChildren(childrenList);
            List subsubclusterMaps = (List)clMap.get("subclusters");
            childrenArray = getSubClusters(subsubclusterMaps, childrenArray);
            jsonCluster.put("children",childrenArray);
            
            if (clusterArray==null)
                clusterArray = new JSONArray();
            clusterArray.put(jsonCluster);
            
        }
        return clusterArray;
    }
    
    private JSONArray getChildren(List children) throws JSONException {
        if(children == null)
            return null;
        
        JSONArray childrenArray = null;
        Iterator it = children.iterator();
        while(it.hasNext()) {
            Themas th = (Themas) it.next();
            String ttitel = th.getNaam();
            JSONObject jsonCluster = new JSONObject().put("id", th.getId()).put("type", "child").put("title", ttitel).put("cluster", false);
            
            if (th.isVisible()) {
                jsonCluster.put("visible", "on");
            } else {
                jsonCluster.put("visible", "off");
            }
            
            if (th.isAnalyse_thema()) {
                jsonCluster.put("analyse", "on");
            } else {
                jsonCluster.put("analyse", "off");
            }
            
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
            if (th.getMetadata_link()!=null){
                String metadatalink=th.getMetadata_link();
                metadatalink=metadatalink.replaceAll("%id%",""+th.getId());
                jsonCluster.put("metadatalink",metadatalink);
            }else{
                jsonCluster.put("metadatalink","#");
            }
            
            if (childrenArray==null)
                childrenArray = new JSONArray();
            childrenArray.put(jsonCluster);
        }
        
        return childrenArray;
    }
    
}
