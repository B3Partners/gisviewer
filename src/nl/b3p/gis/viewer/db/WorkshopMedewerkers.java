/**
 * @(#)WorkshopMedewerkers.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een WorkshopMedewerkers opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
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
