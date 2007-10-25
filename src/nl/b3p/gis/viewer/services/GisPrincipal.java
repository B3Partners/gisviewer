/*
 * $Id: NbrPrincipal.java 6852 2007-09-24 11:47:11Z Matthijs $
 */

package nl.b3p.gis.viewer.services;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import nl.b3p.wms.capabilities.Layer;
import nl.b3p.wms.capabilities.Roles;
import nl.b3p.wms.capabilities.ServiceProvider;
import nl.b3p.wms.capabilities.Style;
import nl.b3p.wms.capabilities.StyleDomainResource;

public class GisPrincipal implements Principal {
    
    public static String ANONYMOUS_PRINCIPAL = "anoniem_principal";
    
    private String name;
    private Set roles;
    private ServiceProvider sp;
    
    public GisPrincipal(String name, List roles) {
        this.name = name;
        this.roles = new HashSet();
        this.roles.addAll(roles);
    }
    
    public GisPrincipal(String name, ServiceProvider sp) {
        this.name = name;
        this.sp = sp;
        if(sp==null)
            return;
        
        this.roles = new HashSet();
        Set sproles = sp.getAllRoles();
        if(sproles==null || sproles.isEmpty())
            return;
        
        Iterator it = sproles.iterator();
        while (it.hasNext()) {
            Roles role = (Roles) it.next();
            String sprole = role.getRole();
            if (sprole!=null && sprole.length()>0)
                roles.add(sprole);
        }
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
    
    public ServiceProvider getSp() {
        return sp;
    }
    
    public void setSp(ServiceProvider sp) {
        this.sp = sp;
    }
    
    public List getLayerNames(boolean legendGraphicOnly) {
        if(sp==null)
            return null;
        Set layers = sp.getAllLayers();
        if (layers==null  || layers.isEmpty())
            return null;
        
        List allLayers = new ArrayList();
        Iterator it = layers.iterator();
        while (it.hasNext()) {
            Layer layer = (Layer) it.next();
            String name = layer.getName();
            if (name!=null && name.length()>0) {
                if ((legendGraphicOnly && hasLegendGraphic(layer)) ||
                        !legendGraphicOnly)
                    allLayers.add(name);
            }
        }
        if (allLayers!=null)
            Collections.sort(allLayers);
        return allLayers;
    }
    
    public boolean hasLegendGraphic(Layer l) {
        Set styles = l.getStyles();
        if (styles==null || styles.isEmpty())
            return false;
        Iterator it = styles.iterator();
        while (it.hasNext()) {
            Style style = (Style)it.next();
            Set ldrs = style.getDomainResource();
            if (ldrs==null || ldrs.isEmpty())
                return false;
            Iterator it2 = ldrs.iterator();
            while (it2.hasNext()) {
                StyleDomainResource sdr = (StyleDomainResource)it2.next();
                if ("LegendURL".equalsIgnoreCase(sdr.getDomain()))
                    return true;
            }
        }
        return false;
    }
    
    public Layer getLayer(String layerName) {
        if(sp==null)
            return null;
        Set layers = sp.getAllLayers();
        if (layers==null  || layers.isEmpty())
            return null;
        
        Iterator it = layers.iterator();
        while (it.hasNext()) {
            Layer layer = (Layer) it.next();
            String name = layer.getName();
            if (name==null || name.length()==0)
                continue;
            if (name.equalsIgnoreCase(layerName))
                return layer;
        }
        return null;
    }
    
    public String getLayerTitle(String layerName) {
        Layer layer = getLayer(layerName);
        if (layer==null)
            return null;
        return layer.getTitle();
    }
    
    public static GisPrincipal getGisPrincipal(HttpServletRequest request) {
        Principal user = request.getUserPrincipal();
        if (user==null) {
            HttpSession sess = request.getSession();
            user = (Principal)sess.getAttribute(ANONYMOUS_PRINCIPAL);
        }
        if (user==null || !(user instanceof GisPrincipal))
            return null;
        return (GisPrincipal)user;
    }
}
