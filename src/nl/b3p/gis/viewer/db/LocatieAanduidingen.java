/**
 * @(#)LocatieAanduidingen.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: a class handling the different actions which come from classes extending this class.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer.db;

public class LocatieAanduidingen {
    
    private int id;
    private String naam;
    private String omschrijving;
    
    /** Creates a new instance of LocatieAanduidingen */
    public LocatieAanduidingen() {
    }

    /** 
     * Return het ID van de locatieaanduiding.
     *
     * @return int ID van de locatieaanduiding.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van de locatieaanduiding.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return de naam van de locatieaanduiding.
     *
     * @return String met de naam.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van de locatieaanduiding.
     *
     * @param naam String met de naam van het locatieaanduiding.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
    
    /** 
     * Return de omschrijving van de locatieaanduiding.
     *
     * @return String met de omschrijving van de locatieaanduiding.
     */
    // <editor-fold defaultstate="" desc="public String getOmschrijving()">
    public String getOmschrijving() {
        return omschrijving;
    }
    // </editor-fold>
    
    /** 
     * Set de omschrijving van de locatieaanduiding.
     *
     * @param omschrijving String met de omschrijving van de locatieaanduiding.
     */
    // <editor-fold defaultstate="" desc="public void setOmschrijving(String omschrijving)">
    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }
    // </editor-fold>
}
