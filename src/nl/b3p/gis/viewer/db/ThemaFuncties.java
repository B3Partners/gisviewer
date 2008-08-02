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
