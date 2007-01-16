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
    
}
