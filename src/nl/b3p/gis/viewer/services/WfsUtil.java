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

import java.io.StringReader;
import java.util.ArrayList;
import nl.b3p.gis.viewer.db.Connecties;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.ogc.utils.OGCRequest;
import nl.b3p.ogc.utils.OgcWfsClient;
import nl.b3p.xml.wfs.FeatureType;
import nl.b3p.xml.wfs.GetFeature;
import nl.b3p.xml.wfs.WFS_Capabilities;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.exolab.castor.xml.Unmarshaller;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

/**
 *
 * @author Roy Braam
 */
public class WfsUtil {

    private static final Log log = LogFactory.getLog(WfsUtil.class);

    /** Creates a new instance of WfsUtil */
    public WfsUtil() {
    }

    public static ArrayList getFeatureNameList(WFS_Capabilities cap) {
        if (cap == null) {
            return null;
        }
        nl.b3p.xml.wfs.FeatureTypeList ftl = cap.getFeatureTypeList();
        ArrayList tns = null;
        if (ftl != null) {
            tns = new ArrayList();
            for (int i = 0; i < ftl.getFeatureTypeCount(); i++) {
                nl.b3p.xml.wfs.FeatureType ft = ftl.getFeatureType(i);
                if (ft.getName() != null && ft.getName().length() > 0) {
                    tns.add(ft.getName());
                }
            }
        }
        return tns;
    }

    static public ArrayList getFeatureElements(Connecties c, String adminTable) throws Exception {
        ArrayList returnvalue = null;
        if (c != null && c.getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            OGCRequest or = new OGCRequest(c.getConnectie_url());
            if (adminTable == null || adminTable.length() < 1) {
                return null;
            }
            or.addOrReplaceParameter(OGCRequest.WFS_PARAM_TYPENAME, adminTable);
            NodeList nl = OgcWfsClient.getDescribeFeatureElements(OgcWfsClient.getDescribeFeatureType(or));
            if (nl != null) {
                for (int i = 0; i < nl.getLength(); i++) {
                    if (returnvalue == null) {
                        returnvalue = new ArrayList();
                    }
                    Element e = (Element) nl.item(i);
                    returnvalue.add(e);
                }
            }
        } else {
            return null;
        }
        return returnvalue;
    }

    static public WFS_Capabilities getCapabilities(Connecties c) throws Exception {
        if (c != null && c.getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            return OgcWfsClient.getCapabilities(new OGCRequest(c.getConnectie_url()));
        } else {
            return null;
        }
    }

    public static ArrayList getWFSObjects(Themas t, double x, double y, double distance) throws Exception {
        if (t == null || t.getConnectie() == null || !t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            return null;
        }
        OGCRequest or = new OGCRequest(t.getConnectie().getConnectie_url());
        or.addOrReplaceParameter(OGCRequest.WFS_PARAM_TYPENAME, t.getAdmin_tabel());
        GetFeature gf = OgcWfsClient.getGetFeatureRequest(or);
        //beide nodig voor het maken van een bbox wfs query
        WFS_Capabilities cap = OgcWfsClient.getCapabilities(or);
        FeatureType ft = OgcWfsClient.getCapabilitieFeatureType(cap, t.getAdmin_tabel());

        double[] bbox = new double[4];
        double distance2 = distance / 2;
        bbox[0] = x - distance2;
        bbox[1] = y - distance2;
        bbox[2] = x + distance2;
        bbox[3] = y + distance2;
        OgcWfsClient.addBboxFilter(gf, getGeometryAttributeName(t), bbox, ft);
        return OgcWfsClient.getFeatureElements(gf, or);
    }

    public static ArrayList getWFSObjects(Themas t, String key, String value) throws Exception {
        if (t == null || t.getConnectie() == null || !t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            return null;
        }
        OGCRequest or = new OGCRequest(t.getConnectie().getConnectie_url());
        or.addOrReplaceParameter(OGCRequest.WFS_PARAM_TYPENAME, t.getAdmin_tabel());
        GetFeature gf = OgcWfsClient.getGetFeatureRequest(or);
        OgcWfsClient.addPropertyIsEqualToFilter(gf, key, value);
        return OgcWfsClient.getFeatureElements(gf, or);
    }

    public static com.vividsolutions.jump.feature.Feature getWfsObject(Themas t, String attributeName, String compareValue) throws Exception {
        if (t == null || t.getConnectie() == null || !t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            return null;
        }
        OGCRequest or = new OGCRequest(t.getConnectie().getConnectie_url());
        or.addOrReplaceParameter(OGCRequest.WFS_PARAM_TYPENAME, t.getAdmin_tabel());
        GetFeature gf = OgcWfsClient.getGetFeatureRequest(or);
        OgcWfsClient.addPropertyIsEqualToFilter(gf, attributeName, compareValue);
        ArrayList features = OgcWfsClient.getFeatureElements(gf, or);
        if (features == null || features.size() != 1) {
            throw new Exception("De gegeven id is niet uniek. Query geeft meerdere objecten");
        }
        return (com.vividsolutions.jump.feature.Feature) features.get(0);

    }

    public static String getGeometryAttributeName(Themas t) throws Exception {
        ArrayList elements = getFeatureElements(t.getConnectie(), t.getAdmin_tabel());
        for (int i = 0; i < elements.size(); i++) {
            Element e = (Element) elements.get(i);
            if (e.getAttribute("type") != null && e.getAttribute("type").equalsIgnoreCase(OGCRequest.WFS_OBJECT_GEOMETRYTYPE)) {
                return e.getAttribute("name");
            }
        }
        return null;
    }

    public static nl.b3p.xml.ogc.v100.Filter createFilterV100(Themas t, double x, double y, double distance, nl.b3p.xml.wfs.v100.capabilities.FeatureType feature) throws Exception {
        double lowerX, lowerY, upperX, upperY;
        double distance2 = distance / 2;
        lowerX = x - distance2;
        lowerY = y - distance2;
        upperX = x + distance2;
        upperY = y + distance2;
        StringBuffer sb = new StringBuffer();
        sb.append("<Filter><BBOX><PropertyName>");
        sb.append(getGeometryAttributeName(t));
        sb.append("</PropertyName>");
        sb.append("<gml:Box srsName=\"http://www.opengis.net/gml/srs/epsg.xml#");
        sb.append(28992);
        sb.append("\"><gml:coordinates>");
        sb.append(lowerX).append(",").append(lowerY);
        sb.append(" ");
        sb.append(upperX).append(",").append(upperY);
        sb.append("</gml:coordinates></gml:Box>");
        sb.append("</BBOX></Filter>");
        return (nl.b3p.xml.ogc.v100.Filter) Unmarshaller.unmarshal(nl.b3p.xml.ogc.v100.Filter.class, new StringReader(sb.toString()));

    }

    public static nl.b3p.xml.ogc.v110.Filter createFilterV110(Themas t, double x, double y, double distance, nl.b3p.xml.wfs.v110.FeatureType feature) throws Exception {
        double lowerX, lowerY, upperX, upperY;
        double distance2 = distance / 2;
        lowerX = x - distance2;
        lowerY = y - distance2;
        upperX = x + distance2;
        upperY = y + distance2;
        StringBuffer sb = new StringBuffer();
        sb.append("<Filter><Within><PropertyName>");
        sb.append(getGeometryAttributeName(t));
        //sb.append("app:geom");
        sb.append("</PropertyName>");
        sb.append("<gml:Envelope srsName=\"http://www.opengis.net/gml/srs/epsg.xml#");
        sb.append(28992);
        sb.append("\"><gml:lowerCorner>");
        sb.append(lowerX).append(" ").append(lowerY);
        sb.append("</gml:lowerCorner><gml:upperCorner>");
        sb.append(upperX).append(" ").append(upperY);
        sb.append("</gml:upperCorner></gml:Envelope>");
        sb.append("</Within></Filter>");
        return (nl.b3p.xml.ogc.v110.Filter) Unmarshaller.unmarshal(nl.b3p.xml.ogc.v110.Filter.class, new StringReader(sb.toString()));
    }
}
