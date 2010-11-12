/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nl.b3p.vml.util;

import com.vividsolutions.jts.geom.Envelope;
import com.vividsolutions.jts.geom.Geometry;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.xml.transform.TransformerException;
import nl.b3p.commons.jpa.TransactionalAjax;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.geotools.data.DataStore;
import org.geotools.data.DataStoreFinder;
import org.geotools.data.DefaultQuery;
import org.geotools.data.FeatureSource;
import org.geotools.data.wfs.WFSDataStoreFactory;
import org.geotools.factory.CommonFactoryFinder;
import org.geotools.factory.GeoTools;
import org.geotools.feature.FeatureCollection;
import org.geotools.feature.FeatureIterator;
import org.geotools.feature.simple.SimpleFeatureImpl;
import org.geotools.filter.FilterTransformer;
import org.opengis.filter.Filter;
import org.opengis.filter.FilterFactory2;

/**
 *
 * @author meine
 */
public class GeometryUtil {

    private static final Log log = LogFactory.getLog(GeometryUtil.class);

    /**
     * Constructor
     **/
    public GeometryUtil() throws Exception {
    }

    @TransactionalAjax
    public Map<String, Double> getExtentFromWeg(String telpuntnummer) {
        Map<String, Double> extent = new HashMap<String, Double>();

        List<Geometry> geoms = new ArrayList<Geometry>();

        DataStore ds = null;
        List features = new ArrayList();
        try {
            Map params = new HashMap();
            String url = Highlight.limburgService;//"http://acceptatie.prvlimburg.nl/geoservices/infrastructuur";
            if (url.toLowerCase().indexOf("request=") == -1) {
                if (url.indexOf("?") > 0) {
                    url += "&";
                } else {
                    url += "?";
                }
                url += "request=GetCapabilities&service=WFS";
                //temp hack: default use version 1.0.0
                if (url.toLowerCase().indexOf("version") == -1) {
                    url += "&Version=1.0.0";
                }
            }
            params.put(WFSDataStoreFactory.URL.key, url);

            //params.put(WFSDataStoreFactory.TIMEOUT.key, "");

            ds = DataStoreFinder.getDataStore(params);

            FilterFactory2 ff2 = CommonFactoryFinder.getFilterFactory2(GeoTools.getDefaultHints());

            //like(Expression expr, String pattern, String wildcard, String singleChar, String escape, boolean matchCase)
            Filter f = ff2.like(ff2.property("TELPUNT"), telpuntnummer, "*", "?", "/", false);



            String[] types = ds.getTypeNames();
            FeatureSource fs = ds.getFeatureSource("telvakken_l");
            FilterTransformer ft = new FilterTransformer();
            //String s = ft.transform(f);
            //log.info("Do query with filter: " + s);
            DefaultQuery query = new DefaultQuery("telvakken_l", f);
            
            FeatureCollection fc = fs.getFeatures(query);
            FeatureIterator<SimpleFeatureImpl> fi = fc.features();

            if(fc.size() > 0){
                SimpleFeatureImpl fe = fi.next();


                Geometry geom = (Geometry) fe.getDefaultGeometry();
                features.add(fe);

                extent = getExtentFromGeom(geom);
            } else {
                extent = null;
            }

            return extent;
    /*   } catch (TransformerException ex) {
            log.error(ex);*/ 
        }catch (IOException e) {
            log.error(e);
        }

        return null;
    }

    private Map<String, Double> getExtentFromGeom(Geometry geom) {
        Map<String, Double> extent = new HashMap<String, Double>();
        Envelope envelope = geom.getEnvelopeInternal();
        envelope.expandBy(2000);

        extent.put("minx", envelope.getMinX());
        extent.put("miny", envelope.getMinY());
        extent.put("maxx", envelope.getMaxX());
        extent.put("maxy", envelope.getMaxY());

        return extent;
    }
}
