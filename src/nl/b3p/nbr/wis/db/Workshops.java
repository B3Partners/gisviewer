/*
 * Workshops.java
 *
 * Created on 16 januari 2007, 15:06
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class Workshops {
    
    /** Creates a new instance of Workshops */
    public Workshops() {
    }
    
    private int id;
    private int volgnr;
    private String naam;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getVolgnr() {
        return volgnr;
    }

    public void setVolgnr(int volgnr) {
        this.volgnr = volgnr;
    }

    public String getNaam() {
        return naam;
    }

    public void setNaam(String naam) {
        this.naam = naam;
    }
}
