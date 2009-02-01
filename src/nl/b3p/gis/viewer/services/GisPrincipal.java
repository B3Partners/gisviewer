/*
 * B3P Gisviewer is an extension to Flamingo MapComponents making
 * it a complete webbased GIS viewer and configuration tool that
 * works in cooperation with B3P Kaartenbalie.
 *
 * Copyright 2006, 2007, 2008 B3Partners BV
 * 
 * This file is part of B3P Gisviewer.
 * 
 * B3P Gisviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * B3P Gisviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
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
import nl.b3p.wms.capabilities.Layer;
import nl.b3p.wms.capabilities.Roles;
import nl.b3p.wms.capabilities.ServiceProvider;
import nl.b3p.wms.capabilities.Style;
import nl.b3p.wms.capabilities.StyleDomainResource;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.securityfilter.filter.SecurityRequestWrapper;

public class GisPrincipal implements Principal {

    private static final Log log = LogFactory.getLog(GisPrincipal.class);
    private String name;
    private String password;
    /*TODO ipv code misschien hele kaartenbalie url??? */
    private String code;
    private Set roles;
    private ServiceProvider sp;

    public GisPrincipal(String name, List roles) {
        this.name = name;
        this.roles = new HashSet();
        this.roles.addAll(roles);
    }

    public GisPrincipal(String name, String password, String code, ServiceProvider sp) {
        this.name = name;
        this.password = password;
        this.code = code;
        this.sp = sp;
        if (sp == null) {
            return;
        }
        this.roles = new HashSet();
        Set sproles = sp.getAllRoles();
        if (sproles == null || sproles.isEmpty()) {
            return;
        }
        Iterator it = sproles.iterator();
        while (it.hasNext()) {
            Roles role = (Roles) it.next();
            String sprole = role.getRole();
            if (sprole != null && sprole.length() > 0) {
                roles.add(sprole);
            }
        }
    }

    public String getName() {
        return name;
    }

    public String getPassword() {
        return password;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
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
        if (sp == null) {
            return null;
        }
        Set layers = sp.getAllLayers();
        if (layers == null || layers.isEmpty()) {
            return null;
        }
        List allLayers = new ArrayList();
        Iterator it = layers.iterator();
        while (it.hasNext()) {
            Layer layer = (Layer) it.next();
            String name = layer.getName();
            if (name != null && name.length() > 0) {
                if ((legendGraphicOnly && hasLegendGraphic(layer)) ||
                        !legendGraphicOnly) {
                    allLayers.add(name);
                }
            }
        }
        if (allLayers != null) {
            Collections.sort(allLayers);
        }
        return allLayers;
    }

    public boolean hasLegendGraphic(Layer l) {
        Set styles = l.getStyles();
        if (styles == null || styles.isEmpty()) {
            return false;
        }
        Iterator it = styles.iterator();
        while (it.hasNext()) {
            Style style = (Style) it.next();
            Set ldrs = style.getDomainResource();
            if (ldrs == null || ldrs.isEmpty()) {
                return false;
            }
            Iterator it2 = ldrs.iterator();
            while (it2.hasNext()) {
                StyleDomainResource sdr = (StyleDomainResource) it2.next();
                if ("LegendURL".equalsIgnoreCase(sdr.getDomain())) {
                    return true;
                }
            }
        }
        return false;
    }

    public Layer getLayer(String layerName) {
        if (sp == null) {
            return null;
        }
        Set layers = sp.getAllLayers();
        if (layers == null || layers.isEmpty()) {
            return null;
        }
        Iterator it = layers.iterator();
        while (it.hasNext()) {
            Layer layer = (Layer) it.next();
            String name = layer.getName();
            if (name == null || name.length() == 0) {
                continue;
            }
            if (name.equalsIgnoreCase(layerName)) {
                return layer;
            }
        }
        return null;
    }

    public String getLayerTitle(String layerName) {
        Layer layer = getLayer(layerName);
        if (layer == null) {
            return null;
        }
        return layer.getTitle();
    }

    public static GisPrincipal getGisPrincipal(HttpServletRequest request) {
        Principal user = request.getUserPrincipal();
        if (!(user instanceof GisPrincipal)) {
            return null;
        }
        if (user == null) {
            // Eventueel fake Principal aanmaken
            if (!HibernateUtil.isCheckLoginKaartenbalie()) {
                user = GisSecurityRealm.authenticateFake(HibernateUtil.ANONYMOUS_USER);
            } else {
                String url = GisSecurityRealm.createCapabilitiesURL(null);
                user = GisSecurityRealm.authenticateHttp(url, HibernateUtil.ANONYMOUS_USER, null, null);
            }

            if (request instanceof SecurityRequestWrapper) {
                SecurityRequestWrapper srw = (SecurityRequestWrapper) request;
                srw.setUserPrincipal(user);
                log.debug("Automatic login for user: " + HibernateUtil.ANONYMOUS_USER);
            }

        }

        return (GisPrincipal) user;
    }
}
