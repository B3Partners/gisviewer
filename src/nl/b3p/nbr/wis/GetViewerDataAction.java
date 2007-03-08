package nl.b3p.nbr.wis;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
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
    
    public ActionForward analysedata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String lagen = request.getParameter("lagen");
        ArrayList objectdata = new ArrayList();
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        List ctl = null;
        String hquery = "FROM Themas WHERE locatie_thema = true";
        if(!lagen.equals("ALL")) {
            hquery += " AND (";
            String[] alleLagen = lagen.split(",");
            boolean firstTime = true;
            for(int i = 0; i < alleLagen.length; i++) {
                if(firstTime) {
                    hquery += "id = " + alleLagen[i].substring(1);
                    firstTime = false;
                } else {
                    hquery += " OR id = " + alleLagen[i].substring(1);
                }
            }
            hquery += ")";
        }
        /*
        Query q = sess.createQuery(hquery);
        ctl = q.list();
        if(ctl != null) {
            Iterator it = ctl.iterator();
            while(it.hasNext()) {
                ArrayList thema = new ArrayList();
                Themas t = (Themas) it.next();
                thema.add(t.getNaam());
                hquery = "FROM DataRegels WHERE thema = " + t.getId();
                q = sess.createQuery(hquery);
                List ctl2 = null;
                ctl2 = q.list();
                if(ctl2 != null) {
                    Iterator it2 = ctl2.iterator();
                    while(it2.hasNext()) {
                        DataRegels dr = (DataRegels) it2.next();
                        hquery = "FROM SpatialObjects WHERE regel = " + dr.getId();
                        List ctl3 = null;
                        q = sess.createQuery(hquery);
                        ctl3 = q.list();
                        if(ctl3 != null) {
                            Iterator it3 = ctl3.iterator();
                            ArrayList waardes = new ArrayList();
                            while(it3.hasNext()) {
                                SpatialObjects so = (SpatialObjects) it3.next();
                                ThemaItemsSpatial tis = so.getTis();
                                ArrayList rij_waarde = new ArrayList();
                                if(tis != null) {
                                    rij_waarde.add(tis.getId());
                                    rij_waarde.add(tis.getKenmerk());
                                } else if(so != null) {
                                    rij_waarde.add("-1");
                                    rij_waarde.add("<onbekend>");
                                }
                                if(so != null) {
                                    rij_waarde.add(so.getGeometry());
                                }
                                waardes.add(rij_waarde);
                            }
                            thema.add(waardes);
                        }
                    }
                }
                objectdata.add(thema);
            }
        }
        request.setAttribute("analyse_data", objectdata);
         
        String log = "";
         
        String laagid = request.getParameter("laagid");
        String id = laagid.substring(1);
        ctl = null;
        hquery = "FROM ThemaItemsAdmin WHERE thema = " + id + " AND label != ''";
        q = sess.createQuery(hquery);
        ctl = q.list();
        if(ctl != null) {
            ArrayList returnValues = new ArrayList();
            Iterator it = ctl.iterator();
            while(it.hasNext()) {
                ArrayList list = new ArrayList();
                ThemaData tia = (ThemaData) it.next();
                list.add(tia.getId());
                list.add(tia.getLabel());
         
                List ctl2 = null;
                String hquery2 = "FROM DataRegels WHERE thema = " + id;
                Query q2 = sess.createQuery(hquery2);
                ctl2 = q2.list();
                if(ctl2 != null) {
                    Iterator it2 = ctl2.iterator();
                    ArrayList regels = new ArrayList();
                    while(it2.hasNext()) {
                        DataRegels dr = (DataRegels) it2.next();
                        List ctl3 = null;
                        String hquery3 = "FROM RegelAttributen WHERE regel = " + dr.getId() + " AND tia = " + tia.getId();
                        Query q3 = sess.createQuery(hquery3);
                        ctl3 = q3.list();
                        if(ctl3 != null) {
                            Iterator it3 = ctl3.iterator();
                            while(it3.hasNext()) {
                                RegelAttributen ra = (RegelAttributen) it3.next();
                                regels.add(ra.getWaarde());
                            }
                        }
                    }
                    list.add(regels);
                }
                returnValues.add(list);
            }
            request.setAttribute("thema_items", returnValues);
        }
         */
        return mapping.findForward("analysedata");
    }
    
    protected int getPkDataType(Themas t, Connection conn) throws SQLException {
        DatabaseMetaData dbmd = conn.getMetaData();
        String dbtn = t.getAdmin_tabel();
        String adminPk = t.getAdmin_pk();
        int dt = java.sql.Types.VARCHAR;
        ResultSet rs = dbmd.getColumns(null, null, dbtn, adminPk);
        if (rs.next()) {
            dt = rs.getInt("DATA_TYPE");
        }
        return dt;
    }
    
    protected String createClickGeom(double x, double y, int srid) {
        StringBuffer sq = new StringBuffer();
        sq.append(" GeometryFromText ( ");
        sq.append("'POINT(");
        sq.append(x);
        sq.append(" ");
        sq.append(y);
        sq.append(")'");
        sq.append(", ");
        sq.append(srid);
        sq.append(") ");
        return sq.toString();
    }
    
    protected List findPks(Themas t, ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        String xcoord = request.getParameter("xcoord");
        String ycoord = request.getParameter("ycoord");
        
        double x = Double.parseDouble(xcoord);
        double y = Double.parseDouble(ycoord);
        double distance = 1000.0;
        int srid = 28992; // RD-new
        
        ArrayList pks = new ArrayList();
        
        String saf = t.getSpatial_admin_ref();
        String sptn = t.getSpatial_tabel();
        StringBuffer sq = new StringBuffer();
        sq.append("select ");
        sq.append(saf);
        sq.append(" from ");
        sq.append(sptn);
        sq.append(" sptn where ");
        sq.append(" distance( ");
        sq.append(" sptn.the_geom, ");
        sq.append(createClickGeom(x, y, srid));
        sq.append(") < ");
        sq.append(distance);
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        try {
            String taq = t.getAdmin_query();
            PreparedStatement statement = connection.prepareStatement(sq.toString());
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
        
        List thema_items = getThemaData(t, true);
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
        
        List thema_items = getThemaData(t, false);
        request.setAttribute("thema_items", thema_items);
        
        List pks = getPks(t, dynaForm, request);
        
        request.setAttribute("regels", getThemaObjects(t, pks, thema_items));
        
        return mapping.findForward("aanvullendeinfo");
    }
    
    protected Themas getThema(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request) {
        String themaid = request.getParameter(Themas.THEMAID);
        Integer id = new Integer(themaid);
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Themas t = (Themas)sess.get(Themas.class, id);
        return t;
    }
    
    protected List getThemaData(Themas t, boolean basisregel) {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        
        Query q = sess.createQuery("from ThemaData td where td.thema.id = :tid "
                + "and td.basisregel = :br");
        q.setInteger("tid", t.getId());
        q.setBoolean("br", basisregel);
        return q.list();
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
        
        int dt = getPkDataType( t, connection);
        
        try {
            String taq = t.getAdmin_query();
            Iterator it = pks.iterator();
            for (int i=1; i<=pks.size(); i++) {
                PreparedStatement statement = connection.prepareStatement(taq);
                switch (dt) {
                    case java.sql.Types.INTEGER:
                        statement.setInt(1, ((Integer)pks.get(i-1)).intValue());
                    case java.sql.Types.VARCHAR:
                    default:
                        statement.setString(1, (String)pks.get(i-1));
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
        
        int dt = getPkDataType( t, connection);
        String adminPk = t.getAdmin_pk();
        switch (dt) {
            case java.sql.Types.INTEGER:
                pks.add(new Integer(request.getParameter(adminPk)));
            case java.sql.Types.VARCHAR:
            default:
                pks.add(request.getParameter(adminPk));
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
                if(!isDefinitief) {
                    String pakket = new String();
                    if(ta.isVoorkeur()) pakket = a.getPakket() + " " + a.getModule() + " (heeft voorkeur)";
                    else pakket = a.getPakket() + " " + a.getModule();
                    producten.add(pakket);
                }
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
        String hquery = "FROM Themas WHERE locatie_thema = true";
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
                
                List thema_items = getThemaData(t, true);
                
                List pks = findPks(t, mapping, dynaForm, request);
                List ao = getThemaObjects(t, pks, thema_items);
                thema.addAll(ao);
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