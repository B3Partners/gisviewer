/*
 * $Id: NbrSecurityRealm.java 6875 2007-09-25 14:54:38Z Chris $
 */

package nl.b3p.gis.viewer.services;

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
        
        return authenticateHttp(url, username, password);
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
    
    public Principal authenticate(String username, String password) {
        return null;
    }    
}
