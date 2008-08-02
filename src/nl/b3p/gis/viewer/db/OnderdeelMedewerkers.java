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

public class OnderdeelMedewerkers {

    private int id;
    private Medewerkers medewerker;
    private Onderdeel onderdeel;
    private boolean vertegenwoordiger;

    /** Creates a new instance of OnderdeelMedewerkers */
    public OnderdeelMedewerkers() {
    }

    /** 
     * Return het ID van het onderdeelmedewerkers.
     *
     * @return int ID van het onderdeelmedewerkers.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    /** 
     * Set het ID van het onderdeelmedewerkers.
     *
     * @param id int met het id van het onderdeelmedewerkers.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    /** 
     * Returns een boolean als de medewerker een vertegenwoordiger is.
     *
     * @return boolean true als de medewerker een vertegenwoordiger is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isVertegenwoordiger()">
    public boolean isVertegenwoordiger() {
        return vertegenwoordiger;
    }
    // </editor-fold>
    /** 
     * Set de medewerker op vertegenwoordiger voor dit onderdeel. Als de medewerker een vertegenwoordiger is zet deze dan true, 
     * anders false.
     *
     * @param vertegenwoordiger boolean met true als de medewerker een vertegenwoordiger is, anders false.
     */
    // <editor-fold defaultstate="" desc="public void setVertegenwoordiger(boolean vertegenwoordiger)">
    public void setVertegenwoordiger(boolean vertegenwoordiger) {
        this.vertegenwoordiger = vertegenwoordiger;
    }
    // </editor-fold>
    /** 
     * Return de medewerker horende bij dit onderdeel.
     *
     * @return Medewerkers de medewerker horende bij dit onderdeel.
     *
     * @see Medewerkers
     */
    // <editor-fold defaultstate="" desc="public Medewerkers getMedewerker()">
    public Medewerkers getMedewerker() {
        return medewerker;
    }
    // </editor-fold>
    /** 
     * Set de medewerker horende bij dit onderdeel.
     *
     * @param medewerker Medewerkers de medewerker horende bij dit onderdeel.
     *
     * @see Medewerkers
     */
    // <editor-fold defaultstate="" desc="public void setMedewerker(Medewerkers medewerker)">
    public void setMedewerker(Medewerkers medewerker) {
        this.medewerker = medewerker;
    }
    // </editor-fold>
    /** 
     * Return het onderdeel horende bij de medewerker.
     *
     * @return Onderdeel het onderdeel horende bij de medewerker.
     *
     * @see Onderdeel
     */
    // <editor-fold defaultstate="" desc="public Onderdeel getOnderdeel()">
    public Onderdeel getOnderdeel() {
        return onderdeel;
    }
    // </editor-fold>
    /** 
     * Set het onderdeel horende bij de medewerker.
     *
     * @param onderdeel Onderdeel het onderdeel horende bij de medewerker.
     *
     * @see Onderdeel
     */
    // <editor-fold defaultstate="" desc="public void setOnderdeel(Onderdeel onderdeel)">
    public void setOnderdeel(Onderdeel onderdeel) {
        this.onderdeel = onderdeel;
    }
    // </editor-fold>
}
