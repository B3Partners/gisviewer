/*
 * ThemaVerantwoordelijkheden.java
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
public class ThemaVerantwoordelijkheden {
    private int id;
    private Themas thema;
    private Medewerkers medewerker;
    private Onderdeel onderdeel;
    private Rollen rol;
    private boolean huidige_situatie;
    private boolean gewenste_situatie;
    private String opmerkingen;
    
    /** Creates a new instance of ThemaVerantwoordelijkheden */
    public ThemaVerantwoordelijkheden() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

     public boolean isHuidige_situatie() {
        return huidige_situatie;
    }

    public void setHuidige_situatie(boolean huidige_situatie) {
        this.huidige_situatie = huidige_situatie;
    }

    public boolean isGewenste_situatie() {
        return gewenste_situatie;
    }

    public void setGewenste_situatie(boolean gewenste_situatie) {
        this.gewenste_situatie = gewenste_situatie;
    }

    public Themas getThema() {
        return thema;
    }

    public void setThema(Themas thema) {
        this.thema = thema;
    }

    public Medewerkers getMedewerker() {
        return medewerker;
    }

    public void setMedewerker(Medewerkers medewerker) {
        this.medewerker = medewerker;
    }

    public Rollen getRol() {
        return rol;
    }

    public void setRol(Rollen rol) {
        this.rol = rol;
    }

    public Onderdeel getOnderdeel() {
        return onderdeel;
    }

    public void setOnderdeel(Onderdeel onderdeel) {
        this.onderdeel = onderdeel;
    }

    public String getOpmerkingen() {
        return opmerkingen;
    }

    public void setOpmerkingen(String opmerkingen) {
        this.opmerkingen = opmerkingen;
    }
    
}
