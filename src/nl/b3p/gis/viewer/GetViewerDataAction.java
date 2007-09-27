package nl.b3p.gis.viewer;

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
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.gis.viewer.db.ThemaData;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.gis.viewer.BaseGisAction;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Query;
import org.hibernate.Session;

public class GetViewerDataAction extends BaseGisAction {
    
    private static final Log log = LogFactory.getLog(GetViewerDataAction.class);
    
    protected static final String ANALYSEWAARDE = "analysewaarde";
    protected static final String ANALYSEDATA = "analysedata";
    protected static final String ANALYSEOBJECT = "analyseobject";
    protected static final String OBJECTDATA = "objectdata";
    protected static final String ADMINDATA = "admindata";
    protected static final String AANVULLENDEINFO = "aanvullendeinfo";
    protected static final String METADATA = "metadata";
    /**
     * Return een hashmap die een property koppelt aan een Action.
     *
     * @return Map hashmap met action properties.
     */
    // <editor-fold defaultstate="" desc="protected Map getActionMethodPropertiesMap()">
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
    // </editor-fold>
    
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
    // <editor-fold defaultstate="" desc="public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return mapping.findForward(SUCCESS);
    }
    // </editor-fold>
    
    /**
     * Methode die aangeroepen wordt aan de hand van de button 'bereken' in het analyse tabblad
     * van de viewer. Deze methode stelt een query samen op basis van de gegevens die ingoevoerd
     * zijn door de gebruiker om zo het gewenste resultaat te kunnen tonen.
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
    // <editor-fold defaultstate="" desc="public ActionForward analysewaarde(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) method.">
    public ActionForward analysewaarde(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map inputParameters = getInputParameters(mapping, dynaForm, request, response);
        
        //Alle invoervelden zijn bekend en door de verschillende controleprocedures gekomen
        //om een juiste query uit te kunnen voeren.
        int zow = 0;
        if (inputParameters.get("zoekOpties_waarde")!=null)
            zow = ((Integer)inputParameters.get("zoekOpties_waarde")).intValue();
        String tgt = (String)inputParameters.get("themaGeomType");
        
        String stype = null;
        String sfunction = null;
        int sfactor = -1;
        String sdesc = null;
        String[] scolumns = null;
        
        
        switch (zow) {
            case 1:
                if (tgt.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                    stype = "LINESTRING";
                    sfunction = "max";
                    sfactor = 1000;
                    sdesc = "Grootste lengte(km)";
                    scolumns = new String[]{"result"};
                } else if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
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
        }
        
        Map extraCriteria = (Map)inputParameters.get("extraCriteria");
        StringBuffer extraCriteriaString = new StringBuffer();
        Iterator it = extraCriteria.keySet().iterator();
        while(it.hasNext()) {
            String key = (String)it.next();
            String keyvalue = (String)inputParameters.get(key);
            if(keyvalue != "" && keyvalue != null) {
                extraCriteriaString.append(" and tb2." + key + "='" + keyvalue + "'");
            }
        }
        
        StringBuffer result = new StringBuffer("");
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        if (stype != null) {
            String query = null;
            if("POINT".equalsIgnoreCase(stype)) {
                query = SpatialUtil.containsQuery(
                        sfunction,
                        (String)inputParameters.get("analyseGeomTabel"),
                        (String)inputParameters.get("themaGeomTabel"),
                        (String)inputParameters.get("analyseGeomIdColumn"),
                        (String)inputParameters.get("analyseGeomId"),
                        extraCriteriaString.toString());
            } else if("LINESTRING".equalsIgnoreCase(stype)) {
                query = SpatialUtil.intersectionLength(
                        sfunction,
                        (String)inputParameters.get("themaGeomTabel"),
                        (String)inputParameters.get("analyseGeomTabel"),
                        (String)inputParameters.get("analyseGeomId"),
                        sfactor,
                        extraCriteriaString.toString());
            } else if("POLYGON".equalsIgnoreCase(stype)) {
                query = SpatialUtil.intersectionArea(
                        sfunction,
                        (String)inputParameters.get("themaGeomTabel"),
                        (String)inputParameters.get("analyseGeomTabel"),
                        (String)inputParameters.get("analyseGeomId"),
                        sfactor,
                        extraCriteriaString.toString());
            }
            
            log.debug(query);
            result.append("<b>" + sdesc + " " + ((Themas)inputParameters.get("thema")).getNaam());
            
            if ((String)inputParameters.get("analyseNaam")!=null){
                result.append(" in " + (String)inputParameters.get("analyseNaam"));
            }
            result.append(":");
            
            executeQuery(query, sess, result, scolumns);
            result.append("</b>");
        } else {
            result.append("<b>Niet mogelijk met dit thema-geometry-type<br/></b>");
        }
        
        request.setAttribute("waarde", result.toString());
        return analysedataParameters(inputParameters, mapping, dynaForm, request);
    }
    // </editor-fold>
    
    /**
     * Methode die aangeroepen wordt door de methode analysewaarde.
     * Deze methode zet een aantal attributen op het request en stelt een query waarmee
     * de thema's die in de database staan op het scherm getoond zullen worden.
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
    public ActionForward analysedata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return analysedataParameters(null, mapping, dynaForm, request);
    }
    
    public ActionForward analysedataParameters(Map inputParameters, ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        
        Themas t = getThema(mapping, dynaForm, request);
        if (t!=null){
            List thema_items = SpatialUtil.getThemaData(t, true);
            request.setAttribute("thema_items", thema_items);
            
            String lagen = request.getParameter("lagen");
            request.setAttribute(Themas.THEMAID, new Integer(t.getId()));
            request.setAttribute("lagen", lagen);
            request.setAttribute("xcoord", request.getParameter("xcoord"));
            request.setAttribute("ycoord", request.getParameter("ycoord"));
            
            ArrayList analysedata = new ArrayList();
            List ctl = getValidThemas(true, null, request);
            if(ctl != null) {
                Iterator it = ctl.iterator();
                while(it.hasNext()) {
                    ArrayList thema = new ArrayList();
                    Themas tt = (Themas) it.next();
                    thema.add(tt.getNaam());
                    thema.add(new Integer(tt.getId()));
                    
                    List tthema_items = SpatialUtil.getThemaData(tt, true);
                    
                    List pks = findPks(tt, mapping, dynaForm, request);
                    List ao = getThemaObjects(tt, pks, tthema_items);
                    if (ao==null)
                        ao = new ArrayList();
                    thema.add(ao);
                    analysedata.add(thema);
                }
            }
            
            if(inputParameters != null) {
                inputParameters.put("analyse_data", analysedata);
            }
            request.setAttribute("analyse_data", analysedata);
        }
        fillForm(request, inputParameters);
        return mapping.findForward("analysedata");
    }
    
    /**
     * Methode die aangeroepen wordt aan de hand van de button 'bereken' in het analyse tabblad
     * van de viewer. Deze methode stelt een query samen op basis van de gegevens die ingoevoerd
     * zijn door de gebruiker om zo het gewenste resultaat te kunnen tonen.
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
    // <editor-fold defaultstate="" desc="public ActionForward analyseobject(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) method.">
    public ActionForward analyseobject(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Map inputParameters = getInputParameters(mapping, dynaForm, request, response);
        
        ArrayList pks = new ArrayList();
        
        //create relation query
        String relationFunction=null;
        int zoo = 0;
        if (inputParameters.get("zoekOpties_object")!=null)
            zoo = ((Integer)inputParameters.get("zoekOpties_object")).intValue();
        if (zoo == 1)
            relationFunction="Disjoint";
        else if (zoo == 2)
            relationFunction="Within";
        else if (zoo == 3)
            relationFunction="Intersects";
        else
            log.error("Deze analyse/zoek_optie is niet geimplementeerd!");
        
        Map extraCriteria = (Map)inputParameters.get("extraCriteria");
        StringBuffer extraCriteriaString = new StringBuffer();
        Iterator it = extraCriteria.keySet().iterator();
        while(it.hasNext()) {
            String key = (String)it.next();
            String keyvalue = (String)extraCriteria.get(key);
            if(keyvalue != "" && keyvalue != null) {
                extraCriteriaString.append(" and tb1." + key + "='" + keyvalue + "'");
            }
        }
        
        String analyseGeomTabel = (String)inputParameters.get("analyseGeomTabel");
        /* This part of the query is taking to long.
            if (analyseGeomTabel.equalsIgnoreCase("analysegebied_weg")){
                extraCriteriaString.append("and tb2.wegnummer=(select w.prov_nr from beh_10_wwl_m w order by distance(w.the_geom,tb1.the_geom) limit 1)");
            }
         */
        String query= SpatialUtil.hasRelationQuery(
                (String)inputParameters.get("themaGeomTabel"), //tb1
                analyseGeomTabel, //tb2
                relationFunction,
                (String)inputParameters.get("themaGeomIdColumn"),
                (String)inputParameters.get("analyseGeomId"),
                extraCriteriaString.toString());
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        try {
            PreparedStatement statement = connection.prepareStatement(query);
            try {
                ResultSet rs = statement.executeQuery();
                while(rs.next()) {
                    pks.add(rs.getObject((String)inputParameters.get("themaGeomIdColumn")));
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
            List thema_items = SpatialUtil.getThemaData((Themas)inputParameters.get("thema"), true);
            request.setAttribute("thema_items", thema_items);
            request.setAttribute("regels", getThemaObjects((Themas)inputParameters.get("thema"), pks, thema_items));
        }
        fillForm(request, inputParameters);
        return mapping.findForward("doanalyse");
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
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
    // <editor-fold defaultstate="" desc="public ActionForward objectdata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward objectdata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String lagen = request.getParameter("lagen");
        ArrayList objectdata = new ArrayList();
        
        List ctl = getValidThemas(true, null, request);
        if(ctl != null) {
            Iterator it = ctl.iterator();
            while(it.hasNext()) {
                ArrayList thema = new ArrayList();
                Themas t = (Themas) it.next();
                thema.add(t.getNaam());
                
                List thema_items = SpatialUtil.getThemaData(t, true);
                
                List pks = findPks(t, mapping, dynaForm, request);
                List ao = getThemaObjects(t, pks, thema_items);
                if (ao==null)
                    ao = new ArrayList();
                thema.add(ao);
                objectdata.add(thema);
            }
        }
        request.setAttribute("object_data", objectdata);
        
        return mapping.findForward("objectdata");
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
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
    // <editor-fold defaultstate="" desc="public ActionForward admindata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward admindata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(mapping, dynaForm, request);
        
        List thema_items = SpatialUtil.getThemaData(t, true);
        request.setAttribute("thema_items", thema_items);
        
        List pks = null;
        pks = findPks(t, mapping, dynaForm, request);
        
        request.setAttribute("regels", getThemaObjects(t, pks, thema_items));
        
        return mapping.findForward("admindata");
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
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
    // <editor-fold defaultstate="" desc="public ActionForward aanvullendeinfo(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward aanvullendeinfo(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Themas t = getThema(mapping, dynaForm, request);
        
        List thema_items = SpatialUtil.getThemaData(t, false);
        request.setAttribute("thema_items", thema_items);
        
        List pks = getPks(t, dynaForm, request);
        
        request.setAttribute("regels", getThemaObjects(t, pks, thema_items));
        
        return mapping.findForward("aanvullendeinfo");
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
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
    // <editor-fold defaultstate="" desc="public ActionForward metadata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward metadata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(mapping, dynaForm, request);
        request.setAttribute("themas", t);
        return mapping.findForward("metadata");
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!!!
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
    // <editor-fold defaultstate="" desc="protected List getThemaObjects(Themas t, List pks, List thema_items)">
    protected List getThemaObjects(Themas t, List pks, List thema_items) throws SQLException, UnsupportedEncodingException {
        if (t==null)
            return null;
        if (pks==null || pks.isEmpty())
            return null;
        if (thema_items==null || thema_items.isEmpty())
            return null;
        
        ArrayList regels = new ArrayList();
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
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
    // </editor-fold>
    
    /**
     * Een private methode die alle gegevens van het request haalt en controleert op de aanwezig-
     * heid van bepaalde vereiste waarden om een query mee samen te kunnen stellen. Als bepaalde
     * waarden ontbreken zal er een Exception opgeworpen worden.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param form The DynaValidatorForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     *
     * @return an Actionforward object.
     *
     * @throws Exception
     */
    // <editor-fold defaultstate="" desc="private Map getInputParameters(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) method.">
    private Map getInputParameters(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        //Themas t = getThema(mapping, dynaForm, request);
        /*
         * Voordat we gaan beginnen met het samenstellen van een query die aan de juiste zoekparameter voldoet
         * gaan we eerst al deze zoekparameters uit het request halen. Een aantal van deze zoekparameters zijn
         * variabel en afhankelijk van het thema dat geselecteerd is. Om deze waarden met bijbehorende juiste
         * naam te vinden is het eerst belangrijk om met een iterator over alle parameters heen te wandelen.
         */
        String optionInputThemaId = null;
        String geselecteerd_object = null;
        
        int zoekOpties = 0;
        int zoekOpties_object = 0;
        int zoekOpties_waarde = 0;
        
        Map inputParams = new HashMap();
        Map parameterMap = request.getParameterMap();
        
        /*
         * Loop door alle parameters heen die meegegeven worden tijdens het request.
         * Als eerste wordt er door de parameter Map gelopen waarbij er gezocht wordt
         * naar een id voor het thema waar de query op uitgevoerd moet worden. Zodra
         * deze id gevonden is wordt er doorgegaan met het ophalen van de geselecteerde
         * waarde in het drop-down menu in het Analysegebied.
         * Vervolgens wordt de waarde uitgelezen van de radiobuttons die onder het drop
         * down menu geprojecteerd staan. Deze radiobuttons zijn opgedeeld in twee cate-
         * gorieen 'Geef object' en 'Geef waarde'. Vervolgens bestaat deze uit een paar
         * opties.
         */
        if (!parameterMap.isEmpty()) {
            geselecteerd_object = getStringFromParam(parameterMap,"geselecteerd_object");
            inputParams.put("geselecteerd_object", geselecteerd_object);
            
            zoekOpties = Integer.parseInt(getStringFromParam(parameterMap, "zoekopties"));
            inputParams.put("zoekopties", new Integer(zoekOpties));
            if(zoekOpties == 1) {
                String number = getStringFromParam(parameterMap, "zoekopties_object");
                if(number != null) {
                    zoekOpties_object = Integer.parseInt(number);
                    inputParams.put("zoekOpties_object", new Integer(zoekOpties_object));
                }
            } else if (zoekOpties == 2) {
                String number = getStringFromParam(parameterMap, "zoekopties_waarde");
                if(number != null) {
                    zoekOpties_waarde = Integer.parseInt(number);
                    inputParams.put("zoekOpties_waarde", new Integer(zoekOpties_waarde));
                }
            }
        }
        
        /*
         * Na het vinden van de vastgestelde invoerboxen is het nog noodzaak dat de
         * waarden uitgelezen worden van de invoervelden die de gebruiker zelf in kan
         * vullen. Dit wordt hieronder gedaan. Van het betreffende thema wordt gekeken
         * welke themadata dit thema bevat en welke daarvan een basisregel zijn. Ver-
         * volgens wordt de naam van het invoerveld gegenereerd en wordt de waarde
         * die de gebruiker ingevoerd heeft gelezen.
         */
        Map extraCriteria = new HashMap();
        Themas thema = getThema(mapping, dynaForm, request);
        if (thema != null) {
            inputParams.put("thema", thema);
            int themaId = thema.getId();
            Set themaData = thema.getThemaData();
            Iterator themaDataIterator = themaData.iterator();
            while (themaDataIterator.hasNext()) {
                ThemaData td = (ThemaData)themaDataIterator.next();
                int themaDataId = td.getId();
                if(td.isBasisregel()) {
                    String inputValue = "ThemaItem_" + themaId + "_" + themaDataId;
                    String value = getStringFromParam(parameterMap,inputValue);
                    String key = td.getKolomnaam();
                    if (value != null) {
                        extraCriteria.put(key, value);
                    }
                }
            }
        } else {
            throw new Exception("Fout in selectie van thema.");
        }
        
        /*
         * Van de verschillende invoer moet gecontroleerd worden of deze invoer wel voldoet aan de eisen
         * namelijk of bepaalde items wel ingevuld zijn en of deze invoer wel klopt.
         */
        if (geselecteerd_object.equals("-1")) {
            throw new Exception("Er is geen analysegebied geselecteerd");
            //log.error("Er is geen analysegebied geselecteerd");
            //addAlternateMessage(mapping, request, null, "Er is geen analysegebied geselecteerd");
            //return analysedata(mapping, dynaForm, request, response);
        }
        
        String[] tokens = geselecteerd_object.split("_");
        Themas geselecteerdObjectThema = getObjectThema(tokens[1]);
        if (geselecteerdObjectThema == null) {
            throw new Exception("Kan het thema niet vinden");
            //log.error("Kan het thema niet vinden");
            //addAlternateMessage(mapping, request, null, "Kan het thema niet vinden");
            //return analysedata(mapping, dynaForm, request, response);
        }
        
        if (zoekOpties == 0 || (zoekOpties_object == 0 && zoekOpties_waarde == 0)) {
            throw new Exception("Er is geen selectie criterium aangegeven door middel van de radio buttons");
            //log.error("Er is geen selectie criterium aangegeven door middel van de radio buttons");
            //addAlternateMessage(mapping, request, null, "Er is geen selectie criterium aangegeven door middel van de radio buttons");
            //return analysedata(mapping, dynaForm, request, response);
        }
        
        /*
         * Alle eventuele foute invoer van de gebruiker is afgevangen. Nu dienen we te kijken wat
         * we met de verschillende invoer kunnen doen. We beginnen met het thema dat hoort bij de
         * invoervelden, dit is ook het thema waar de uiteindelijke informatie over opgevraagd gaat
         * worden in de database. Opvragen wat voor type object het hier om gaat, namelijk een
         * MULTIPOINT, MULTILINESTRING, MULTIPOLYGON, POLYGON, etc etc.
         */
        String themaGeomTabel   = thema.getSpatial_tabel();
        String themaGeomIdColumn= thema.getSpatial_admin_ref();
        String themaGeomType    = getThemaGeomType(thema);
        
        /*
         * Van het dropdown menu willen we nu nog weten wat voor naam er geselecteerd is, zodat deze
         * in het resultaat weer opgenomen kan worden in de tekst.
         */
        String analyseGeomId        = tokens[2];
        String analyseGeomTabel     = geselecteerdObjectThema.getSpatial_tabel();
        String analyseGeomIdColumn  = geselecteerdObjectThema.getSpatial_admin_ref();
        String analyseNaam          = getAnalyseNaam(analyseGeomId, geselecteerdObjectThema);
        
        /*
         * Stop nu al deze variabelen in de HashMap en return deze HashMap.
         * In de andere methodes kunnen de waarden nu eenvoudig uitgelezen worden.
         */
        inputParams.put("extraCriteria", extraCriteria);
        inputParams.put("themaGeomIdColumn", themaGeomIdColumn);
        inputParams.put("themaGeomTabel", themaGeomTabel);
        inputParams.put("themaGeomType", themaGeomType);
        inputParams.put("analyseGeomId", analyseGeomId);
        inputParams.put("analyseGeomTabel", analyseGeomTabel);
        inputParams.put("analyseGeomIdColumn", analyseGeomIdColumn);
        inputParams.put("analyseNaam", analyseNaam);
        return inputParams;
    }
    // </editor-fold>
    
    
    /**
     * Methode die aangeroepen wordt om de input ingegeven door de gebruiker bij een analyse
     * opdracht opnieuw op het scherm te plaatsen zodat de gebruiker terug kan zien waar ze
     * de analyse op heeft uitgevoerd.
     * Deze methode maakt gebruik van de global variable inputParameters die een Map met alle
     * ingegeven parameters bijhoudt plus alle parameters die afgeleid zijn uit de invoer van
     * de gebruiker.
     *
     * @param request The HTTP Request we are processing.
     */
    // <editor-fold defaultstate="" desc="private void fillForm(HttpServletRequest request) method.">
    private void fillForm(HttpServletRequest request, Map inputParameters) {
        String [] checked = new String[]{null, null, null, null, null, null, null, null, null};
        String [] selection = new String[]{null, null, null, null, null, null, null, null};
        if(inputParameters != null) {
            Map extraCriteria = (Map)inputParameters.get("extraCriteria");
            ArrayList items = new ArrayList();
            if(extraCriteria != null) {
                Themas thema = (Themas) inputParameters.get("thema");
                Set data = thema.getThemaData();
                Iterator dataIterator = data.iterator();
                while(dataIterator.hasNext()) {
                    ThemaData themaData = (ThemaData) dataIterator.next();
                    String kolomNaam = themaData.getKolomnaam();
                    Iterator it = extraCriteria.keySet().iterator();
                    while(it.hasNext()) {
                        String key = (String)it.next();
                        if(key.equalsIgnoreCase(kolomNaam)) {
                            String keyvalue = (String)extraCriteria.get(key);
                            String itemNaam = "ThemaItem_" + thema.getId() + "_" + themaData.getId();
                            String [] item = new String[]{itemNaam, keyvalue};
                            items.add(item);
                            break;
                        }
                    }
                }
            }
            request.setAttribute("items", items);
            
            String selectedObject = (String) inputParameters.get("geselecteerd_object");
            ArrayList analysedata = (ArrayList) inputParameters.get("analyse_data");
            boolean found = false;
            if(analysedata != null) {
                Iterator analysedataIterator = analysedata.iterator();
                int totalLength = analysedata.size();
                selection = new String[totalLength];
                int atPoint = 0;
                while (analysedataIterator.hasNext()) {
                    ArrayList areas = (ArrayList) analysedataIterator.next();
                    Integer mainAreaId = (Integer) areas.get(1);
                    ArrayList subAreas = (ArrayList) areas.get(2);
                    Iterator subAreasIterator = subAreas.iterator();
                    while (subAreasIterator.hasNext()) {
                        Integer subAreaId = (Integer) ((ArrayList)(subAreasIterator.next())).get(0);
                        String selectedName = "ThemaObject_" + mainAreaId + "_" + subAreaId;
                        if(selectedName.equalsIgnoreCase(selectedObject)) {
                            selection[atPoint] = "selected";
                            found = true;
                        }
                        if(found)
                            break;
                    }
                    if(found)
                        break;
                    atPoint++;
                }
            }
            
            Integer optie = (Integer)inputParameters.get("zoekopties");
            if (optie != null) {
                if (optie.intValue() == 1) {
                    checked[0] = "checked";
                    Integer optieObject = (Integer)inputParameters.get("zoekOpties_object");
                    checked[optieObject.intValue()] = "checked";
                } else if (optie.intValue() == 2) {
                    checked[4] = "checked";
                    Integer optieWaarde = (Integer)inputParameters.get("zoekOpties_waarde");
                    checked[4 + optieWaarde.intValue()] = "checked";
                }
            }
            
        }
        request.setAttribute("selection", selection);
        request.setAttribute("checked", checked);
    }
    // </editor-fold>
    
    
}