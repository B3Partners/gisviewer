/**
 * @(#)Moscow.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een Moscow opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.db;

public class Moscow {
    
    private int id;
    private String code;
    private String naam;
    private String omschrijving;
    
    /** Creates a new instance of Moscow */
    public Moscow() {
    }

    /** 
     * Return het ID van de moscow.
     *
     * @return int ID van de moscow.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van de moscow.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return de code van de moscow.
     *
     * @return String met de code van de moscow.
     */
    // <editor-fold defaultstate="" desc="public String getCode()">
    public String getCode() {
        return code;
    }
    // </editor-fold>
    
    /** 
     * Set de code van de moscow.
     *
     * @param code String met de code van de moscow.
     */
    // <editor-fold defaultstate="" desc="public void setCode(String code)">
    public void setCode(String code) {
        this.code = code;
    }
    // </editor-fold>
        
    /** 
     * Return de naam van de moscow.
     *
     * @return String met de moscow.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van de moscow.
     *
     * @param naam String met de naam van de moscow.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
    
    /** 
     * Return de omschrijving van de moscow.
     *
     * @return String met de omschrijving van de moscow.
     */
    // <editor-fold defaultstate="" desc="public String getOmschrijving()">
    public String getOmschrijving() {
        return omschrijving;
    }
    // </editor-fold>
    
    /** 
     * Set de omschrijving van de moscow.
     *
     * @param omschrijving String met de omschrijving van de moscow.
     */
    // <editor-fold defaultstate="" desc="public void setOmschrijving(String omschrijving)">
    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }
    // </editor-fold>
}
