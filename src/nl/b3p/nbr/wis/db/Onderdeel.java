/**
 * @(#)Onderdeel.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een Onderdeel opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.db;

public class Onderdeel {
    
    private int id;
    private String naam;
    private String omschrijving;
    private String locatie;
    private boolean regio;
    
    /** Creates a new instance of Onderdeel */
    public Onderdeel() {
    }

    /** 
     * Return het ID van het onderdeel.
     *
     * @return int ID van het onderdeel.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van het onderdeel.
     *
     * @param id int met het id van het onderdeel.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return de naam van het onderdeel.
     *
     * @return String met de naam van het onderdeel.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van het onderdeel.
     *
     * @param naam String met de naam van het onderdeel.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
    
    /** 
     * Return de omschrijving van het onderdeel.
     *
     * @return String met de omschrijving van het onderdeel.
     */
    // <editor-fold defaultstate="" desc="public String getOmschrijving()">
    public String getOmschrijving() {
        return omschrijving;
    }
    // </editor-fold>
    
    /** 
     * Set de omschrijving van het onderdeel.
     *
     * @param omschrijving String met de omschrijving van het onderdeel.
     */
    // <editor-fold defaultstate="" desc="public void setOmschrijving(String omschrijving)">
    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }
    // </editor-fold>
    
    /** 
     * Return de locatie van het onderdeel.
     *
     * @return String met de locatie van het onderdeel.
     */
    // <editor-fold defaultstate="" desc="public String getLocatie()">
    public String getLocatie() {
        return locatie;
    }
    // </editor-fold>
    
    /** 
     * Set de locatie van het onderdeel.
     *
     * @param locatie String met de locatie van het onderdeel.
     */
    // <editor-fold defaultstate="" desc="public void setLocatie(String locatie)">
    public void setLocatie(String locatie) {
        this.locatie = locatie;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit onderdeel voor de regio is.
     *
     * @return boolean true als dit onderdeel voor de regio is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isRegio()">
    public boolean isRegio() {
        return regio;
    }
    // </editor-fold>
    
    /** 
     * Set dit onderdeel op regio. Als dit onderdeel voor de regio is zet deze dan true, anders false.
     *
     * @param regio boolean met true als deze regio is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setRegio(boolean regio)">
    public void setRegio(boolean regio) {
        this.regio = regio;
    }
    // </editor-fold>
}
