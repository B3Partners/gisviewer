/*
 * ThemaItemsSpatial.java
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
public class ThemaItemsSpatial {
    
    private int id;
    private String kenmerk;
    private String omschrijving;
    private Themas thema;
    private int type;
    private Byte lrood;
    private Byte lgroen;
    private Byte lblauw;
    private Byte vrood;
    private Byte vgroen;
    private Byte vblauw;
    
    /** Creates a new instance of ThemaItemsSpatial */
    public ThemaItemsSpatial() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getKenmerk() {
        return kenmerk;
    }

    public void setKenmerk(String kenmerk) {
        this.kenmerk = kenmerk;
    }

    public String getOmschrijving() {
        return omschrijving;
    }

    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }

     public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public Byte getLrood() {
        return lrood;
    }

    public void setLrood(Byte lrood) {
        this.lrood = lrood;
    }

    public Byte getLgroen() {
        return lgroen;
    }

    public void setLgroen(Byte lgroen) {
        this.lgroen = lgroen;
    }

    public Byte getLblauw() {
        return lblauw;
    }

    public void setLblauw(Byte lblauw) {
        this.lblauw = lblauw;
    }

    public Byte getVrood() {
        return vrood;
    }

    public void setVrood(Byte vrood) {
        this.vrood = vrood;
    }

    public Byte getVgroen() {
        return vgroen;
    }

    public void setVgroen(Byte vgroen) {
        this.vgroen = vgroen;
    }

    public Byte getVblauw() {
        return vblauw;
    }

    public void setVblauw(Byte vblauw) {
        this.vblauw = vblauw;
    }

    public Themas getThema() {
        return thema;
    }

    public void setThema(Themas thema) {
        this.thema = thema;
    }
    
}
