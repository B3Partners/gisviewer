/*
 * Onderdeel.java
 *
 * Created on 16 januari 2007, 15:03
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class Onderdeel {
    
    private int id;
    private String naam;
    private String omschrijving;
    private String locatie;
    private boolean regio;
    
    /** Creates a new instance of Onderdeel */
    public Onderdeel() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNaam() {
        return naam;
    }

    public void setNaam(String naam) {
        this.naam = naam;
    }

    public String getOmschrijving() {
        return omschrijving;
    }

    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }

    public String getLocatie() {
        return locatie;
    }

    public void setLocatie(String locatie) {
        this.locatie = locatie;
    }

    public boolean isRegio() {
        return regio;
    }

    public void setRegio(boolean regio) {
        this.regio = regio;
    }
    
}
