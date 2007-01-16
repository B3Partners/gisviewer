/*
 * Clusters.java
 *
 * Created on 16 januari 2007, 15:02
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

import java.util.Set;

/**
 *
 * @author Chris
 */
public class Clusters {
    
    private int id;
    private String naam;
    private String omschrijving;
    private Clusters parent;
    private Set children;
    private Set themas;
    
    /** Creates a new instance of Clusters */
    public Clusters() {
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
    
    public Set getChildren() {
        return children;
    }
    
    public void setChildren(Set children) {
        this.children = children;
    }
    
    public Set getThemas() {
        return themas;
    }
    
    public void setThemas(Set themas) {
        this.themas = themas;
    }
    
}
