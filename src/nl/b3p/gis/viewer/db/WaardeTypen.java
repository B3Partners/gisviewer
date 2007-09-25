/**
 * @(#)WaardeTypen.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een WaardeTypen opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer.db;

public class WaardeTypen {
    
    private int id;
    private String naam;
    
    /** Creates a new instance of WaardeTypen */
    public WaardeTypen() {
    }

    /** 
     * Return het ID van het waarde type.
     *
     * @return int ID van het waarde type.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van het waarde type.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return de naam van het waarde type.
     *
     * @return String met de naam van het waarde type.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van het waarde type.
     *
     * @param naam String met de naam van het waarde type.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
}
