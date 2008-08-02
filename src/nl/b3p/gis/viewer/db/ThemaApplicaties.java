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

public class ThemaApplicaties {

    private int id;
    private Themas thema;
    private Applicaties applicatie;
    private boolean ingebruik;
    private boolean geodata;
    private boolean administratief;
    private boolean voorkeur;
    private boolean definitief;
    private boolean standaard;

    /** Creates a new instance of ThemaApplicaties */
    public ThemaApplicaties() {
    }

    /** 
     * Return het ID van de thema applicatie.
     *
     * @return int ID van de thema applicatie.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    /** 
     * Set het ID van de thema applicatie.
     *
     * @param id int id van de thema applicatie.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    /** 
     * Returns een boolean als deze thema applicatie in gebruik is.
     *
     * @return boolean true als deze thema applicatie in gebruik is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isIngebruik()">
    public boolean isIngebruik() {
        return ingebruik;
    }
    // </editor-fold>
    /** 
     * Set deze thema applicatie in gebruik. Als deze thema applicatie in gebruik is zet deze dan true, 
     * anders false.
     *
     * @param ingebruik boolean met true als deze thema applicatie in gebruik is, anders false.
     */
    // <editor-fold defaultstate="" desc="public void setIngebruik(boolean ingebruik)">
    public void setIngebruik(boolean ingebruik) {
        this.ingebruik = ingebruik;
    }
    // </editor-fold>
    /** 
     * Returns een boolean als deze thema applicatie administratief is.
     *
     * @return boolean true als deze thema applicatie administratief is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isAdministratief()">
    public boolean isAdministratief() {
        return administratief;
    }
    // </editor-fold>
    /** 
     * Set deze thema applicatie administratief. Als deze thema applicatie administratief is zet deze dan true, 
     * anders false.
     *
     * @param administratief boolean met true als deze thema applicatie administratief is, anders false.
     */
    // <editor-fold defaultstate="" desc="public void setAdministratief(boolean administratief)">
    public void setAdministratief(boolean administratief) {
        this.administratief = administratief;
    }
    // </editor-fold>
    /** 
     * Returns een boolean als deze thema applicatie de voorkeur heeft.
     *
     * @return boolean true als deze thema applicatie de voorkeur heeft, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isVoorkeur()">
    public boolean isVoorkeur() {
        return voorkeur;
    }
    // </editor-fold>
    /** 
     * Set de voorkeur voor deze thema applicatie. Als deze thema applicatie de voorkeur heeft zet deze dan true, 
     * anders false.
     *
     * @param voorkeur boolean met true als deze thema applicatie de voorkeur heeft, anders false.
     */
    // <editor-fold defaultstate="" desc="public void setVoorkeur(boolean voorkeur)">
    public void setVoorkeur(boolean voorkeur) {
        this.voorkeur = voorkeur;
    }
    // </editor-fold>
    /** 
     * Returns een boolean als deze thema applicatie definitief is.
     *
     * @return boolean true als deze thema applicatie definitief is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isDefinitief()">
    public boolean isDefinitief() {
        return definitief;
    }
    // </editor-fold>
    /** 
     * Set deze thema applicatie definitief. Als deze thema applicatie definitief is zet deze dan true, 
     * anders false.
     *
     * @param definitief boolean met true als deze thema applicatie definitief is, anders false.
     */
    // <editor-fold defaultstate="" desc="public void setDefinitief(boolean definitief)">
    public void setDefinitief(boolean definitief) {
        this.definitief = definitief;
    }
    // </editor-fold>
    /** 
     * Returns een boolean als deze thema applicatie standaard is.
     *
     * @return boolean true als deze thema applicatie standaard is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isStandaard()">
    public boolean isStandaard() {
        return standaard;
    }
    // </editor-fold>
    /** 
     * Set deze thema applicatie standaard. Als deze thema applicatie standaard is zet deze dan true, 
     * anders false.
     *
     * @param standaard boolean met true als deze thema applicatie standaard is, anders false.
     */
    // <editor-fold defaultstate="" desc="public void setStandaard(boolean standaard)">
    public void setStandaard(boolean standaard) {
        this.standaard = standaard;
    }
    // </editor-fold>
    /** 
     * Return het thema van de Applicatie.
     *
     * @return Themas met het thema bij deze Applicatie.
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="public String getModule()">
    public Themas getThema() {
        return thema;
    }
    // </editor-fold>
    /** 
     * Set het thema van de Applicatie.
     *
     * @param thema Themas met het thema bij deze Applicatie.
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="public void setPakket(String pakket)">
    public void setThema(Themas thema) {
        this.thema = thema;
    }
    // </editor-fold>
    /** 
     * Return de applicatie gekoppeld aan het thema.
     *
     * @return Applicaties met de applicatie gekoppeld aan het thema.
     *
     * @see Applicaties
     */
    // <editor-fold defaultstate="" desc="public String getModule()">
    public Applicaties getApplicatie() {
        return applicatie;
    }
    // </editor-fold>
    /** 
     * Set de applicatie gekoppeld aan het thema.
     *
     * @param applicatie Applicaties met de applicatie gekoppeld aan het thema.
     *
     * @see Applicaties
     */
    // <editor-fold defaultstate="" desc="public void setPakket(String pakket)">
    public void setApplicatie(Applicaties applicatie) {
        this.applicatie = applicatie;
    }
    // </editor-fold>
    /** 
     * Returns een boolean als deze thema applicatie geodata heeft.
     *
     * @return boolean true als deze thema applicatie geodata heeft, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isGeodata()">
    public boolean isGeodata() {
        return geodata;
    }
    // </editor-fold>
    /** 
     * Set deze thema applicatie geodata. Als deze thema applicatie geodata heeft zet deze dan true, 
     * anders false.
     *
     * @param geodata boolean met true als deze thema applicatie geodata heeft, anders false.
     */
    // <editor-fold defaultstate="" desc="public void setGeodata(boolean geodata)">
    public void setGeodata(boolean geodata) {
        this.geodata = geodata;
    }
    // </editor-fold>    
}
