/*
 * Themas.java
 *
 * Created on 16 januari 2007, 15:05
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class Themas {
    
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
     
    /** Creates a new instance of Themas */
    public Themas() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNaam() {
        return naam;
    }

    public void setNaam(String naam) {
        this.naam = naam;
    }

    public int getBelangnr() {
        return belangnr;
    }

    public void setBelangnr(int belangnr) {
        this.belangnr = belangnr;
    }

    public String getOpmerkingen() {
        return opmerkingen;
    }

    public void setOpmerkingen(String opmerkingen) {
        this.opmerkingen = opmerkingen;
    }

    public boolean isAnalyse_thema() {
        return analyse_thema;
    }

    public void setAnalyse_thema(boolean analyse_thema) {
        this.analyse_thema = analyse_thema;
    }

    public boolean isLocatie_thema() {
        return locatie_thema;
    }

    public void setLocatie_thema(boolean locatie_thema) {
        this.locatie_thema = locatie_thema;
    }

    public Moscow getMoscow() {
        return moscow;
    }

    public void setMoscow(Moscow moscow) {
        this.moscow = moscow;
    }

    public Clusters getCluster() {
        return cluster;
    }

    public void setCluster(Clusters cluster) {
        this.cluster = cluster;
    }

    public String getAdmin_tabel_opmerkingen() {
        return admin_tabel_opmerkingen;
    }

    public void setAdmin_tabel_opmerkingen(String admin_tabel_opmerkingen) {
        this.admin_tabel_opmerkingen = admin_tabel_opmerkingen;
    }

    public String getAdmin_tabel() {
        return admin_tabel;
    }

    public void setAdmin_tabel(String admin_tabel) {
        this.admin_tabel = admin_tabel;
    }

    public String getAdmin_pk() {
        return admin_pk;
    }

    public void setAdmin_pk(String admin_pk) {
        this.admin_pk = admin_pk;
    }

    public boolean isAdmin_pk_complex() {
        return admin_pk_complex;
    }

    public void setAdmin_pk_complex(boolean admin_pk_complex) {
        this.admin_pk_complex = admin_pk_complex;
    }

    public String getAdmin_spatial_ref() {
        return admin_spatial_ref;
    }

    public void setAdmin_spatial_ref(String admin_spatial_ref) {
        this.admin_spatial_ref = admin_spatial_ref;
    }

    public String getAdmin_query() {
        return admin_query;
    }

    public void setAdmin_query(String admin_query) {
        this.admin_query = admin_query;
    }

    public String getSpatial_tabel_opmerkingen() {
        return spatial_tabel_opmerkingen;
    }

    public void setSpatial_tabel_opmerkingen(String spatial_tabel_opmerkingen) {
        this.spatial_tabel_opmerkingen = spatial_tabel_opmerkingen;
    }

    public String getSpatial_tabel() {
        return spatial_tabel;
    }

    public void setSpatial_tabel(String spatial_tabel) {
        this.spatial_tabel = spatial_tabel;
    }

    public String getSpatial_pk() {
        return spatial_pk;
    }

    public void setSpatial_pk(String spatial_pk) {
        this.spatial_pk = spatial_pk;
    }

    public boolean isSpatial_pk_complex() {
        return spatial_pk_complex;
    }

    public void setSpatial_pk_complex(boolean spatial_pk_complex) {
        this.spatial_pk_complex = spatial_pk_complex;
    }

    public String getSpatial_admin_ref() {
        return spatial_admin_ref;
    }

    public void setSpatial_admin_ref(String spatial_admin_ref) {
        this.spatial_admin_ref = spatial_admin_ref;
    }
    
}
