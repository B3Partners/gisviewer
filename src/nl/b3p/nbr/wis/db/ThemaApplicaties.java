/*
 * ThemaApplicaties.java
 *
 * Created on 16 januari 2007, 15:04
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class ThemaApplicaties {
    
    private int id;
    private Themas thema;
    private Applicaties applicatie;
    private boolean ingebruik;
    private boolean geodata;
    private boolean administratief;
    private boolean voorkeur;
    private boolean definitief;
    private boolean standaard;
    
    /** Creates a new instance of ThemaApplicaties */
    public ThemaApplicaties() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public boolean isIngebruik() {
        return ingebruik;
    }

    public void setIngebruik(boolean ingebruik) {
        this.ingebruik = ingebruik;
    }

    public boolean isAdministratief() {
        return administratief;
    }

    public void setAdministratief(boolean administratief) {
        this.administratief = administratief;
    }

    public boolean isVoorkeur() {
        return voorkeur;
    }

    public void setVoorkeur(boolean voorkeur) {
        this.voorkeur = voorkeur;
    }

    public boolean isDefinitief() {
        return definitief;
    }

    public void setDefinitief(boolean definitief) {
        this.definitief = definitief;
    }

    public boolean isStandaard() {
        return standaard;
    }

    public void setStandaard(boolean standaard) {
        this.standaard = standaard;
    }

    public Themas getThema() {
        return thema;
    }

    public void setThema(Themas thema) {
        this.thema = thema;
    }

    public Applicaties getApplicatie() {
        return applicatie;
    }

    public void setApplicatie(Applicaties applicatie) {
        this.applicatie = applicatie;
    }

    public boolean isGeodata() {
        return geodata;
    }

    public void setGeodata(boolean geodata) {
        this.geodata = geodata;
    }
    
}
