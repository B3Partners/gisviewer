/*
 * ConfigThemaAction.java
 *
 * Created on 13 oktober 2007, 19:08
 *
 */

package nl.b3p.gis.viewer;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.services.FormUtils;
import nl.b3p.gis.viewer.db.Clusters;
import nl.b3p.gis.viewer.db.Moscow;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.services.HibernateUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Session;

/**
 *
 * @author Chris
 */
public class ConfigThemaAction extends ViewerCrudAction {
    
    private static final Log log = LogFactory.getLog(ConfigThemaAction.class);
    
    protected Themas getThema(DynaValidatorForm form, boolean createNew) {
        Integer id = FormUtils.StringToInteger(form.getString("themaID"));
        Themas t = null;
        if(id == null && createNew)
            t = new Themas();
        else if (id != null) {
            Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
            t = (Themas)sess.get(Themas.class, id);
        }
        return t;
    }
    
    protected Themas getFirstThema() {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        List cs = sess.createQuery("from Themas order by naam").setMaxResults(1).list();
        if (cs!=null && cs.size()>0) {
            return (Themas) cs.get(0);
        }
        return null;
    }
    
    protected void createLists(DynaValidatorForm form, HttpServletRequest request) throws Exception {
        super.createLists(form, request);
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        request.setAttribute("allThemas", sess.createQuery("from Themas order by belangnr").list());
        request.setAttribute("allClusters", sess.createQuery("from Clusters where id<>9 order by naam").list());
        request.setAttribute("listMoscow", sess.createQuery("from Moscow order by id").list());
    }
    
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(dynaForm, false);
        if (t==null)
            t = getFirstThema();
        populateThemasForm(t, dynaForm, request);
        return super.unspecified(mapping, dynaForm, request, response);
    }
    
    public ActionForward edit(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(dynaForm, false);
        if (t==null)
            t = getFirstThema();
        populateThemasForm(t, dynaForm, request);
        return super.edit(mapping, dynaForm, request, response);
    }
    
    public ActionForward save(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        if (!isTokenValid(request)) {
            prepareMethod(dynaForm, request, EDIT, LIST);
            addAlternateMessage(mapping, request, TOKEN_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        // nieuwe default actie op delete zetten
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        
        ActionErrors errors = dynaForm.validate(mapping, request);
        if(!errors.isEmpty()) {
            addMessages(request, errors);
            prepareMethod(dynaForm, request, EDIT, LIST);
            addAlternateMessage(mapping, request, VALIDATION_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        Themas t = getThema(dynaForm, true);
        if (t==null) {
            prepareMethod(dynaForm, request, LIST, EDIT);
            addAlternateMessage(mapping, request, NOTFOUND_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        populateThemasObject(dynaForm, t, request);
        
        sess.saveOrUpdate(t);
        sess.flush();
        
        /* Indien we input bijvoorbeeld herformatteren oid laad het dynaForm met
         * de waardes uit de database.
         */
        sess.refresh(t);
        populateThemasForm(t, dynaForm, request);
        
        return super.save(mapping, dynaForm, request, response);
    }
    
    public ActionForward delete(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        if (!isTokenValid(request)) {
            prepareMethod(dynaForm, request, EDIT, LIST);
            addAlternateMessage(mapping, request, TOKEN_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        // nieuwe default actie op delete zetten
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        
        Themas t = getThema(dynaForm, false);
        if (t==null) {
            prepareMethod(dynaForm, request, LIST, EDIT);
            addAlternateMessage(mapping, request, NOTFOUND_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        sess.delete(t);
        sess.flush();
        
        return super.delete(mapping, dynaForm, request, response);
    }
    
    
    private void populateThemasForm(Themas t, DynaValidatorForm dynaForm, HttpServletRequest request) {
        
        dynaForm.set("themaID", Integer.toString(t.getId()));
        dynaForm.set("code", t.getCode());
        dynaForm.set("naam", t.getNaam());
        String val = "";
        if (t.getMoscow()!=null)
            val = Integer.toString(t.getMoscow().getId());
        dynaForm.set("moscowID", val);
        dynaForm.set("belangnr", FormUtils.IntegerToString(t.getBelangnr()));
        val = "";
        if (t.getCluster()!=null)
            val = Integer.toString(t.getCluster().getId());
        dynaForm.set("clusterID", val);
        dynaForm.set("opmerkingen", t.getOpmerkingen());
        dynaForm.set("analyse_thema", new Boolean(t.isAnalyse_thema()));
        dynaForm.set("locatie_thema", new Boolean(t.isLocatie_thema()));
        dynaForm.set("admin_tabel_opmerkingen", t.getAdmin_tabel_opmerkingen());
        dynaForm.set("admin_tabel", t.getAdmin_tabel());
        dynaForm.set("admin_pk", t.getAdmin_pk());
        dynaForm.set("admin_pk_complex", new Boolean(t.isAdmin_pk_complex()));
        dynaForm.set("admin_spatial_ref", t.getAdmin_spatial_ref());
        dynaForm.set("admin_query", t.getAdmin_query());
        dynaForm.set("spatial_tabel_opmerkingen", t.getSpatial_tabel_opmerkingen());
        dynaForm.set("spatial_tabel", t.getSpatial_tabel());
        dynaForm.set("spatial_pk", t.getSpatial_pk());
        dynaForm.set("spatial_pk_complex", new Boolean(t.isSpatial_pk_complex()));
        dynaForm.set("spatial_admin_ref", t.getSpatial_admin_ref());
        dynaForm.set("wms_url", t.getWms_url());
        dynaForm.set("wms_layers", t.getWms_layers());
        dynaForm.set("wms_layers_real", t.getWms_layers_real());
        dynaForm.set("wms_querylayers", t.getWms_querylayers());
        dynaForm.set("wms_querylayers_real", t.getWms_querylayers_real());
        dynaForm.set("wms_legendlayer", t.getWms_legendlayer());
        dynaForm.set("wms_legendlayer_real", t.getWms_legendlayer_real());
        dynaForm.set("update_frequentie_in_dagen", FormUtils.IntegerToString(t.getUpdate_frequentie_in_dagen()));
        dynaForm.set("view_geomtype", t.getView_geomtype());
    }
    
    private void populateThemasObject(DynaValidatorForm dynaForm, Themas t, HttpServletRequest request) {
        
        t.setCode(FormUtils.nullIfEmpty(dynaForm.getString("code")));
        t.setNaam(FormUtils.nullIfEmpty(dynaForm.getString("naam")));
        t.setBelangnr(Integer.parseInt(dynaForm.getString("belangnr")));
        t.setOpmerkingen(FormUtils.nullIfEmpty(dynaForm.getString("opmerkingen")));
        Boolean b = (Boolean)dynaForm.get("analyse_thema");
        t.setAnalyse_thema(b==null?false:b.booleanValue());
        b = (Boolean)dynaForm.get("locatie_thema");
        t.setLocatie_thema(b==null?false:b.booleanValue());
        t.setAdmin_tabel_opmerkingen(FormUtils.nullIfEmpty(dynaForm.getString("admin_tabel_opmerkingen")));
        t.setAdmin_tabel(FormUtils.nullIfEmpty(dynaForm.getString("admin_tabel")));
        t.setAdmin_pk(FormUtils.nullIfEmpty(dynaForm.getString("admin_pk")));
        b = (Boolean)dynaForm.get("admin_pk_complex");
        t.setAdmin_pk_complex(b==null?false:b.booleanValue());
        t.setAdmin_spatial_ref(FormUtils.nullIfEmpty(dynaForm.getString("admin_spatial_ref")));
        t.setAdmin_query(FormUtils.nullIfEmpty(dynaForm.getString("admin_query")));
        t.setSpatial_tabel_opmerkingen(FormUtils.nullIfEmpty(dynaForm.getString("spatial_tabel_opmerkingen")));
        t.setSpatial_tabel(FormUtils.nullIfEmpty(dynaForm.getString("spatial_tabel")));
        t.setSpatial_pk(FormUtils.nullIfEmpty(dynaForm.getString("spatial_pk")));
        b = (Boolean)dynaForm.get("spatial_pk_complex");
        t.setSpatial_pk_complex(b==null?false:b.booleanValue());
        t.setSpatial_admin_ref(FormUtils.nullIfEmpty(dynaForm.getString("spatial_admin_ref")));
        t.setWms_url(FormUtils.nullIfEmpty(dynaForm.getString("wms_url")));
        //komma separated layers
        t.setWms_layers(FormUtils.nullIfEmpty(dynaForm.getString("wms_layers")));
        t.setWms_layers_real(FormUtils.nullIfEmpty(dynaForm.getString("wms_layers_real")));
        //komma separated layers
        t.setWms_querylayers(FormUtils.nullIfEmpty(dynaForm.getString("wms_querylayers")));
        t.setWms_querylayers_real(FormUtils.nullIfEmpty(dynaForm.getString("wms_querylayers_real")));
        //one layer to create a wms legend image
        t.setWms_legendlayer(FormUtils.nullIfEmpty(dynaForm.getString("wms_legendlayer")));
        t.setWms_legendlayer_real(FormUtils.nullIfEmpty(dynaForm.getString("wms_legendlayer_real")));
        t.setUpdate_frequentie_in_dagen(FormUtils.StringToInteger(dynaForm.getString("update_frequentie_in_dagen")));
        t.setView_geomtype(FormUtils.nullIfEmpty(dynaForm.getString("view_geomtype")));
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        int mId=0, cId=0;
        try {
            mId = Integer.parseInt(dynaForm.getString("moscowID"));
        } catch (NumberFormatException ex) {
            log.error("Illegal Moscow type id", ex);
        }
        try {
            cId = Integer.parseInt(dynaForm.getString("clusterID"));
        } catch (NumberFormatException ex) {
            log.error("Illegal Cluster id", ex);
        }
        Moscow m = (Moscow)sess.get(Moscow.class, new Integer(mId));
        t.setMoscow(m);
        Clusters c = (Clusters)sess.get(Clusters.class, new Integer(cId));
        t.setCluster(c);
    }
    
    
}
