package nl.b3p.nbr.wis;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import nl.b3p.nbr.wis.db.ThemaItemsAdmin;
import nl.b3p.nbr.wis.services.HibernateUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForward;
import org.apache.struts.util.MessageResources;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

/**
 *
 * @author Geert
 */
public class GetViewerAdminData {
    
    private static final Log log = LogFactory.getLog(GetViewerAdminData.class);
    
    public GetViewerAdminData() {
        Session sess = getHibernateSession();
        Transaction tx = sess.beginTransaction();
        
        ActionForward forward = null;
        String msg = null;
        try {
            tx.commit();
        } catch(Exception e) {
            tx.rollback();
            log.error("Exception occured, rollback", e);
            
            if (e instanceof org.hibernate.JDBCException) {
                msg = e.toString();
                SQLException sqle = ((org.hibernate.JDBCException)e).getSQLException();
                msg = msg + ": " + sqle;
                SQLException nextSqlE = sqle.getNextException();
                if(nextSqlE != null) {
                    msg = msg + ": " + nextSqlE;
                }
            } else {
                msg = e.toString();
            }
            
        }
    }
    
    public ArrayList getData(String id) {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        List ctl = null;
        String hquery = "FROM thema_items_admin WHERE basisregel=" + id;
        Query q = sess.createQuery(hquery);
        ctl = q.list();
        if(ctl != null) {
            ArrayList returnValues = new ArrayList();
            Iterator it = ctl.iterator();
            while(it.hasNext()) {
                ThemaItemsAdmin tia = (ThemaItemsAdmin) it.next();
                returnValues.add(tia);
            }
            return returnValues;
        }
        return null;
    }
    
    protected Session getHibernateSession() {
        return HibernateUtil.getSessionFactory().getCurrentSession();
    }
    
}