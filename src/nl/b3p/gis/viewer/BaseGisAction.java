/**
 * @(#)BaseGisAction.java
 * @author Chris van Lith
 *
 * Purpose: a class handling security and general purpose methods.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer;

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
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import nl.b3p.gis.viewer.db.DataTypen;
import nl.b3p.gis.viewer.db.ThemaData;
import nl.b3p.gis.viewer.db.Themas;
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
        
        // Check de rechten op alle layers uit het thema
        if (!checkThemaRights(t,  request))
            return null;
        
        return t;
    }
    
    protected List getValidThemas(boolean locatie,  HttpServletRequest request) {
        List l = SpatialUtil.getValidThemas(locatie);
        List checkedList = new ArrayList();
        if (l!=null) {
            Iterator it = l.iterator();
            while(it.hasNext()) {
                Themas t = (Themas)it.next();
                if (checkThemaRights(t,  request))
                    checkedList.add(t);
                
            }
        }
        return checkedList;
    }
    
    protected boolean checkThemaRights(Themas t,  HttpServletRequest request) {
        String wmsls = t.getWms_layers();
        if (wmsls==null || wmsls.length()==0)
            return false;
        
        String wmsqls = t.getWms_querylayers();
        if (wmsqls!=null || wmsqls.length()>0)
            wmsls += "," + wmsqls;
        String wmslls = t.getWms_legendlayer();
        if (wmslls!=null || wmslls.length()>0)
            wmsls += "," + wmslls;
        
        String[] wmsla = wmsls.split(",");
        for (int i=0; i<wmsla.length; i++) {
            if(!request.isUserInRole("layer_" + wmsla[i]))
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
        Connection conn = sess.connection();
        return SpatialUtil.getThemaGeomType(thema, conn);
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
    protected String getAnalyseNaam(String analyseGeomId, Themas t) {
        
        String analyseGeomTabel     = t.getSpatial_tabel();
        String analyseGeomIdColumn  = t.getSpatial_admin_ref();
        int themaid = t.getId();
        
        String analyseNaam= t.getNaam();
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
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
    protected void executeQuery(String query, Session sess, StringBuffer result, String[] columns){
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
            if (td.getDataType().getId() == DataTypen.DATA && td.getKolomnaam() != null) {
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
                url.append("&");
                url.append(adminPk);
                url.append("=");
                url.append(URLEncoder.encode((rs.getObject(adminPk)).toString().trim(), "utf-8"));
                
                regel.add(url.toString());
                
            /*
             * De laatste mogelijkheid betreft een query. Vanuit de themadata wordt nu een
             * een commando url opgehaald en deze wordt met de admin primary key uit het
             * Thema aangevuld.
             */
            } else if (td.getDataType().getId()==DataTypen.QUERY) {
                StringBuffer url = new StringBuffer(td.getCommando());
                String adminPk = t.getAdmin_pk();
                url.append(URLEncoder.encode((rs.getObject(adminPk)).toString().trim(), "utf-8"));
                regel.add(url.toString());
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
