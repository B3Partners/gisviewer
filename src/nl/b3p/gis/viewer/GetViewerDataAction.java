package nl.b3p.gis.viewer;

import com.vividsolutions.jump.feature.Feature;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.NotSupportedException;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.gis.viewer.db.Connecties;
import nl.b3p.gis.viewer.db.ThemaData;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.gis.viewer.services.WfsUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Session;

public class GetViewerDataAction extends BaseGisAction {
    
    private static final Log log = LogFactory.getLog(GetViewerDataAction.class);
    
    protected static final String ADMINDATA = "admindata";
    protected static final String AANVULLENDEINFO = "aanvullendeinfo";
    protected static final String METADATA = "metadata";
    protected static final String OBJECTDATA = "objectdata";
    protected static final String ANALYSEDATA = "analysedata";
    protected static final String ANALYSEWAARDE = "analysewaarde";
    protected static final String ANALYSEOBJECT = "analyseobject";
    
    /**
     * Return een hashmap die een property koppelt aan een Action.
     *
     * @return Map hashmap met action properties.
     */
    protected Map getActionMethodPropertiesMap() {
        Map map = new HashMap();
        
        ExtendedMethodProperties hibProp = null;
        hibProp = new ExtendedMethodProperties(ANALYSEWAARDE);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.analysewaarde.failed");
        map.put(ANALYSEWAARDE, hibProp);
        
        hibProp = new ExtendedMethodProperties(ANALYSEDATA);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.analysedata.failed");
        map.put(ANALYSEDATA, hibProp);
        
        hibProp = new ExtendedMethodProperties(ANALYSEOBJECT);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.analyseobject.failed");
        map.put(ANALYSEOBJECT, hibProp);
        
        hibProp = new ExtendedMethodProperties(OBJECTDATA);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.objectdata.failed");
        map.put(OBJECTDATA, hibProp);
        
        hibProp = new ExtendedMethodProperties(ADMINDATA);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.admindata.failed");
        map.put(ADMINDATA, hibProp);
        
        hibProp = new ExtendedMethodProperties(AANVULLENDEINFO);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.aanvullende.failed");
        map.put(AANVULLENDEINFO, hibProp);
        
        hibProp = new ExtendedMethodProperties(METADATA);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.metadata.failed");
        map.put(METADATA, hibProp);
        
        return map;
    }
    
    /**
     *
     * @param mapping ActionMapping
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     *
     * @return ActionForward
     *
     * @throws Exception
     */
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return mapping.findForward(SUCCESS);
    }
    
    /**
     * Methode is attributen ophaalt welke nodig zijn voor het tonen van de
     * administratieve data.
     * @param mapping ActionMapping
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     *
     * @return ActionForward
     *
     * @throws Exception
     *
     * thema_items
     * regels
     */
    public ActionForward admindata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {        
        ArrayList themas = getThemas(mapping,dynaForm,request);
        ArrayList regels=new ArrayList();
        ArrayList ti=null;
        if (themas!=null){
            for (int i=0 ; i < themas.size(); i++){        
                Themas t=(Themas)themas.get(i);
                List thema_items = SpatialUtil.getThemaData(t, true);
                int themadatanummer=0;
                if (ti!=null)
                    themadatanummer=ti.size();
                if (ti!=null){
                    for (int a=0; a < ti.size(); a++){
                        if (compareThemaDataLists((List)ti.get(a),thema_items)){
                            themadatanummer=a;
                            break;
                        }
                    }                
                }
                //haal op met JDBC connectie
                List l=null;
                if (t.getConnectie()==null || t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_JDBC)){
                    List pks = null;
                    pks = findPks(t, mapping, dynaForm, request);
                    if (themadatanummer==regels.size()){
                        regels.add(new ArrayList());
                    }
                    l =getThemaObjects(t, pks, thema_items);

                }//Haal op met WFS
                else if (t.getConnectie()!=null && t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
                    if (themadatanummer==regels.size()){
                        regels.add(new ArrayList());
                    }
                    l =getThemaWfsObjectsWithXY(t,thema_items,request);

                }
                if (l!=null && l.size()>0){
                    ((ArrayList)regels.get(themadatanummer)).addAll(l); 
                    if (ti==null){
                    ti=new ArrayList();
                    }
                    if (themadatanummer==ti.size()){
                        ti.add(thema_items);
                    }
                }

            }
        }
        request.setAttribute("regels_list",regels);
        request.setAttribute("thema_items_list", ti);
        return mapping.findForward("admindata");
    }
    
    /**
     * Methode is attributen ophaalt welke nodig zijn voor het tonen van de
     * aanvullende info.
     * @param mapping ActionMapping
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     *
     * @return ActionForward
     *
     * @throws Exception
     *
     * thema_items
     * regels
     */
    public ActionForward aanvullendeinfo(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Themas t = getThema(mapping, dynaForm, request);
        
        List thema_items = SpatialUtil.getThemaData(t, false);
        request.setAttribute("thema_items", thema_items);
        if (t.getConnectie()==null || t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_JDBC)){
            List pks = getPks(t, dynaForm, request);
            request.setAttribute("regels", getThemaObjects(t, pks, thema_items));
        }//Haal op met WFS
        else if (t.getConnectie()!=null && t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            request.setAttribute("regels",getThemaWfsObjectsWithId(t,thema_items,request));
        }
        return mapping.findForward("aanvullendeinfo");
        
        
    }
    
    /**
     * Methode is attributen ophaalt welke nodig zijn voor het tonen van de
     * metadata.
     * @param mapping ActionMapping
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     *
     * @return ActionForward
     *
     * @throws Exception
     *
     * thema
     */
    public ActionForward metadata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(mapping, dynaForm, request);
        request.setAttribute("themas", t);
        return mapping.findForward("metadata");
    }
    
    /**
     * Methode is attributen ophaalt welke nodig zijn voor het tonen van de
     * "Gebieden" tab.
     * @param mapping ActionMapping
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     *
     * @return ActionForward
     *
     * @throws Exception
     *
     * object_data
     *
     */
    public ActionForward objectdata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        List tol = createThemaObjectsList(mapping, dynaForm, request);
        request.setAttribute("object_data", tol);
        
        return mapping.findForward("objectdata");
    }
    
    /**
     * Methode is attributen ophaalt welke nodig zijn voor het tonen van de
     * "Analyse" tab.
     * @param mapping The ActionMapping used to select this instance.
     * @param dynaForm The DynaValidatorForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @return an Actionforward object.
     * @throws Exception Exception
     *
     * object_data
     * thema
     * lagen
     * xcoord
     * ycoord
     *
     */
    public ActionForward analysedata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        List tol = createThemaObjectsList(mapping, dynaForm, request);
        request.setAttribute("object_data", tol);
        
        return mapping.findForward("analysedata");
    }
    
    /**
     * Methode wordt aangeroepen door knop "analysewaarde" op tabblad "Analyse"
     * en berekent een waarde op basis van actieve thema, plus evt. een
     * extra zoekcriterium voor de administratieve waarde in de basisregel, en
     * een gekozen gebied onder het klikpunt.
     * @param mapping The ActionMapping used to select this instance.
     * @param dynaForm The DynaValidatorForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @return an Actionforward object.
     * @throws Exception exception
     *
     * waarde
     */
    public ActionForward analysewaarde(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Maakt nu gebruik van het activeanalysethema property door true mee te geven
        Themas t = getThema(mapping, dynaForm, request, true);
        
        List thema_items = SpatialUtil.getThemaData(t, true);
        
        String organizationcodekey = t.getOrganizationcodekey();
        String organizationcode = getOrganizationCode(request);
        String extraCriterium = dynaForm.getString("extraCriteria");
        String extraWhere = calculateExtraWhere(thema_items, extraCriterium,
                organizationcodekey, organizationcode, "tb1" );
        
        String geselecteerdObject = dynaForm.getString("geselecteerd_object");
        if (geselecteerdObject==null || geselecteerdObject.length()==0) {
            log.error("Er is geen analysegebied aangegeven!");
            throw new Exception("Er is geen analysegebied aangegeven!");
        }
        String[] tokens = geselecteerdObject.split("_");
        if (tokens.length!=3) {
            log.error("Id van analysegebied verkeerd geformatteerd!");
            throw new Exception("Id van analysegebied verkeerd geformatteerd!");
        }
        Themas geselecteerdObjectThema = getObjectThema(tokens[1]);
        if (geselecteerdObjectThema == null) {
            log.error("Kan het geselecteerde thema object niet vinden!");
            throw new Exception("Kan het geselecteerde thema object niet vinden!");
        }
        String analyseGeomId = tokens[2];
        String analyseNaam = getAnalyseNaam(analyseGeomId, geselecteerdObjectThema);
        
        String tgt = getThemaGeomType(t);
        String stype = null;
        String sfunction = null;
        int sfactor = -1;
        String sdesc = null;
        String[] scolumns = null;
        
        //Alle invoervelden zijn bekend en door de verschillende controleprocedures gekomen
        //om een juiste query uit te kunnen voeren.
        int zow = 0;
        try {
            zow = Integer.parseInt(dynaForm.getString("zoekopties_waarde"));
        } catch (NumberFormatException nfe) {
            log.debug("zoekopties_waarde fout: ",nfe);
        }
        switch (zow) {
            case 1:
                if (tgt.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                    stype = "LINESTRING";
                    sfunction = "max";
                    sfactor = 1000;
                    sdesc = "Grootste lengte(km)";
                    scolumns = new String[]{"result"};
                } else if (tgt.equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
                    stype = "POLYGON";
                    sfunction = "max";
                    sfactor = 1000000;
                    sdesc = "Grootste oppervlakte(km2)";
                    scolumns = new String[]{"result"};
                }
                break;
            case 2:
                if (tgt.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                    stype = "LINESTRING";
                    sfunction = "min";
                    sfactor = 1000;
                    sdesc = "Kleinste lengte(km)";
                    scolumns = new String[]{"result"};
                } else if (tgt.equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
                    stype = "POLYGON";
                    sfunction = "min";
                    sfactor = 1000000;
                    sdesc = "Kleinste oppervlakte(km2)";
                    scolumns = new String[]{"result"};
                }
                break;
            case 3:
                if (tgt.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                    stype = "LINESTRING";
                    sfunction = "avg";
                    sfactor = 1000;
                    sdesc = "Gemiddelde lengte(km)";
                    scolumns = new String[]{"result"};
                } else if (tgt.equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
                    stype = "POLYGON";
                    sfunction = "avg";
                    sfactor = 1000000;
                    sdesc = "Gemiddelde oppervlakte(km2)";
                    scolumns = new String[]{"result"};
                }
                break;
            case 4:
                if (tgt.equalsIgnoreCase(SpatialUtil.MULTIPOINT)){
                    stype = "POINT";
                    sfunction = "count(*)";
                    sfactor = -1;
                    sdesc = "Aantal";
                    scolumns = new String[]{"count"};
                } else if (tgt.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                    stype = "LINESTRING";
                    sfunction = "sum";
                    sfactor = 1000;
                    sdesc = "Totale lengte(km)";
                    scolumns = new String[]{"result"};
                } else if (tgt.equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
                    stype = "POLYGON";
                    sfunction = "sum";
                    sfactor = 1000000;
                    sdesc = "Totale oppervlakte(km2)";
                    scolumns = new String[]{"result"};
                }
                break;
            default:
                log.error("Er is geen geldige selectie aangegeven door middel van de radio buttons!");
                throw new Exception("Er is geen geldige selectie aangegeven door middel van de radio buttons!");
        }
        
        StringBuffer result = new StringBuffer("");
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        if (stype != null) {
            String query = null;
            if("POINT".equalsIgnoreCase(stype)) {
                query = SpatialUtil.withinQuery(
                        sfunction,
                        t.getSpatial_tabel(),
                        geselecteerdObjectThema.getSpatial_tabel(),
                        t.getSpatial_admin_ref(),
                        analyseGeomId,
                        extraWhere);
            } else if("LINESTRING".equalsIgnoreCase(stype)) {
                query = SpatialUtil.intersectionLength(
                        sfunction,
                        t.getSpatial_tabel(),
                        geselecteerdObjectThema.getSpatial_tabel(),
                        analyseGeomId,
                        sfactor,
                        extraWhere);
            } else if("POLYGON".equalsIgnoreCase(stype)) {
                query = SpatialUtil.intersectionArea(
                        sfunction,
                        t.getSpatial_tabel(),
                        geselecteerdObjectThema.getSpatial_tabel(),
                        analyseGeomId,
                        sfactor,
                        extraWhere);
            }
            
            log.debug(query);
            result.append("<b>" + sdesc + " " + t.getNaam());
            
            if (analyseNaam!=null){
                result.append(" in ");
                result.append(analyseNaam);
            }
            result.append(": ");
            
            executeQuery(query, sess, result, scolumns, t);
            result.append("</b>");
        } else {
            result.append("<b>Niet mogelijk met dit thema-geometry-type<br/></b>");
        }
        
        request.setAttribute("waarde", result.toString());
        
        return mapping.findForward("analyseobject");
    }
    
    
    /**
     * Methode wordt aangeroepen door knop "analyseobject" op tabblad "Analyse"
     * en bepaalt alle objecten uit het actieve thema, plus evt. een
     * extra zoekcriterium voor de administratieve waarde in de basisregel, in
     * een gekozen gebied onder het klikpunt.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param dynaForm The DynaValidatorForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     *
     * @return an Actionforward object.
     *
     * @throws Exception
     *
     * thema_items
     * regels
     *
     */
    public ActionForward analyseobject(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(mapping, dynaForm, request);
        
        List thema_items = SpatialUtil.getThemaData(t, true);
        
        String organizationcodekey = t.getOrganizationcodekey();
        String organizationcode = getOrganizationCode(request);
        String extraCriterium = dynaForm.getString("extraCriteria");
        String extraWhere = calculateExtraWhere(thema_items, extraCriterium,
                organizationcodekey, organizationcode, "tb1" );
        
        String geselecteerdObject = dynaForm.getString("geselecteerd_object");
        if (geselecteerdObject==null || geselecteerdObject.length()==0) {
            log.error("Er is geen analysegebied aangegeven!");
            throw new Exception("Er is geen analysegebied aangegeven!");
        }
        String[] tokens = geselecteerdObject.split("_");
        if (tokens.length!=3) {
            log.error("Id van analysegebied verkeerd geformatteerd!");
            throw new Exception("Id van analysegebied verkeerd geformatteerd!");
        }
        Themas geselecteerdObjectThema = getObjectThema(tokens[1]);
        if (geselecteerdObjectThema == null) {
            log.error("Kan het geselecteerde thema object niet vinden!");
            throw new Exception("Kan het geselecteerde thema object niet vinden!");
        }
        String analyseGeomId = tokens[2];
        
        //create relation query
        String relationFunction=null;
        int zoo = 0;
        try {
            zoo = Integer.parseInt(dynaForm.getString("zoekopties_object"));
        } catch (NumberFormatException nfe) {
            log.debug("zoekopties_object fout: ",nfe);
        }
        if (zoo == 1)
            relationFunction="Disjoint";
        else if (zoo == 2)
            relationFunction="Within";
        else if (zoo == 3)
            relationFunction="Intersects";
        else
            log.error("Deze analyse/zoek_optie is niet geimplementeerd!");
        
        String query= SpatialUtil.hasRelationQuery(
                t.getSpatial_tabel(), //tb1
                geselecteerdObjectThema.getSpatial_tabel(), //tb2
                relationFunction,
                t.getSpatial_admin_ref(),
                analyseGeomId,
                extraWhere);
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = null;
        if (t.getConnectie()!=null){
            connection=t.getConnectie().getJdbcConnection();
        }
        if (connection==null)
            connection=sess.connection();
        
        ArrayList pks = new ArrayList();
        try {
            PreparedStatement statement = connection.prepareStatement(query);
            try {
                ResultSet rs = statement.executeQuery();
                while(rs.next()) {
                    pks.add(rs.getObject(t.getSpatial_admin_ref()));
                }
                
            } finally {
                statement.close();
            }
        } catch (SQLException ex) {
            log.error("", ex);
        } finally {
            try {
                connection.close();
            } catch (SQLException ex) {
                log.error("", ex);
            }
        }
        
        if (pks.size()>0){
            ArrayList regels= new ArrayList();
            ArrayList ti= new ArrayList();
            regels.add(getThemaObjects(t, pks, thema_items));
            ti.add(thema_items);
            request.setAttribute("thema_items_list", ti);
            request.setAttribute("regels_list", regels);
        }
        return mapping.findForward("admindata");
    }
    
    public static String calculateExtraWhere(List thema_items, String extraCriterium,
            String organizationcodekey, String organizationcode, String tableAlias ) {
        StringBuffer extraWhere = new StringBuffer();
        
        if (thema_items!=null && thema_items.size()>0 &&
                extraCriterium!=null && extraCriterium.length()>0) {
            extraCriterium = extraCriterium.replaceAll("\\'", "''");
            Iterator it = thema_items.iterator();
            while(it.hasNext()) {
                ThemaData td = (ThemaData)it.next();
                if (extraWhere.length()==0)
                    extraWhere.append(" and (");
                else
                    extraWhere.append(" or");
                extraWhere.append(" lower(");
                extraWhere.append(tableAlias);
                extraWhere.append(".");
                extraWhere.append(td.getKolomnaam());
                extraWhere.append(") like lower('%");
                extraWhere.append(extraCriterium);
                extraWhere.append("%')");
            }
            if (extraWhere.length()!=0)
                extraWhere.append(" )");
        }
        
        if(organizationcode != null && organizationcode.length() > 0 &&
                organizationcodekey != null && organizationcodekey.length() > 0) {
            extraWhere.append(" and ");
            extraWhere.append(tableAlias);
            extraWhere.append(".");
            extraWhere.append(organizationcodekey);
            extraWhere.append(" = '");
            extraWhere.append(organizationcode);
            extraWhere.append("' ");
        }
        
        return extraWhere.toString();
    }
    
    protected List createThemaObjectsList(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        
        ArrayList objectdata = new ArrayList();
        List ctl = getValidThemas(true, null, request);
        if(ctl == null || ctl.isEmpty())
            return null;
        
        Iterator it = ctl.iterator();
        while(it.hasNext()) {
            Themas t = (Themas) it.next();
            List thema_items = SpatialUtil.getThemaData(t, true);
            List pks = findPks(t, mapping, dynaForm, request);
            List ao = getThemaObjects(t, pks, thema_items);
            
            if (ao==null || ao.isEmpty())
                continue;
            
            ArrayList thema = new ArrayList();
            thema.add(t.getId());
            thema.add(t.getNaam());
            thema.add(ao);
            objectdata.add(thema);
        }
        return objectdata;
    }
    
    protected List getThemaWfsObjectsWithXY(Themas t, List thema_items,HttpServletRequest request) throws Exception{
        if (t==null)
            return null;
        if (thema_items==null || thema_items.isEmpty())
            return null;
        String xcoord = request.getParameter("xcoord");
        String ycoord = request.getParameter("ycoord");
        String s= request.getParameter("scale");
        double scale=0.0;
        try{
            if (s!=null){
                scale= Double.parseDouble(s);
                //af ronden op 1 decimaal
                scale=Math.round(scale*10)/10;
            }
        } catch (NumberFormatException nfe){
            scale=0.0;
            log.debug("Scale is geen double dus wordt genegeerd");
        }
        double x = Double.parseDouble(xcoord);
        double y = Double.parseDouble(ycoord);
        double distance=10.0;
        if (scale> 0.0){
            distance=scale*(distance);
        } else{
            distance = 10.0;
        }
        ArrayList regels = new ArrayList();
        ArrayList features= WfsUtil.getWFSObjects(t,x,y,distance);
        for (int i=0; i < features.size(); i++){
            Feature f = (Feature) features.get(i);
            regels.add(getRegel(f,t,thema_items));
        }
        return regels;
    }
    
    protected List getThemaWfsObjectsWithId(Themas t, List thema_items,HttpServletRequest request) throws Exception{
        if (t==null)
            return null;
        if (thema_items==null || thema_items.isEmpty())
            return null;
        String adminPk=t.getAdmin_pk();
        String id=request.getParameter(adminPk);
        if (id==null && adminPk.split(":").length>1){
            id=request.getParameter(adminPk.split(":")[1]);
        }
        if (id==null){
            return null;
        }
        ArrayList regels = new ArrayList();
        ArrayList features= WfsUtil.getWFSObjects(t,adminPk, id);
        for (int i=0; i < features.size(); i++){
            Feature f = (Feature) features.get(i);
            regels.add(getRegel(f,t,thema_items));
        }
        return regels;
    }
    
    /**
     *
     * @param t Themas
     * @param pks List
     * @param thema_items List
     *
     * @return List
     *
     * @throws SQLException, UnsupportedEncodingException
     *
     * @see Themas
     */
    protected List getThemaObjects(Themas t, List pks, List thema_items) throws SQLException, UnsupportedEncodingException, NotSupportedException {
        if (t==null)
            return null;
        if (pks==null || pks.isEmpty())
            return null;
        if (thema_items==null || thema_items.isEmpty())
            return null;
        
        ArrayList regels = new ArrayList();
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = null;
        if (t.getConnectie()!=null){
            connection=t.getConnectie().getJdbcConnection();
        }
        if (connection==null)
            connection=sess.connection();
        try {
            
            int dt = SpatialUtil.getPkDataType( t, connection);
            
            String taq = t.getAdmin_query();
            Iterator it = pks.iterator();
            for (int i=1; i<=pks.size(); i++) {
                PreparedStatement statement = connection.prepareStatement(taq);
                switch (dt) {
                    case java.sql.Types.SMALLINT:
                        statement.setShort(1, ((Short)pks.get(i-1)).shortValue());
                        break;
                    case java.sql.Types.INTEGER:
                        statement.setInt(1, ((Integer)pks.get(i-1)).intValue());
                        break;
                    case java.sql.Types.BIGINT:
                        statement.setLong(1, ((Long)pks.get(i-1)).longValue());
                        break;
                    case java.sql.Types.BIT:
                        statement.setBoolean(1, ((Boolean)pks.get(i-1)).booleanValue());
                        break;
                    case java.sql.Types.DATE:
                        statement.setDate(1, (Date)pks.get(i-1));
                        break;
                    case java.sql.Types.DECIMAL:
                    case java.sql.Types.NUMERIC:
                        statement.setBigDecimal(1, (BigDecimal)pks.get(i-1));
                        break;
                    case java.sql.Types.REAL:
                        statement.setFloat(1, ((Float)pks.get(i-1)).floatValue());
                        break;
                    case java.sql.Types.FLOAT:
                    case java.sql.Types.DOUBLE:
                        statement.setDouble(1, ((Double)pks.get(i-1)).doubleValue());
                        break;
                    case java.sql.Types.TIME:
                        statement.setTime(1, (Time)pks.get(i-1));
                        break;
                    case java.sql.Types.TIMESTAMP:
                        statement.setTimestamp(1, (Timestamp)pks.get(i-1));
                        break;
                    case java.sql.Types.TINYINT:
                        statement.setByte(1, ((Byte)pks.get(i-1)).byteValue());
                        break;
                    case java.sql.Types.CHAR:
                    case java.sql.Types.LONGVARCHAR:
                    case java.sql.Types.VARCHAR:
                        statement.setString(1, (String)pks.get(i-1));
                        break;
                    case java.sql.Types.NULL:
                    default:
//                        SpatialUtil.testMetaData(connection);
                        return null;
                }
                try {
                    ResultSet rs = statement.executeQuery();
                    while(rs.next()) {
                        regels.add(getRegel(rs, t, thema_items));
                    }
                } finally {
                    statement.close();
                }
            }
        } finally {
            connection.close();
        }
        return regels;
    }
    
}
