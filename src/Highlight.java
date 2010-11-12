/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.vml.util;

import java.io.FileInputStream;
import javax.xml.transform.Transformer;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import nl.b3p.commons.services.FormUtils;
import nl.b3p.gis.viewer.db.Connecties;
import nl.b3p.gis.viewer.db.Themas;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

/**
 *
 * @author meine
 */
public class Highlight extends HttpServlet {

    private static final Log log = LogFactory.getLog(Highlight.class);
    public static final String OGCNS = "http://www.opengis.net/ogc";
    public static final String SLDNS = "http://www.opengis.net/sld";
    public static final String SENS = "http://www.opengis.net/se";
    public static final String SLDTYPE_NAMEDSTYLE = "NamedStyle";
    public static final String SLDTYPE_USERSTYLE = "UserStyle";
    public static final String DEFAULT_STYLE = "default";


    private String defaultSldPath;
    public static String limburgService;
    public static String viswebURL;

    public static String getViswebURL() {
        return viswebURL;
    }

    public static void setViswebURL(String aViswebURL) {
        viswebURL = aViswebURL;
    }
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OutputStream out = response.getOutputStream();
        try {
            //get parameters
            String visibleValue[] = null;
            if (request.getParameter("visibleValue") != null) {
                visibleValue = request.getParameter("visibleValue").split(",");
            }
            if (visibleValue == null) {
                throw new Exception("visibleValue is verplicht");
            }

            //get sldtype default: SLDTYPE_USERSTYLE
            String sldType = SLDTYPE_USERSTYLE;

            //create root doc
            Document doc = getDefaultSld();
            Node root = doc.getDocumentElement();
            Node child = createNamedLayer(doc, "telvakken_l", "TELPUNT", visibleValue, "line", SLDTYPE_USERSTYLE, false);

            root.appendChild(child);

            DOMSource domSource = new DOMSource(doc);
            Transformer t = TransformerFactory.newInstance().newTransformer();
            response.setContentType("text/xml");
            t.transform(domSource, new StreamResult(out));


        } catch (Exception e) {

            log.error("Fout bij maken sld: ", e);
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter pw = new PrintWriter(out);
            pw.write(e.getMessage());
        } finally {
            out.close();
        }
    }

    public Node createNamedLayer(Document doc, String featureName, String attribute, String[] value, String geometryType, String sldType, boolean not) {
        Node name = doc.createElementNS(SLDNS, "Name");
        name.appendChild(doc.createTextNode(featureName));
        Node namedLayer = doc.createElementNS(SLDNS, "NamedLayer");
        namedLayer.appendChild(name);

        if (sldType.equalsIgnoreCase(SLDTYPE_USERSTYLE)) {
            Node featureTypeStyle = createFeatureTypeStyle(doc, attribute, value, geometryType);
            Node userStyle = doc.createElementNS(SLDNS, "UserStyle");
            userStyle.appendChild(featureTypeStyle);
            namedLayer.appendChild(userStyle);
        } else if (sldType.equalsIgnoreCase(SLDTYPE_NAMEDSTYLE)) {
            //Node layerFeatureConstraints = createLayerFeatureConstraints(doc, attribute, value, geometryType);
            Node layerFeatureConstraints = doc.createElementNS(SLDNS, "LayerFeatureConstraints");
            Node featureTypeConstraints = createFeatureTypeConstraint(doc, attribute, value, not);

            layerFeatureConstraints.appendChild(featureTypeConstraints);
            namedLayer.appendChild(layerFeatureConstraints);

            Node namedStyle = doc.createElementNS(SLDNS, "NamedStyle");
            Node styleName = doc.createElementNS(SLDNS, "Name");
            styleName.appendChild(doc.createTextNode(DEFAULT_STYLE));
            namedStyle.appendChild(styleName);
            namedLayer.appendChild(namedStyle);
        }
        return namedLayer;
    }

    public Node createFeatureTypeStyle(Document doc, String attribute, String[] value, String geometryType) {

        Node featureTypeStyle = doc.createElementNS(SLDNS, "FeatureTypeStyle");
        Node rule = doc.createElement("Rule");

        Node filter = createFilter(doc, attribute, value, false);

        rule.appendChild(filter);
        if (geometryType == null || geometryType.toLowerCase().indexOf("polygon") >= 0) {
            rule.appendChild(createStylePolygon(doc, attribute));
        } else if (geometryType == null || geometryType.toLowerCase().indexOf("line") >= 0) {
            rule.appendChild(createStyleLine(doc, attribute));
        } else if (geometryType == null || geometryType.toLowerCase().indexOf("point") >= 0) {
            rule.appendChild(createStylePoint(doc, attribute));
        }

        featureTypeStyle.appendChild(rule);
        return featureTypeStyle;
    }

    private Node createStylePoint(Document doc, String geoProperty) {


        Node pointSymbolizer = doc.createElement("PointSymbolizer");
        Node geo = doc.createElement("Geometry");
        Node propName = doc.createElementNS(OGCNS, "PropertyName");
        propName.appendChild(doc.createTextNode(geoProperty));
        geo.appendChild(propName);
        Node graphic = doc.createElement("Graphic");
        Node mark = doc.createElement("Mark");
        Node wkn = doc.createElement("WellKnownName");
        wkn.appendChild(doc.createTextNode("circle"));
        Node fill = doc.createElement("Fill");
        Element cssParam = doc.createElement("CssParameter");
        cssParam.setAttribute("name", "fill");
        cssParam.appendChild(doc.createTextNode("#ff0000"));
        Node size = doc.createElement("Size");
        size.appendChild(doc.createTextNode("10.0"));

        fill.appendChild(cssParam);
        mark.appendChild(wkn);
        mark.appendChild(fill);

        graphic.appendChild(mark);
        graphic.appendChild(size);

        pointSymbolizer.appendChild(geo);
        pointSymbolizer.appendChild(graphic);

        return pointSymbolizer;
    }

    private Node createStylePolygon(Document doc, String geoProperty) {


        Node polygonSymbolizer = doc.createElement("PolygonSymbolizer");
        Node geo = doc.createElement("Geometry");
        Node propName = doc.createElementNS(OGCNS, "PropertyName");
        propName.appendChild(doc.createTextNode(geoProperty));
        geo.appendChild(propName);

        Node fill = doc.createElement("Fill");
        Element cssParam2 = doc.createElement("CssParameter");
        cssParam2.setAttribute("name", "fill");
        cssParam2.appendChild(doc.createTextNode("#ff0000"));
        fill.appendChild(cssParam2);

        Node stroke = doc.createElement("Stroke");
        Element cssParam = doc.createElement("CssParameter");
        cssParam.setAttribute("name", "stroke");
        cssParam.appendChild(doc.createTextNode("#ff00ff"));
        stroke.appendChild(cssParam);

        polygonSymbolizer.appendChild(geo);
        polygonSymbolizer.appendChild(stroke);
        polygonSymbolizer.appendChild(fill);

        return polygonSymbolizer;
    }

    private Node createStyleLine(Document doc, String geoProperty) {


        Node lineSymbolizer = doc.createElement("LineSymbolizer");
        Node geo = doc.createElement("Geometry");
        Node propName = doc.createElementNS(OGCNS, "PropertyName");
        propName.appendChild(doc.createTextNode(geoProperty));
        geo.appendChild(propName);

        Node stroke = doc.createElement("Stroke");

        Element cssStroke = doc.createElement("CssParameter");
        cssStroke.setAttribute("name", "stroke");
        cssStroke.appendChild(doc.createTextNode("#0000ff"));
        stroke.appendChild(cssStroke);


        Element csswidth = doc.createElement("CssParameter");
        csswidth.setAttribute("name", "stroke-width");
        csswidth.appendChild(doc.createTextNode("6"));
        stroke.appendChild(csswidth);

     //   Element cssDash = doc.createElement("CssParameter");
      //  cssDash.setAttribute("name", "stroke-dasharray");
     //   cssDash.appendChild(doc.createTextNode("10.0 5 5 10"));
       // stroke.appendChild(cssDash);

        // Node graphicFill = doc.createElement("GraphicFill");
        //graphicFill.appendChild(graphic);
        lineSymbolizer.appendChild(geo);
        lineSymbolizer.appendChild(stroke);

        return lineSymbolizer;
    }

    private Node createFeatureTypeConstraint(Document doc, String attribute, String[] value, boolean not) {
        Node featureTypeConstraint = doc.createElementNS(SLDNS, "FeatureTypeConstraint");
        Node filter = createFilter(doc, attribute, value, not);
        featureTypeConstraint.appendChild(filter);
        return featureTypeConstraint;
    }

    private Node createFilter(Document doc, String attribute, String[] value, boolean not) {
        Node filter = doc.createElementNS(OGCNS, "Filter");

        Node nodeToUse = filter;
        if (not) {
            Node notFilter = doc.createElementNS(OGCNS, "Not");
            filter.appendChild(notFilter);
            nodeToUse = notFilter;
        }
        if (value.length > 1) {
            Node orFilter = doc.createElementNS(OGCNS, "Or");
            nodeToUse.appendChild(orFilter);
            nodeToUse = orFilter;
        }

        for (int i = 0; i < value.length; i++) {
            Node propertyName = doc.createElementNS(OGCNS, "PropertyName");
            propertyName.appendChild(doc.createTextNode(attribute));
            Node literal = doc.createElementNS(OGCNS, "Literal");
            literal.appendChild(doc.createTextNode(value[i]));

            Node propertyIsEqualTo = doc.createElementNS(OGCNS, "PropertyIsEqualTo");
            propertyIsEqualTo.appendChild(propertyName);
            propertyIsEqualTo.appendChild(literal);

            nodeToUse.appendChild(propertyIsEqualTo);
        }
        return filter;
    }

    public Document getDefaultSld() throws Exception {
        DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        FileInputStream fi = new FileInputStream(defaultSldPath);
        Document doc = db.parse(fi);
        return doc;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try {
            if (config.getInitParameter("defaultSld") != null) {
                defaultSldPath = getServletContext().getRealPath(config.getInitParameter("defaultSld"));
            }
            if (config.getInitParameter("viswebURL") != null) {
                viswebURL = config.getInitParameter("viswebURL");
            }
            if (config.getInitParameter("limburgService") != null) {
                limburgService = config.getInitParameter("limburgService");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // </editor-fold>
}
