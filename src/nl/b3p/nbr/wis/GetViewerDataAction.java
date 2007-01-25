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
import nl.b3p.nbr.wis.db.Medewerkers;
import nl.b3p.nbr.wis.db.Onderdeel;
import nl.b3p.nbr.wis.db.Rollen;
import nl.b3p.nbr.wis.db.ThemaApplicaties;
import nl.b3p.nbr.wis.db.ThemaItemsAdmin;
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
                    producten.add(a.getPakket());
                    isDefinitief = true;
                }
                if(!isDefinitief) {
                    producten.add(a.getPakket());
                }
            }
            
            ArrayList rij = new ArrayList();
            rij.add("Applicatie: ");
            rij.add(producten);
            
            meta_data.add(rij);
        }
        
        ArrayList rij = new ArrayList();
        rij.add("Moscow");
        rij.add(new ArrayList().add(th.getMoscow().getNaam()));
        meta_data.add(rij);
        
        hquery = "FROM ThemaVerantwoordelijkheden WHERE thema = '" + id + "'";
        q = sess.createQuery(hquery);
        ctl = q.list();
        if(ctl != null) {
            Iterator it = ctl.iterator();
            ArrayList producten = new ArrayList();
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
                rij = new ArrayList();
                rij.add("Verantwoordelijkheid: ");
                rij.add(new ArrayList().add(s));
                meta_data.add(rij);
            }
            
        }
        request.setAttribute("meta_data", meta_data);
        return mapping.findForward("metadata");
    }
    
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        return mapping.findForward(SUCCESS);
    }
}