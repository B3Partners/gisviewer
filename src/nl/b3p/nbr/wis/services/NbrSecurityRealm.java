/*
 * $Id$
 */

package nl.b3p.nbr.wis.services;

import java.security.Principal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.securityfilter.realm.ExternalAuthenticatedRealm;
import org.securityfilter.realm.SecurityRealmInterface;

public class NbrSecurityRealm implements SecurityRealmInterface, ExternalAuthenticatedRealm {
    private static final Log log = LogFactory.getLog(NbrSecurityRealm.class);
    
    /* Naam van de organisatie van kaartenbalie gebruikers voor de rollen "gebruiker"
     * en "themabeheerder"
     */
    private static final String GEWONE_GEBRUIKERS_ORGANISATIE = "PNB - Gewone gebruikers";
    private static final String THEMABEHEERDERS_ORGANISATE = "PNB - Themabeheerders";
    
    public Principal authenticate(String username, String password) {
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
                    if(organization.equals(GEWONE_GEBRUIKERS_ORGANISATIE)) {
                        roles.add("gebruiker");
                    } else if(organization.equals(THEMABEHEERDERS_ORGANISATE)) {
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
                    return new NbrPrincipal(name, roles);
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
    
    public Principal getAuthenticatedPrincipal(String username) {
        return null;
    }

    public boolean isUserInRole(Principal principal, String rolename) {
        return ((NbrPrincipal)principal).isInRole(rolename);
    }
}
