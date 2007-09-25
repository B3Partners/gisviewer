/**
 * @(#)Medewerkers.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een Medewerkers opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer.db;

public class Medewerkers {
    
    private int id;
    private String Achternaam;
    private String Voornaam;
    private String telefoon;
    private String Functie;
    private String Locatie;
    private String email;
    
    /** Creates a new instance of Medewerkers */
    public Medewerkers() {
    }
    
    /** 
     * Return het ID van de medewerker.
     *
     * @return int ID van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van de medewerker.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
        
    /** 
     * Return de achternaam van de medewerker.
     *
     * @return String met de achternaam van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public String getAchternaam()">
    public String getAchternaam() {
        return Achternaam;
    }
    // </editor-fold>
    
    /** 
     * Set de achternaam van de medewerker.
     *
     * @param Achternaam String met de achternaam van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public void setAchternaam(String Achternaam)">
    public void setAchternaam(String Achternaam) {
        this.Achternaam = Achternaam;
    }
    // </editor-fold>
    
    /** 
     * Return de voornaam van de medewerker.
     *
     * @return String met de voornaam van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public String getVoornaam()">
    public String getVoornaam() {
        return Voornaam;
    }
    // </editor-fold>
    
    /** 
     * Set de voornaam van de medewerker.
     *
     * @param Voornaam String met de voornaam van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public void setVoornaam(String Voornaam)">
    public void setVoornaam(String Voornaam) {
        this.Voornaam = Voornaam;
    }
    // </editor-fold>
    
    /** 
     * Return het telefoonnummer van de medewerker.
     *
     * @return String met het telefoonnummer van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public String getTelefoon()">
    public String getTelefoon() {
        return telefoon;
    }
    // </editor-fold>
    
    /** 
     * Set het telefoonnummer van de medewerker.
     *
     * @param telefoon String met het telefoonnummer van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public void setTelefoon(String telefoon)">
    public void setTelefoon(String telefoon) {
        this.telefoon = telefoon;
    }
    // </editor-fold>
    
    /** 
     * Return de functie van de medewerker.
     *
     * @return String met de functie van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public String getFunctie()">
    public String getFunctie() {
        return Functie;
    }
    // </editor-fold>
    
    /** 
     * Set de functie van de medewerker.
     *
     * @param Functie String met de functie van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public void setFunctie(String Functie)">
    public void setFunctie(String Functie) {
        this.Functie = Functie;
    }
    // </editor-fold>
    
    /** 
     * Return de locatie van de medewerker.
     *
     * @return String met de locatie van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public String getLocatie()">
    public String getLocatie() {
        return Locatie;
    }
    // </editor-fold>
    
    /** 
     * Set de locatie van de medewerker.
     *
     * @param Locatie String met de locatie van de medewerker.
     */
    // <editor-fold defaultstate="" desc="public void setLocatie(String Locatie)">
    public void setLocatie(String Locatie) {
        this.Locatie = Locatie;
    }
    // </editor-fold>
    
    /** 
     * Return het email adres horende bij deze medewerker.
     *
     * @return String met het email adres horende bij deze medewerker.
     */
    // <editor-fold defaultstate="" desc="public String getEmail()">
    public String getEmail() {
        return email;
    }
    // </editor-fold>
    
    /** 
     * Set het email adres horende bij deze medewerker.
     *
     * @param email String met het email adres horende bij deze medewerker.
     */
    // <editor-fold defaultstate="" desc="public void setEmail(String email)">
    public void setEmail(String email) {
        this.email = email;
    }
    // </editor-fold>
}
