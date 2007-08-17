/**
 * @(#)Leveranciers.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een Leveranciers opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.db;

public class Leveranciers {
    
    private int id;
    private String naam;
    private String pakket;
    private String telefoon1;
    private String contact;
    private String telefoon2;
    private String telefoon3;
    private String email;
    private boolean info;
    private String opmerkingen;
    
    /** Creates a new instance of Leveranciers */
    public Leveranciers() {
    }

    /** 
     * Return het ID van de leverancier.
     *
     * @return int ID van de leverancier.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van de leverancier.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return de naam van de leverancier.
     *
     * @return String met de naam.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van de leverancier.
     *
     * @param naam String met de naam van de leverancier.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
    
    /** 
     * Return het pakket.
     *
     * @return String pakket.
     */
    // <editor-fold defaultstate="" desc="public String getPakket()">
    public String getPakket() {
        return pakket;
    }
    // </editor-fold>
    
    /** 
     * Set het pakket.
     *
     * @param pakket String pakket.
     */
    // <editor-fold defaultstate="" desc="public void setPakket(String pakket)">
    public void setPakket(String pakket) {
        this.pakket = pakket;
    }
    // </editor-fold>
    
    
    /** 
     * Return het eerste telefoonnummer van de Leverancier.
     *
     * @return String met het eerste telefoonnummer van de Leverancier.
     */
    // <editor-fold defaultstate="" desc="public String getTelefoon1()">
    public String getTelefoon1() {
        return telefoon1;
    }
    // </editor-fold>
    
    /** 
     * Set het eerste telefoonnummer van de Leverancier.
     *
     * @param telefoon1 String met het eerste telefoonnummer van de Leverancier.
     */
    // <editor-fold defaultstate="" desc="public void setTelefoon1(String telefoon1)">
    public void setTelefoon1(String telefoon1) {
        this.telefoon1 = telefoon1;
    }
    
    /** 
     * Return het contact van de leverancier.
     *
     * @return String met het contact van de leverancier.
     */
    // <editor-fold defaultstate="" desc="public void setLabel(String label)">
    public String getContact() {
        return contact;
    }
    // </editor-fold>
    
    /** 
     * Set het contact van de leverancier.
     *
     * @param contact String met het contact van de leverancier.
     */
    // <editor-fold defaultstate="" desc="public void setContact(String contact)">
    public void setContact(String contact) {
        this.contact = contact;
    }
    // </editor-fold>
    
    /** 
     * Return het tweede telefoonnummer van de Leverancier.
     *
     * @return String met het tweede telefoonnummer van de Leverancier.
     */
    // <editor-fold defaultstate="" desc="public String getTelefoon2()">
    public String getTelefoon2() {
        return telefoon2;
    }
    // </editor-fold>
    
    /** 
     * Set het tweede telefoonnummer van de Leverancier.
     *
     * @param telefoon2 String met het tweede telefoonnummer van de Leverancier.
     */
    // <editor-fold defaultstate="" desc="public void setTelefoon2(String telefoon2)">
    public void setTelefoon2(String telefoon2) {
        this.telefoon2 = telefoon2;
    }
    // </editor-fold>
    
    /** 
     * Return het derde telefoonnummer van de Leverancier.
     *
     * @return String met het derde telefoonnummer van de Leverancier.
     */
    // <editor-fold defaultstate="" desc="public String getTelefoon3()">
    public String getTelefoon3() {
        return telefoon3;
    }
    // </editor-fold>
    
    /** 
     * Set het derde telefoonnummer van de Leverancier.
     *
     * @param telefoon3 String met het derde telefoonnummer van de Leverancier.
     */
    // <editor-fold defaultstate="" desc="public void setTelefoon3(String telefoon3)">
    public void setTelefoon3(String telefoon3) {
        this.telefoon3 = telefoon3;
    }
    // </editor-fold>
    
    /** 
     * Return het email adres horende bij deze leverancier.
     *
     * @return String met het email adres horende bij deze leverancier.
     */
    // <editor-fold defaultstate="" desc="public String getEmail()">
    public String getEmail() {
        return email;
    }
    // </editor-fold>
    
    /** 
     * Set het email adres horende bij deze leverancier.
     *
     * @param email String met het email adres horende bij deze leverancier.
     */
    // <editor-fold defaultstate="" desc="public void setEmail(String email)">
    public void setEmail(String email) {
        this.email = email;
    }
    // </editor-fold>
    
    
    /** 
     * Returns een boolean of deze leverancier informatief is.
     *
     * @return boolean true als deze leverancier ter informatie gebruikt wordt, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isInfo()">
    public boolean isInfo() {
        return info;
    }
    // </editor-fold>
    
    /** 
     * Set deze leverancier op informatief. Als deze leverancier ter informatie gebruikt wordt zet deze dan true, anders false.
     *
     * @param info boolean met true als deze info is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setInfo(boolean info)">
    public void setInfo(boolean info) {
        this.info = info;
    }
    // </editor-fold>
    
    /** 
     * Return opmerkingen horende bij deze leverancier.
     *
     * @return String met opmerkingen bij deze leverancier.
     */
    // <editor-fold defaultstate="" desc="public String getOpmerkingen()">
    public String getOpmerkingen() {
        return opmerkingen;
    }
    // </editor-fold>
    
    /** 
     * Set opmerkingen bij deze leverancier.
     *
     * @param opmerkingen String met opmerkingen bij deze leverancier.
     */
    // <editor-fold defaultstate="" desc="public void setOpmerkingen(String opmerkingen)">
    public void setOpmerkingen(String opmerkingen) {
        this.opmerkingen = opmerkingen;
    }
    // </editor-fold>    
}
