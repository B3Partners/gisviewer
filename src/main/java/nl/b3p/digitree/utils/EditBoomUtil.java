package nl.b3p.digitree.utils;

import com.vividsolutions.jts.geom.Geometry;
import java.security.Principal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import nl.b3p.gis.geotools.DataStoreUtil;
import nl.b3p.gis.geotools.FilterBuilder;
import nl.b3p.gis.utils.ConfigKeeper;
import nl.b3p.gis.utils.EditUtil;
import nl.b3p.gis.viewer.db.Gegevensbron;
import nl.b3p.gis.viewer.services.GisPrincipal;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.zoeker.configuratie.Bron;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.geotools.data.DataStore;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.opengis.feature.Feature;
import org.opengis.feature.Property;
import org.opengis.filter.Filter;

/**
 *
 * @author Boy de Wit
 */
public class EditBoomUtil extends EditUtil {

    private static final Log log = LogFactory.getLog(EditBoomUtil.class);

    /**
     * Constructor
     *
     */
    public EditBoomUtil() throws Exception {
    }

    // maakt een JSONArray met voor elk resultaat een label (omschrijving) en value (boomsoort)
    public String getAutoSuggestBoomSoorten(String search) throws JSONException {

        String output = "";
        if (search == null || search.equals("") || search.isEmpty()) {
            return output;
        }
        

        search.replaceAll("'", "\'");
        String query = "select boomsoort, omschrijving from digitree_boomsoorten where UPPER(omschrijving) like UPPER('%" + search + "%') order by omschrijving asc";

        Connection conn = null;

        try {
            InitialContext cxt = new InitialContext();
            DataSource ds = (DataSource) cxt.lookup("java:/comp/env/jdbc/gisdata");
            if (ds == null) {
                return output;
            }
            conn = ds.getConnection();

            PreparedStatement statement = conn.prepareStatement(query.toString());
            JSONObject json = new JSONObject();
            try {
                JSONArray soorten = new JSONArray();
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    String boomsoort = rs.getString(1);
                    String omschrijving = rs.getString(2);

                    JSONObject soort = new JSONObject()
                            .put("label", omschrijving)
                            .put("value", boomsoort);
                    soorten.put(soort);
                }

                output = soorten.toString();

            } finally {
                statement.close();
            }

        } catch (SQLException ex) {
            log.error("", ex);
        } catch (NamingException ex) {
            log.error("", ex);
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                log.error("", ex);
            }
        }
        return output;
    }

    private String[] ListToArray(List<String> values) {
        int size = values.size();
        String[] stringvalues = new String[size];

        int i = 0;
        for (Iterator it = values.iterator(); it.hasNext();) {
            String value = (String) it.next();
            stringvalues[i] = value;
            i++;
        }
        return stringvalues;
    }

    public String getIdAndWktForBoomObject(String wkt, Integer boomGegevensbronId,
            String schaal, String tol, String appCode) throws Exception {

        /* Als er geen redlining gegevensbron bekend is dan HP */
        if (boomGegevensbronId == null || boomGegevensbronId < 0) {
            return "-1";
        }

        String jsonObject = null;

        /* Redlineobject zoeken en jsonObject teruggeven record zodat
         formulier met deze waardes ingevuld kan worden */
        Geometry geom = DataStoreUtil.createGeomFromWKTString(wkt);
        double distance = getDistance(schaal, tol);

        if (distance > 0) {
            geom = geom.buffer(distance);
        }

        ArrayList<Feature> features = doQueryRedliningObject(geom, boomGegevensbronId, appCode);

        if ((features != null) && (features.size() > 0)) {
            Feature f = features.get(0);

            if (features.size() > 1) {
                Property p = f.getProperty("status");
                String status = p.getValue().toString();

                if (status.contains("actueel")) {
                    f = features.get(1);
                }

                log.debug("Meerdere redline objecten gevonden. Feature met status 'nieuw' gebruikt. Wkt string = " + wkt);
            }

            jsonObject = boomfeatureToJson(f).toString();
        }

        /* Als er geen redline object gevonden wordt dan HP */
        if (features == null || features.size() < 1 || jsonObject == null) {
            return "-1";
        }

        return jsonObject;
    }

    private JSONObject boomfeatureToJson(Feature f) throws JSONException {
        String wkt = "";

        if (f != null || f.getDefaultGeometryProperty() != null) {
            wkt = DataStoreUtil.selecteerKaartObjectWkt(f);
            if (wkt.startsWith("ST_MULTI")) {
                int begin = wkt.lastIndexOf("(");
                int end = wkt.indexOf(")");
                wkt = "ST_POINT(" + wkt.substring(begin + 1, end) + ")";
            }
        }

        Date vandaag = new Date(System.currentTimeMillis());
        SimpleDateFormat sdf = (SimpleDateFormat) SimpleDateFormat.getDateInstance();
        sdf.applyPattern("dd-MM-yyyy");

        SimpleDateFormat sdf2 = (SimpleDateFormat) SimpleDateFormat.getDateInstance();
        sdf2.applyPattern("HH:mm:ss");

        /* TODO: Zorgen dat f.getProperty hoofdlettergevoelig onafhankelijk
         * werkt, dus zowel voor Postgres als Oracle */
        String id = getFeatureString(f, "id");
        String project = getFeatureString(f, "project");
        String projectid = getFeatureString(f, "projectid");
        String boomid = getFeatureString(f, "boomid");
        String status = getFeatureString(f, "status");

        String mutatiedatum = sdf.format(vandaag);
        String mutatietijd = sdf2.format(vandaag);

        String aktie = getFeatureString(f, "aktie");
        String boomsoort = getBoomSoortlabel(getFeatureString(f, "boomsrt"));
        Integer plantjaar = (Integer) f.getProperty("plantjaar").getValue();
        String boomhoogte = getFeatureString(f, "boomhoogte");
        String eindbeeld = getFeatureString(f, "eindbeeld");
        String scheefstand = getFeatureCheckbox(f, "scheefstand");
        String scheuren = getFeatureCheckbox(f, "scheuren");
        String holten = getFeatureCheckbox(f, "holten");
        String stamvoetschade = getFeatureCheckbox(f, "stamvoetschade");
        String stamschade = getFeatureCheckbox(f, "stamschade");
        String kroonschade = getFeatureCheckbox(f, "kroonschade");
        String inrot = getFeatureCheckbox(f, "inrot");
        String houtboorder = getFeatureCheckbox(f, "houtboorder");
        String zwam = getFeatureCheckbox(f, "zwam");
        String zwam_stamvoet = getFeatureCheckbox(f, "zwam_stamvoet");
        String zwam_stam = getFeatureCheckbox(f, "zwam_stam");
        String zwam_kroon = getFeatureCheckbox(f, "zwam_kroon");
        String dood_hout = getFeatureCheckbox(f, "dood_hout");
        String plakoksel = getFeatureCheckbox(f, "plakoksel");
        String stamschot = getFeatureCheckbox(f, "stamschot");
        String wortelopslag = getFeatureCheckbox(f, "wortelopslag");
        String takken = getFeatureCheckbox(f, "takken");
        String opdruk = getFeatureCheckbox(f, "opdruk");
        String vta1 = getFeatureCheckbox(f, "vta1");
        String vta2 = getFeatureCheckbox(f, "vta2");
        String vta3 = getFeatureCheckbox(f, "vta3");
        String vta4 = getFeatureCheckbox(f, "vta4");
        String vta5 = getFeatureCheckbox(f, "vta5");
        String vta6 = getFeatureCheckbox(f, "vta6");
        String aantastingen = getFeatureString(f, "aantastingen");
        String maatregelen_kort = getFeatureString(f, "maatregelen_kort");
        String maatregelen_lang = getFeatureString(f, "maatregelen_lang");
        String wegtype = getFeatureString(f, "wegtype");
        String bereikbaarheid = getFeatureCheckbox(f, "bereikbaarheid");
        String nader_onderzoek = getFeatureCheckbox(f, "nader_onderzoek");
        String status_zp = getFeatureString(f, "status_zp");
        String classificatie = getFeatureString(f, "classificatie");
        String risicoklasse = getFeatureString(f, "risicoklasse");
        String uitvoerdatum = getFeatureString(f, "uitvoerdatum");
        String opmerkingen = getFeatureString(f, "opmerkingen");
        String extra1 = getFeatureString(f, "extra1");
        String extra2 = getFeatureString(f, "extra2");
        String extra3 = getFeatureString(f, "extra3");
        String extra4 = getFeatureString(f, "extra4");
        String extra5 = getFeatureString(f, "extra5");
        String extra6 = getFeatureString(f, "extra6");
        String extra7 = getFeatureString(f, "extra7");
        String extra8 = getFeatureString(f, "extra8");
        String extra9 = getFeatureString(f, "extra9");
        String extra10 = getFeatureString(f, "extra10");

        JSONObject json = new JSONObject()
                .put("id", id)
                .put("project", project)
                .put("wkt", wkt)
                .put("projectid", projectid)
                .put("boomid", boomid)
                .put("status", status)
                .put("mutatiedatum", mutatiedatum)
                .put("mutatietijd", mutatietijd)
                .put("aktie", aktie)
                .put("boomsoort", boomsoort)
                .put("plantjaar", plantjaar)
                .put("boomhoogte", boomhoogte)
                .put("eindbeeld", eindbeeld)
                .put("scheefstand", scheefstand)
                .put("scheuren", scheuren)
                .put("holten", holten)
                .put("stamvoetschade", stamvoetschade)
                .put("stamschade", stamschade)
                .put("kroonschade", kroonschade)
                .put("inrot", inrot)
                .put("houtboorder", houtboorder)
                .put("zwam", zwam)
                .put("zwam_stamvoet", zwam_stamvoet)
                .put("zwam_stam", zwam_stam)
                .put("zwam_kroon", zwam_kroon)
                .put("dood_hout", dood_hout)
                .put("plakoksel", plakoksel)
                .put("stamschot", stamschot)
                .put("wortelopslag", wortelopslag)
                .put("takken", takken)
                .put("opdruk", opdruk)
                .put("vta1", vta1)
                .put("vta2", vta2)
                .put("vta3", vta3)
                .put("vta4", vta4)
                .put("vta5", vta5)
                .put("vta6", vta6)
                .put("aantastingen", aantastingen)
                .put("maatregelen_kort", maatregelen_kort)
                .put("maatregelen_lang", maatregelen_lang)
                .put("wegtype", wegtype)
                .put("bereikbaarheid", bereikbaarheid)
                .put("nader_onderzoek", nader_onderzoek)
                .put("status_zp", status_zp)
                .put("classificatie", classificatie)
                .put("risicoklasse", risicoklasse)
                .put("uitvoerdatum", uitvoerdatum)
                .put("opmerkingen", opmerkingen)
                .put("extra1", extra1)
                .put("extra2", extra2)
                .put("extra3", extra3)
                .put("extra4", extra4)
                .put("extra5", extra5)
                .put("extra6", extra6)
                .put("extra7", extra7)
                .put("extra8", extra8)
                .put("extra9", extra9)
                .put("extra10", extra10);

        return json;
    }

    private String getFeatureString(Feature f, String kolom) {
        String value = "";

        Object newValue = f.getProperty(kolom).getValue();
        if (newValue != null) {
            value = newValue.toString().trim();
        }

        return value;
    }

    private String getFeatureCheckbox(Feature f, String kolom) {
        String value = "";
        String newValue = null;

        /* TODO: Opletten met wat langere statements achter elkaar.
         * f.getProperty(kolom).getValue().toString() zat ook een NPE in
         * omdat f.getProperty(kolom).getValue() bij vta1 kolom null is.
         */
        if (f.getProperty(kolom).getValue() != null) {
            newValue = f.getProperty(kolom).getValue().toString();
        }

        if (newValue != null && newValue.equals("1")) {
            value = "true";
        }

        return value;
    }

    private String getBoomSoortlabel(String boomsoort) {
        String output = "";

        String query = "select omschrijving from digitree_boomsoorten where boomsoort = '" + boomsoort + "'";

        Connection conn = null;

        try {
            InitialContext cxt = new InitialContext();
            DataSource ds = (DataSource) cxt.lookup("java:/comp/env/jdbc/gisdata");
            if (ds == null) {
                return output;
            }
            conn = ds.getConnection();

            PreparedStatement statement = conn.prepareStatement(query);
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    output = rs.getString(1);
                }
            } finally {
                statement.close();
            }

        } catch (SQLException ex) {
            log.error("", ex);
        } catch (NamingException ex) {
            log.error("", ex);
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                log.error("", ex);
            }
        }
        return output;
    }

    @Override
    protected ArrayList<Feature> doQueryRedliningObject(Geometry geom, Integer gbId, String appCode) throws Exception {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();

        Transaction tx = null;
        DataStore ds = null;
        ArrayList<Feature> features = null;

        try {
            tx = sess.beginTransaction();

            Gegevensbron gb = (Gegevensbron) sess.get(Gegevensbron.class, gbId);

            if (gb == null) {
                return new ArrayList();
            }

            WebContext ctx = WebContextFactory.get();
            HttpServletRequest request = ctx.getHttpServletRequest();

            Bron b = gb.getBron(request);

            if (b == null || b.getType().equals(Bron.TYPE_WFS)) {
                return new ArrayList();
            }

            ds = b.toDatastore();

            List thema_items = SpatialUtil.getThemaData(gb, false);
            List<String> propnames = DataStoreUtil.themaData2PropertyNames(thema_items);

            /* ophalen ingelogd projectid */
            Principal user = request.getUserPrincipal();
            GisPrincipal gp = (GisPrincipal) user;
            String projectid = gp.getSp().getOrganizationCode();

            /* Filters op status en op projectid. Een gebruiker mag geen bomen editen van een ander projectid */
            Filter project = FilterBuilder.createEqualsFilter("projectid", projectid);
            //Filter status = FilterBuilder.createLikeFilter("status", "actueel");
            String[] statusNamen = {"nieuw", "actueel"};
            Filter status = FilterBuilder.createOrEqualsFilter("status", statusNamen);

            Filter f = FilterBuilder.getFactory().and(status, project);

            Integer maximum = ConfigKeeper.getMaxNumberOfFeatures(appCode);
            features = DataStoreUtil.getFeatures(b, gb, geom, f, propnames, maximum, true);

            tx.commit();

        } catch (Exception ex) {
            log.error("Fout tijdens ophalen redlining: ", ex);

            if (tx != null && tx.isActive()) {
                tx.rollback();
            }

        } finally {
            if (ds != null) {
                ds.dispose();
            }
        }

        return features;
    }

    private double getDistance(String schaal, String tol) {
        String s = schaal;
        double scale = 0.0;
        try {
            if (s != null) {
                scale = Double.parseDouble(s);
                //af ronden op 6 decimalen
                scale = Math.round((scale * 1000000));
                scale = scale / 1000000;
            }
        } catch (NumberFormatException nfe) {
            scale = 0.0;
            log.debug("Scale is geen double dus wordt genegeerd");
        }
        String tolerance = tol;
        double clickTolerance = DEFAULTTOLERANCE;
        try {
            if (tolerance != null) {
                clickTolerance = Double.parseDouble(tolerance);
            }
        } catch (NumberFormatException nfe) {
            clickTolerance = DEFAULTTOLERANCE;
            log.debug("Tolerance is geen double dus de default wordt gebruikt: " + DEFAULTTOLERANCE + " pixels");
        }
        double distance = clickTolerance;
        if (scale > 0.0) {
            distance = scale * (clickTolerance);
        }
        return distance;
    }
}
