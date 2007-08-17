/**
 * @(#)ThemaFuncties.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een ThemaFuncties opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.db;

public class ThemaFuncties {
    
    private int id;
    private String naam;
    private String omschrijving;
    private Themas thema;
    private Applicaties applicatie;
    private String protocol;
    
    /** Creates a new instance of ThemaFuncties */
    public ThemaFuncties() {
    }

    /** 
     * Return het ID van de thema functie.
     *
     * @return int ID van de thema functie.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van de thema functie.
     *
     * @param id int id van de thema functie.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return de naam van de thema functie.
     *
     * @return String met de naam.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van de thema functie.
     *
     * @param naam String met de naam van de thema functie.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
    
    /** 
     * Return de omschrijving van de thema functie.
     *
     * @return String met de omschrijving van de thema functie.
     */
    // <editor-fold defaultstate="" desc="public String getOmschrijving()">
    public String getOmschrijving() {
        return omschrijving;
    }
    // </editor-fold>
    
    /** 
     * Set de omschrijving van de thema functie.
     *
     * @param omschrijving String met de omschrijving van de thema functie.
     */
    // <editor-fold defaultstate="" desc="public void setOmschrijving(String omschrijving)">
    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }
    // </editor-fold>
    
    /** 
     * Return het protocol van de thema functie.
     *
     * @return String met het protocol van de thema functie.
     */
    // <editor-fold defaultstate="" desc="public String getOmschrijving()">
    public String getProtocol() {
        return protocol;
    }
    // </editor-fold>
    
    /** 
     * Set het protocol van de thema functie.
     *
     * @param protocol String met het protocol van de thema functie.
     */
    // <editor-fold defaultstate="" desc="public void setOmschrijving(String omschrijving)">
    public void setProtocol(String protocol) {
        this.protocol = protocol;
    }
    // </editor-fold>
    
    /** 
     * Return het thema van de thema functie.
     *
     * @return Themas met het thema van de thema functie.
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="public Themas getThema()">
    public Themas getThema() {
        return thema;
    }
    // </editor-fold>
    
    /** 
     * Set het thema van de thema functie.
     *
     * @param thema Themas met het thema van de thema functie.
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="public void setThema(Themas thema)">
    public void setThema(Themas thema) {
        this.thema = thema;
    }
    // </editor-fold>
    
    /** 
     * Return de applicatie van de thema functie.
     *
     * @return Applicaties met de applicatie van de thema functie.
     *
     * @see Applicaties
     */
    // <editor-fold defaultstate="" desc="public String getOmschrijving()">
    public Applicaties getApplicatie() {
        return applicatie;
    }
    // </editor-fold>
    
    /** 
     * Set de applicatie van de thema functie.
     *
     * @param applicatie Applicaties met de applicatie van de thema functie.
     *
     * @see Applicaties
     */
    // <editor-fold defaultstate="" desc="public void setOmschrijving(String omschrijving)">
    public void setApplicatie(Applicaties applicatie) {
        this.applicatie = applicatie;
    }
    // </editor-fold>
}
