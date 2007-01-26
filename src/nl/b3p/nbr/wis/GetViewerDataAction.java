package nl.b3p.nbr.wis;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.nbr.wis.db.Applicaties;
import nl.b3p.nbr.wis.db.DataRegels;
import nl.b3p.nbr.wis.db.Medewerkers;
import nl.b3p.nbr.wis.db.Onderdeel;
import nl.b3p.nbr.wis.db.Rollen;
import nl.b3p.nbr.wis.db.SpatialObjects;
import nl.b3p.nbr.wis.db.ThemaApplicaties;
import nl.b3p.nbr.wis.db.ThemaItemsAdmin;
import nl.b3p.nbr.wis.db.ThemaItemsSpatial;
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
        
        return map;
    }
    
    public ActionForward admindata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String laagid = request.getParameter("laagid");
        String id = laagid.substring(1);
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        List ctl = null;
        String hquery = "FROM ThemaItemsAdmin WHERE thema = '" + id + "' AND label != ''";
        Query q = sess.createQuery(hquery);
        ctl = q.list();
        if(ctl != null) {
            ArrayList returnValues = new ArrayList();
            Iterator it = ctl.iterator();
            while(it.hasNext()) {
                ThemaItemsAdmin tia = (ThemaItemsAdmin) it.next();
                returnValues.add(tia);
            }
            request.setAttribute("thema_items", returnValues);
        }
        return mapping.findForward("admindata");
    }
    
    public ActionForward metadata(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String laagid = request.getParameter("laagid");
        String id = laagid.substring(1);
        ArrayList meta_data = new ArrayList();
        boolean isDefinitief = false;
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        String hquery = "FROM Themas WHERE id = '" + id + "'";
        Query q = sess.createQuery(hquery);
        Themas th = (Themas) q.uniqueResult();
        
        request.setAttribute("thema", th.getNaam());
        
        List ctl = null;
        hquery = "FROM ThemaApplicaties WHERE thema = '" + id + "' ORDER BY voorkeur";
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
            
            ArrayList rij = new ArrayList();
            rij.add("Applicatie: ");
            rij.add(producten);
            
            meta_data.add(rij);
        }
        
        ArrayList rij = new ArrayList();
        rij.add("Moscow");
        ArrayList waarde = new ArrayList();
        waarde.add(th.getMoscow().getNaam());
        rij.add(waarde);
        meta_data.add(rij);
        
        hquery = "FROM ThemaVerantwoordelijkheden WHERE thema = '" + id + "' ORDER BY rol DESC";
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
        String hquery = "FROM Themas WHERE locatie_thema IS TRUE";
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
                        hquery = "SELECT so.geometry, tis.kenmerk WHERE so.tis = tis.id AND so.regel = " + dr.getId();
                        List ctl3 = null;
                        ctl3 = q.list();
                        if(ctl3 != null) {
                            Iterator it3 = ctl3.iterator();
                            ArrayList waardes = new ArrayList();
                            while(it3.hasNext()) {
                                Object[] rij = (Object[]) it3.next();
                                SpatialObjects so = (SpatialObjects) rij[0];
                                ThemaItemsSpatial tis = (ThemaItemsSpatial) rij[1];
                                ArrayList rij_waarde = new ArrayList();
                                if(tis != null) {
                                    rij_waarde.add(tis.getKenmerk());
                                } else if(so != null) {
                                    rij_waarde.add("<onbekend>");
                                }
                                if(so != null) {
                                    rij_waarde.add(so.getGeometry());
                                }
                            }
                            thema.add(waardes);
                        }
                    }
                }
                objectdata.add(thema);
            }
        }
        request.setAttribute("objectdata", objectdata);
        return mapping.findForward("objectdata");
    }
    
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return mapping.findForward(SUCCESS);
    }
}