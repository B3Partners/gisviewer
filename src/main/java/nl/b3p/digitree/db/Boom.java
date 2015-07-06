package nl.b3p.digitree.db;

import org.geotools.feature.simple.SimpleFeatureBuilder;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import com.vividsolutions.jts.geom.Geometry;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author jytte
 */
public class Boom {

    private Integer id;
    private Geometry the_geom;
    private String boomid;
    private String projectid;
    private String project;
    private String status;
    private String upload_rdx;
    private String upload_rdy;
    private String mutatiedatum;
    private String mutatietijd;
    private String inspecteur;
    private String aktie;
    private String boomsrt;
    private Integer plantjaar;
    private String boomhoogte;
    private String eindbeeld;
    private String scheefstand = "0";
    private String scheuren = "0";
    private String holten = "0";
    private String stamvoetschade = "0";
    private String stamschade = "0";
    private String kroonschade = "0";
    private String inrot = "0";
    private String houtboorder = "0";
    private String zwam = "0";
    private String zwam_stamvoet = "0";
    private String zwam_stam = "0";
    private String zwam_kroon = "0";
    private String dood_hout = "0";
    private String plakoksel = "0";
    private String stamschot = "0";
    private String wortelopslag = "0";
    private String takken = "0";
    private String opdruk = "0";
    private String vta1 = "0";
    private String vta2 = "0";
    private String vta3 = "0";
    private String vta4 = "0";
    private String vta5 = "0";
    private String vta6 = "0";
    private String aantastingen;
    private String status_zp;
    private String classificatie;
    private String maatregelen_kort;
    private String nader_onderzoek = "0";
    private String maatregelen_lang;
    private String risicoklasse;
    private String uitvoerdatum;
    private String bereikbaarheid = "0";
    private String wegtype;
    private String opmerkingen;
    private String extra1;
    private String extra2;
    private String extra3;
    private String extra4;
    private String extra5;
    private String extra6;
    private String extra7;
    private String extra8;
    private String extra9;
    private String extra10;

    public String getBoomid() {
        return boomid;
    }

    public void setBoomid(String boomid) {
        this.boomid = boomid;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getProject() {
        return project;
    }

    public void setProject(String project) {
        this.project = project;
    }

    public String getProjectid() {
        return projectid;
    }

    public void setProjectid(String projectid) {
        this.projectid = projectid;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Geometry getThe_geom() {
        return the_geom;
    }

    public void setThe_geom(Geometry the_geom) {
        this.the_geom = the_geom;
    }

    public String getAantastingen() {
        return aantastingen;
    }

    public void setAantastingen(String aantastingen) {
        this.aantastingen = aantastingen;
    }

    public String getAktie() {
        return aktie;
    }

    public void setAktie(String aktie) {
        this.aktie = aktie;
    }

    public String getBoomhoogte() {
        return boomhoogte;
    }

    public void setBoomhoogte(String boomhoogte) {
        this.boomhoogte = boomhoogte;
    }

    public String getBoomsrt() {
        return boomsrt;
    }

    public void setBoomsrt(String boomsrt) {
        this.boomsrt = boomsrt;
    }

    public String getClassificatie() {
        return classificatie;
    }

    public void setClassificatie(String classificatie) {
        this.classificatie = classificatie;
    }

    public String getEindbeeld() {
        return eindbeeld;
    }

    public void setEindbeeld(String eindbeeld) {
        this.eindbeeld = eindbeeld;
    }

    public String getExtra1() {
        return extra1;
    }

    public void setExtra1(String extra1) {
        this.extra1 = extra1;
    }

    public String getExtra10() {
        return extra10;
    }

    public void setExtra10(String extra10) {
        this.extra10 = extra10;
    }

    public String getExtra2() {
        return extra2;
    }

    public void setExtra2(String extra2) {
        this.extra2 = extra2;
    }

    public String getExtra3() {
        return extra3;
    }

    public void setExtra3(String extra3) {
        this.extra3 = extra3;
    }

    public String getExtra4() {
        return extra4;
    }

    public void setExtra4(String extra4) {
        this.extra4 = extra4;
    }

    public String getExtra5() {
        return extra5;
    }

    public void setExtra5(String extra5) {
        this.extra5 = extra5;
    }

    public String getExtra6() {
        return extra6;
    }

    public void setExtra6(String extra6) {
        this.extra6 = extra6;
    }

    public String getExtra7() {
        return extra7;
    }

    public void setExtra7(String extra7) {
        this.extra7 = extra7;
    }

    public String getExtra8() {
        return extra8;
    }

    public void setExtra8(String extra8) {
        this.extra8 = extra8;
    }

    public String getExtra9() {
        return extra9;
    }

    public void setExtra9(String extra9) {
        this.extra9 = extra9;
    }

    public String getInspecteur() {
        return inspecteur;
    }

    public void setInspecteur(String inspecteur) {
        this.inspecteur = inspecteur;
    }

    public String getMaatregelen_kort() {
        return maatregelen_kort;
    }

    public void setMaatregelen_kort(String maatregelen_kort) {
        this.maatregelen_kort = maatregelen_kort;
    }

    public String getMaatregelen_lang() {
        return maatregelen_lang;
    }

    public void setMaatregelen_lang(String maatregelen_lang) {
        this.maatregelen_lang = maatregelen_lang;
    }

    public String getMutatiedatum() {
        return mutatiedatum;
    }

    public void setMutatiedatum(String mutatiedatum) {
        this.mutatiedatum = mutatiedatum;
    }

    public String getMutatietijd() {
        return mutatietijd;
    }

    public void setMutatietijd(String mutatietijd) {
        this.mutatietijd = mutatietijd;
    }

    public String getOpmerkingen() {
        return opmerkingen;
    }

    public void setOpmerkingen(String opmerkingen) {
        this.opmerkingen = opmerkingen;
    }

    public Integer getPlantjaar() {
        return plantjaar;
    }

    public void setPlantjaar(Integer plantjaar) {
        this.plantjaar = plantjaar;
    }

    public String getRisicoklasse() {
        return risicoklasse;
    }

    public void setRisicoklasse(String risicoklasse) {
        this.risicoklasse = risicoklasse;
    }

    public String getStatus_zp() {
        return status_zp;
    }

    public void setStatus_zp(String status_zp) {
        this.status_zp = status_zp;
    }

    public String getUitvoerdatum() {
        return uitvoerdatum;
    }

    public void setUitvoerdatum(String uitvoerdatum) {
        this.uitvoerdatum = uitvoerdatum;
    }

    public String getWegtype() {
        return wegtype;
    }

    public void setWegtype(String wegtype) {
        this.wegtype = wegtype;
    }

    public String getUpload_rdx() {
        return upload_rdx;
    }

    public void setUpload_rdx(String upload_rdx) {
        this.upload_rdx = upload_rdx;
    }

    public String getUpload_rdy() {
        return upload_rdy;
    }

    public void setUpload_rdy(String upload_rdy) {
        this.upload_rdy = upload_rdy;
    }

    public String getBereikbaarheid() {
        return bereikbaarheid;
    }

    public void setBereikbaarheid(String bereikbaarheid) {
        this.bereikbaarheid = bereikbaarheid;
    }

    public String getDood_hout() {
        return dood_hout;
    }

    public void setDood_hout(String dood_hout) {
        this.dood_hout = dood_hout;
    }

    public String getHolten() {
        return holten;
    }

    public void setHolten(String holten) {
        this.holten = holten;
    }

    public String getHoutboorder() {
        return houtboorder;
    }

    public void setHoutboorder(String houtboorder) {
        this.houtboorder = houtboorder;
    }

    public String getInrot() {
        return inrot;
    }

    public void setInrot(String inrot) {
        this.inrot = inrot;
    }

    public String getKroonschade() {
        return kroonschade;
    }

    public void setKroonschade(String kroonschade) {
        this.kroonschade = kroonschade;
    }

    public String getNader_onderzoek() {
        return nader_onderzoek;
    }

    public void setNader_onderzoek(String nader_onderzoek) {
        this.nader_onderzoek = nader_onderzoek;
    }

    public String getOpdruk() {
        return opdruk;
    }

    public void setOpdruk(String opdruk) {
        this.opdruk = opdruk;
    }

    public String getPlakoksel() {
        return plakoksel;
    }

    public void setPlakoksel(String plakoksel) {
        this.plakoksel = plakoksel;
    }

    public String getScheefstand() {
        return scheefstand;
    }

    public void setScheefstand(String scheefstand) {
        this.scheefstand = scheefstand;
    }

    public String getScheuren() {
        return scheuren;
    }

    public void setScheuren(String scheuren) {
        this.scheuren = scheuren;
    }

    public String getStamschade() {
        return stamschade;
    }

    public void setStamschade(String stamschade) {
        this.stamschade = stamschade;
    }

    public String getStamschot() {
        return stamschot;
    }

    public void setStamschot(String stamschot) {
        this.stamschot = stamschot;
    }

    public String getStamvoetschade() {
        return stamvoetschade;
    }

    public void setStamvoetschade(String stamvoetschade) {
        this.stamvoetschade = stamvoetschade;
    }

    public String getTakken() {
        return takken;
    }

    public void setTakken(String takken) {
        this.takken = takken;
    }

    public String getVta1() {
        return vta1;
    }

    public void setVta1(String vta1) {
        this.vta1 = vta1;
    }

    public String getVta2() {
        return vta2;
    }

    public void setVta2(String vta2) {
        this.vta2 = vta2;
    }

    public String getVta3() {
        return vta3;
    }

    public void setVta3(String vta3) {
        this.vta3 = vta3;
    }

    public String getVta4() {
        return vta4;
    }

    public void setVta4(String vta4) {
        this.vta4 = vta4;
    }

    public String getVta5() {
        return vta5;
    }

    public void setVta5(String vta5) {
        this.vta5 = vta5;
    }

    public String getVta6() {
        return vta6;
    }

    public void setVta6(String vta6) {
        this.vta6 = vta6;
    }

    public String getWortelopslag() {
        return wortelopslag;
    }

    public void setWortelopslag(String wortelopslag) {
        this.wortelopslag = wortelopslag;
    }

    public String getZwam() {
        return zwam;
    }

    public void setZwam(String zwam) {
        this.zwam = zwam;
    }

    public String getZwam_kroon() {
        return zwam_kroon;
    }

    public void setZwam_kroon(String zwam_kroon) {
        this.zwam_kroon = zwam_kroon;
    }

    public String getZwam_stam() {
        return zwam_stam;
    }

    public void setZwam_stam(String zwam_stam) {
        this.zwam_stam = zwam_stam;
    }

    public String getZwam_stamvoet() {
        return zwam_stamvoet;
    }

    public void setZwam_stamvoet(String zwam_stamvoet) {
        this.zwam_stamvoet = zwam_stamvoet;
    }

    public HashMap getAttributesMap() {
        HashMap hm = new HashMap();

        /*hm.put("boomid", boomid);
        hm.put("projectid", projectid);
        hm.put("project", project);
        hm.put("status", status);
        hm.put("the_geom", the_geom);*/

        hm.put("id", id );
        hm.put("the_geom", the_geom );
        hm.put("boomid", boomid );
        hm.put("projectid", projectid );
        hm.put("project", project );
        hm.put("status", status );
        hm.put("upload_rdx", upload_rdx );
        hm.put("upload_rdy", upload_rdy );
        hm.put("mutatiedatum", mutatiedatum );
        hm.put("mutatietijd", mutatietijd );
        hm.put("inspecteur", inspecteur );
        hm.put("aktie", aktie );
        hm.put("boomsrt", boomsrt );
        hm.put("plantjaar", plantjaar );
        hm.put("boomhoogte", boomhoogte );
        hm.put("eindbeeld", eindbeeld );
        hm.put("scheefstand", scheefstand );
        hm.put("scheuren", scheuren );
        hm.put("holten", holten );
        hm.put("stamvoetschade", stamvoetschade );
        hm.put("stamschade", stamschade );
        hm.put("kroonschade", kroonschade );
        hm.put("inrot", inrot );
        hm.put("houtboorder", houtboorder );
        hm.put("zwam", zwam );
        hm.put("zwam_stamvoet", zwam_stamvoet );
        hm.put("zwam_stam", zwam_stam );
        hm.put("zwam_kroon", zwam_kroon );
        hm.put("dood_hout", dood_hout );
        hm.put("plakoksel", plakoksel );
        hm.put("stamschot", stamschot );
        hm.put("wortelopslag", wortelopslag );
        hm.put("takken", takken );
        hm.put("opdruk", opdruk );
        hm.put("vta1", vta1 );
        hm.put("vta2", vta2 );
        hm.put("vta3", vta3 );
        hm.put("vta4", vta4 );
        hm.put("vta5", vta5 );
        hm.put("vta6", vta6 );
        hm.put("aantastingen", aantastingen );
        hm.put("status_zp", status_zp );
        hm.put("classificatie", classificatie );
        hm.put("maatregelen_kort", maatregelen_kort );
        hm.put("nader_onderzoek", nader_onderzoek );
        hm.put("maatregelen_lang", maatregelen_lang );
        hm.put("risicoklasse", risicoklasse );
        hm.put("uitvoerdatum", uitvoerdatum );
        hm.put("bereikbaarheid", bereikbaarheid );
        hm.put("wegtype", wegtype );
        hm.put("opmerkingen", opmerkingen );
        hm.put("extra1", extra1 );
        hm.put("extra2", extra2 );
        hm.put("extra3", extra3 );
        hm.put("extra4", extra4 );
        hm.put("extra5", extra5 );
        hm.put("extra6", extra6 );
        hm.put("extra7", extra7 );
        hm.put("extra8", extra8 );
        hm.put("extra9", extra9 );
        hm.put("extra10", extra10 );

        return hm;
    }

    public SimpleFeature getFeature(SimpleFeatureType ft) {
        SimpleFeatureBuilder featureBuilder = new SimpleFeatureBuilder(ft);

        List<AttributeDescriptor> attributeDescriptors = new ArrayList<AttributeDescriptor>(ft.getAttributeDescriptors());
        for (AttributeDescriptor ad : attributeDescriptors) {
            String ln = ad.getLocalName().toLowerCase();
            Object lnv = this.getAttributesMap().get(ln);
            featureBuilder.add(lnv);
        }

        SimpleFeature f = featureBuilder.buildFeature(null);

        return f;
    }
}
