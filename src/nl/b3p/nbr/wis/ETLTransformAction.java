/**
 * @(#)ETLTransformAction.java
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

package nl.b3p.gis.viewer;

import java.io.UnsupportedEncodingException;
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
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.gis.viewer.BaseGisAction;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Query;
import org.hibernate.Session;

public class ETLTransformAction extends BaseGisAction {
    
    private static final Log log = LogFactory.getLog(ETLTransformAction.class);
    
    private static final String ADMINDATA = "admindata";
    private static final String EDIT = "edit";
    private static final String SHOWOPTIONS = "showOptions";
    
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
        List thema_data = SpatialUtil.getThemaData(t, false);
        Object o = thema_data.get(1);
        request.setAttribute("thema_items", thema_data);
        if(thema_data != null && !thema_data.isEmpty()) {
            request.setAttribute("regels", getThemaObjects(t, status, thema_data));
        } else {
            request.setAttribute("regels", null);
        }
        return mapping.findForward("showData");
    }
    // </editor-fold>
    
    /**
     * /**
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
    protected List getThemaObjects(Themas t, String status, List thema_items) throws SQLException, UnsupportedEncodingException {
        if (t==null)
            return null;
        ArrayList regels = new ArrayList();
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        String taq = "select * from " + t.getSpatial_tabel() + " where status_etl = ?";
        
        try {
            PreparedStatement statement = connection.prepareStatement(taq);
            statement.setString(1, status);
            try {
                ResultSet rs = statement.executeQuery();
                while(rs.next()) {
                    regels.add(getRegel(rs, t, thema_items));
                }
            } finally {
                statement.close();
            }
        } finally {
            connection.close();
        }
        return regels;
    }
    
    /*
     * Methode die aangeroepen wordt om de boomstructuur op te bouwen. De opbouw wordt op een iteratieve en recursieve
     * manier uitgevoerd waarbij over de verschillende thema's heen gewandeld wordt om van deze thema's de children
     * (clusters) te bepalen en in de juiste volgorde in de lijst te plaatsen.
     *
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     *
     * @throws Exception
     */
    protected void createLists(DynaValidatorForm dynaForm, HttpServletRequest request) {
        List ctl = SpatialUtil.getValidClusters();
        List themalist = getValidThemas(false, request);
        List newThemalist = new ArrayList(themalist);
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        Iterator it = themalist.iterator();
        while(it.hasNext()) {
            Themas t = (Themas)it.next();
            boolean etlExists = false;
            try {
                etlExists = SpatialUtil.isEtlThema(t, connection);
            } catch (SQLException sqle) {
                
            }
            if (!etlExists) {
                 newThemalist.remove(t);
            }
        }
        try {
            connection.close();
        } catch (SQLException ex) {
            log.error("", ex);
        }
        
        request.setAttribute("themalist", newThemalist);
    }
    
}
