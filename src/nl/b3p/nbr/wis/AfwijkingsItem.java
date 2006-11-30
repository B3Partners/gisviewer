/*
 * AfwijkingsItem.java
 *
 * Created on 30 november 2006, 13:51
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis;

/**
 *
 * @author Geert
 */
public class AfwijkingsItem {
    
    private String naam;
    private String id;
    private String afwijking;
    
    /** Creates a new instance of AfwijkingsItem */
    public AfwijkingsItem(String naam, String id, String afwijking) {
        this.naam = naam;
        this.id = id;
        this.afwijking = afwijking;
    }

    public String getNaam() {
        return naam;
    }

    public String getId() {
        return id;
    }

    public String getAfwijking() {
        return afwijking;
    }
    
}
