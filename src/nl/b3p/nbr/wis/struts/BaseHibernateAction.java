/**
 * @(#)BaseHibernateAction.java
 * @author Matthijs Laan
 * @version 1.00 2006/03/23
 *
 * Purpose: Een base class voor het initialiseren en uitvoeren van alle Hibernate actions.
 * Alle Actions die door een gebruiker of het systeem aangeroepen worden komen
 * langs deze klasse om de communicatie met Hibernate te bewerkstelligen. Eventuele
 * fouten zullen ook hier worden afgevangen en worden via deze klasse op een voor 
 * de gebruiker duidelijke manier afgehandeld en op het scherm getoond.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.struts;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodAction;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.nbr.wis.services.HibernateUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Session;
import org.hibernate.Transaction;

public abstract class BaseHibernateAction extends ExtendedMethodAction {
    
    private static final Log log = LogFactory.getLog(BaseHibernateAction.class);
    protected static final String SUCCESS = "success";
    protected static final String FAILURE = "failure";
    protected static final String VALIDATION_ERROR_KEY = "error.validation";
    
    /** 
     * Een Struts action die doorverwijst naar de strandaard forward.
     * 
     * @param mapping ActionMapping die gebruikt wordt voor deze forward.
     * @param request HttpServletRequest die gebruikt wordt voor deze forward.
     *
     * @return ActionForward met de struts forward waar deze methode naar toe moet verwijzen.
     * 
     */
    // <editor-fold defaultstate="" desc="protected ActionForward getUnspecifiedDefaultForward(ActionMapping mapping, HttpServletRequest request)">
    protected ActionForward getUnspecifiedDefaultForward(ActionMapping mapping, HttpServletRequest request) {
        return mapping.findForward(SUCCESS);
    }
    // </editor-fold>
    
    /** 
     * Een Struts action execute die verwijst naar de standaard action als alles goed verloopt en anders een 
     * alternatieve forward aanroept.
     * 
     * @param mapping ActionMapping die gebruikt wordt voor deze forward.
     * @param form ActionForm die gebruikt wordt voor deze forward.
     * @param request HttpServletRequest die gebruikt wordt voor deze forward.
     * @param response HttpServletResponse die gebruikt wordt voor deze forward.
     *
     * @return ActionForward met de struts forward waar deze methode naar toe moet verwijzen.
     *
     * @throws Exception
     * 
     */
    // <editor-fold defaultstate="" desc="public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception">
    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        Session sess = getHibernateSession();
        Transaction tx = sess.beginTransaction();
        
        ActionForward forward = null;
        String msg = null;
        try {
            forward = super.execute(mapping, form, request, response);
            tx.commit();
            return forward;
        } catch(Exception e) {
            tx.rollback();
            log.error("Exception occured, rollback", e);
            MessageResources messages = getResources(request);
            
            if (e instanceof org.hibernate.JDBCException) {
                msg = e.toString();
                SQLException sqle = ((org.hibernate.JDBCException)e).getSQLException();
                msg = msg + ": " + sqle;
                SQLException nextSqlE = sqle.getNextException();
                if(nextSqlE != null) {
                    msg = msg + ": " + nextSqlE;
                }
            } else if (e instanceof java.sql.SQLException) {
                msg = e.toString();
                SQLException nextSqlE = ((java.sql.SQLException)e).getNextException();
                if(nextSqlE != null) {
                    msg = msg + ": " + nextSqlE;
                }
            } else {
                msg = e.toString();
            }
            addAlternateMessage(mapping, request, null, msg);
            return getAlternateForward(mapping, request);
        }
        
    }
    // </editor-fold>
    
    /** 
     * Return de hibernate session.
     *
     * @return Session met de huidige hibernate session.
     *
     * @see Session
     * 
     */
    // <editor-fold defaultstate="" desc="protected Session getHibernateSession()">
    protected Session getHibernateSession() {
        return HibernateUtil.getSessionFactory().getCurrentSession();
    }
    // </editor-fold>
}