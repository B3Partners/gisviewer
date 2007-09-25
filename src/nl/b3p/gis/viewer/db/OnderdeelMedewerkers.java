/**
 * @(#)OnderdeelMedewerkers.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een OnderdeelMedewerkers opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
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
