/*
 * WaardeTypen.java
 *
 * Created on 16 januari 2007, 15:17
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class WaardeTypen {
    private int id;
    private String naam;
    
    /** Creates a new instance of WaardeTypen */
    public WaardeTypen() {
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
    
}
