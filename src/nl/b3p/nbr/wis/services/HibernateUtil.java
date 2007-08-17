/**
 * @(#)HibernateUtil.java
 * @author Matthijs Laan
 * @version 1.00 2006/02/28
 *
 * Purpose: Een klasse die nodig is om de communicatie met Hibernate te initialiseren.
 * Hiervoor worden verschillende instellingen uit een xml ingeladen en in het programma
 * vastgehouden tot de applicatie afgesloten wordt.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.services;

import org.apache.commons.logging.*;
import org.hibernate.*;
import org.hibernate.cfg.*;

public class HibernateUtil {
    
    private static final Log log = LogFactory.getLog(HibernateUtil.class);
    private static final SessionFactory sessionFactory;
    
    /** 
     * Initialiseer Hibernate.
     * Creeer de SessionFactory vanuit hibernate.cfg.xml.
     *
     * Gebruik ImprovedNamingStrategy. Let op, deze staat ook in build.xml bij hbm2ddl.
     * 
     */
    // <editor-fold defaultstate="" desc="static">
    static {
        try {
            Configuration config = new Configuration();
            config.setNamingStrategy(org.hibernate.cfg.ImprovedNamingStrategy.INSTANCE);
            sessionFactory = config.configure().buildSessionFactory();
        } catch (Throwable ex) {
            log.error("Initial SessionFactory creation failed", ex);
            throw new ExceptionInInitializerError(ex);
        }
    }
    // </editor-fold>
    
    /** 
     * Returns the SessionFactory of Hibernate.
     *
     * @return SessionFactory met de Hibernate session factory.
     *
     * @see SessionFactory
     */
    // <editor-fold defaultstate="" desc="public static SessionFactory getSessionFactory()">
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
    // </editor-fold>
}