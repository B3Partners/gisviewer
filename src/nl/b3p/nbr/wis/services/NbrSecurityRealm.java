/*
 * $Id$
 */

package nl.b3p.nbr.wis.services;

import java.security.Principal;
import org.securityfilter.realm.SecurityRealmInterface;
import org.securityfilter.realm.SimplePrincipal;

public class NbrSecurityRealm implements SecurityRealmInterface {
    public Principal authenticate(String username, String password) {
        if(password == null || password.trim().equals("")) {
            return null;
        } else {
            return new SimplePrincipal(username);
        }
    }

    public boolean isUserInRole(Principal principal, String rolename) {
        return true;
    }
}
