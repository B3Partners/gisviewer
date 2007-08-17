/**
 * @(#)HibernateUtil.java
 * @author Geert Plaisier
 * @version 1.00 2006/11/30
 *
 * Purpose: a class handling the different actions which come from classes extending this class.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

/*
 * Wat gaan we precies doen met deze ETL beheer tool? Het is de bedoeling dat een gebruiker
 * straks de mogelijkheid heeft om door middel van eenvoudige selectie criteria van een bepaald
 * thema op te kunnen vragen wat er voor gebreken in de objecten zijn bij dit thema.
 * Met eenvoudige selectie criteria wordt hier dan bedoelt dat een gebruiker aangeeft in welk
 * thema hij geinteresseerd is en vervolgens wat voor informatie hij over dit thema wil zien.
 * Hier kan bijvoorbeeld ingegeven worden welke status een object dient te hebben, wat voor
 * type object het om zou moeten gaan en binnen welke periodes (of batchperiode) dit object 
 * verwerkt zou moeten zijn.
 * 
 * 
 */

package nl.b3p.nbr.wis;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.nbr.wis.db.Clusters;
import nl.b3p.nbr.wis.db.DataTypen;
import nl.b3p.nbr.wis.db.ThemaData;
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
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ETLTransformAction extends BaseHibernateAction {
    
    private static final Log log = LogFactory.getLog(ETLTransformAction.class);
    
    private static final String ADMINDATA = "admindata";
    private static final String EDIT = "edit";
    private static final String SHOWOPTIONS = "showOptions";
    private static final String KNOP = "knop";
    private List themalist = null;
        
    /**
     * Actie die aangeroepen wordt vanuit het Struts frameword als een handeling aangeroepen wordt zonder property.
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
    // <editor-fold defaultstate="" desc="public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) method.">
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        createLists(dynaForm, request);
        return mapping.findForward(SUCCESS);
    }
    // </editor-fold>
    
    /**
     * Actie die aangeroepen wordt vanuit het Struts frameword als een handeling aangeroepen wordt met een showOption property.
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
    // <editor-fold defaultstate="" desc="public ActionForward showOptions(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) method.">
    public ActionForward showOptions(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String themaid = request.getParameter("themaid");
        Themas t = getThema(mapping, dynaForm, request);
        request.setAttribute("themaName", t.getNaam());
        request.setAttribute("themaid", themaid);
        return mapping.findForward(SUCCESS);
    }
    // </editor-fold>
    
    /**
     * Actie die aangeroepen wordt vanuit het Struts frameword als een handeling aangeroepen wordt met een edit property.
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param dynaForm The optional ActionForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     *
     * @return ActionForward
     *
     * @throws Exception
     */
    // <editor-fold defaultstate="" desc="public ActionForward edit(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) method.">
    public ActionForward edit(ActionMapping mapping, DynaValidatorForm  dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String themaid              = (String)request.getParameter("themaid");
        int statusInt               = Integer.parseInt((String)request.getParameter("type"));
        
        //Eerst moet de status van de te tonen objecten opgevraagd worden.
        String status = "";        
        if(statusInt == 1) {
            status = "NO";
        } else if(statusInt == 2) {
            status = "OAO";
        } else if(statusInt == 3) {
            status = "OGO";
        } else if(statusInt == 4) {
            status = "UO";
        } else if(statusInt == 5) {
            status = "VO";
        } else if(statusInt == 6) {
            status = "FO";
        } else if(statusInt == 7) {
            status = "OO";
        }
        
        Themas t = getThema(mapping, dynaForm, request);
        request.setAttribute("themaName", t.getNaam());
        List thema_data = /*SpatialUtil.*/getThemaData(t, true);//, etlProcesses, status);
        Object o = thema_data.get(1);
        request.setAttribute("thema_items", thema_data);
        if(thema_data != null && !thema_data.isEmpty()) {
            request.setAttribute("regels", getThemaObjects(t, /*pks,*/ thema_data, status));
        } else {
            request.setAttribute("regels", null);
        }
        return mapping.findForward("showData");
    }
    // </editor-fold>
    
    /**
     * De methode zorgt voor een lijst met objecten. Ieder van deze objecten bevat gegevens over een bepaalde
     * kolom horende bij een specifiek Thema dat meegegeven is aan de methode aanroep. De verschillende gegevens
     * die er in opgeslagen liggen zijn per Thema gedefinieerd. Een voorbeeld van informatie in een dergelijk
     * object is of een bepaalde kolom wel of geen basisregel is.
     *
     * @param t Themas
     * @param basisregel boolean
     * @param etlProcesses List
     * @param status String
     *
     * @return List
     */
    // <editor-fold defaultstate="" desc="static public List getThemaData(Themas t, boolean basisregel, List etlProcesses, String status) method.">
    static public List getThemaData(Themas t, boolean basisregel) {//, List etlProcesses, String status) {
        String admintabel = t.getAdmin_tabel();
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Query q = sess.createQuery("from ThemaData td where td.thema.id = :tid order by td.dataorder");
        q.setInteger("tid", t.getId());
        String queryString = q.getQueryString();
        return q.list();
    }
    // </editor-fold>
    
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
    // <editor-fold defaultstate="" desc="protected Themas getThema(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) method.">
    protected Themas getThema(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) {
        String themaid = (String)request.getParameter("themaid");
        return getThema(themaid);
    }
    // </editor-fold>
    
    /**
     * Haal een Thema op uit de database door middel van het meegegeven thema id.
     *
     * @param themaid String
     *
     * @return Themas
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="protected Themas getThema(String themaid) method.">
    protected Themas getThema(String themaid) {
        if (themaid==null || themaid.length()==0) {
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
    // <editor-fold defaultstate="" desc="protected List getThemaObjects(Themas t, /*List pks,*/ List thema_items) throws SQLException, UnsupportedEncodingException method.">
    protected List getThemaObjects(Themas t, /*List pks,*/ List thema_items, String status) throws SQLException, UnsupportedEncodingException {
        /*
        if (t==null)
            return null;
        if (pks==null || pks.isEmpty())
            return null;
        if (thema_items==null || thema_items.isEmpty())
            return null;
        */
        ArrayList regels = new ArrayList();
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        try {
                        
//            int dt = SpatialUtil.getPkDataType( t, connection);
            String taq = "select * from " + t.getSpatial_tabel() + " where status = '" + status + "'";
//            String taq = t.getAdmin_query();
//            Iterator it = pks.iterator();
//            for (int i=1; i<=pks.size(); i++) {
                PreparedStatement statement = connection.prepareStatement(taq);
                /*
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
                 
                }*/
                try {
                    ResultSet rs = statement.executeQuery();
                    while(rs.next()) {
                        regels.add(getRegel(rs, t, thema_items));
                    }
                } finally {
                    statement.close();
                }
//            }
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
    // <editor-fold defaultstate="" desc="protected List getPks(Themas t, DynaValidatorForm dynaForm, HttpServletRequest request) method.">
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
    // <editor-fold defaultstate="" desc="protected List getRegel(ResultSet rs, Themas t, List thema_items) method.">
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
    // </editor-fold>
    
    /**
     * Methode die aangeroepen wordt om de boomstructuur op te bouwen. De opbouw wordt op een iteratieve en recursieve
     * manier uitgevoerd waarbij over de verschillende thema's heen gewandeld wordt om van deze thema's de children
     * (clusters) te bepalen en in de juiste volgorde in de lijst te plaatsen.
     *
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     *
     * @throws Exception
     */
    // <editor-fold defaultstate="" desc="protected void createLists(DynaValidatorForm dynaForm, HttpServletRequest request) method.">
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
    // </editor-fold>
    
    /**
     * private method die zorg draagt het opzetten van de boomstructuur van de verschillende thema's.
     *
     * @param root JSONArray
     * @param rootCluster Clusters
     * @param list List
     *
     * @throws JSONException
     *
     * @see Clusters
     */
    // <editor-fold defaultstate="" desc="private void getSubClusters(JSONArray root, Clusters rootCluster, List list) method.">
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
    // </editor-fold>
    
    /**
     * private method die child objecten toevoegd aan het meegegeven root object.
     *
     * @param root JSONArray
     * @param rootCluster Clusters
     *
     * @throws JSONException
     *
     * @see Clusters
     */
    // <editor-fold defaultstate="" desc="private void getChildren(JSONArray root, Clusters rootCluster) method.">
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
    // </editor-fold>
    
    /**
     * Return een hashmap die verschillende user gedefinieerde properties koppelt aan Actions.
     *
     * @return Map
     */
    // <editor-fold defaultstate="" desc="protected Map getActionMethodPropertiesMap() method.">
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
        
        hibProp = new ExtendedMethodProperties(SHOWOPTIONS);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.admindata.failed");
        map.put(SHOWOPTIONS, hibProp);
        
        return map;
    }
    // </editor-fold>
}