/*
 * ObjectTypen.java
 *
 * Created on 16 januari 2007, 15:14
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class ObjectTypen {
    
    private int id;
    private String naam;
    
    /** Creates a new instance of ObjectTypen */
    public ObjectTypen() {
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
