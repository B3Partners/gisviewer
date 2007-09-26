/*
 * $Id: NbrPrincipal.java 6852 2007-09-24 11:47:11Z Matthijs $
 */

package nl.b3p.gis.viewer.services;

import java.security.Principal;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class GisPrincipal implements Principal {
    private String name;
    private Set roles;
    
    public GisPrincipal(String name, List roles) {
        this.name = name;
        this.roles = new HashSet();
        this.roles.addAll(roles);
    }

    public String getName() {
        return name;
    }
    
    public boolean isInRole(String role) {
        return roles.contains(role);
    }
    
    public Set getRoles() {
        return roles;
    }
    
    public String toString() {
        return "GisPrincipal[name=" + name + "]";
    }
    
    /* TODO: implement equals/hashCode */
}
