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

package nl.b3p.gis.viewer.services;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil extends HttpServlet {
    
    private static final Log log = LogFactory.getLog(HibernateUtil.class);
    private static final SessionFactory sessionFactory;
    
    public static String ANONIEM_ROL= "anoniem";
    public static String GEBRUIKERS_ROL = "gebruiker";
    public static String THEMABEHEERDERS_ROL = "themabeheerder";
    public static String DEMOGEBRUIKERS_ROL = "demogebruiker";
    public static String BEHEERDERS_ROL = "beheerder";
    
    public static String KBURL = "http://localhost:8084/kaartenbalie/wms/";
    
    public static boolean CHECK_LOGIN_KAARTENBALIE = true;
    public static String ANONYMOUS_USER = "anoniem";
    public static String KAARTENBALIE_CLUSTER = "Extra";
    
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
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        
        try {
            String value = config.getInitParameter("kburl");
            if (value!=null && value.length()>0)
                KBURL = value;
            value = config.getInitParameter("anonymous_user");
            if (value!=null && value.length()>0)
                ANONYMOUS_USER = value;
            
            value = config.getInitParameter("gebruikers_rol");
            if (value!=null && value.length()>0)
                GEBRUIKERS_ROL = value;
            value = config.getInitParameter("themabeheerders_rol");
            if (value!=null && value.length()>0)
                THEMABEHEERDERS_ROL = value;
            
            value = config.getInitParameter("check_login_kaartenbalie");
            if (value!=null && value.equalsIgnoreCase("false"))
                CHECK_LOGIN_KAARTENBALIE = false;

            
        } catch(Exception e) {
            throw new ServletException(e);
        }
    }
    
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