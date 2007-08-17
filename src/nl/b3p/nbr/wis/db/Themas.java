/**
 * @(#)Themas.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een Themas opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.db;

import java.util.Set;

public class Themas {
    
    public static final String THEMAID = "themaid";
    
    private int id;
    private String code;
    private String naam;
    private Moscow moscow;
    private int belangnr;
    private Clusters cluster;
    private String opmerkingen;
    private boolean analyse_thema;
    private boolean locatie_thema;
    private String admin_tabel_opmerkingen;
    private String admin_tabel;
    private String admin_pk;
    private boolean admin_pk_complex;
    private String admin_spatial_ref;
    private String admin_query;
    private String spatial_tabel_opmerkingen;
    private String spatial_tabel;
    private String spatial_pk;
    private boolean spatial_pk_complex;
    private String spatial_admin_ref;
    private String wms_url;
    //komma separated layers
    private String wms_layers;
    //komma separated layers
    private String wms_querylayers;
    private Set themaData;
    private Set themaVerantwoordelijkheden;
    private Set themaApplicaties;
    private Integer update_frequentie_in_dagen;
     
    /** Creates a new instance of Themas */
    public Themas() {
    }

    /** 
     * Return het ID van het thema.
     *
     * @return int ID van het thema.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van het thema.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return de code van het thema.
     *
     * @return String met de code van het thema.
     */
    // <editor-fold defaultstate="" desc="public String getCode()">
    public String getCode() {
        return code;
    }
    // </editor-fold>
    
    /** 
     * Set de code van het thema.
     *
     * @param code String met de code van het thema.
     */
    // <editor-fold defaultstate="" desc="public void setCode(String code)">
    public void setCode(String code) {
        this.code = code;
    }
    // </editor-fold>
    
    /** 
     * Return de naam van het thema.
     *
     * @return String met het thema.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van het thema.
     *
     * @param naam String met de naam van het thema.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
    
    /** 
     * Return het belangnummer van het thema.
     *
     * @return int met het belangnummer van het thema.
     */
    // <editor-fold defaultstate="" desc="public int getBelangnr()">
    public int getBelangnr() {
        return belangnr;
    }
    // </editor-fold>
    
    /** 
     * Set het belangnummer van het thema.
     *
     * @param belangnr int met het belangnummer van het thema.
     */
    // <editor-fold defaultstate="" desc="public void setBelangnr(int belangnr)">
    public void setBelangnr(int belangnr) {
        this.belangnr = belangnr;
    }    
    // </editor-fold>
    
    /** 
     * Return opmerkingen behorende bij dit thema.
     *
     * @return String met opmerkingen.
     */
    // <editor-fold defaultstate="" desc="public String getOpmerkingen()">
    public String getOpmerkingen() {
        return opmerkingen;
    }
    // </editor-fold>
    
    /** 
     * Set opmerkingen horende bij dit thema.
     *
     * @param opmerkingen String met opmerkingen horende bij dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setOpmerkingen(String opmerkingen)">
    public void setOpmerkingen(String opmerkingen) {
        this.opmerkingen = opmerkingen;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit een analyse_thema is.
     *
     * @return boolean true als dit een analyse_thema is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isAnalyse_thema()">
    public boolean isAnalyse_thema() {
        return analyse_thema;
    }
    // </editor-fold>
    
    /** 
     * Set dit thema als een analyse_thema is. Als dit een analyse_thema is zet deze dan true, anders false.
     *
     * @param analyse_thema boolean met true als dit een analyse_thema is.
     */
    // <editor-fold defaultstate="" desc="public void setAnalyse_thema(boolean analyse_thema)">
    public void setAnalyse_thema(boolean analyse_thema) {
        this.analyse_thema = analyse_thema;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit de locatie_thema is.
     *
     * @return boolean true als dit de locatie_thema is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isLocatie_thema()">
    public boolean isLocatie_thema() {
        return locatie_thema;
    }
    // </editor-fold>
    
    /** 
     * Set dit thema als een locatie_thema is. Als dit een locatie_thema is zet deze dan true, anders false.
     *
     * @param locatie_thema boolean met true als dit een locatie_thema is.
     */
    // <editor-fold defaultstate="" desc="public void setLocatie_thema(boolean locatie_thema)">
    public void setLocatie_thema(boolean locatie_thema) {
        this.locatie_thema = locatie_thema;
    }
    // </editor-fold>

    /** 
     * Return de moscow van dit thema.
     *
     * @return Moscow met de moscow van dit thema.
     *
     * @see Moscow
     */
    // <editor-fold defaultstate="" desc="public Moscow getMoscow()">
    public Moscow getMoscow() {
        return moscow;
    }
    // </editor-fold>
    
    /** 
     * Set de moscow van dit thema.
     *
     * @param moscow Moscow met de moscow van dit thema.
     *
     * @see Moscow
     */
    // <editor-fold defaultstate="" desc="public void setMoscow(Moscow moscow)">
    public void setMoscow(Moscow moscow) {
        this.moscow = moscow;
    }
    // </editor-fold>

    
    
    
    
    /** 
     * Return het cluster van dit thema.
     *
     * @return Clusters met het cluster van dit thema.
     *
     * @see Clusters
     */
    // <editor-fold defaultstate="" desc="public Clusters getCluster()">
    public Clusters getCluster() {
        return cluster;
    }
    // </editor-fold>
    
    /** 
     * Set het cluster van dit thema.
     *
     * @param cluster Clusters met het cluster van dit thema.
     *
     * @see Clusters
     */
    // <editor-fold defaultstate="" desc="public void setMoscow(Moscow moscow)">
    public void setCluster(Clusters cluster) {
        this.cluster = cluster;
    }
    // </editor-fold>
    
    /** 
     * Return admin tabel opmerkingen van dit thema.
     *
     * @return String met de admin tabel opmerkingen van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getAdmin_tabel_opmerkingen()">
    public String getAdmin_tabel_opmerkingen() {
        return admin_tabel_opmerkingen;
    }
    // </editor-fold>
    
    /** 
     * Set de admin tabel opmerkingen van dit thema.
     *
     * @param admin_tabel_opmerkingen String met de admin tabel opmerkingen van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setAdmin_tabel_opmerkingen(String admin_tabel_opmerkingen)">
    public void setAdmin_tabel_opmerkingen(String admin_tabel_opmerkingen) {
        this.admin_tabel_opmerkingen = admin_tabel_opmerkingen;
    }
    // </editor-fold>
    
    /** 
     * Return de admin tabel van dit thema.
     *
     * @return String met de admin tabel van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getAdmin_tabel()">
    public String getAdmin_tabel() {
        return admin_tabel;
    }
    // </editor-fold>
    
    /** 
     * Set de admin tabel van dit thema.
     *
     * @param admin_tabel String met de admin tabel van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setAdmin_tabel(String admin_tabel)">
    public void setAdmin_tabel(String admin_tabel) {
        this.admin_tabel = admin_tabel;
    }
    // </editor-fold>
    
    /** 
     * Return de admin primary key van dit thema.
     *
     * @return String met de admin primary key van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getAdmin_pk()">
    public String getAdmin_pk() {
        return admin_pk;
    }
    // </editor-fold>
    
    /** 
     * Set de admin primary key van dit thema.
     *
     * @param admin_pk Moscow met de admin primary key van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setAdmin_pk(String admin_pk)">
    public void setAdmin_pk(String admin_pk) {
        this.admin_pk = admin_pk;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of de admin primary key complex is.
     *
     * @return boolean true als de admin primary key complex is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isAdmin_pk_complex()">
    public boolean isAdmin_pk_complex() {
        return admin_pk_complex;
    }
    // </editor-fold>
    
    /** 
     * Set de admin primary key complex status. Als de admin primary key complex is zet deze dan true, anders false.
     *
     * @param admin_pk_complex boolean met true alsde admin primary key complex is.
     */
    // <editor-fold defaultstate="" desc="public void setAdmin_pk_complex(boolean admin_pk_complex)">
    public void setAdmin_pk_complex(boolean admin_pk_complex) {
        this.admin_pk_complex = admin_pk_complex;
    }
    // </editor-fold>
    
    /** 
     * Return de admin spatial referentie van dit thema.
     *
     * @return String met de admin spatial referentie van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getAdmin_spatial_ref()">
    public String getAdmin_spatial_ref() {
        return admin_spatial_ref;
    }
    // </editor-fold>
    
    /** 
     * Set de admin spatial referentie van dit thema.
     *
     * @param admin_spatial_ref String met de admin spatial referentie van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setAdmin_spatial_ref(String admin_spatial_ref)">
    public void setAdmin_spatial_ref(String admin_spatial_ref) {
        this.admin_spatial_ref = admin_spatial_ref;
    }
    // </editor-fold>
    
    /** 
     * Return de admin query van dit thema.
     *
     * @return String met de admin query van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getAdmin_query()">
    public String getAdmin_query() {
        return admin_query;
    }
    // </editor-fold>
    
    /** 
     * Set de admin query van dit thema.
     *
     * @param admin_query String met de admin query van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setAdmin_query(String admin_query)">
    public void setAdmin_query(String admin_query) {
        this.admin_query = admin_query;
    }
    // </editor-fold>
    
    /** 
     * Return de spatial tabel opmerkingen van dit thema.
     *
     * @return String met de spatial tabel opmerkingen van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getSpatial_tabel_opmerkingen()">
    public String getSpatial_tabel_opmerkingen() {
        return spatial_tabel_opmerkingen;
    }
    // </editor-fold>
    
    /** 
     * Set de spatial tabel opmerkingen van dit thema.
     *
     * @param spatial_tabel_opmerkingen String met de spatial tabel opmerkingen van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setSpatial_tabel_opmerkingen(String spatial_tabel_opmerkingen)">
    public void setSpatial_tabel_opmerkingen(String spatial_tabel_opmerkingen) {
        this.spatial_tabel_opmerkingen = spatial_tabel_opmerkingen;
    }
    // </editor-fold>
    
    /** 
     * Return de spatial tabel van dit thema.
     *
     * @return Moscow met de spatial tabel van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getSpatial_tabel()">
    public String getSpatial_tabel() {
        return spatial_tabel;
    }
    // </editor-fold>
    
    /** 
     * Set de spatial tabel van dit thema.
     *
     * @param spatial_tabel String met de spatial tabel van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setSpatial_tabel(String spatial_tabel)">
    public void setSpatial_tabel(String spatial_tabel) {
        this.spatial_tabel = spatial_tabel;
    }
    // </editor-fold>
    
    /** 
     * Return de spatial primary key van dit thema.
     *
     * @return String met de spatial primary key van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getSpatial_pk()">
    public String getSpatial_pk() {
        return spatial_pk;
    }
    // </editor-fold>
    
    /** 
     * Set de spatial primary key van dit thema.
     *
     * @param spatial_pk String met de spatial primary key van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setSpatial_pk(String spatial_pk)">
    public void setSpatial_pk(String spatial_pk) {
        this.spatial_pk = spatial_pk;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of de spatial primary key complex is.
     *
     * @return boolean true als de spatial primary key complex is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isSpatial_pk_complex()">
    public boolean isSpatial_pk_complex() {
        return spatial_pk_complex;
    }
    // </editor-fold>
    
    /** 
     * Set de spatial primary key complex status. Als de spatial primary key complex is zet deze dan true, anders false.
     *
     * @param spatial_pk_complex boolean met true als de spatial primary key complex is.
     */
    // <editor-fold defaultstate="" desc="public void setSpatial_pk_complex(boolean spatial_pk_complex)">
    public void setSpatial_pk_complex(boolean spatial_pk_complex) {
        this.spatial_pk_complex = spatial_pk_complex;
    }
    // </editor-fold>
    
    /** 
     * Return de spatial admin referentie van dit thema.
     *
     * @return String met de spatial admin referentie van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getSpatial_admin_ref()">
    public String getSpatial_admin_ref() {
        return spatial_admin_ref;
    }
    // </editor-fold>
    
    /** 
     * Set de spatial admin referentie van dit thema.
     *
     * @param spatial_admin_ref String met de spatial admin referentie van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setSpatial_admin_ref(String spatial_admin_ref)">
    public void setSpatial_admin_ref(String spatial_admin_ref) {
        this.spatial_admin_ref = spatial_admin_ref;
    }
    // </editor-fold>
    
    /** 
     * Return de wms url van dit thema.
     *
     * @return String met de wms url van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getWms_url()">
    public String getWms_url() {
        return wms_url;
    }
    // </editor-fold>
    
    /** 
     * Set de wms url van dit thema.
     *
     * @param wms_url String met de wms url van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setWms_url(String wms_url)">
    public void setWms_url(String wms_url) {
        this.wms_url = wms_url;
    }
    // </editor-fold>
    
    /** 
     * Return de wms layers van dit thema.
     *
     * @return String met de wms layers van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getWms_layers()">
    public String getWms_layers() {
        return wms_layers;
    }
    // </editor-fold>
    
    /** 
     * Set de wms layers van dit thema.
     *
     * @param wms_layers String met de wms layers van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setWms_layers(String wms_layers)">
    public void setWms_layers(String wms_layers) {
        this.wms_layers = wms_layers;
    }
    // </editor-fold>
    
    /** 
     * Return de wms query layers van dit thema.
     *
     * @return String met de wms query layers van dit thema.
     */
    // <editor-fold defaultstate="" desc="public String getWms_querylayers()">
    public String getWms_querylayers() {
        return wms_querylayers;
    }
    // </editor-fold>
    
    /** 
     * Set de wms query layers van dit thema.
     *
     * @param wms_querylayers String met de wms query layers van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setWms_querylayers(String wms_querylayers)">
    public void setWms_querylayers(String wms_querylayers) {
        this.wms_querylayers = wms_querylayers;
    }
    // </editor-fold>
    
    /** 
     * Return de thema data van dit thema.
     *
     * @return Set met de thema data van dit thema.
     *
     * @see ThemaData
     */
    // <editor-fold defaultstate="" desc="public Set getThemaData()">
    public Set getThemaData() {
        return themaData;
    }
    // </editor-fold>
    
    /** 
     * Set de thema data van dit thema.
     *
     * @param themaData Set met de thema data van dit thema.
     *
     * @see ThemaData
     */
    // <editor-fold defaultstate="" desc="public void setThemaData(Set themaData)">
    public void setThemaData(Set themaData) {
        this.themaData = themaData;
    }
    // </editor-fold>
    
    /** 
     * Return de thema verantwoordelijkheden van dit thema.
     *
     * @return Set met de thema verantwoordelijkheden van dit thema.
     *
     * @see ThemaVerantwoordelijkheden
     */
    // <editor-fold defaultstate="" desc="public Set getThemaVerantwoordelijkheden()">
    public Set getThemaVerantwoordelijkheden() {
        return themaVerantwoordelijkheden;
    }
    // </editor-fold>
    
    /** 
     * Set de thema verantwoordelijkheden van dit thema.
     *
     * @param themaVerantwoordelijkheden Set met de thema verantwoordelijkheden van dit thema.
     *
     * @see ThemaVerantwoordelijkheden
     */
    // <editor-fold defaultstate="" desc="public void setThemaVerantwoordelijkheden(Set themaVerantwoordelijkheden)">
    public void setThemaVerantwoordelijkheden(Set themaVerantwoordelijkheden) {
        this.themaVerantwoordelijkheden = themaVerantwoordelijkheden;
    }
    // </editor-fold>
    
    /** 
     * Return de thema applicaties van dit thema.
     *
     * @return Set met de thema applicaties van dit thema.
     *
     * @see ThemaApplicaties
     */
    // <editor-fold defaultstate="" desc="public Set getThemaApplicaties()">
    public Set getThemaApplicaties() {
        return themaApplicaties;
    }
    // </editor-fold>
    
    /** 
     * Set de thema applicaties van dit thema.
     *
     * @param themaApplicaties Set met de thema applicaties van dit thema.
     *
     * @see ThemaApplicaties
     */
    // <editor-fold defaultstate="" desc="public void setThemaApplicaties(Set themaApplicaties)">
    public void setThemaApplicaties(Set themaApplicaties) {
        this.themaApplicaties = themaApplicaties;
    }
    // </editor-fold>
    
    /** 
     * Return de update frequentie in dagen van dit thema.
     *
     * @return Integer met de update frequentie in dagen van dit thema.
     */
    // <editor-fold defaultstate="" desc="public Integer getUpdate_frequentie_in_dagen()">
    public Integer getUpdate_frequentie_in_dagen() {
        return update_frequentie_in_dagen;
    }
    // </editor-fold>
    
    /** 
     * Set de update frequentie in dagen van dit thema.
     *
     * @param update_frequentie_in_dagen Integer met de update frequentie in dagen van dit thema.
     */
    // <editor-fold defaultstate="" desc="public void setUpdate_frequentie_in_dagen(Integer update_frequentie_in_dagen)">
    public void setUpdate_frequentie_in_dagen(Integer update_frequentie_in_dagen) {
        this.update_frequentie_in_dagen = update_frequentie_in_dagen;
    }
    // </editor-fold>
}
