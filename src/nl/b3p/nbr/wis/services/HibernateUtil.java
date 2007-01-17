/*
 * $Id: HibernateUtil.java 2757 2006-02-28 16:58:52Z Matthijs $
 */

package nl.b3p.nbr.wis.services;

import org.apache.commons.logging.*;

import org.hibernate.*;
import org.hibernate.cfg.*;

public class HibernateUtil {
    private static final Log log = LogFactory.getLog(HibernateUtil.class);
    
    private static final SessionFactory sessionFactory;

    static {
        try {
            /* Create the SessionFactory from hibernate.cfg.xml */
            Configuration config = new Configuration();
            
            /* Gebruik ImprovedNamingStrategy. Let op, deze staat ook in 
             * build.xml bij hbm2ddl.
             */
            config.setNamingStrategy(org.hibernate.cfg.ImprovedNamingStrategy.INSTANCE);
            sessionFactory = config.configure().buildSessionFactory();
        } catch (Throwable ex) {
            /* Make sure you log the exception, as it might be swallowed */
            log.error("Initial SessionFactory creation failed", ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
}