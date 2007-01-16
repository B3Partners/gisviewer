/*
 * Medewerkers.java
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

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getAchternaam() {
        return Achternaam;
    }

    public void setAchternaam(String Achternaam) {
        this.Achternaam = Achternaam;
    }

    public String getVoornaam() {
        return Voornaam;
    }

    public void setVoornaam(String Voornaam) {
        this.Voornaam = Voornaam;
    }

    public String getTelefoon() {
        return telefoon;
    }

    public void setTelefoon(String telefoon) {
        this.telefoon = telefoon;
    }

    public String getFunctie() {
        return Functie;
    }

    public void setFunctie(String Functie) {
        this.Functie = Functie;
    }

    public String getLocatie() {
        return Locatie;
    }

    public void setLocatie(String Locatie) {
        this.Locatie = Locatie;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    
}
