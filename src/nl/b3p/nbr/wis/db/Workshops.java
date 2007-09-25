/**
 * @(#)Workshops.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een Workshops opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer.db;

public class Workshops {
        
    private int id;
    private int volgnr;
    private String naam;
    
    /** Creates a new instance of Workshops */
    public Workshops() {
    }

    /** 
     * Return het ID van de workshop.
     *
     * @return int ID van de workshop.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van de workshop.
     *
     * @param id int id van de workshop.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return het volgnummer van de workshop.
     *
     * @return int met het volgnummer van de workshop.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getVolgnr() {
        return volgnr;
    }
    // </editor-fold>
    
    /** 
     * Set het volgnummer van de workshop.
     *
     * @param volgnr int met het volgnummer van de workshop.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setVolgnr(int volgnr) {
        this.volgnr = volgnr;
    }
    // </editor-fold>

    /** 
     * Return de naam van de workshop.
     *
     * @return String met de naam van de workshop.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van de workshop.
     *
     * @param naam String met de naam van de workshop.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
}
