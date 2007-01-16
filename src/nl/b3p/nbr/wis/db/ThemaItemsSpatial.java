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
    private byte lrood;
    private byte lgroen;
    private byte lblauw;
    private byte vrood;
    private byte vgroen;
    private byte vblauw;
    
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

    public byte getLrood() {
        return lrood;
    }

    public void setLrood(byte lrood) {
        this.lrood = lrood;
    }

    public byte getLgroen() {
        return lgroen;
    }

    public void setLgroen(byte lgroen) {
        this.lgroen = lgroen;
    }

    public byte getLblauw() {
        return lblauw;
    }

    public void setLblauw(byte lblauw) {
        this.lblauw = lblauw;
    }

    public byte getVrood() {
        return vrood;
    }

    public void setVrood(byte vrood) {
        this.vrood = vrood;
    }

    public byte getVgroen() {
        return vgroen;
    }

    public void setVgroen(byte vgroen) {
        this.vgroen = vgroen;
    }

    public byte getVblauw() {
        return vblauw;
    }

    public void setVblauw(byte vblauw) {
        this.vblauw = vblauw;
    }

    public Themas getThema() {
        return thema;
    }

    public void setThema(Themas thema) {
        this.thema = thema;
    }
    
}
