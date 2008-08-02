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

public class WorkshopMedewerkers {

    private int id;
    private Workshops workshop;
    private Medewerkers medewerker;
    private boolean aanwezig;

    /** Creates a new instance of WorkshopMedewerkers */
    public WorkshopMedewerkers() {
    }

    /** 
     * Return het ID van het waarde type.
     *
     * @return int ID van het waarde type.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    /** 
     * Set het ID van het waarde type.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    /** 
     * Return de naam van het waarde type.
     *
     * @return Workshops met de workshop horende bij de medewerker.
     *
     * @see Workshops
     */
    // <editor-fold defaultstate="" desc="public Workshops getWorkshop()">    
    public Workshops getWorkshop() {
        return workshop;
    }
    // </editor-fold>
    /** 
     * Set de workshop horende bij de medewerker.
     *
     * @param workshop Workshops met de workshop horende bij de medewerker.
     *
     * @see Workshops
     */
    // <editor-fold defaultstate="" desc="public void setWorkshop(Workshops workshop)">
    public void setWorkshop(Workshops workshop) {
        this.workshop = workshop;
    }
    // </editor-fold>
    /** 
     * Return de medewerker horende bij deze workshop.
     *
     * @return Medewerkers de medewerker horende bij deze workshop.
     *
     * @see Medewerkers
     */
    // <editor-fold defaultstate="" desc="public Medewerkers getMedewerker()">
    public Medewerkers getMedewerker() {
        return medewerker;
    }
    // </editor-fold>
    /** 
     * Set de medewerker horende bij deze workshop.
     *
     * @param medewerker Medewerkers horende bij deze workshop.
     *
     * @see Medewerkers
     */
    // <editor-fold defaultstate="" desc="public void setMedewerker(Medewerkers medewerker)">
    public void setMedewerker(Medewerkers medewerker) {
        this.medewerker = medewerker;
    }
    // </editor-fold>
    /** 
     * Returns een boolean als de medewerker aanwezig is bij de workshop.
     *
     * @return boolean true als de medewerker aanwezig is bij de workshop, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isAanwezig()">
    public boolean isAanwezig() {
        return aanwezig;
    }
    // </editor-fold>
    /** 
     * Set de medewerker op aanwezig voor deze workshop. Als de medewerker aanwezig is bij de workshop zet deze dan true, 
     * anders false.
     *
     * @param aanwezig boolean met true als de medewerker aanwezig is bij de workshop, anders false.
     */
    // <editor-fold defaultstate="" desc="public void setAanwezig(boolean aanwezig)">
    public void setAanwezig(boolean aanwezig) {
        this.aanwezig = aanwezig;
    }
    // </editor-fold>
}
