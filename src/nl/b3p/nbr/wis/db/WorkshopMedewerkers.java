/*
 * WorkshopMedewerkers.java
 *
 * Created on 16 januari 2007, 15:06
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class WorkshopMedewerkers {
    
    /** Creates a new instance of WorkshopMedewerkers */
    public WorkshopMedewerkers() {
    }
    
    private int id;
    private Workshops workshop;
    private Medewerkers medewerker;
    private boolean aanwezig;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public boolean isAanwezig() {
        return aanwezig;
    }

    public void setAanwezig(boolean aanwezig) {
        this.aanwezig = aanwezig;
    }

    public Workshops getWorkshop() {
        return workshop;
    }

    public void setWorkshop(Workshops workshop) {
        this.workshop = workshop;
    }

    public Medewerkers getMedewerker() {
        return medewerker;
    }

    public void setMedewerker(Medewerkers medewerker) {
        this.medewerker = medewerker;
    }
}
