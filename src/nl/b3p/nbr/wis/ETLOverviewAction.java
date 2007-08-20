/*
 * @(#)ETLOverviewAction.java
 * @author N. de Goeij
 * @version 1.00, 20 augustus 2007
 *
 * @copyright 2007 B3Partners. All rights reserved.
 * B3Partners PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 */

package nl.b3p.nbr.wis;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.nbr.wis.services.HibernateUtil;
import nl.b3p.nbr.wis.struts.BaseHibernateAction;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Session;

/**
 * ETLOverviewAction definition:
 */

public class ETLOverviewAction extends BaseHibernateAction {
    
    private static final Log log = LogFactory.getLog(ETLOverviewAction.class);
    
    private static final String ADMINDATA = "admindata";
    private static final String EDIT = "edit";
    private static final String SHOWOPTIONS = "showOptions";
    private static final String KNOP = "knop";
    
    private static final String GIVEN_COLUMN_NAME = "status";
    private static final String [] STATUS = new String [] {"NO", "OGO", "OAO", "GO", "VO", "FO", "OO"};
    
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
        createOverview(dynaForm, request);
        return mapping.findForward(SUCCESS);
    }
    // </editor-fold>
    
    
    /**
     * Methode die zorg draagt voor het vullen en op het request zetten van de overzichtsresultaten 
     * van de verschillende Thema afwijkingen die tijdens het laatste ETL proces aan het licht gekomen
     * zijn. Per Thema wordt er een onderscheidt gemaakt in de verschillende statussen die aan het
     * Thema toegekend kan zijn.
     *
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     */
    // <editor-fold defaultstate="" desc="private void createOverview(DynaValidatorForm dynaForm, HttpServletRequest request)">
    private void createOverview(DynaValidatorForm dynaForm, HttpServletRequest request) {
        
        
        //Vraag eerst een lijst op van alle thema's die in de db bekend zijn
        //Vraag vervolgens per thema alle items op
        //Sorteer het thema op status en creeer arraylists met een deel van het thema
        //geselecteerd per status
        //Moet geen volledige Thema selectie gedaan worden alleen een count.
        
        
        //Een lijst met alle themas (namen en admin tabellen)
        //SELECT naam, admin_tabel FROM themas
        
        //de admin tabellen kunnen gebruikt worden in onderstaande QUERY
        //De status moet iedere keer aangepast worden.
        //SELECT COUNT(1) FROM tankstations_centroid WHERE status = 'OGO'
        
        //de integers die uit bovenstaande query komen,
        //moeten opgeteld worden. Daarmee kan het percentage incorrecte
        //gegevens uitgerekend worden.
        ArrayList overview = new ArrayList();
        
        String thema_naam = null;
        String admin_tabel = null;
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        String themaQuery = "SELECT naam, admin_tabel FROM themas";
        try {
            PreparedStatement statement = connection.prepareStatement(themaQuery);
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()){
                    thema_naam  = rs.getString("naam");
                    admin_tabel = rs.getString("admin_tabel");
                    
                    ArrayList count = new ArrayList();
                    if(admin_tabel != null && checkThemaStatusAvailable(admin_tabel)) {
                        //Doe dan iets waarmee de waarden opgehaald kunnen worden....
                        count = getCount(thema_naam, admin_tabel);
                    } else {
                        count.add(thema_naam);
                        for (int i = 0; i < STATUS.length; i++) {
                            count.add("onbekend");
                        }
                    }
                    overview.add(count);
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
        request.setAttribute("overview", overview);
        //return themaGeomType;
    }
    // </editor-fold>
    
    private boolean checkThemaStatusAvailable(String admin_tabel) {
        //controleer van het thema of de admin tabel wel een status kolom heeft
        boolean bool = false;
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        try {
            // Create a result set
            PreparedStatement _statement = connection.prepareStatement("SELECT * FROM " + admin_tabel);
            ResultSet result = _statement.executeQuery();
            
            // Get result set meta data
            ResultSetMetaData rsmd = result.getMetaData();
            int numColumns = rsmd.getColumnCount();
            
            // Get the column names; column indices start from 1
            for (int i = 1; i < numColumns + 1; i++) {
                String columnName = rsmd.getColumnName(i);
                if(columnName.equalsIgnoreCase(GIVEN_COLUMN_NAME)) {
                    bool = true;
                }
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
        
        return bool;
    }
    
    private ArrayList getCount(String thema_naam, String admin_tabel) {
        ArrayList count = new ArrayList();
        count.add(thema_naam);
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        if(admin_tabel != null) {
            for (int i = 0; i < STATUS.length; i++) {
                String query = "SELECT COUNT(1) FROM " + admin_tabel + " WHERE status = '" + STATUS[i] + "'";
                try {
                    PreparedStatement statement = connection.prepareStatement(query);
                    try {
                        ResultSet rs = statement.executeQuery();
                        if (rs.next()){
                            count.add(rs.getInt("status"));
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
        } else {
            for (int i = 0; i < STATUS.length; i++) {
                count.add("onbekend");
            }
        }
        return count;
    }
    
    
    
    
    /**
     * Return een hashmap. Deze is verplicht overriden vanwege abstracte klasse BaseHibernateAction.
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