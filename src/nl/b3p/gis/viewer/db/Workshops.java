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

public class Workshops {

    private int id;
    private int volgnr;
    private String naam;

    /** Creates a new instance of Workshops */
    public Workshops() {
    }

    /** 
     * Return het ID van de workshop.
     *
     * @return int ID van de workshop.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    /** 
     * Set het ID van de workshop.
     *
     * @param id int id van de workshop.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    /** 
     * Return het volgnummer van de workshop.
     *
     * @return int met het volgnummer van de workshop.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getVolgnr() {
        return volgnr;
    }
    // </editor-fold>
    /** 
     * Set het volgnummer van de workshop.
     *
     * @param volgnr int met het volgnummer van de workshop.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setVolgnr(int volgnr) {
        this.volgnr = volgnr;
    }
    // </editor-fold>
    /** 
     * Return de naam van de workshop.
     *
     * @return String met de naam van de workshop.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    /** 
     * Set de naam van de workshop.
     *
     * @param naam String met de naam van de workshop.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
}
