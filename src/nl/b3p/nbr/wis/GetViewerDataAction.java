package nl.b3p.nbr.wis;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.sql.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.nbr.wis.db.Applicaties;
import nl.b3p.nbr.wis.db.DataTypen;
import nl.b3p.nbr.wis.db.Medewerkers;
import nl.b3p.nbr.wis.db.Onderdeel;
import nl.b3p.nbr.wis.db.Rollen;
import nl.b3p.nbr.wis.db.ThemaApplicaties;
import nl.b3p.nbr.wis.db.ThemaData;
import nl.b3p.nbr.wis.db.ThemaVerantwoordelijkheden;
import nl.b3p.nbr.wis.db.Themas;
import nl.b3p.nbr.wis.services.HibernateUtil;
import nl.b3p.nbr.wis.services.SpatialUtil;
import nl.b3p.nbr.wis.struts.BaseHibernateAction;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Query;
import org.hibernate.Session;

public class GetViewerDataAction extends BaseHibernateAction {
    
    private static final Log log = LogFactory.getLog(GetViewerDataAction.class);
        
    private Map inputParameters = null;
    private List themalist = null;
    
    protected static final String ADMINDATA = "admindata";
    protected static final String ANALYSEDATA = "analysedata";
    protected static final String AANVULLENDEINFO = "aanvullendeinfo";
    protected static final String METADATA = "metadata";
    protected static final String OBJECTDATA = "objectdata";
    protected static final String ANALYSEWAARDE = "analysewaarde";
    protected static final String ANALYSEOBJECT = "analyseobject";
        
    /** 
     * Return een hashmap die een property koppelt aan een Action.
     *
     * @return Map hashmap met action properties.
     */
    // <editor-fold defaultstate="" desc="protected Map getActionMethodPropertiesMap()">
    protected Map getActionMethodPropertiesMap() {
        Map map = new HashMap();
        
        ExtendedMethodProperties hibProp = null;
        hibProp = new ExtendedMethodProperties(ADMINDATA);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.admindata.failed");
        map.put(ADMINDATA, hibProp);
        
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
        
        hibProp = new ExtendedMethodProperties(ANALYSEWAARDE);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.analysewaarde.failed");
        map.put(ANALYSEWAARDE, hibProp);
        
        hibProp = new ExtendedMethodProperties(METADATA);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.metadata.failed");
        map.put(METADATA, hibProp);
        
        hibProp = new ExtendedMethodProperties(OBJECTDATA);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.objectdata.failed");
        map.put(OBJECTDATA, hibProp);
        
        hibProp = new ExtendedMethodProperties(AANVULLENDEINFO);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.aanvullende.failed");
        map.put(AANVULLENDEINFO, hibProp);
        
        return map;
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
        try {
            inputParameters = this.getInputParameters(mapping, dynaForm, request, response);
        } catch (Exception e) {
            String message = e.getMessage();
            log.error(message);
            //addAlternateMessage(mapping, request, null, message); 
            throw(e);
        }
        
        //Alle invoervelden zijn bekend en door de verschillende controleprocedures gekomen
        //om een juiste query uit te kunnen voeren.        
        Object [] value = null;
        //if ((Integer)inputParameters.get("zoekOpties") == 2) {
            if ((Integer)inputParameters.get("zoekOpties_waarde") == 1){
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){ value = new Object[]{"LINESTRING", "max", 1000, "Grootste lengte(km)", "result"}; }
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){ value = new Object[]{"POLYGON", "max", 1000000, "Grootste oppervlakte(km2)", "result"}; }
            }
            if ((Integer)inputParameters.get("zoekOpties_waarde") == 2){
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){ value = new Object[]{"LINESTRING", "min", 1000, "Kleinste lengte(km)", "result"}; }
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){ value = new Object[]{"POLYGON", "min", 1000000, "Kleinste oppervlakte(km2)", "result"}; }
            }
            if ((Integer)inputParameters.get("zoekOpties_waarde") == 3){
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){ value = new Object[]{"LINESTRING", "avg", 1000, "Gemiddelde lengte(km)", "result"}; }
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){ value = new Object[]{"POLYGON", "avg", 1000000, "Gemiddelde oppervlakte(km2)", "result"}; }
            }
            if ((Integer)inputParameters.get("zoekOpties_waarde") == 4){
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTIPOINT)){ value = new Object[]{"POINT", "count(*)", null, "Aantal", "count"}; }
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){ value = new Object[]{"LINESTRING", "sum", 1000, "Totale lengte(km)", "result"}; }
                if (((String)inputParameters.get("themaGeomType")).equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){ value = new Object[]{"POLYGON", "sum", 1000000, "Totale oppervlakte(km2)", "result"}; }
            }
        
        //}
        
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
        if (value != null) {
            String query = null;
            if(value[0].equals("POINT")) {
                query = SpatialUtil.containsQuery(
                        (String) value[1], 
                        (String)inputParameters.get("analyseGeomTabel"), 
                        (String)inputParameters.get("themaGeomTabel"), 
                        (String)inputParameters.get("analyseGeomIdColumn"), 
                        (String)inputParameters.get("analyseGeomId"), 
                        extraCriteriaString.toString());
            } else if(value[0].equals("LINESTRING")) {
                query = SpatialUtil.intersectionLength(
                        (String) value[1], 
                        (String)inputParameters.get("themaGeomTabel"), 
                        (String)inputParameters.get("analyseGeomTabel"), 
                        (String)inputParameters.get("analyseGeomId"), 
                        (Integer) value[2], 
                        extraCriteriaString.toString());
            } else if(value[0].equals("POLYGON")) {
                query = SpatialUtil.intersectionArea(
                        (String) value[1], 
                        (String)inputParameters.get("themaGeomTabel"), 
                        (String)inputParameters.get("analyseGeomTabel"), 
                        (String)inputParameters.get("analyseGeomId"), 
                        (Integer) value[2], 
                        extraCriteriaString.toString());
            }
            
            log.info(query);
            result.append("<b>" + value[3] + " " + ((Themas)inputParameters.get("thema")).getNaam());
            
            if ((String)inputParameters.get("analyseNaam")!=null){
                result.append(" in " + (String)inputParameters.get("analyseNaam"));
            }
            result.append(":");
            
            executeQuery(query, sess, result, new String[]{(String)value[4]});                                            
            result.append("</b>");
        } else {
            result.append("<b>Niet mogelijk met dit thema-geometry-type<br/></b>");
        }
        
        request.setAttribute("waarde", result.toString());
        return analysedata(mapping, dynaForm, request, response);
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
            inputParams.put("zoekopties", zoekOpties);
            if(zoekOpties == 1) {
                String number = getStringFromParam(parameterMap, "zoekopties_object");
                if(number != null) {
                    zoekOpties_object = Integer.parseInt(number);
                    inputParams.put("zoekOpties_object", zoekOpties_object);
                }
            } else if (zoekOpties == 2) {
                String number = getStringFromParam(parameterMap, "zoekopties_waarde");
                if(number != null) {
                    zoekOpties_waarde = Integer.parseInt(number);
                    inputParams.put("zoekOpties_waarde", zoekOpties_waarde);
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
        String themaGeomType    = getThemaGeomType(themaGeomTabel);        
        if (themaGeomType == null){
            throw new Exception("Kan het type geo-object niet vinden: " + thema.getNaam());
            //log.error("Kan het type geo-object niet vinden: " + thema.getNaam());
            //addAlternateMessage(mapping, request, null, "Kan het type geo-object niet vinden.");
            //return analysedata(mapping, dynaForm, request, response);
        }       
        
        /* 
         * Van het dropdown menu willen we nu nog weten wat voor naam er geselecteerd is, zodat deze
         * in het resultaat weer opgenomen kan worden in de tekst.
         */
        String analyseGeomId        = tokens[2];
        String analyseGeomTabel     = geselecteerdObjectThema.getSpatial_tabel();
        String analyseGeomIdColumn  = geselecteerdObjectThema.getSpatial_admin_ref();        
        String analyseNaam          = getAnalyseNaam(analyseGeomTabel, analyseGeomIdColumn, analyseGeomId, geselecteerdObjectThema.getId(), geselecteerdObjectThema.getNaam());        
        if (analyseNaam == null){
            throw new Exception("Kan het type geo-object niet vinden: " + geselecteerdObjectThema.getNaam());
            //log.error("Kan het type geo-object niet vinden: " + geselecteerdObjectThema.getNaam());
            //addAlternateMessage(mapping, request, null, "Kan het type geo-object niet vinden.");
            //return analysedata(mapping, dynaForm, request, response);
        }
        
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
     * Een private methode die het Thema Geometry type ophaalt uit de database.
     *
     * @param themaGeomTabel De table for which the Geometry type is requested.
     *
     * @return a String with the Geometry type.
     *
     */
    // <editor-fold defaultstate="" desc="private String getThemaGeomType(String themaGeomTabel) method.">
    private String getThemaGeomType(String themaGeomTabel) {
        String themaGeomType = null;
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        String q = "select * from geometry_columns gc where gc.f_table_name = '" + themaGeomTabel + "'";
        try {
            PreparedStatement statement = connection.prepareStatement(q);
            try {
                ResultSet rs = statement.executeQuery();
                if (rs.next()){
                    themaGeomType=rs.getString("type");
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
        return themaGeomType;
    }
    // </editor-fold>
        
    /**
     * Een private methode die de Analysenaam van een bepaalde tabel en kolom samenstelt met
     * de opgegeven waarden.
     *
     * @param analyseGeomTabel De table for which the analysename is requested.
     * @param analyseGeomIdColumn De column for which the analysename is requested.
     * @param analyseGeomId De id for which the analysename is requested.
     *
     * @return a String with the analysename.
     *
     */
    // <editor-fold defaultstate="" desc="private String getAnalyseNaam(String analyseGeomTabel, String analyseGeomIdColumn, String analyseGeomId) method.">
    private String getAnalyseNaam(String analyseGeomTabel, String analyseGeomIdColumn, String analyseGeomId, int themaid, String themaNaam) {
        String analyseNaam= themaNaam;
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        try {
            PreparedStatement statement = 
                    connection.prepareStatement("select * from "+analyseGeomTabel+ " where "+analyseGeomIdColumn+" = "+analyseGeomId);
            PreparedStatement statement2 = 
                    connection.prepareStatement("select kolomnaam from thema_data where thema = "+themaid+" order by dataorder");
            
            try {
                ResultSet rs = statement.executeQuery();
                ResultSet rs2 = statement2.executeQuery();
                if (rs.next() && rs2.next()){
                    if(rs2.next()){
                        String extraString = rs.getString(rs2.getString("kolomnaam"));
                        if (extraString != null) {
                            analyseNaam+=" "+ extraString;
                        }
                    }
                }
            } finally {
                statement.close();
                statement2.close();
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
        return analyseNaam;
    }
    // </editor-fold>
    
    /**
     * Een private methode het object thema ophaalt dat hoort bij een bepaald id.
     *
     * @param identifier String which identifies the object thema to be found.
     *
     * @return a Themas object representing the object thema.
     *
     */
    // <editor-fold defaultstate="" desc="private Themas getObjectThema(String identifier) method.">
    private Themas getObjectThema(String identifier) {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Themas objectThema = null;
        try {
            Integer id  = Integer.parseInt(identifier);
            objectThema =(Themas)sess.get(Themas.class, id);
        } catch(NumberFormatException nfe) {
            objectThema = (Themas)sess.get(Themas.class, identifier);
        }
        return objectThema;
    }
    // </editor-fold>
    
    /** 
     * DOCUMENT ME!!!
     *
     * @param query String
     * @param sess Session
     * @param result StringBuffer
     * @param columns String[]
     */
    // <editor-fold defaultstate="" desc="private void executeQuery(String query, Session sess, StringBuffer result, String[] columns)">
    private void executeQuery(String query, Session sess, StringBuffer result, String[] columns){
        Connection connection = sess.connection();
        try {
            PreparedStatement statement = connection.prepareStatement(query);
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()){
                    for (int i=0; i < columns.length; i++){
                        result.append("<br/>");
                        Object resultObject=rs.getObject(columns[i]);
                        if (resultObject instanceof java.lang.Double){
                            double resultDouble=((Double)resultObject).doubleValue();
                            resultDouble*=100;
                            resultDouble=Math.round(resultDouble);
                            resultDouble/=100;
                            result.append(resultDouble);
                        }else{
                            result.append(resultObject);
                        }
                    }
                    result.append("<br/>");
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
    }
    // </editor-fold>
    
    /** 
     * DOCUMENT ME!!!
     *
     * @param params Map
     * @param key String
     *
     * @return String
     */
    // <editor-fold defaultstate="" desc="private String getStringFromParam(Map params, String key)">
    private String getStringFromParam(Map params, String key){
        Object ob = params.get(key);
        String zoekopties_waarde = null;
        String string = null;
        if (ob instanceof String)
            string = (String)ob;
        if (ob instanceof String[])
            string = ((String[])ob)[0]; 
        return string;
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
    // <editor-fold defaultstate="" desc="public ActionForward analyseobject(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) method.">
    public ActionForward analyseobject(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        try {
            inputParameters = this.getInputParameters(mapping, dynaForm, request, response);
        } catch (Exception e) {
            String message = e.getMessage();
            log.error(message);
            addAlternateMessage(mapping, request, null, message);
            //return analysedata(mapping, dynaForm, request, response);
        }
        
        ArrayList pks = new ArrayList();

        //create relation query
        String relationFunction=null;
        //String test = (String) inputParameters.get("zoekOpties_object");
        if ((Integer)inputParameters.get("zoekOpties_object") == 1)
            relationFunction="Disjoint";                                    
        else if ((Integer)inputParameters.get("zoekOpties_object") == 2)
            relationFunction="Within";
        else if ((Integer)inputParameters.get("zoekOpties_object") == 3)
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
//      
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
        this.fillForm(request);
        return mapping.findForward("doanalyse");
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
    // <editor-fold defaultstate="" desc="public ActionForward analysedata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward analysedata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(mapping, dynaForm, request);
        if (t!=null){
            List thema_items = SpatialUtil.getThemaData(t, true);
            request.setAttribute("thema_items", thema_items);

            String lagen = request.getParameter("lagen");
            request.setAttribute(Themas.THEMAID, t.getId());
            request.setAttribute("lagen", lagen);
            request.setAttribute("xcoord", request.getParameter("xcoord"));
            request.setAttribute("ycoord", request.getParameter("ycoord"));
            

            Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
            List ctl = null;
            String hquery = "FROM Themas WHERE locatie_thema = true AND (moscow = 1 OR moscow = 2 OR moscow = 3) AND code < 3";
    //        if(!lagen.equals("ALL")) {
    //            hquery += " AND (";
    //            String[] alleLagen = lagen.split(",");
    //            boolean firstTime = true;
    //            for(int i = 0; i < alleLagen.length; i++) {
    //                if(firstTime) {
    //                    hquery += "id = " + alleLagen[i];
    //                    firstTime = false;
    //                } else {
    //                    hquery += " OR id = " + alleLagen[i];
    //                }
    //            }
    //            hquery += ")";
    //        }

            ArrayList analysedata = new ArrayList();
            Query q = sess.createQuery(hquery);
            ctl = q.list();
            if(ctl != null) {
                Iterator it = ctl.iterator();
                while(it.hasNext()) {
                    ArrayList thema = new ArrayList();
                    Themas tt = (Themas) it.next();
                    thema.add(tt.getNaam());
                    thema.add(tt.getId());

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
        this.fillForm(request);
        return mapping.findForward("analysedata");
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
    private void fillForm(HttpServletRequest request) {
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
    
    /** 
     * DOCUMENT ME!!!
     *
     * @param t Themas
     * @param mapping ActionMapping
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     *
     * @return List
     *
     * @throws Exception
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="protected List findPks(Themas t, ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request)">
    protected List findPks(Themas t, ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
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
        }
        catch (NumberFormatException nfe){
            scale=0.0;
            log.info("Scale is geen double dus wordt genegeerd");
        }
        double x = Double.parseDouble(xcoord);
        double y = Double.parseDouble(ycoord);
        double distance=10.0;
        if (scale> 0.0){
            distance=scale*(distance);
        }            
        else{
            distance = 10.0;
        }
        int srid = 28992; // RD-new
        
        ArrayList pks = new ArrayList();
        
        String saf = t.getSpatial_admin_ref();
        if (saf==null || saf.length()==0)
            return null;
        String sptn = t.getSpatial_tabel();
        if (sptn==null || sptn.length()==0)
            return null;
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        try {
            String q = SpatialUtil.InfoSelectQuery(saf, sptn, x, y, distance, srid);
            
            PreparedStatement statement = connection.prepareStatement(q);
            try {
                ResultSet rs = statement.executeQuery();
                while(rs.next()) {
                    pks.add(rs.getObject(saf));
                }
            } finally {
                statement.close();
            }
        } finally {
            connection.close();
        }
        return pks;
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
//      pks = getPks(t, dynaForm, request);
//        pks = new ArrayList();
//        pks.add("639YCHA");
        
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
     *
     * @return ActionForward
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="protected Themas getThema(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request)">
    protected Themas getThema(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) {
        String themaid = request.getParameter(Themas.THEMAID);
        return getThema(themaid);
    }
    // </editor-fold>
    
    /** 
     * DOCUMENT ME!!!
     *
     * @param themaid String
     *
     * @return Themas
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="protected Themas getThema(String themaid)">
    protected Themas getThema(String themaid){
        if (themaid==null || themaid.length()==0){
            return null;
        }
        Integer id = new Integer(themaid);
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Themas t = (Themas)sess.get(Themas.class, id);
        return t;
    }
    // </editor-fold>
    
    /** 
     * DOCUMENT ME!!!
     *
     * @param rs ResultSet
     * @param t Themas
     * @param thema_items List
     *
     * @return List
     *
     * @throws SQLException, UnsupportedEncodingException
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="protected List getRegel(ResultSet rs, Themas t, List thema_items)">
    protected List getRegel(ResultSet rs, Themas t, List thema_items) throws SQLException, UnsupportedEncodingException  {
        ArrayList regel = new ArrayList();
        
        Iterator it = thema_items.iterator();
        while(it.hasNext()) {
            ThemaData td = (ThemaData) it.next();
            if (td.getDataType().getId()==DataTypen.DATA && td.getKolomnaam()!=null) {
                String kn = td.getKolomnaam();
                Object retval = null;
                retval = rs.getObject(kn);
                regel.add(retval);                
            } else if (td.getDataType().getId()==DataTypen.URL) {
                StringBuffer url = new StringBuffer(td.getCommando());
                url.append(Themas.THEMAID);
                url.append("=");
                url.append(t.getId());
                
                String adminPk = t.getAdmin_pk();
                url.append("&");
                url.append(adminPk);
                url.append("=");
                url.append(URLEncoder.encode((rs.getObject(adminPk)).toString().trim(), "utf-8"));
                
                String kolomnaam= td.getKolomnaam();
                if (kolomnaam!=null && kolomnaam.length()>0){
                    url.append("&");
                    url.append(kolomnaam);
                    url.append("=");
                    url.append(URLEncoder.encode((rs.getObject(kolomnaam)).toString().trim(), "utf-8"));                    
                }
                regel.add(url.toString());
            } else if (td.getDataType().getId()==DataTypen.QUERY) {
                StringBuffer url = new StringBuffer(td.getCommando());
                String kolomnaam = td.getKolomnaam();//t.getAdmin_pk();
                url.append(URLEncoder.encode((rs.getObject(kolomnaam)).toString().trim(), "utf-8"));
                
                regel.add(url.toString());
            } else
                regel.add("");
        }
        return regel;
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
     * DOCUMENT ME!!!
     *
     * @param t Themas
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     *
     * @return List
     *
     * @throws SQLException
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="protected List getPks(Themas t, DynaValidatorForm dynaForm, HttpServletRequest request)">
    protected List getPks(Themas t, DynaValidatorForm dynaForm, HttpServletRequest request) throws SQLException {
        ArrayList pks = new ArrayList();
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        int dt = SpatialUtil.getPkDataType( t, connection);
        String adminPk = t.getAdmin_pk();
        switch (dt) {
            case java.sql.Types.SMALLINT:
                pks.add(new Short(request.getParameter(adminPk)));
                break;
            case java.sql.Types.INTEGER:
                pks.add(new Integer(request.getParameter(adminPk)));
                break;
            case java.sql.Types.BIGINT:
                pks.add(new Long(request.getParameter(adminPk)));
                break;
            case java.sql.Types.BIT:
                pks.add(new Boolean(request.getParameter(adminPk)));
                break;
            case java.sql.Types.DATE:
//                pks.add(new Date(request.getParameter(adminPk)));
                break;
            case java.sql.Types.DECIMAL:
            case java.sql.Types.NUMERIC:
                pks.add(new BigDecimal(request.getParameter(adminPk)));
                break;
            case java.sql.Types.REAL:
                pks.add(new Float(request.getParameter(adminPk)));
                break;
            case java.sql.Types.FLOAT:
            case java.sql.Types.DOUBLE:
                pks.add(new Double(request.getParameter(adminPk)));
                break;
            case java.sql.Types.TIME:
//                pks.add(new Time(request.getParameter(adminPk)));
                break;
            case java.sql.Types.TIMESTAMP:
//                pks.add(new Timestamp(request.getParameter(adminPk)));
                break;
            case java.sql.Types.TINYINT:
                pks.add(new Byte(request.getParameter(adminPk)));
                break;
            case java.sql.Types.CHAR:
            case java.sql.Types.LONGVARCHAR:
            case java.sql.Types.VARCHAR:
                pks.add(request.getParameter(adminPk));
                break;
            case java.sql.Types.NULL:
            default:
                return null;
        }
        return pks;
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
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        List ctl = null;
        String hquery = "FROM Themas WHERE locatie_thema = true AND (moscow = 1 OR moscow = 2 OR moscow = 3) AND code < 3";
        
        Query q = sess.createQuery(hquery);
        ctl = q.list();
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
    // <editor-fold defaultstate="" desc="public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)">
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return mapping.findForward(SUCCESS);
    }
    // </editor-fold>
}