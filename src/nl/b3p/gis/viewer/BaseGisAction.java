/**
 * @(#)BaseGisAction.java
 * @author Chris van Lith
 *
 * Purpose: a class handling security and general purpose methods.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer;

import com.vividsolutions.jump.feature.Feature;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.transaction.NotSupportedException;
import nl.b3p.gis.viewer.db.Clusters;
import nl.b3p.gis.viewer.db.DataTypen;
import nl.b3p.gis.viewer.db.ThemaData;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.db.WaardeTypen;
import nl.b3p.gis.viewer.services.GisPrincipal;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.gis.viewer.struts.BaseHibernateAction;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Session;

public abstract class BaseGisAction extends BaseHibernateAction {
    
    private static final Log log = LogFactory.getLog(BaseGisAction.class);
    
    
    protected void createLists(DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        // zet kaartenbalie url
        request.setAttribute("kburl", HibernateUtil.KBURL);
    }
    
    /**
     * Haal een Thema op uit de database door middel van een in het request meegegeven thema id.
     *
     * @param mapping ActionMapping
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     *
     * @return Themas
     *
     * @see Themas
     */
    protected Themas getThema(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) {
        String themaid = (String)request.getParameter("themaid");
        Themas t = SpatialUtil.getThema(themaid);
        
        if (!HibernateUtil.CHECK_LOGIN_KAARTENBALIE)
            return t;
        
        // Zoek layers die via principal binnen komen
        GisPrincipal user = GisPrincipal.getGisPrincipal(request);
        if (user==null)
            return null;
        List layersFromRoles = user.getLayerNames(false);
        if (layersFromRoles==null)
            return null;
        
        // Check de rechten op alle layers uit het thema
        if (!checkThemaLayers(t,  layersFromRoles))
            return null;
        
        return t;
    }
    
    /**
     * Indien een cluster wordt meegegeven dan voegt deze functie ook de layers
     * die niet als thema geconfigureerd zijn, maar toch als role aan de principal
     * zijn meegegeven als dummy thema toe. Als dit niet de bedoeling is dan
     * dient null als cluster meegegeven te worden.
     *
     * @param locatie
     * @param request
     * @return
     */
    protected List getValidThemas(boolean locatie, List ctl, HttpServletRequest request) {
        List configuredThemasList = SpatialUtil.getValidThemas(locatie);
        // Als geen check via kaartenbalie dan alle layers doorgeven
        if (!HibernateUtil.CHECK_LOGIN_KAARTENBALIE)
            return configuredThemasList;
        
        // Zoek layers die via principal binnen komen
        GisPrincipal user = GisPrincipal.getGisPrincipal(request);
        if (user==null)
            return null;
        List layersFromRoles = user.getLayerNames(false);
        if (layersFromRoles==null)
            return null;
        
        // Voeg alle themas toe die layers hebben die volgens de rollen
        // acceptabel zijn (voldoende rechten dus).
        List layersFound = new ArrayList();
        List checkedThemaList = new ArrayList();
        if (configuredThemasList!=null) {
            Iterator it2 = configuredThemasList.iterator();
            while(it2.hasNext()) {
                Themas t = (Themas)it2.next();
                if (checkThemaLayers(t,  layersFromRoles)) {
                    checkedThemaList.add(t);
                    layersFound.add(t.getWms_layers_real());
                }
            }
        }
        
        // Als geen cluster dan hier stoppen.
        if (ctl==null)
            return checkedThemaList;
        
        //maak alvast een cluster aan voor als er kaarten worden gevonden die geen thema hebben.
        Clusters c = new Clusters();
        c.setNaam(HibernateUtil.KAARTENBALIE_CLUSTER);
        c.setParent(null);
        
        Iterator it = layersFromRoles.iterator();
        int tid = 100000;
        ArrayList extraThemaList = new ArrayList();
        // Kijk welke lagen uit de rollen nog niet zijn toegevoegd
        // en voeg deze alsnog toe via dummy thema en cluster.
        while (it.hasNext()) {
            String layer = (String)it.next();
            if (layersFound.contains(layer))
                continue;
            
            // Layer bestaat nog niet dus aanmaken
            Themas t = new Themas();
            t.setId(new Integer(tid++));
            t.setNaam(user.getLayerTitle(layer));
            t.setWms_layers_real(layer);
            t.setWms_legendlayer_real(layer);
            t.setCluster(c);
            // voeg extra laag als nieuw thema toe
            extraThemaList.add(t);
        }
        if (extraThemaList.size()>0){
            ctl.add(c);
            for (int i=0; i < extraThemaList.size(); i++){
                checkedThemaList.add(extraThemaList.get(i));
            }
        }        
        
        return checkedThemaList;
    }
    
    /**
     * Voeg alle layers samen voor een thema en controleer of de gebruiker
     * voor alle layers rechten heeft. Zo nee, thema niet toevoegen.
     * @param t
     * @param request
     * @return
     */
    protected boolean checkThemaLayers(Themas t,  List acceptableLayers) {
        if (t==null || acceptableLayers==null)
            return false;
        String wmsls = t.getWms_layers_real();
        if (wmsls==null || wmsls.length()==0)
            return false;
        
        // Dit is te streng alleen op wms layer checken
//        String wmsqls = t.getWms_querylayers_real();
//        if (wmsqls!=null && wmsqls.length()>0)
//            wmsls += "," + wmsqls;
//        String wmslls = t.getWms_legendlayer_real();
//        if (wmslls!=null && wmslls.length()>0)
//            wmsls += "," + wmslls;
        
        String[] wmsla = wmsls.split(",");
        for (int i=0; i<wmsla.length; i++) {
            if(!acceptableLayers.contains(wmsla[i]))
                return false;
        }
        return true;
    }
    
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
    protected List getPks(Themas t, DynaValidatorForm dynaForm, HttpServletRequest request) throws SQLException, NotSupportedException {
        ArrayList pks = new ArrayList();
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = null;
        if (t.getConnectie()!=null){            
            connection=t.getConnectie().getJdbcConnection();
        }
        if (connection==null)
            connection=sess.connection();
        
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
        } catch (NumberFormatException nfe){
            scale=0.0;
            log.info("Scale is geen double dus wordt genegeerd");
        }
        double x = Double.parseDouble(xcoord);
        double y = Double.parseDouble(ycoord);
        double distance=10.0;
        if (scale> 0.0){
            distance=scale*(distance);
        } else{
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
        Connection connection = null;
        if (t.getConnectie()!=null){            
            connection=t.getConnectie().getJdbcConnection();
        }
        if (connection==null)
            connection=sess.connection();
        
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
     * Een protected methode het object thema ophaalt dat hoort bij een bepaald id.
     *
     * @param identifier String which identifies the object thema to be found.
     *
     * @return a Themas object representing the object thema.
     *
     */
    // <editor-fold defaultstate="" desc="private Themas getObjectThema(String identifier) method.">
    protected Themas getObjectThema(String identifier) {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Themas objectThema = null;
        try {
            int id  = Integer.parseInt(identifier);
            objectThema =(Themas)sess.get(Themas.class, new Integer(id));
        } catch(NumberFormatException nfe) {
            objectThema = (Themas)sess.get(Themas.class, identifier);
        }
        return objectThema;
    }
    // </editor-fold>
    
    
    /**
     * Een protected methode die het Thema Geometry type ophaalt uit de database.
     *
     * @param themaGeomTabel De table for which the Geometry type is requested.
     *
     * @return a String with the Geometry type.
     *
     */
    protected String getThemaGeomType(Themas thema) throws Exception {
        String themaGeomType = thema.getView_geomtype();
        if (themaGeomType!=null)
            return themaGeomType;
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = null;
        if (thema.getConnectie()!=null){            
            connection=thema.getConnectie().getJdbcConnection();
        }
        if (connection==null)
            connection=sess.connection();
        return SpatialUtil.getThemaGeomType(thema, connection);
    }
    
    /**
     * Een protected methode die de Analysenaam van een bepaalde tabel en kolom samenstelt met
     * de opgegeven waarden.
     *
     * @param analyseGeomTabel De table for which the analysename is requested.
     * @param analyseGeomIdColumn De column for which the analysename is requested.
     * @param analyseGeomId De id for which the analysename is requested.
     *
     * @return a String with the analysename.
     *
     */
    protected String getAnalyseNaam(String analyseGeomId, Themas t) throws NotSupportedException, SQLException {
        
        String analyseGeomTabel     = t.getSpatial_tabel();
        String analyseGeomIdColumn  = t.getSpatial_admin_ref();
        int themaid = t.getId().intValue();
        
        String analyseNaam= t.getNaam();
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = null;
        if (t.getConnectie()!=null){            
            connection=t.getConnectie().getJdbcConnection();
        }
        if (connection==null)
            connection=sess.connection();
        try {
            PreparedStatement statement =
                    connection.prepareStatement("select * from "+analyseGeomTabel+
                    " where "+analyseGeomIdColumn+" = "+analyseGeomId);
            PreparedStatement statement2 =
                    connection.prepareStatement("select kolomnaam from thema_data where thema = "+
                    themaid+" order by dataorder");
            
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
        
//        if (analyseNaam == null){
//            throw new Exception("Kan het type geo-object niet vinden: " + t.getNaam());
//        }
        
        return analyseNaam;
    }
    
    /**
     * DOCUMENT ME!!!
     *
     * @param query String
     * @param sess Session
     * @param result StringBuffer
     * @param columns String[]
     */
    // <editor-fold defaultstate="" desc="private void executeQuery(String query, Session sess, StringBuffer result, String[] columns)">
    protected void executeQuery(String query, Session sess, StringBuffer result, String[] columns, Themas t) throws NotSupportedException, SQLException{
        Connection connection = null;
        if (t.getConnectie()!=null){            
            connection=t.getConnectie().getJdbcConnection();
        }
        if (connection==null)
            connection=sess.connection();
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
     * @param rs ResultSet
     * @param t Themas
     * @param thema_items List
     *
     * @return List
     *
     * @throws SQLException
     * @throws UnsupportedEncodingException
     *
     * @see Themas
     */
    protected List getRegel(ResultSet rs, Themas t, List thema_items) throws SQLException, UnsupportedEncodingException  {
        ArrayList regel = new ArrayList();
        
        Iterator it = thema_items.iterator();
        while(it.hasNext()) {
            ThemaData td = (ThemaData) it.next();
            /*
             * Controleer eerst om welk datatype dit themadata object om draait.
             * Binnen het Datatype zijn er drie mogelijkheden, namelijk echt data,
             * een URL of een Query.
             * In alle drie de gevallen moeten er verschillende handelingen verricht
             * worden om deze informatie op het scherm te krijgen.
             *
             * In het eerste geval, wanneer het gaat om data, betreft dit de kolomnaam.
             * Als deze kolomnaam ingevuld staat hoeft deze alleen opgehaald te worden
             * en aan de arraylist regel toegevoegd te worden.
             */
            if (td.getDataType().getId() == DataTypen.DATA && td.getKolomnaam() != null && !td.getKolomnaam().equals("")) {
                regel.add(rs.getObject(td.getKolomnaam()));
                
            /*
             * In het tweede geval dient de informatie in de thema data als link naar een andere
             * informatiebron. Deze link zal enigszins aangepast moeten worden om tot vollende
             * werkende link te dienen.
             */
            } else if (td.getDataType().getId() == DataTypen.URL) {
                StringBuffer url = new StringBuffer(td.getCommando());
                url.append(Themas.THEMAID);
                url.append("=");
                url.append(t.getId());
                
                String adminPk = t.getAdmin_pk();
                Object value = rs.getObject(adminPk);
                if (value!=null) {
                    url.append("&");
                    url.append(adminPk);
                    url.append("=");
                    url.append(URLEncoder.encode(value.toString().trim(), "utf-8"));
                }
                
                String kolomNaam = td.getKolomnaam();
                if (kolomNaam!=null && kolomNaam.length()>0 && !kolomNaam.equalsIgnoreCase(adminPk)) {
                    value = rs.getObject(kolomNaam);
                    if (value!=null) {                    
                        url.append("&");
                        url.append(kolomNaam);
                        url.append("=");
                        url.append(URLEncoder.encode(value.toString().trim(), "utf-8"));
                    }
                }
                
                regel.add(url.toString());
                
            /*
             * De laatste mogelijkheid betreft een query. Vanuit de themadata wordt nu een
             * een commando url opgehaald en deze wordt met de kolomnaam aangevuld.
             */
            } else if (td.getDataType().getId()==DataTypen.QUERY) {
                StringBuffer url = new StringBuffer(td.getCommando());
                String kolomNaam = td.getKolomnaam();
                if (kolomNaam==null || kolomNaam.length()==0)
                    kolomNaam = t.getAdmin_pk();
                Object value = rs.getObject(kolomNaam);
                if (value!=null) {
                    url.append(value.toString().trim());
                    regel.add(url.toString());
                } else
                    regel.add("");
            }else if (td.getDataType().getId()==DataTypen.FUNCTION){
                StringBuffer function = new StringBuffer(td.getCommando());
                function.append("(this, ");                
                String kolomNaam = td.getKolomnaam();
                if (kolomNaam==null || kolomNaam.length()==0)
                    kolomNaam = t.getAdmin_pk();
                Object value = rs.getObject(kolomNaam);
                if (value!=null) {
                    function.append("'"+td.getThema().getId()+"'");
                    function.append(",");
                    function.append("'"+kolomNaam+"'");
                    function.append(",");
                    function.append("'"+value+"'");
                    function.append(",");
                    function.append("'"+td.getEenheid()+"'");
                    function.append(")");
                    regel.add(function.toString());
                }else{
                    regel.add("");
                }
                
            } else
                
            /*
             * Indien een datatype aan geen van de voorwaarden voldoet wordt er een
             * lege regel aan de regel arraylist toegevoegd.
             */
                regel.add("");
        }
        return regel;
    }
    /**
     * Zelfde als getRegel met Resultset maar nu met Feature
     *
     * @param rs ResultSet
     * @param t Themas
     * @param thema_items List
     *
     * @return List
     *
     * @throws SQLException
     * @throws UnsupportedEncodingException
     *
     * @see Themas
     */
    protected List getRegel(Feature f, Themas t, List thema_items) throws SQLException, UnsupportedEncodingException  {
        ArrayList regel = new ArrayList();
        
        Iterator it = thema_items.iterator();
        while(it.hasNext()) {
            ThemaData td = (ThemaData) it.next();
            /*
             * Controleer of de kolomnaam van dit themadata object wel voorkomt in de feature.
             * zoniet kan het zijn dat er een prefix ns in staat. Die moet er dan van afgehaald worden. 
             * Als het dan nog steeds niet bestaat: een lege toevoegen.
             */
            String kolomnaam=td.getKolomnaam();
            if (!f.getSchema().hasAttribute(kolomnaam) && kolomnaam!=null){
                if (kolomnaam.split(":").length>1){
                    kolomnaam=kolomnaam.split(":")[1];
                }
            }
            if (!f.getSchema().hasAttribute(kolomnaam)&& kolomnaam!=null){
                regel.add("");
            }
            /*
             * Controleer om welk datatype dit themadata object om draait.
             * Binnen het Datatype zijn er drie mogelijkheden, namelijk echt data,
             * een URL of een Query.
             * In alle drie de gevallen moeten er verschillende handelingen verricht
             * worden om deze informatie op het scherm te krijgen.
             *
             * In het eerste geval, wanneer het gaat om data, betreft dit de kolomnaam.
             * Als deze kolomnaam ingevuld staat hoeft deze alleen opgehaald te worden
             * en aan de arraylist regel toegevoegd te worden.
             */
            else if (td.getDataType().getId() == DataTypen.DATA && kolomnaam != null && !kolomnaam.equals("")) {
                          
                regel.add(f.getString(kolomnaam));
                
            /*
             * In het tweede geval dient de informatie in de thema data als link naar een andere
             * informatiebron. Deze link zal enigszins aangepast moeten worden om tot vollende
             * werkende link te dienen.
             */
            } else if (td.getDataType().getId() == DataTypen.URL) {
                StringBuffer url = new StringBuffer(td.getCommando());
                url.append(Themas.THEMAID);
                url.append("=");
                url.append(t.getId());
                
                String adminPk = t.getAdmin_pk();
                Object value = f.getString(adminPk);
                if (value!=null) {
                    url.append("&");
                    url.append(adminPk);
                    url.append("=");
                    url.append(URLEncoder.encode(value.toString().trim(), "utf-8"));
                }                
                
                if (kolomnaam!=null && kolomnaam.length()>0 && !kolomnaam.equalsIgnoreCase(adminPk)) {
                    value = f.getString(kolomnaam);
                    if (value!=null) {                    
                        url.append("&");
                        url.append(kolomnaam);
                        url.append("=");
                        url.append(URLEncoder.encode(value.toString().trim(), "utf-8"));
                    }
                }
                
                regel.add(url.toString());
                
            /*
             * De laatste mogelijkheid betreft een query. Vanuit de themadata wordt nu een
             * een commando url opgehaald en deze wordt met de kolomnaam aangevuld.
             */
            } else if (td.getDataType().getId()==DataTypen.QUERY) {
                StringBuffer url = new StringBuffer(td.getCommando());
                
                if (kolomnaam==null || kolomnaam.length()==0)
                    kolomnaam = t.getAdmin_pk();
                Object value = f.getString(kolomnaam);
                if (value!=null) {
                    url.append(value.toString().trim());
                    regel.add(url.toString());
                } else
                    regel.add("");
            }else if (td.getDataType().getId()==DataTypen.FUNCTION){
                StringBuffer function = new StringBuffer(td.getCommando());
                function.append("(this, ");                
                if (kolomnaam==null || kolomnaam.length()==0)
                    kolomnaam = t.getAdmin_pk();
                Object value = f.getString(kolomnaam);
                String queryName= td.getKolomnaam();
                if (queryName==null){
                    queryName=t.getAdmin_pk();
                }
                if (value!=null) {
                    function.append("'"+td.getThema().getId()+"'");
                    function.append(",");
                    function.append("'"+queryName+"'");
                    function.append(",");
                    function.append("'"+value+"'");
                    function.append(",");
                    function.append("'"+td.getEenheid()+"'");
                    function.append(")");
                    regel.add(function.toString());
                }else{
                    regel.add("");
                }
                
            }else
                
            /*
             * Indien een datatype aan geen van de voorwaarden voldoet wordt er een
             * lege regel aan de regel arraylist toegevoegd.
             */
                regel.add("");
        }
        return regel;
    }
    /**
     * DOCUMENT ME!!!
     *
     * @param params Map
     * @param key String
     *
     * @return String
     */
    protected String getStringFromParam(Map params, String key){
        Object ob = params.get(key);
        String zoekopties_waarde = null;
        String string = null;
        if (ob instanceof String)
            string = (String)ob;
        if (ob instanceof String[])
            string = ((String[])ob)[0];
        return string;
    }
    
}
