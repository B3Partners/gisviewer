/*
 * ThemaFuncties.java
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
public class ThemaFuncties {
    
    private int id;
    private String naam;
    private String omschrijving;
    private Themas thema;
    private Applicaties applicatie;
    private String protocol;
    
    /** Creates a new instance of ThemaFuncties */
    public ThemaFuncties() {
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

    public String getProtocol() {
        return protocol;
    }

    public void setProtocol(String protocol) {
        this.protocol = protocol;
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
    
}
