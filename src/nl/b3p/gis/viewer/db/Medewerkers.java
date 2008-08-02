/*
 * B3P Gisviewer is an extension to Flamingo MapComponents making
 * it a complete webbased GIS viewer and configuration tool that
 * works in cooperation with B3P Kaartenbalie.
 *
 * Copyright 2006, 2007, 2008 B3Partners BV
 * 
 * This file is part of B3P Gisviewer.
 * 
 * B3P Gisviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * B3P Gisviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
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
