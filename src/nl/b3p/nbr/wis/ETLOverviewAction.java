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
    private static final String [] STATUS = new String [] {"NO", "OAO", "OGO", "GO", "VO", "OO"};
    
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
        ArrayList overview = new ArrayList();
        String thema_naam = null;
        String admin_tabel = null;
        
        String themaQuery = "SELECT naam, admin_tabel FROM themas WHERE admin_tabel IS NOT NULL ORDER BY naam";
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        try {
            PreparedStatement statement = connection.prepareStatement(themaQuery);
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()){
                    thema_naam  = rs.getString("naam");
                    admin_tabel = rs.getString("admin_tabel");
                    ArrayList count = getCount(thema_naam, admin_tabel);
                    if(count != null) {
                        overview.add(getCount(thema_naam, admin_tabel));
                    }
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
    
    /**
     * Een methode die van een bepaald thema bepaald hoeveel hits er van elke status zijn.
     * De verschillende statussen die gebruikt worden zijn:
     * - NO
     * - OGO
     * - OAO
     * - GO
     * - VO
     * - OO
     *
     * Naast deze statussen wordt ook berekend wat het totaal aantal statussen is en wat het percentage
     * onvolledige objecten is binnen het thema. Deze wordt berekend uit het percentage OGO
     * en OAO.
     *
     * Om deze berekening snel uit te kunnen voeren is de database geoptimaliseerd. Hiertoe zijn er van de
     * huidige bruikbare tabellen indices gemaakt zodat de database een snelle response kan leveren.
     *
     * Een dergelijke index is als volgt gemaakt:
     * CREATE INDEX tankstations_centroid_status_index ON tankstations_centroid USING BTREE (status_etl)
     *
     * Een dergelijke index kan ook weer verwijderd worden. Dit kan als volgt:
     * DROP INDEX tankstations_centroid_status_index
     *
     * @param thema_naam String met de naam van het thema waar de telling van verricht moet worden.
     * @param admin_tabel String met de naam van de tabel van het thema waar de tellingen uit opgehaald kunnen worden.
     *
     * @return ArrayList met de tellingen van de verschillende statussen voor het betreffende thema.
     */
    // <editor-fold defaultstate="" desc="private ArrayList getCount(String thema_naam, String admin_tabel)">
    private ArrayList getCount(String thema_naam, String admin_tabel) {
        ArrayList count = new ArrayList();
        
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Connection connection = sess.connection();
        
        boolean columnExists = false;
        if(admin_tabel != null) {
            //Create two queries            
            String existQuery = "SELECT * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='" + 
                    admin_tabel + "' AND COLUMN_NAME = 'status_etl'";
            
            String selectQuery = "SELECT COUNT(1) as Total, " +
                    "  (SELECT COUNT(1) FROM " + admin_tabel + " AS subresult WHERE subresult.status_etl = '" + STATUS[0] + "') AS Status_" + STATUS[0] + ", " +
                    "  (SELECT COUNT(1) FROM " + admin_tabel + " AS subresult WHERE subresult.status_etl = '" + STATUS[1] + "') AS Status_" + STATUS[1] + ", " +
                    "  (SELECT COUNT(1) FROM " + admin_tabel + " AS subresult WHERE subresult.status_etl = '" + STATUS[2] + "') AS Status_" + STATUS[2] + ", " +
                    "  (SELECT COUNT(1) FROM " + admin_tabel + " AS subresult WHERE subresult.status_etl = '" + STATUS[3] + "') AS Status_" + STATUS[3] + ", " +
                    "  (SELECT COUNT(1) FROM " + admin_tabel + " AS subresult WHERE subresult.status_etl = '" + STATUS[4] + "') AS Status_" + STATUS[4] + ", " +
                    "  (SELECT COUNT(1) FROM " + admin_tabel + " AS subresult WHERE subresult.status_etl = '" + STATUS[5] + "') AS Status_" + STATUS[5] + " " +
                    "FROM " + admin_tabel;
            
            boolean exists = false;
            try {
                PreparedStatement statement = connection.prepareStatement(existQuery);
                ResultSet rs = statement.executeQuery();
                if (rs.next()){
                    exists = true;
                }
                statement.close();
            } catch (SQLException ex) {
                log.error("", ex);
            } finally {
                try {
                    connection.close();
                } catch (SQLException ex) {
                    log.error("", ex);
                }
            }
            
            if(exists) { 
                try {
                    count.add(thema_naam);
                    int total = 0;
                    PreparedStatement statement = connection.prepareStatement(selectQuery);
                    ResultSet rs = statement.executeQuery();
                    if (rs.next()){
                        count.add(rs.getInt("Status_" + STATUS[0]));
                        count.add(rs.getInt("Status_" + STATUS[1]));
                        count.add(rs.getInt("Status_" + STATUS[2]));
                        count.add(rs.getInt("Status_" + STATUS[3]));
                        count.add(rs.getInt("Status_" + STATUS[4]));
                        count.add(rs.getInt("Status_" + STATUS[5]));
                        total = rs.getInt("Total");
                        count.add(total);
                        statement.close();
                    }

                    int amountOGO = (Integer)count.get(2);
                    int amountOAO = (Integer)count.get(3);
                    if(total != 0) {
                        int percent = ((amountOGO + amountOAO) * 100) / total;
                        count.add(percent);
                    } else {
                        count.add(0);
                    }
                    statement.close();
                } catch (SQLException ex) {
                    log.error("", ex);
                } finally {
                    try {
                        connection.close();
                    } catch (SQLException ex) {
                        log.error("", ex);
                    }
                }
            } else {
                return null;
            }
        }
        
        return count;
    }
    // </editor-fold>
    
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