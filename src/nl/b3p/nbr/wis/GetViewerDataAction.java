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
    
    protected static final String ADMINDATA = "admindata";
    protected static final String ANALYSEDATA = "analysedata";
    protected static final String AANVULLENDEINFO = "aanvullendeinfo";
    protected static final String METADATA = "metadata";
    protected static final String OBJECTDATA = "objectdata";
    protected static final String ANALYSEWAARDE = "analysewaarde";
    protected static final String ANALYSEOBJECT = "analyseobject";
    private List themalist = null;
    
    
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
    
    public ActionForward analysewaarde(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(mapping, dynaForm, request);
        
        StringBuffer result = new StringBuffer("");
        Map params = request.getParameterMap();
        if (!params.isEmpty()) {
            Iterator it = params.keySet().iterator();
            Boolean done=false;
            while (it.hasNext()) {
                String pn = (String) it.next();
                if (pn.startsWith("ThemaItem")&&!done) {
                    done=true;
                    String tsTokens[]= pn.split("_");
                    String themaId=tsTokens[1];
                    Themas thema=getThema(themaId);
                    if (params.get("zoekopties_waarde")!=null&&thema!=null){
                        String zoekopties_waarde = getStringFromParam(params,"zoekopties_waarde");
                        String zoekopties=getStringFromParam(params,"zoekopties");
                        if (zoekopties_waarde!=null && zoekopties!=null) {
                            String geselecteerd_object=getStringFromParam(params,"geselecteerd_object");
                            if (geselecteerd_object!=null){
                                //Bereken/haal de gegevens op die nodig zijn voor een spatial query                            
                                String[] tokens = geselecteerd_object.split("_");
                                Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
                                Themas objectThema=null;
                                try {
                                    Integer id= Integer.parseInt(tokens[1]);
                                    objectThema=(Themas)sess.get(Themas.class, id);
                                }catch(NumberFormatException nfe){
                                    String id=tokens[1];
                                    objectThema=(Themas)sess.get(Themas.class, id);
                                }
                                if (objectThema==null){
                                    log.error("Kan het thema niet vinden");
                                    return null;
                                }
                                //De gegevens van het analyse object die nodig zijn om een query uit te voeren.
                                String analyseGeomTabel=objectThema.getSpatial_tabel();
                                String analyseGeomIdColumn=objectThema.getSpatial_admin_ref();
                                String analyseGeomId=tokens[2];
                                
                                String themaGeomTabel=thema.getSpatial_tabel();
                                String themaGeomIdColumn=thema.getSpatial_admin_ref();
                                
                                //zoek het type object op.
                                String themaGeomType=null;
                                Connection connection = sess.connection();
                                try {
                                    PreparedStatement statement = connection.prepareStatement("select * from geometry_columns gc where gc.f_table_name = '"+themaGeomTabel+"'");
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
                                if (themaGeomType==null){
                                    log.error("Kan het type geoobject niet vinden");
                                    return null;
                                }

                                
                                //hier alle 'geef waarde' functies
                                if (zoekopties.equalsIgnoreCase("2")){
                                    //geef maximale
                                    if (zoekopties_waarde.equalsIgnoreCase("1")){
                                        if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTIPOINT)){
                                            result.append("<b>Niet mogelijk met dit thema-geometry-type<br/></b>");
                                        }
                                        else if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                                            String query=SpatialUtil.intersectionLength("max",themaGeomTabel,analyseGeomTabel,analyseGeomId,1000);
                                            log.info(query);
                                            result.append("<b>Grootste thema lengte(km): ");
                                            executeQuery(query,sess,result, new String[]{"result"});                                            
                                            result.append("</b>");
                                        }
                                        else if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
                                            String query=SpatialUtil.intersectionArea("max",themaGeomTabel,analyseGeomTabel,analyseGeomId,1000000);
                                            log.info(query);
                                            result.append("<b>Grootste thema oppervlakte(km2): ");
                                            executeQuery(query,sess,result, new String[]{"result"});                                            
                                            result.append("</b>");
                                        }                                        
                                    }
                                    //geef minimale waarde
                                    else if (zoekopties_waarde.equalsIgnoreCase("2")){
                                        if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTIPOINT)){
                                            result.append("<b>Niet mogelijk met dit thema-geometry-type<br/></b>");
                                        }
                                        else if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                                            String query=SpatialUtil.intersectionLength("min",themaGeomTabel,analyseGeomTabel,analyseGeomId,1000);
                                            log.info(query);
                                            result.append("<b>Kleinste thema lengte(km): ");
                                            executeQuery(query,sess,result, new String[]{"result"});                                            
                                            result.append("</b>");
                                        }
                                        else if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
                                            String query=SpatialUtil.intersectionArea("min",themaGeomTabel,analyseGeomTabel,analyseGeomId,1000000);
                                            log.info(query);
                                            result.append("<b>Kleinste thema oppervlakte(km2): ");
                                            executeQuery(query,sess,result, new String[]{"result"});                                            
                                            result.append("</b>");
                                        }  
                                    }
                                    //geef gemiddelde
                                    else if (zoekopties_waarde.equalsIgnoreCase("3")){
                                        if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTIPOINT)){
                                            result.append("<b>Niet mogelijk met dit thema-geometry-type</b><br/>");
                                        }
                                        else if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                                            String query=SpatialUtil.intersectionLength("avg",themaGeomTabel,analyseGeomTabel,analyseGeomId,1000);
                                            log.info(query);
                                            result.append("<b>Gemiddelde thema lengte(km): ");
                                            executeQuery(query,sess,result, new String[]{"result"});                                            
                                            result.append("</b>");
                                        }
                                        else if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
                                            String query=SpatialUtil.intersectionArea("avg",themaGeomTabel,analyseGeomTabel,analyseGeomId,1000000);
                                            log.info(query);
                                            result.append("<b>Gemiddelde thema oppervlakte(km2): ");
                                            executeQuery(query,sess,result, new String[]{"result"});                                            
                                            result.append("</b>");
                                        }  
                                    }
                                    //geef totale 
                                    else if (zoekopties_waarde.equalsIgnoreCase("4")){
                                                                 
                                        if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTIPOINT)){
                                            String query= SpatialUtil.containsQuery("count(*)",analyseGeomTabel,themaGeomTabel,analyseGeomIdColumn,analyseGeomId);
                                            log.info(query);
                                            result.append("<b>Aantal: ");
                                            executeQuery(query,sess,result, new String[]{"count"});
                                            result.append("</b>");
                                        }
                                        else if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTILINESTRING)){
                                            //create query and get in KM
                                            String query=SpatialUtil.intersectionLength("sum",themaGeomTabel,analyseGeomTabel,analyseGeomId,1000);
                                            log.info(query);
                                            result.append("<b>Totale lengte(km): ");
                                            executeQuery(query,sess,result, new String[]{"result"});                                            
                                            result.append("</b>");
                                        }
                                        else if (themaGeomType.equalsIgnoreCase(SpatialUtil.MULTIPOLYGON)){
                                            String query=SpatialUtil.intersectionArea("sum",themaGeomTabel,analyseGeomTabel,analyseGeomId,1000000);
                                            log.info(query);
                                            result.append("<b>Totale oppervlakte(km2): ");
                                            executeQuery(query,sess,result, new String[]{"result"});                                            
                                            result.append("</b>");
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (pn.equalsIgnoreCase("geselecteerd_object")) {
                    Object pv = params.get(pn);
                    String ps = null;
                    if (pv instanceof String)
                        ps = (String)pv;
                    if (pv instanceof String[])
                        ps = ((String[])pv)[0];
                    if (ps!=null) {
                        String[] sa = ps.split("_");
                        if (sa.length==3) {
                            result.append("thema id: ");
                            result.append(sa[1]);
                            result.append(", object id: ");
                            result.append(sa[2]);
                        }
                    }
                }
            }
        }
        request.setAttribute("waarde", result.toString());
        return analysedata(mapping, dynaForm, request, response);
    }
    private void executeQuery(String query,Session sess, StringBuffer result, String[] columns){
        Connection connection = sess.connection();
        try {
            PreparedStatement statement = connection.prepareStatement(query);
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()){
                    for (int i=0; i < columns.length; i++){
                        result.append(rs.getObject(columns[i]));
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
    
    private String getStringFromParam(Map params,String key){
        Object ob= params.get(key);
        String zoekopties_waarde = null;
        String string=null;
        if (ob instanceof String)
            string = (String)ob;
        if (ob instanceof String[])
            string = ((String[])ob)[0]; 
        return string;
    }
    
    public ActionForward analyseobject(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        // Hier moet het formulier worden opgehaald (dynamisch formulier, kan meerdere velden hebben)
        // en moet de waarde worden berekend.
        
        request.setAttribute("object", "Een object");
        return mapping.findForward("analyseobject");
    }
    
    public ActionForward analysedata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(mapping, dynaForm, request);
        
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
        request.setAttribute("analyse_data", analysedata);
        
        return mapping.findForward("analysedata");
    }
    
    
    protected List findPks(Themas t, ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        String xcoord = request.getParameter("xcoord");
        String ycoord = request.getParameter("ycoord");
        
        double x = Double.parseDouble(xcoord);
        double y = Double.parseDouble(ycoord);
        double distance = 10.0;
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
    
    public ActionForward aanvullendeinfo(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        Themas t = getThema(mapping, dynaForm, request);
        
        List thema_items = SpatialUtil.getThemaData(t, false);
        request.setAttribute("thema_items", thema_items);
        
        List pks = getPks(t, dynaForm, request);
        
        request.setAttribute("regels", getThemaObjects(t, pks, thema_items));
        
        return mapping.findForward("aanvullendeinfo");
    }
    
    protected Themas getThema(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) {
        String themaid = request.getParameter(Themas.THEMAID);
        return getThema(themaid);
    }
    protected Themas getThema(String themaid){
        if (themaid==null)
            return null;
        Integer id = new Integer(themaid);
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Themas t = (Themas)sess.get(Themas.class, id);
        return t;
    }
    
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
                
                regel.add(url.toString());
            } else if (td.getDataType().getId()==DataTypen.QUERY) {
                StringBuffer url = new StringBuffer(td.getCommando());
                String adminPk = t.getAdmin_pk();
                url.append(URLEncoder.encode((rs.getObject(adminPk)).toString().trim(), "utf-8"));
                
                regel.add(url.toString());
            } else
                regel.add("");
        }
        return regel;
    }
    
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
    
    public ActionForward metadata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(mapping, dynaForm, request);
        
        ArrayList meta_data = new ArrayList();
        boolean isDefinitief = false;
        ArrayList rij = new ArrayList();
        ArrayList waarde = new ArrayList();
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        String hquery = "FROM Themas WHERE id = '" + t.getId() + "'";
        Query q = sess.createQuery(hquery);
        Themas th = (Themas) q.uniqueResult();
        
        request.setAttribute("thema", th.getNaam());
        
        List ctl = null;
        hquery = "FROM ThemaApplicaties WHERE thema = '" + t.getId() + "' ORDER BY voorkeur";
        q = sess.createQuery(hquery);
        ctl = q.list();
        if(ctl != null) {
            Iterator it = ctl.iterator();
            
            ArrayList producten = new ArrayList();
            while(it.hasNext()) {
                ThemaApplicaties ta = (ThemaApplicaties) it.next();
                Applicaties a = ta.getApplicatie();
                if(ta.isDefinitief()) {
                    producten = new ArrayList();
                    producten.add(a.getPakket() + " " + a.getModule());
                    isDefinitief = true;
                }
//                if(!isDefinitief) {
//                    String pakket = new String();
//                    if(ta.isVoorkeur()) pakket = a.getPakket() + " " + a.getModule() + " (heeft voorkeur)";
//                    else pakket = a.getPakket() + " " + a.getModule();
//                    producten.add(pakket);
//                }
            }
            
            rij = new ArrayList();
            rij.add("Applicatie: ");
            rij.add(producten);
            
            meta_data.add(rij);
        }
        
        rij = new ArrayList();
        rij.add("Moscow");
        waarde = new ArrayList();
        waarde.add(th.getMoscow().getNaam());
        rij.add(waarde);
        meta_data.add(rij);
        
        rij = new ArrayList();
        rij.add("Belangnummer");
        waarde = new ArrayList();
        waarde.add("" + th.getBelangnr());
        rij.add(waarde);
        meta_data.add(rij);
        
        hquery = "FROM ThemaVerantwoordelijkheden WHERE thema = '" + t.getId() + "' ORDER BY rol DESC";
        q = sess.createQuery(hquery);
        ctl = q.list();
        if(ctl != null) {
            Iterator it = ctl.iterator();
            ArrayList waarden = new ArrayList();
            while(it.hasNext()) {
                ThemaVerantwoordelijkheden tv = (ThemaVerantwoordelijkheden) it.next();
                Rollen rol = tv.getRol();
                Medewerkers medewerker = tv.getMedewerker();
                Onderdeel afdeling = tv.getOnderdeel();
                String s = new String();
                if(rol != null) {
                    s += rol.getNaam();
                }
                if(medewerker != null) {
                    s += " - " + medewerker.getVoornaam() + " " + medewerker.getAchternaam();
                }
                if(afdeling != null) {
                    s += " - " + afdeling.getNaam();
                }
                if(tv.isGewenste_situatie()) {
                    s += " (Gewenste situatie)";
                } else if(tv.isHuidige_situatie()) {
                    s += " (Huidige situatie)";
                }
                waarden.add(s);
            }
            rij = new ArrayList();
            rij.add("VERANTWOORDELIJKHEID");
            rij.add(waarden);
            meta_data.add(rij);
            
        }
        request.setAttribute("meta_data", meta_data);
        return mapping.findForward("metadata");
    }
    
    public ActionForward objectdata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String lagen = request.getParameter("lagen");
        ArrayList objectdata = new ArrayList();
        
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
    
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return mapping.findForward(SUCCESS);
    }
}