/**
 * @(#)KaartenbalieCrudAction.java
 * @author R. Braam
 * @version 1.00 2006/09/08
 *
 * Purpose: a class handling the different actions which come from classes extending this class.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer;

import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.CrudAction;
import nl.b3p.gis.viewer.services.HibernateUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.MessageResources;
import org.apache.struts.validator.DynaValidatorForm;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class ViewerCrudAction extends CrudAction {
    
    private static Log log = LogFactory.getLog(ViewerCrudAction.class);
    
    protected ActionForward getUnspecifiedAlternateForward(ActionMapping mapping, HttpServletRequest request) {
        return mapping.findForward(FAILURE);
    }
    
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
    throws Exception {
        
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Transaction tx = sess.getTransaction();
        tx.begin();
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
        }
        
        // Start tweede sessie om tenminste nog de lijsten op te halen
        sess = HibernateUtil.getSessionFactory().getCurrentSession();
        tx = sess.getTransaction();
        tx.begin();
        
        try {
            prepareMethod((DynaValidatorForm)form, request, LIST, EDIT);
            //throw new Exception("Lorem Ipsum 2");
            tx.commit();
        } catch(Exception e) {
            tx.rollback();
            log.error("Exception occured in second session, rollback", e);
            addAlternateMessage(mapping, request, null, e.toString());
        }
        //addAlternateMessage(mapping, request, null, message);
        return getAlternateForward(mapping, request);
    }
    
}
