/*
 * ETLTransformAction.java
 *
 * Created on 30 november 2006, 12:54
 */

package nl.b3p.nbr.wis;



import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

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
/**
 *
 * @author Geert
 * @version
 */

public class ETLTransformAction extends BaseHibernateAction {
    
    /* forward name="success" path="" */
    private final static String SUCCESS = "success";
    private static final String ADMINDATA = "admindata";
    private static final String EDIT = "edit";
    private static final String SHOWOPTIONS = "showOptions";
    
    private static final Log log = LogFactory.getLog(ETLTransformAction.class);
    
    private static final String KNOP = "knop";
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
     *
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
    */
    
    
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        createLists(dynaForm, request);
        return mapping.findForward(SUCCESS);
    }
    
    public ActionForward showOptions(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String themaid = request.getParameter("themaid");
        Themas t = getThema(mapping, dynaForm, request);
        this.addBatches(request);
        request.setAttribute("themaName", t.getNaam());
        request.setAttribute("themaid", themaid);
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
    public ActionForward edit(ActionMapping mapping, DynaValidatorForm  dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String type     = (String)request.getParameter("type");
        String optie    = (String)request.getParameter("optie");
        String begin    = (String)request.getParameter("begin");
        String end      = (String)request.getParameter("end");
        String themaid  = (String)request.getParameter("themaid");
        
        int selectedType = Integer.parseInt(type);
        int selectedOption = Integer.parseInt(optie);
        
        String statusQuery = "";        
        if(selectedType == 1) {
            statusQuery += " where status = NO";
        } else if(selectedType == 2) {
            statusQuery += " where status = ONO";
        } else if(selectedType == 3) {
            statusQuery += " where status = UO";
        } else if(selectedType == 4) {
            statusQuery += " where status = VO";
        } else if(selectedType == 5) {
            statusQuery += " where status = OVO";
        } else if(selectedType == 6) {
            statusQuery += " where status = FO";
        }
        
        String selectionQuery = "";
        if(selectedOption == 1) {
            selectionQuery += " where objectType = the_geom";
        } else if(selectedType == 2) {
            selectionQuery += " where objectType = admin";
        }
        
        java.util.Date beginTimestampDate = null;
        java.util.Date endTimestampDate = null;
        
        if(!begin.equals("") && !end.equals("")) {
            DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
            beginTimestampDate   = df.parse(begin);
            endTimestampDate     = df.parse(end);
        }
        
        String dateQuery = "";
        if(beginTimestampDate != null && endTimestampDate != null) {
            dateQuery = " where timestamp >= '" + beginTimestampDate + "' and timestamp <= '" + endTimestampDate + "'";
        }
        
        String extraParamsQuery = statusQuery + " and" + selectionQuery + " and" + dateQuery;
        
        
        
        Themas t = getThema(mapping, dynaForm, request);
        request.setAttribute("themaName", t.getNaam());
        List thema_items = SpatialUtil.getThemaData(t, true);
        request.setAttribute("thema_items", thema_items);
        if(thema_items != null && !thema_items.isEmpty()) {
            request.setAttribute("regels", getThemaObjects(t, /*pks,*/ thema_items));
        } else {
            request.setAttribute("regels", null);
        }
        this.addBatches(request);
        return mapping.findForward("showData");
        //return mapping.findForward("success");
    }
    
    private void addBatches(HttpServletRequest request) {
        List batches = new ArrayList();
        for(int i = 0; i < 10; i++) {
            Batchverwerking batchverwerking = new Batchverwerking();
            batchverwerking.setId(i);
            batchverwerking.setName("Batchverwerking van " + (new Date()).toString());
            batches.add(batchverwerking);
        }
        request.setAttribute("batches", batches);
    }
    
    protected Themas getThema(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) {
        String themaid = (String)request.getParameter("themaid");
        return getThema(themaid);
    }
    
    protected Themas getThema(String themaid) {
        if (themaid==null || themaid.length()==0) {
            return null;
        }
        
        Integer id = new Integer(themaid);
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Themas t = (Themas)sess.get(Themas.class, id);
        return t;
    }
        
    protected List getThemaObjects(Themas t, /*List pks,*/ List thema_items) throws SQLException, UnsupportedEncodingException {
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
            String taq = "select * from " + t.getSpatial_tabel();
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
}

