package nl.b3p.digitree.viewer;

import com.vividsolutions.jts.geom.Geometry;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import nl.b3p.commons.services.FormUtils;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.gis.geotools.DataStoreUtil;
import nl.b3p.gis.utils.ConfigKeeper;
import nl.b3p.gis.viewer.ViewerCrudAction;
import nl.b3p.digitree.db.Boom;
import nl.b3p.gis.viewer.db.Configuratie;
import nl.b3p.gis.viewer.db.Gegevensbron;
import nl.b3p.gis.viewer.services.GisPrincipal;
import nl.b3p.gis.viewer.services.HibernateUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;
import org.geotools.data.DataStore;
import org.geotools.data.FeatureWriter;
import org.geotools.data.Transaction;
import org.geotools.filter.text.cql2.CQL;
import org.geotools.filter.text.cql2.CQLException;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.hibernate.Session;
import org.opengis.filter.Filter;

/**
 *
 * @author jytte
 */
public class EditBoomAction extends ViewerCrudAction {

    private static final Log logger = LogFactory.getLog(EditBoomAction.class);
    protected static final String SEND_EDITBOOM = "sendEditBoom";
    protected static final String REMOVE_BOOM = "removeBoom";
    
    private static final String[] EDIT_FIELDS = {
        "id", "the_geom", "boomid", "projectid", "project", "status", "upload_rdx",
        "upload_rdy", "mutatiedatum", "mutatietijd", "inspecteur", "aktie", "boomsrt",
        "plantjaar", "boomhoogte", "eindbeeld", "scheefstand", "scheuren", "holten",
        "stamvoetschade", "stamschade", "kroonschade", "inrot", "houtboorder",
        "zwam", "zwam_stamvoet", "zwam_stam", "zwam_kroon", "dood_hout", "plakoksel",
        "stamschot", "wortelopslag", "takken", "opdruk", "vta1", "vta2", "vta3", "vta4",
        "vta5", "vta6", "aantastingen", "status_zp", "classificatie", "maatregelen_kort",
        "nader_onderzoek", "maatregelen_lang", "risicoklasse", "uitvoerdatum",
        "bereikbaarheid", "wegtype", "opmerkingen", "extra1", "extra2", "extra3",
        "extra4", "extra5", "extra6", "extra7", "extra8", "extra9", "extra10"
    };
    private static final String[] NEW_FIELDS = {
        "the_geom", "boomid", "projectid", "project", "status", "upload_rdx",
        "upload_rdy", "mutatiedatum", "mutatietijd", "inspecteur", "aktie", "boomsrt",
        "plantjaar", "boomhoogte", "eindbeeld", "scheefstand", "scheuren", "holten",
        "stamvoetschade", "stamschade", "kroonschade", "inrot", "houtboorder",
        "zwam", "zwam_stamvoet", "zwam_stam", "zwam_kroon", "dood_hout", "plakoksel",
        "stamschot", "wortelopslag", "takken", "opdruk", "vta1", "vta2", "vta3", "vta4",
        "vta5", "vta6", "aantastingen", "status_zp", "classificatie", "maatregelen_kort",
        "nader_onderzoek", "maatregelen_lang", "risicoklasse", "uitvoerdatum",
        "bereikbaarheid", "wegtype", "opmerkingen", "extra1", "extra2", "extra3",
        "extra4", "extra5", "extra6", "extra7", "extra8", "extra9", "extra10"
    };

    /* waardes voor dropdowns */
    private static final String[] BOOMHOOGTE = {"0-6 m", "6-9 m", "9-12 m", "12-15 m", "15-18 m", "18-24 m", ">24 m"};
    private static final String[] EINDBEELD = {
        "vrij uitgroeiend", "niet vrij uitgroeiend", "opkronen 0-4 m", "opkronen 0-6 m", "opkronen 0-8 m",
        "opkronen 4-4 m", "opkronen 4-6 m", "opkronen 4-8 m", "opkronen 6-6 m", "opkronen 6-8 m", "opkronen 8-8 m",
        "knotboom", "leiboom", "gekandelaberde boom", "haagboom", "vormboom", "overig"};
    private static final String[] AANTASTINGEN = {
        "massaria", "essterfte", "iepziekte", "eikenprocessierups", "bloedingsziekte", "Bastwoekerziekte",
        "Berkendoder", "Berkenweerschijnzwam", "Dikrandtonderzwam", "Echte honingzwam", "Echte tonderzwam",
        "Eikenweerschijnzwam", "Gesteelde lakzwam", "Gewone oesterzwam", "Goudvliesbundelzwam",
        "Harslakzwam", "Kastanjemineermot", "Kogelhoutskoolzwam", "Korsthoutskoolzwam", "Platte tonderzwam",
        "Prachtkever", "Reuzenzwam", "Roodporiezwam", "Sombere honingzwam", "Verwelkingziekte (Verticilium)",
        "Waslakzwam", "Watermerkziekte", "Wilgenhoutrups", "Zadelzwam", "Zwavelzwam"};
    private static final String[] AANTASTINGEN_DIGIDIS = {
        "massaria", "essterfte", "iepziekte", "eikenprocessierups", "bloedingsziekte"};
    private static final String[] MAATREGELEN_KORT = {
        "BGS beeld", "BGS achterstallig", "BGS verwaarloosd", "OHS beeld", "OHS achterstallig", "Rooien"};
    private static final String[] MAATREGELEN_LANG = {
        "BGS fase", "OHS 1x/1 jr", "OHS 1x/2 jr", "OHS 1x/3 jr", "OHS 1x/6 jr", "OHS 1x/9 jr", "OHS 1x/12 jr"};
    private static final String[] RISICOKLASSE = {
        "geen verhoogd risico", "mogelijk verhoogd risico", "tijdelijk verhoogd risico", "attentieboom", "risicoboom"};
    private static final String[] WEGTYPE = {"A", "B1", "B2", "C1", "C2", "D", "E", "F1", "F2", "KR", "RO", "FP", "VP"};
       
    @Override
    protected Map getActionMethodPropertiesMap() {
        Map map = super.getActionMethodPropertiesMap();

        ExtendedMethodProperties hibProp = null;

        hibProp = new ExtendedMethodProperties(REMOVE_BOOM);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setDefaultMessageKey("message.deleteboom.success");
        hibProp.setAlternateForwardName(FAILURE);
        //hibProp.setAlternateMessageKey("error.deleteboom.failed");
        map.put(REMOVE_BOOM, hibProp);

        hibProp = new ExtendedMethodProperties(SEND_EDITBOOM);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setDefaultMessageKey("message.sendeditboom.success");
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.sendeditboom.failed");
        map.put(SEND_EDITBOOM, hibProp);

        return map;
    }

    @Override
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        makeLists(dynaForm, request);

        return mapping.findForward(SUCCESS);
    }

    public ActionForward sendEditBoom(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String massage = "";
        Boom boom = new Boom();
        boolean valideBoom = populateBoomObject(dynaForm, request, boom);

        Integer ggbId = (Integer) dynaForm.get("gegevensbron");
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Gegevensbron ggb = (Gegevensbron) sess.get(Gegevensbron.class, ggbId);

        String uniek = checkPK(boom, ggb.getAdmin_tabel());

        /* TODO: Nog eens kijken of deze if constructie niet anders kan.
         * In vorige versie gaf boom.getId een NPE. Kan uniek niet een boolean worden?
         * Als uniek false wordt hieronder toch het form id gebruikt om te updaten of
         * te inserten. */
        if(!valideBoom){
            massage = "error.boom.niet.valide";
        } else if(uniek.equals("") || (!uniek.equals("") && boom.getId() != null && boom.getId() != -1)){

            ggb.getBron().getUrl();

            String adminPk = ggb.getAdmin_pk();

            DataStore ds = ggb.getBron().toDatastore();
            try {
                String typename = ggb.getAdmin_tabel();

                SimpleFeatureType ft = ds.getSchema(typename);
                SimpleFeature f = boom.getFeature(ft);

                Integer id = FormUtils.getInteger(dynaForm, "id");
                String status = dynaForm.getString("status");

                if (id != null && id > 0 && status.equals("nieuw")) {
                    doUpdate(adminPk, ds, f, id);
                } else {
                    doInsert(ds, f);
                }
            } finally {
                ds.dispose();
            }
        } else {
            massage = "error.boom.niet.uniek";
            // toon bestaande boom
            String wkt = getWKT(ggb.getAdmin_tabel(), uniek);
            request.setAttribute("boomWkt", wkt);
        }

        makeLists(dynaForm, request);

        if (valideBoom && massage.length() == 0) {
            addDefaultMessage(mapping, request, ACKNOWLEDGE_MESSAGES);
            return mapping.findForward(SUCCESS);
        } else {
            this.addAlternateMessage(mapping, request, massage);
            return getAlternateForward(mapping, request);
        }
    }

    public ActionForward removeBoom(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {

        Integer ggbId = (Integer) dynaForm.get("gegevensbron");
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        Gegevensbron ggb = (Gegevensbron) sess.get(Gegevensbron.class, ggbId);
        ggb.getBron().getUrl();
        DataStore ds = ggb.getBron().toDatastore();

        String adminPK = ggb.getAdmin_pk();

        try {
            String typename = ggb.getAdmin_tabel();
            Integer id = FormUtils.getInteger(dynaForm, "id");
            String boomid = dynaForm.getString("boomid");
            String status = dynaForm.getString("status");

            List bomen = getBomen(boomid);
            int aantal = bomen.size();

            if (id != null && id > 0 && status.equals("nieuw")) {
                // de status is nieuw, dus de boom uit de database verwijderen
                doDelete(adminPK, ds, typename, id);
            }else if (id != null && id > 0 && status.equals("actueel")){
                // verander status in 'weg' en sla boom op.
                Boom boom = new Boom();
                populateBoomObject(dynaForm, request, boom);
                boom.setStatus("weg");
                SimpleFeatureType ft = ds.getSchema(typename);
                SimpleFeature f = boom.getFeature(ft);
                doUpdate(adminPK, ds, f, id);
            }
        } finally {
            ds.dispose();
        }

        addDefaultMessage(mapping, request, ACKNOWLEDGE_MESSAGES);
        cleanForm(dynaForm);
        makeLists(dynaForm, request);

        return getDefaultForward(mapping, request);
    }

    private void doDelete(String adminPk, DataStore ds, String typename, Integer id) throws IOException, CQLException {
        Filter f = CQL.toFilter(adminPk + " = '" + id + "'");

        FeatureWriter writer = ds.getFeatureWriter(typename, f, Transaction.AUTO_COMMIT);

        try {
            while (writer.hasNext()) {
                SimpleFeature newFeature = (SimpleFeature) writer.next();
                writer.remove();
            }
        } finally {
            if (writer != null) {
                writer.close();
            }
        }
    }

    private void makeLists(DynaValidatorForm dynaForm, HttpServletRequest request) throws Exception {
        Map instellingen = getInstellingenMap(request);

        Integer gbId = (Integer) instellingen.get("boomGegevensbron");
        dynaForm.set("gegevensbron", gbId);

        //List boomsoort = getBoomSoorten();

        //request.setAttribute("boomsoort", boomsoort);
        request.setAttribute("BOOMHOOGTE", BOOMHOOGTE);
        request.setAttribute("EINDBEELD", EINDBEELD);
        request.setAttribute("AANTASTINGEN", AANTASTINGEN);
        request.setAttribute("AANTASTINGEN_DIGIDIS", AANTASTINGEN_DIGIDIS);
        request.setAttribute("MAATREGELEN_KORT", MAATREGELEN_KORT);
        request.setAttribute("MAATREGELEN_LANG", MAATREGELEN_LANG);
        request.setAttribute("RISICOKLASSE", RISICOKLASSE);
        request.setAttribute("WEGTYPE", WEGTYPE);

        GisPrincipal userInlog = GisPrincipal.getGisPrincipal(request);
        String usernaam = userInlog.getName();
        String naam = getUserFullname(usernaam);
        dynaForm.set("inspecteur", naam);

        LabelsUtil.getExtraLabels(request);
    }

    private boolean populateBoomObject(DynaValidatorForm dynaForm, HttpServletRequest request, Boom boom) {
        Integer id = FormUtils.getInteger(dynaForm, "id");
        String boomid = FormUtils.nullIfEmpty(dynaForm.getString("boomid"));
        String projectid = FormUtils.nullIfEmpty(dynaForm.getString("projectid"));
        String project = FormUtils.nullIfEmpty(dynaForm.getString("project"));
        Integer plantjaar = FormUtils.getInteger(dynaForm, "plantjaar");

        String inspecteur = FormUtils.nullIfEmpty(dynaForm.getString("inspecteur"));
        String aktie = FormUtils.nullIfEmpty(dynaForm.getString("aktie"));

        String boomlabel = FormUtils.nullIfEmpty(dynaForm.getString("boomsoort"));
        String boomsoort = getBoomSoort(boomlabel);
        
        String boomhoogte = FormUtils.nullIfEmpty(dynaForm.getString("boomhoogte"));
        String boomhoogtevrij = FormUtils.nullIfEmpty(dynaForm.getString("boomhoogtevrij"));
        String eindbeeldvrij = FormUtils.nullIfEmpty(dynaForm.getString("eindbeeldvrij"));
        String eindbeeld = FormUtils.nullIfEmpty(dynaForm.getString("eindbeeld"));
        String aantastingenvrij = FormUtils.nullIfEmpty(dynaForm.getString("aantastingenvrij"));
        String aantastingen = FormUtils.nullIfEmpty(dynaForm.getString("aantastingen"));
        String status_zp = FormUtils.nullIfEmpty(dynaForm.getString("status_zp"));
        String classificatie = FormUtils.nullIfEmpty(dynaForm.getString("classificatie"));
        String maatregelen_kortvrij = FormUtils.nullIfEmpty(dynaForm.getString("maatregelen_kortvrij"));
        String maatregelen_kort = FormUtils.nullIfEmpty(dynaForm.getString("maatregelen_kort"));
        String maatregelen_langvrij = FormUtils.nullIfEmpty(dynaForm.getString("maatregelen_langvrij"));
        String maatregelen_lang = FormUtils.nullIfEmpty(dynaForm.getString("maatregelen_lang"));
        String risicoklasse = FormUtils.nullIfEmpty(dynaForm.getString("risicoklasse"));
        String uitvoerdatum = FormUtils.nullIfEmpty(dynaForm.getString("uitvoerdatum"));
        String wegtypevrij = FormUtils.nullIfEmpty(dynaForm.getString("wegtypevrij"));
        String wegtype = FormUtils.nullIfEmpty(dynaForm.getString("wegtype"));
        String opmerking = FormUtils.nullIfEmpty(dynaForm.getString("opmerking"));
        String extra1 = FormUtils.nullIfEmpty(dynaForm.getString("extra1"));
        String extra2 = FormUtils.nullIfEmpty(dynaForm.getString("extra2"));
        String extra3 = FormUtils.nullIfEmpty(dynaForm.getString("extra3"));
        String extra4 = FormUtils.nullIfEmpty(dynaForm.getString("extra4"));
        String extra5 = FormUtils.nullIfEmpty(dynaForm.getString("extra5"));
        String extra6 = FormUtils.nullIfEmpty(dynaForm.getString("extra6"));
        String extra7 = FormUtils.nullIfEmpty(dynaForm.getString("extra7"));
        String extra8 = FormUtils.nullIfEmpty(dynaForm.getString("extra8"));
        String extra9 = FormUtils.nullIfEmpty(dynaForm.getString("extra9"));
        String extra10 = FormUtils.nullIfEmpty(dynaForm.getString("extra10"));

        boolean scheefstand = FormUtils.getBoolean(dynaForm, "scheefstand");
        boolean scheuren = FormUtils.getBoolean(dynaForm, "scheuren");
        boolean holten = FormUtils.getBoolean(dynaForm, "holten");
        boolean stamvoetschade = FormUtils.getBoolean(dynaForm, "stamvoetschade");
        boolean stamschade = FormUtils.getBoolean(dynaForm, "stamschade");
        boolean kroonschade = FormUtils.getBoolean(dynaForm, "kroonschade");
        boolean inrot = FormUtils.getBoolean(dynaForm, "inrot");
        boolean houtboorder = FormUtils.getBoolean(dynaForm, "houtboorder");
        boolean zwam = FormUtils.getBoolean(dynaForm, "zwam");
        boolean zwam_stamvoet = FormUtils.getBoolean(dynaForm, "zwam_stamvoet");
        boolean zwam_stam = FormUtils.getBoolean(dynaForm, "zwam_stam");
        boolean zwam_kroon = FormUtils.getBoolean(dynaForm, "zwam_kroon");
        boolean dood_hout = FormUtils.getBoolean(dynaForm, "dood_hout");
        boolean plakoksel = FormUtils.getBoolean(dynaForm, "plakoksel");
        boolean stamschot = FormUtils.getBoolean(dynaForm, "stamschot");
        boolean wortelopslag = FormUtils.getBoolean(dynaForm, "wortelopslag");
        boolean takken = FormUtils.getBoolean(dynaForm, "takken");
        boolean opdruk = FormUtils.getBoolean(dynaForm, "opdruk");
        boolean vta1 = FormUtils.getBoolean(dynaForm, "vta1");
        boolean vta2 = FormUtils.getBoolean(dynaForm, "vta2");
        boolean vta3 = FormUtils.getBoolean(dynaForm, "vta3");
        boolean vta4 = FormUtils.getBoolean(dynaForm, "vta4");
        boolean vta5 = FormUtils.getBoolean(dynaForm, "vta5");
        boolean vta6 = FormUtils.getBoolean(dynaForm, "vta6");
        
        boolean nader_onderzoek = FormUtils.getBoolean(dynaForm, "nader_onderzoek");
        boolean bereikbaarheid = FormUtils.getBoolean(dynaForm, "bereikbaarheid");

        if (id.equals(0)) {
            id = null;
        }
        boom.setId(id);
        boom.setBoomid(boomid);

        String wkt = dynaForm.getString("wkt");
        try {
            Geometry geom = DataStoreUtil.createGeomFromWKTString(wkt);
            String xy = geom.getCoordinate().toString().substring(1);
            String[] coordinaten = xy.split(",");
            String x = coordinaten[0].trim();
            String y = coordinaten[1].trim();
            int puntX = x.indexOf(".");
            int puntY = y.indexOf(".");
            boom.setUpload_rdx(x.substring(0, puntX+2));
            boom.setUpload_rdy(y.substring(0, puntY+2));
            boom.setThe_geom(geom);
        } catch (Exception ex) {
            logger.error("Fout tijdens omzetten wkt voor editing: ", ex);
            return false;
        }

        if (projectid == null || projectid.equals("")) {
            GisPrincipal user = GisPrincipal.getGisPrincipal(request);
            projectid = user.getSp().getOrganizationCode();
        }
        if (project == null || project.equals("")){
            project = getWijk(boom.getThe_geom(), projectid);
            dynaForm.set("project", project);
        }
        boom.setProjectid(projectid);
        boom.setProject(project);
        boom.setStatus("nieuw");
        boom.setPlantjaar(plantjaar);
        
        Date now = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy", new Locale("NL"));  
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm:ss", new Locale("NL")); 
        
        String mutatiedatum = dateFormat.format(now);
        String mutatietijd = timeFormat.format(now);

        boom.setMutatiedatum(mutatiedatum);
        boom.setMutatietijd(mutatietijd);

        dynaForm.set("mutatiedatum", mutatiedatum);
        dynaForm.set("mutatietijd", mutatietijd);

        boom.setInspecteur(inspecteur);
        boom.setAktie(aktie);
        boom.setBoomsrt(boomsoort);
        if(boomhoogtevrij != null){
            boom.setBoomhoogte(boomhoogtevrij);
        }else if (boomhoogte != null && !boomhoogte.equals("")) {
            boom.setBoomhoogte(boomhoogte);
        }
        if(eindbeeldvrij != null){
            boom.setEindbeeld(eindbeeldvrij);
        }else if (eindbeeld != null && !eindbeeld.equals("")) {
            boom.setEindbeeld(eindbeeld);
        } 
        if(aantastingenvrij != null){
             boom.setAantastingen(aantastingenvrij);
        }else if (aantastingen != null && !aantastingen.equals("")) {
            boom.setAantastingen(aantastingen);
        } 
        boom.setStatus_zp(status_zp);
        boom.setClassificatie(classificatie);
        if(maatregelen_kortvrij != null){
            boom.setMaatregelen_kort(maatregelen_kortvrij);
        } else if (maatregelen_kort != null && !maatregelen_kort.equals("")) {
            boom.setMaatregelen_kort(maatregelen_kort);
        } 
        if(maatregelen_langvrij != null){
            boom.setMaatregelen_lang(maatregelen_langvrij);
        } else if (maatregelen_lang != null && !maatregelen_lang.equals("")) {
            boom.setMaatregelen_lang(maatregelen_lang);
        }
        boom.setRisicoklasse(risicoklasse);
        boom.setUitvoerdatum(uitvoerdatum);
        if(wegtypevrij != null){
            boom.setWegtype(wegtypevrij);
        }else if (wegtype != null && !wegtype.equals("")) {
            boom.setWegtype(wegtype);
        }
        
        // speciale tekens uit opmerking halen.
        String opmerkingen = "";
        if(opmerking != null && opmerking.length() > 0){
            opmerkingen = opmerking.replaceAll("[#|\"*]", " ");
        }
        
        boom.setOpmerkingen(opmerkingen);
        boom.setExtra1(extra1);
        boom.setExtra2(extra2);
        boom.setExtra3(extra3);
        boom.setExtra4(extra4);
        boom.setExtra5(extra5);
        boom.setExtra6(extra6);
        boom.setExtra7(extra7);
        boom.setExtra8(extra8);
        boom.setExtra9(extra9);
        boom.setExtra10(extra10);

        if (scheefstand){
            boom.setScheefstand("1");
        }else{
            boom.setScheefstand("0");
        }
        if (scheuren){
            boom.setScheuren("1");
        }else{
            boom.setScheuren("0");
        }
        if (holten){
            boom.setHolten("1");
        }else{
            boom.setHolten("0");
        }
        if (stamvoetschade) {
            boom.setStamvoetschade("1");
        }else{
            boom.setStamvoetschade("0");
        }
        if (stamschade) {
            boom.setStamschade("1");
        }else{
            boom.setStamschade("0");
        }
        if (kroonschade) {
            boom.setKroonschade("1");
        }else{
            boom.setKroonschade("0");
        }
        if (inrot) {
            boom.setInrot("1");
        }else{
            boom.setInrot("0");
        }
        if (houtboorder) {
            boom.setHoutboorder("1");
        }else{
            boom.setHoutboorder("0");
        }
        if (zwam) {
            boom.setZwam("1");
        }else{
            boom.setZwam("0");
        }
        if (zwam_stamvoet) {
            boom.setZwam_stamvoet("1");
        }else{
            boom.setZwam_stamvoet("0");
        }
        if (zwam_stam) {
            boom.setZwam_stam("1");
        }else{
            boom.setZwam_stam("0");
        }
        if (zwam_kroon) {
            boom.setZwam_kroon("1");
        }else{
            boom.setZwam_kroon("0");
        }
        if (dood_hout) {
            boom.setDood_hout("1");
        }else{
            boom.setDood_hout("0");
        }
        if (plakoksel) {
            boom.setPlakoksel("1");
        }else{
            boom.setPlakoksel("0");
        }
        if (stamschot) {
            boom.setStamschot("1");
        }else{
            boom.setStamschot("0");
        }
        if (wortelopslag) {
            boom.setWortelopslag("1");
        }else{
            boom.setWortelopslag("0");
        }
        if (takken) {
            boom.setTakken("1");
        }else{
            boom.setTakken("0");
        }
        if (opdruk) {
            boom.setOpdruk("1");
        }else{
            boom.setOpdruk("0");
        }
        if (vta1) {
            boom.setVta1("1");
        }else{
            boom.setVta1("0");
        }
        if (vta2) {
            boom.setVta2("1");
        }else{
            boom.setVta2("0");
        }
        if (vta3) {
            boom.setVta3("1");
        }else{
            boom.setVta3("0");
        }
        if (vta4) {
            boom.setVta4("1");
        }else{
            boom.setVta4("0");
        }
        if (vta5) {
            boom.setVta5("1");
        }else{
            boom.setVta5("0");
        }
        if (vta6) {
            boom.setVta6("1");
        }else{
            boom.setVta6("0");
        }
        
        if (nader_onderzoek) {
            boom.setNader_onderzoek("1");
        }else{
            boom.setNader_onderzoek("0");
        }
        
        if (bereikbaarheid) {
            boom.setBereikbaarheid("1");
        }else{
            boom.setBereikbaarheid("0");
        }
        
        if(boom.getBoomsrt() == null || boom.getBoomsrt().equals("")){
            return false;
        }
        return true;
    }

    private String getWijk(Geometry geom, String projectid){
        String wijk = "";
        String query = "select project from projectindeling where st_contains(the_geom, st_geometryfromtext('"+geom+"',28992))";

        Connection conn = null;

        try {
            InitialContext cxt = new InitialContext();
            DataSource ds = (DataSource) cxt.lookup("java:/comp/env/jdbc/gisdata");
            conn = ds.getConnection();

            PreparedStatement statement = conn.prepareStatement(query.toString());
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    wijk = rs.getString(1);
                }
            } finally {
                statement.close();
            }

        } catch (SQLException ex) {
            logger.error("", ex);
        } catch (NamingException ex) {
            logger.error("", ex);
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                logger.error("", ex);
            }
        }

        if(wijk != null && !wijk.equals("")){
            return wijk;
        }else{
            return projectid;
        }
    }

    private String getBoomSoort(String boomlabel) {
        String[] labels = boomlabel.split("'");
        
        String output = "";
        
        String query = "select boomsoort from digitree_boomsoorten where ";
        
        if(labels.length == 1){
            query += "omschrijving = '"+labels[0]+"' ";
        }else{
            for(int i = 0; i < labels.length; i++){
                if(labels[i] != ""){
                    if(i == 0){
                        query += "omschrijving like '%"+labels[i]+"%' ";
                    }else{
                        query += "and omschrijving like '%"+labels[i]+"%' ";
                    }
                }
            }
        }

        Connection conn = null;

        try {
            InitialContext cxt = new InitialContext();
            DataSource ds = (DataSource) cxt.lookup("java:/comp/env/jdbc/gisdata");
            conn = ds.getConnection();

            PreparedStatement statement = conn.prepareStatement(query.toString());
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    output = rs.getString(1);
                }
            } finally {
                statement.close();
            }

        } catch (SQLException ex) {
            logger.error("", ex);
        } catch (NamingException ex) {
            logger.error("", ex);
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                logger.error("", ex);
            }
        }
        return output;
    }

    private List getBomen(String boomid) {
        List bomen = new ArrayList();
        String query = "select id, status from digitree_bomen where boomid = '"+boomid+"'";

        Connection conn = null;

        try {
            InitialContext cxt = new InitialContext();
            DataSource ds = (DataSource) cxt.lookup("java:/comp/env/jdbc/gisdata");
            conn = ds.getConnection();

            PreparedStatement statement = conn.prepareStatement(query.toString());
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    Map boom = new HashMap();
                    boom.put("id", rs.getString(1));
                    boom.put("status", rs.getString(2));
                    bomen.add(boom);
                }
            } finally {
                statement.close();
            }

        } catch (SQLException ex) {
            logger.error("", ex);
        } catch (NamingException ex) {
            logger.error("", ex);
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                logger.error("", ex);
            }
        }
        return bomen;
    }

    private String getUserFullname(String usernaam) {
        String fullname = "";
        String query = "select first_name, surname from users"
                + " where username ='"+usernaam+"'";

        Connection conn = null;

        try {
            InitialContext cxt = new InitialContext();
            DataSource ds = (DataSource) cxt.lookup("java:/comp/env/jdbc/kaartenbalie");
            conn = ds.getConnection();

            PreparedStatement statement = conn.prepareStatement(query.toString());
            try {
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    fullname = rs.getString(1) + " " + rs.getString(2);
                }
            } finally {
                statement.close();
            }

        } catch (SQLException ex) {
            logger.error("", ex);
        } catch (NamingException ex) {
            logger.error("", ex);
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                logger.error("", ex);
            }
        }
        return fullname;
    }

    /* Check of de combinatie va velden die samen de pk vormen uniek is */
    private String checkPK(Boom boom, String table) {
        String uniek = "";
        StringBuilder query = new StringBuilder();

        /* TODO: SQL injection mogelijk door in deze parameters
         * sql mee te geven. We moeten eigenlijk even al deze
         * voorkomens nagaan.
         */
        query.append("SELECT id, projectid, project, boomid FROM ");
        query.append(table);
        query.append(" WHERE projectid = \'");
        query.append(boom.getProjectid());
        query.append("\' AND boomid = \'");
        query.append(boom.getBoomid());
        query.append("\'");

        Connection conn = null;

        try {
            InitialContext cxt = new InitialContext();
            DataSource ds = (DataSource) cxt.lookup("java:/comp/env/jdbc/gisdata");
            conn = ds.getConnection();

            PreparedStatement statement = conn.prepareStatement(query.toString());
            try {
                ResultSet rs = statement.executeQuery();
                if (rs.next()) {
                    uniek = rs.getString("id");
                }
            } finally {
                statement.close();
            }

        } catch (SQLException ex) {
            logger.error("", ex);
        } catch (NamingException ex) {
            logger.error("", ex);
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                logger.error("", ex);
            }
        }

        return uniek;
    }

    private String getWKT(String table, String id) {
        String wkt = "";
        StringBuilder query = new StringBuilder();

        query.append("SELECT upload_rdx, upload_rdy FROM ");
        query.append(table);
        query.append(" WHERE id = ");
        query.append(id);

        Connection conn = null;

        try {
            InitialContext cxt = new InitialContext();
            DataSource ds = (DataSource) cxt.lookup("java:/comp/env/jdbc/gisdata");
            conn = ds.getConnection();

            PreparedStatement statement = conn.prepareStatement(query.toString());
            try {
                ResultSet rs = statement.executeQuery();
                if (rs.next()) {
                    String x = rs.getString("upload_rdx");
                    String y = rs.getString("upload_rdy");

                    wkt = "POINT("+x+" "+y+")";
                }
            } finally {
                statement.close();
            }

        } catch (SQLException ex) {
            logger.error("", ex);
        } catch (NamingException ex) {
            logger.error("", ex);
        } finally {
            try {
                conn.close();
            } catch (SQLException ex) {
                logger.error("", ex);
            }
        }

        return wkt;
    }

    private void doInsert(DataStore dataStore2Write, SimpleFeature feature) throws IOException {
        String typename = feature.getFeatureType().getTypeName();
        FeatureWriter writer = dataStore2Write.getFeatureWriterAppend(typename, Transaction.AUTO_COMMIT);

        try {
            SimpleFeature newFeature = (SimpleFeature) writer.next();

            for (int i = 0; i < NEW_FIELDS.length; i++) {
                newFeature.setAttribute(NEW_FIELDS[i], feature.getAttribute(NEW_FIELDS[i]));
            }

            writer.write();
        } finally {
            if (writer != null) {
                writer.close();
            }
        }
    }

    private void doUpdate(String adminPk, DataStore ds, SimpleFeature feature, Integer id) throws IOException, CQLException {
        /* Typename en filter voor de writer */
        String typename = feature.getFeatureType().getTypeName();
        Filter f = CQL.toFilter(adminPk + " = '" + id + "'");

        FeatureWriter writer = ds.getFeatureWriter(typename, f, Transaction.AUTO_COMMIT);

        try {
            while (writer.hasNext()) {
                SimpleFeature newFeature = (SimpleFeature) writer.next();

                for (int i = 0; i < EDIT_FIELDS.length; i++) {
                    newFeature.setAttribute(EDIT_FIELDS[i], feature.getAttribute(EDIT_FIELDS[i]));
                }

                writer.write();
            }
        } finally {
            if (writer != null) {
                writer.close();
            }
        }
    }

    private Map getInstellingenMap(HttpServletRequest request) throws Exception {

        GisPrincipal user = GisPrincipal.getGisPrincipal(request);
        ConfigKeeper configKeeper = new ConfigKeeper();

        if (user == null) {
            //TODO waarom komt dit soms voor?
            return configKeeper.getConfigMap(null, true);
        }

        Set roles = user.getRoles();

        Configuratie rollenPrio = null;
        try {
            rollenPrio = configKeeper.getConfiguratie("rollenPrio", "rollen");
        } catch (Exception ex) {
            logger.debug("Fout bij ophalen configKeeper configuratie: " + ex);
        }

        String[] configRollen = null;
        if (rollenPrio != null && rollenPrio.getPropval() != null) {
            configRollen = rollenPrio.getPropval().split(",");
        }

        String echteRol = null;

        Boolean foundRole = false;
        if(configRollen != null && configRollen.length > 0){
            for (int i = 0; i < configRollen.length; i++) {
                if (foundRole) {
                    break;
                }
                String rolnaam = configRollen[i];
                Iterator iter = roles.iterator();
                while (iter.hasNext()) {
                    String inlogRol = iter.next().toString();
                    if (rolnaam.equals(inlogRol)) {
                        echteRol = rolnaam;
                        foundRole = true;
                        break;
                    }
                }
            }
        }

        Map map = configKeeper.getConfigMap(echteRol, false);
        if ((map == null) || (map.isEmpty())) {
            map = configKeeper.getConfigMap(null, true);
        }
        
        return map;
    }

    private void cleanForm(DynaValidatorForm dynaForm){
        dynaForm.set("id", null);
        dynaForm.set("boomid", "");
        dynaForm.set("projectid", "");
        dynaForm.set("project", "");
        dynaForm.set("plantjaar", null);
        dynaForm.set("mutatiedatum", "");
        dynaForm.set("mutatietijd", "");
        dynaForm.set("inspecteur", "");
        dynaForm.set("aktie", "");
        dynaForm.set("boomsoort", "");
        dynaForm.set("boomhoogte", "");
        dynaForm.set("boomhoogtevrij", "");
        dynaForm.set("eindbeeldvrij", "");
        dynaForm.set("eindbeeld", "");
        dynaForm.set("aantastingenvrij", "");
        dynaForm.set("aantastingen", "");
        dynaForm.set("status_zp", "");
        dynaForm.set("classificatie", "");
        dynaForm.set("maatregelen_kortvrij", "");
        dynaForm.set("maatregelen_kort", "");
        dynaForm.set("maatregelen_langvrij", "");
        dynaForm.set("maatregelen_lang", "");
        dynaForm.set("risicoklasse", "");
        dynaForm.set("uitvoerdatum", "");
        dynaForm.set("wegtypevrij", "");
        dynaForm.set("wegtype", "");
        dynaForm.set("opmerking", "");
        dynaForm.set("extra1", "");
        dynaForm.set("extra2", "");
        dynaForm.set("extra3", "");
        dynaForm.set("extra4", "");
        dynaForm.set("extra5", "");
        dynaForm.set("extra6", "");
        dynaForm.set("extra7", "");
        dynaForm.set("extra8", "");
        dynaForm.set("extra9", "");
        dynaForm.set("extra10", "");
        dynaForm.set("scheefstand", false);
        dynaForm.set("scheuren", false);
        dynaForm.set("holten", false);
        dynaForm.set("stamvoetschade", false);
        dynaForm.set("stamschade", false);
        dynaForm.set("kroonschade", false);
        dynaForm.set("inrot", false);
        dynaForm.set("houtboorder", false);
        dynaForm.set("zwam", false);
        dynaForm.set("zwam_stamvoet", false);
        dynaForm.set("zwam_stam", false);
        dynaForm.set("zwam_kroon", false);
        dynaForm.set("dood_hout", false);
        dynaForm.set("plakoksel", false);
        dynaForm.set("stamschot", false);
        dynaForm.set("wortelopslag", false);
        dynaForm.set("takken", false);
        dynaForm.set("opdruk", false);
        dynaForm.set("vta1", false);
        dynaForm.set("vta2", false);
        dynaForm.set("vta3", false);
        dynaForm.set("vta4", false);
        dynaForm.set("vta5", false);
        dynaForm.set("vta6", false);
        dynaForm.set("nader_onderzoek", false);
        dynaForm.set("bereikbaarheid", false);
    }
}
