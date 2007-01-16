/*
 * Leveranciers.java
 *
 * Created on 16 januari 2007, 15:03
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
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

    public String getPakket() {
        return pakket;
    }

    public void setPakket(String pakket) {
        this.pakket = pakket;
    }

    public String getTelefoon1() {
        return telefoon1;
    }

    public void setTelefoon1(String telefoon1) {
        this.telefoon1 = telefoon1;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getTelefoon2() {
        return telefoon2;
    }

    public void setTelefoon2(String telefoon2) {
        this.telefoon2 = telefoon2;
    }

    public String getTelefoon3() {
        return telefoon3;
    }

    public void setTelefoon3(String telefoon3) {
        this.telefoon3 = telefoon3;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isInfo() {
        return info;
    }

    public void setInfo(boolean info) {
        this.info = info;
    }

    public String getOpmerkingen() {
        return opmerkingen;
    }

    public void setOpmerkingen(String opmerkingen) {
        this.opmerkingen = opmerkingen;
    }
    
}
