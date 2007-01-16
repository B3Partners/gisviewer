/*
 * OnderdeelMedewerkers.java
 *
 * Created on 16 januari 2007, 15:04
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class OnderdeelMedewerkers {
    
    private int id;
    private Medewerkers medewerker;
    private Onderdeel onderdeel;
    private boolean vertegenwoordiger;
    
    /** Creates a new instance of OnderdeelMedewerkers */
    public OnderdeelMedewerkers() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public boolean isVertegenwoordiger() {
        return vertegenwoordiger;
    }

    public void setVertegenwoordiger(boolean vertegenwoordiger) {
        this.vertegenwoordiger = vertegenwoordiger;
    }

    public Medewerkers getMedewerker() {
        return medewerker;
    }

    public void setMedewerker(Medewerkers medewerker) {
        this.medewerker = medewerker;
    }

    public Onderdeel getOnderdeel() {
        return onderdeel;
    }

    public void setOnderdeel(Onderdeel onderdeel) {
        this.onderdeel = onderdeel;
    }
    
}
