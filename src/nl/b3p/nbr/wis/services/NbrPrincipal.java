/*
 * $Id$
 */

package nl.b3p.nbr.wis.services;

import java.security.Principal;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class NbrPrincipal implements Principal {
    private String name;
    private Set roles;
    
    public NbrPrincipal(String name, List roles) {
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
    
    public String toString() {
        return "NbrPrincipal[name=" + name + "]";
    }
    
    /* TODO: implement equals/hashCode */
}
