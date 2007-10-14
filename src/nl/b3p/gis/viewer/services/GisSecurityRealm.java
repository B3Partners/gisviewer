/*
 * $Id: NbrSecurityRealm.java 6875 2007-09-25 14:54:38Z Chris $
 */

package nl.b3p.gis.viewer.services;

import java.io.IOException;
import java.security.Principal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import nl.b3p.wms.capabilities.ServiceProvider;
import nl.b3p.wms.capabilities.WMSCapabilitiesReader;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.securityfilter.filter.SecurityRequestWrapper;
import org.securityfilter.realm.ExternalAuthenticatedRealm;
import org.securityfilter.realm.FlexibleRealmInterface;
import org.xml.sax.SAXException;

public class GisSecurityRealm implements FlexibleRealmInterface, ExternalAuthenticatedRealm {
    private static final Log log = LogFactory.getLog(GisSecurityRealm.class);
    
    private static final String FORM_USERNAME = "j_username";
    private static final String FORM_PASSWORD = "j_password";
    private static final String CAPABILITIES_QUERYSTRING = "REQUEST=GetCapabilities&VERSION=1.1.1&SERVICE=WMS";
    
    public Principal authenticate(SecurityRequestWrapper request) {
        
        
        String username = request.getParameter(FORM_USERNAME);
        String password = request.getParameter(FORM_PASSWORD);
        HttpSession sess = request.getSession();
        
        // Eventueel fake Principal aanmaken
        if (!HibernateUtil.CHECK_LOGIN_KAARTENBALIE)
            return authenticateFake(username);
        
        // Haal rechten van user op
        String url = HibernateUtil.KBURL;
        if (url.lastIndexOf('?') == url.length()-1)
            url += CAPABILITIES_QUERYSTRING;
        else if (url.lastIndexOf('&') == url.length()-1)
            url += CAPABILITIES_QUERYSTRING;
        else
            url += "?" + CAPABILITIES_QUERYSTRING;
        
        GisPrincipal user = authenticateHttp(url, username, password);
        if (user!=null) {
            // Als rechten binnengekregen, dan anonieme rechten verwijderen
            sess.removeAttribute(GisPrincipal.ANONYMOUS_PRINCIPAL);
            // door principal te returnen wordt cookie gezet
            return user;
        }
        
        // Kijken of er al anonieme rechten staan, zo ja niets meer doen
        user = (GisPrincipal)sess.getAttribute(GisPrincipal.ANONYMOUS_PRINCIPAL);
        if (user!=null)
            return null;
        
        // Kijk wat rechten voor anonieme gebruiker zijn en zet op sessie
        user = authenticateHttp(HibernateUtil.KBURL,
                HibernateUtil.ANONYMOUS_USER,
                HibernateUtil.ANONYMOUS_PASSWORD);
        if (user!=null)
            sess.setAttribute(GisPrincipal.ANONYMOUS_PRINCIPAL, user);
        
        // Return null om te voorkomen dat cookie gezet wordt en de
        // gebruiker niet alsnog kan inloggen
        return null;
    }
    
    public Principal getAuthenticatedPrincipal(String username) {
        return null;
    }
    
    public boolean isUserInRole(Principal principal, String rolename) {
        return ((GisPrincipal)principal).isInRole(rolename);
    }
    
    protected GisPrincipal authenticateFake(String username) {
        
        List roles = new ArrayList();
        roles.add(HibernateUtil.GEBRUIKERS_ROL);
        roles.add(HibernateUtil.THEMABEHEERDERS_ROL);
        
        return new GisPrincipal(username, roles);
    }
    
    protected GisPrincipal authenticateHttp(String location, String username, String password) {
        WMSCapabilitiesReader wmscr = new WMSCapabilitiesReader();
        ServiceProvider sp = null;
        try {
            sp = wmscr.getProvider(location, username, password);
        } catch (Exception ex) {
            log.error("", ex);
        }
        
        if (sp==null) {
            log.error("No ServiceProvider found, denying login!");
            return null;
        }
        
        if(sp.getAllRoles() == null || sp.getAllRoles().isEmpty()) {
            log.error("ServiceProvider has no roles, denying login!");
            return null;
        }
        
        log.debug("login: " + username);
        return new GisPrincipal(username, sp);
    }
    
    // database schema veranderd, dus werkt niet meer goed
    protected GisPrincipal authenticateJdbc(String username, String password) {
        try {
            DataSource ds = (DataSource)new InitialContext().lookup("java:comp/env/jdbc/kaartenbalie");
            
            Connection c = null;
            PreparedStatement ps = null;
            try {
                c = ds.getConnection();
                /* let op: full join, dus levert alleen users op die rechten hebben
                 * op minimaal 1 layer
                 */
                
                /* TODO: haal rollen op ipv organization name en layers... */
                ps = c.prepareStatement(
                        "select u.firstname, u.lastname, u.username, o.name, l.name " +
                        "from user u " +
                        "join organization o on (o.organizationid = u.organizationid) " +
                        "join organizationlayer ol on (ol.organizationid = u.organizationid) " +
                        "join layer l on (l.layerid = ol.layerid) " +
                        "where u.username = ? and u.password = ?");
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();
                if(!rs.next()) {
                    return null;
                } else {
                    /* TODO: maak Principal met collectie van layers tot welke
                     * hij toegang heeft (als roles) en of ie in de
                     * themabeheerders organisatie zit?
                     */
                    List roles = new ArrayList();
                    String organization = rs.getString(4);
                    if(organization.equals(HibernateUtil.GEBRUIKERS_ROL)) {
                        roles.add("gebruiker");
                    } else if(organization.equals(HibernateUtil.THEMABEHEERDERS_ROL)) {
                        roles.add("themabeheerder");
                    } else {
                        /* kaartenbalie gebruiker is niet lid van speciale PNB
                         * organisatie, geen toegang
                         */
                        return null;
                    }
                    
                    String name = rs.getString(1) + " " + rs.getString(2);
                    do {
                        roles.add("layer_" + rs.getString(5));
                    } while(rs.next());
                    return new GisPrincipal(name, roles);
                }
            } finally {
                if(ps != null) {
                    ps.close();
                }
                if(c != null) {
                    c.close();
                }
            }
        } catch(Exception e) {
            log.error("error authenticating username/password", e);
            return null;
        }
    }
    
    public Principal authenticate(String username, String password) {
        return null;
    }
    
}
