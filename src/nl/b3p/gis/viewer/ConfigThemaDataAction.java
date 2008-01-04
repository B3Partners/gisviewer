/*
 * ConfigThemaAction.java
 *
 * Created on 13 oktober 2007, 19:08
 *
 */

package nl.b3p.gis.viewer;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.services.FormUtils;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.gis.viewer.db.Connecties;
import nl.b3p.gis.viewer.db.DataTypen;
import nl.b3p.gis.viewer.db.Moscow;
import nl.b3p.gis.viewer.db.ThemaData;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.db.WaardeTypen;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.gis.viewer.services.WfsUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Query;
import org.hibernate.Session;
import org.w3c.dom.Element;

/**
 *
 * @author Chris
 */
public class ConfigThemaDataAction extends ViewerCrudAction {
    
    private static final Log log = LogFactory.getLog(ConfigThemaAction.class);
    
    protected static final String CHANGE = "change";
    protected static final String CREATEALLTHEMADATA = "createAllThemaData";
    
    protected Map getActionMethodPropertiesMap() {
        Map map = super.getActionMethodPropertiesMap();
        
        ExtendedMethodProperties crudProp = null;
        
        crudProp = new ExtendedMethodProperties(CHANGE);
        crudProp.setDefaultForwardName(SUCCESS);
        map.put(CHANGE, crudProp);
        
        crudProp = new ExtendedMethodProperties(CREATEALLTHEMADATA);
        crudProp.setDefaultForwardName(SUCCESS);
        map.put(CREATEALLTHEMADATA, crudProp);
        return map;
    }
    
    protected ThemaData getThemaData(DynaValidatorForm form, boolean createNew) {
        Integer id = FormUtils.StringToInteger(form.getString("themaDataID"));
        ThemaData td = null;
        if(id == null && createNew)
            td = new ThemaData();
        else if(id != null) {
            Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
            td = (ThemaData)sess.get(ThemaData.class, id);
        }
        return td;
    }
    
    protected ThemaData getFirstThemaData(Themas t) {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Query q = sess.createQuery("from ThemaData where thema.id = :themaID order by dataorder, label");
        List cs = q.setParameter("themaID", t.getId()).setMaxResults(1).list();
        if (cs!=null && cs.size()>0) {
            return (ThemaData) cs.get(0);
        }
        ThemaData td = new ThemaData();
        td.setThema(t);
        return td;
    }
    
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
    
    protected void createLists(DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        super.createLists(dynaForm, request);
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        request.setAttribute("listThemas", sess.createQuery("from Themas where code in ('1', '2') order by belangnr").list());
        request.setAttribute("listMoscow", sess.createQuery("from Moscow order by id").list());
        request.setAttribute("listWaardeTypen", sess.createQuery("from WaardeTypen order by naam").list());
        request.setAttribute("listDataTypen", sess.createQuery("from DataTypen order by naam").list());
        Themas t = null;
        ThemaData td = getThemaData(dynaForm, false);
        if (td==null) {
            t = getThema(dynaForm, false);
            if (t==null)
                t = getFirstThema();
        } else {
            t = td.getThema();
        }
        if (t==null)
            return;
        
        Query q = sess.createQuery("from ThemaData where thema.id = :themaID order by dataorder, label");
        request.setAttribute("listThemaData", q.setParameter("themaID", t.getId()).list());
        
        String connectieType=Connecties.TYPE_JDBC;
        if (t.getConnectie() == null || (t.getConnectie() != null && t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_JDBC))) {          
            Connection conn=null;
            if (t.getConnectie()!=null){
                conn=t.getConnectie().getJdbcConnection();
            }
            if (conn==null)
                conn = sess.connection();
            request.setAttribute("listAdminTableColumns", SpatialUtil.getAdminColumnNames(t, conn));
        }
        else if (t.getConnectie() != null && t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            connectieType=Connecties.TYPE_WFS;
            List elements=WfsUtil.getFeatureElements(t);
            if (elements!=null){
                ArrayList elementsNames= new ArrayList();
                for (int i=0; i < elements.size(); i++){
                    Element e = (Element)elements.get(i);
                    elementsNames.add(e.getAttribute("name"));
                }
                request.setAttribute("listAdminTableColumns",elementsNames);                           
            }
        }
        request.setAttribute("connectieType",connectieType);
    }
    
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        ThemaData td = getThemaData(dynaForm, false);
        if (td==null) {
            Themas t = getThema(dynaForm, false);
            if (t==null)
                t = getFirstThema();
            td = getFirstThemaData(t);
        }
        populateThemaDataForm(td, dynaForm, request);
        return super.unspecified(mapping, dynaForm, request, response);
    }
    
    public ActionForward change(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(dynaForm, false);
        if (t==null)
            t = getFirstThema();
        ThemaData td = getFirstThemaData(t);
        populateThemaDataForm(td, dynaForm, request);
        return super.unspecified(mapping, dynaForm, request, response);
    }
    
    public ActionForward create(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(dynaForm, false);
        if (t==null)
            t = getFirstThema();
        dynaForm.initialize(mapping);
        String val = "";
        if (t!=null)
            val = Integer.toString(t.getId());
        dynaForm.set("themaID", val);
        prepareMethod(dynaForm, request, EDIT, LIST);
        addDefaultMessage(mapping, request);
        return getDefaultForward(mapping, request);
    }
    
    public ActionForward edit(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(dynaForm, false);
        if (t==null)
            t = getFirstThema();
        ThemaData td = getThemaData(dynaForm, false);
        if (td==null)
            td = getFirstThemaData(t);
        populateThemaDataForm(td, dynaForm, request);
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
        
        ThemaData t = getThemaData(dynaForm, true);
        if (t==null) {
            prepareMethod(dynaForm, request, LIST, EDIT);
            addAlternateMessage(mapping, request, NOTFOUND_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        populateThemaDataObject(dynaForm, t, request);
        
        sess.saveOrUpdate(t);
        sess.flush();
        
        /* Indien we input bijvoorbeeld herformatteren oid laad het dynaForm met
         * de waardes uit de database.
         */
        sess.refresh(t);
        populateThemaDataForm(t, dynaForm, request);
        
        return super.save(mapping, dynaForm, request, response);
    }
    
    public ActionForward createAllThemaData(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Themas t = getThema(dynaForm, false);
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        List attributes=null;
        if (t.getConnectie() == null || (t.getConnectie() != null && t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_JDBC))) {          
            Connection conn=null;
            if (t.getConnectie()!=null){
                conn=t.getConnectie().getJdbcConnection();
            }
            if (conn==null)
                conn = sess.connection();
            attributes=SpatialUtil.getAdminColumnNames(t, conn);
        }
        else if (t.getConnectie() != null && t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            //connectieType=Connecties.TYPE_WFS;
            List elements=WfsUtil.getFeatureElements(t);
            if (elements!=null){
                ArrayList elementsNames= new ArrayList();
                for (int i=0; i < elements.size(); i++){
                    Element e = (Element)elements.get(i);
                    elementsNames.add(e.getAttribute("name"));
                }
                attributes=elementsNames;
            }
        }        
        if (attributes!=null ){
            List bestaandeObjecten=SpatialUtil.getThemaData(t,false);
            for (int i=0; i < attributes.size(); i++){
                boolean bestaatAl=false;
                String themadataobject = (String)attributes.get(i);
                for (int j=0; j < bestaandeObjecten.size() && !bestaatAl; j++){
                    ThemaData td= (ThemaData)bestaandeObjecten.get(j);                    
                    if (themadataobject.compareTo(td.getKolomnaam())==0){
                        bestaatAl=true;
                    }
                }
                if (!bestaatAl){
                    ThemaData td = new ThemaData();                    
                    td.setBasisregel(false);
                    td.setDataType((DataTypen) sess.get(DataTypen.class,DataTypen.DATA));
                    td.setKolomnaam(themadataobject);
                    td.setLabel(themadataobject);
                    td.setThema(t);
                    td.setWaardeType((WaardeTypen) sess.get(WaardeTypen.class,WaardeTypen.STRING));
                    sess.saveOrUpdate(td);
                }else{
                    //niks doen
                }
            }
        }
        return unspecified(mapping,dynaForm,request,response);        
    }
    
    public ActionForward delete(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        if (!isTokenValid(request)) {
            prepareMethod(dynaForm, request, EDIT, LIST);
            addAlternateMessage(mapping, request, TOKEN_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        // nieuwe default actie op delete zetten
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        
        ThemaData td = getThemaData(dynaForm, false);
        if (td==null) {
            prepareMethod(dynaForm, request, LIST, EDIT);
            addAlternateMessage(mapping, request, NOTFOUND_ERROR_KEY);
            return getAlternateForward(mapping, request);
        }
        
        Themas t = td.getThema();
        t.getThemaData().remove(td);
        sess.delete(td);
        sess.flush();
        
        td = getFirstThemaData(t);
        dynaForm.initialize(mapping);
        populateThemaDataForm(td, dynaForm, request);
        prepareMethod(dynaForm, request, LIST, EDIT);
        addDefaultMessage(mapping, request);
        return getDefaultForward(mapping, request);
    }
    
    private void populateThemaDataForm(ThemaData td, DynaValidatorForm dynaForm, HttpServletRequest request) {
        if (td==null)
            return;
        dynaForm.set("themaDataID", Integer.toString(td.getId()));
        dynaForm.set("label", td.getLabel());
        dynaForm.set("eenheid", td.getEenheid());
        dynaForm.set("omschrijving", td.getOmschrijving());
        String val = "";
        if (td.getThema()!=null)
            val = Integer.toString(td.getThema().getId());
        dynaForm.set("themaID", val);
        dynaForm.set("basisregel", new Boolean(td.isBasisregel()));
        dynaForm.set("voorbeelden", td.getVoorbeelden());
        dynaForm.set("kolombreedte", FormUtils.IntToString(td.getKolombreedte()));
        val = "";
        if (td.getMoscow()!=null)
            val = Integer.toString(td.getMoscow().getId());
        dynaForm.set("moscowID", val);
        val = "";
        if (td.getWaardeType()!=null)
            val = Integer.toString(td.getWaardeType().getId());
        dynaForm.set("waardeTypeID", val);
        val = "";
        if (td.getDataType()!=null)
            val = Integer.toString(td.getDataType().getId());
        dynaForm.set("dataTypeID", val);
        dynaForm.set("commando", td.getCommando());
        dynaForm.set("kolomnaam", td.getKolomnaam());
        if(td.getDataorder()!=null)
            dynaForm.set("dataorder", FormUtils.IntToString(td.getDataorder()));
    }
    
    private void populateThemaDataObject(DynaValidatorForm dynaForm, ThemaData td, HttpServletRequest request) {
        
        Boolean b = (Boolean)dynaForm.get("basisregel");
        td.setBasisregel(b==null?false:b.booleanValue());
        td.setCommando(FormUtils.nullIfEmpty(dynaForm.getString("commando")));
        if (FormUtils.nullIfEmpty(dynaForm.getString("dataorder"))!=null)
            td.setDataorder(Integer.parseInt(dynaForm.getString("dataorder")));
        td.setEenheid(FormUtils.nullIfEmpty(dynaForm.getString("eenheid")));
        td.setKolombreedte(FormUtils.StringToInt(dynaForm.getString("kolombreedte")));
        td.setKolomnaam(FormUtils.nullIfEmpty(dynaForm.getString("kolomnaam")));
        td.setLabel(FormUtils.nullIfEmpty(dynaForm.getString("label")));
        td.setOmschrijving(FormUtils.nullIfEmpty(dynaForm.getString("omschrijving")));
        td.setVoorbeelden(FormUtils.nullIfEmpty(dynaForm.getString("voorbeelden")));
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        int mId=0, tId=0, dId=0, wId=0;
        try {
            mId = Integer.parseInt(dynaForm.getString("moscowID"));
        } catch (NumberFormatException ex) {
            log.error("Illegal Moscow type id", ex);
        }
        try {
            tId = Integer.parseInt(dynaForm.getString("themaID"));
        } catch (NumberFormatException ex) {
            log.error("Illegal themaID", ex);
        }
        try {
            dId = Integer.parseInt(dynaForm.getString("dataTypeID"));
        } catch (NumberFormatException ex) {
            log.error("Illegal dataTypeID", ex);
        }
        try {
            wId = Integer.parseInt(dynaForm.getString("waardeTypeID"));
        } catch (NumberFormatException ex) {
            log.error("Illegal waardeTypeID", ex);
        }
        Moscow m = (Moscow)sess.get(Moscow.class, new Integer(mId));
        td.setMoscow(m);
        Themas t = (Themas)sess.get(Themas.class, new Integer(tId));
        td.setThema(t);
        DataTypen d = (DataTypen)sess.get(DataTypen.class, new Integer(dId));
        td.setDataType(d);
        WaardeTypen w = (WaardeTypen)sess.get(WaardeTypen.class, new Integer(wId));
        td.setWaardeType(w);
    }
    
    
}
