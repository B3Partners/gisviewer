/**
 * @(#)ThemaVerantwoordelijkheden.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een ThemaVerantwoordelijkheden opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.db;

public class ThemaVerantwoordelijkheden {
    private int id;
    private Themas thema;
    private Medewerkers medewerker;
    private Onderdeel onderdeel;
    private Rollen rol;
    private boolean huidige_situatie;
    private boolean gewenste_situatie;
    private String opmerkingen;
    
    /** Creates a new instance of ThemaVerantwoordelijkheden */
    public ThemaVerantwoordelijkheden() {
    }

    /** 
     * Return het ID van de thema verantwoordelijkheden.
     *
     * @return int ID van de thema verantwoordelijkheden.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van de thema verantwoordelijkheden.
     *
     * @param id int id van de thema verantwoordelijkheden.
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit de huidige situatie van de thema verantwoordelijkheden is.
     *
     * @return boolean true als dit de huidige situatie van de thema verantwoordelijkheden is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isExtern()">
    public boolean isHuidige_situatie() {
        return huidige_situatie;
    }
    // </editor-fold>
    
    /** 
     * Set de huidige situatie van de thema verantwoordelijkheden. Als dit de huidige situatie van de thema verantwoordelijkheden 
     * is zet deze dan true, anders false.
     *
     * @param huidige_situatie boolean met true als dit de huidige situatie van de thema verantwoordelijkheden is.
     */
    // <editor-fold defaultstate="" desc="public void setInvoer(boolean invoer)">
    public void setHuidige_situatie(boolean huidige_situatie) {
        this.huidige_situatie = huidige_situatie;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit de gewenste situatie van de thema verantwoordelijkheden is.
     *
     * @return boolean true als dit de gewenste situatie van de thema verantwoordelijkheden is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isExtern()">
    public boolean isGewenste_situatie() {
        return gewenste_situatie;
    }
    // </editor-fold>
    
    /** 
     * Set de gewenste situatie van de thema verantwoordelijkheden. Als dit de gewenste situatie van de thema verantwoordelijkheden 
     * is zet deze dan true, anders false.
     *
     * @param gewenste_situatie boolean met true als dit de gewenste situatie van de thema verantwoordelijkheden is.
     */
    // <editor-fold defaultstate="" desc="public void setInvoer(boolean invoer)">
    public void setGewenste_situatie(boolean gewenste_situatie) {
        this.gewenste_situatie = gewenste_situatie;
    }
    // </editor-fold>

    /** 
     * Return het thema van de thema verantwoordelijkheden.
     *
     * @return Themas met het thema van de thema verantwoordelijkheden.
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="public Themas getThema()">
    public Themas getThema() {
        return thema;
    }
    // </editor-fold>
    
    /** 
     * Set het thema van de thema verantwoordelijkheden.
     *
     * @param thema Themas met het thema van de thema verantwoordelijkheden.
     *
     * @see Themas
     */
    // <editor-fold defaultstate="" desc="public void setThema(Themas thema)">
    public void setThema(Themas thema) {
        this.thema = thema;
    }
    // </editor-fold>

    /** 
     * Return de medewerker horende bij de thema verantwoordelijkheden.
     *
     * @return Medewerkers de medewerker horende bij de thema verantwoordelijkheden.
     *
     * @see Medewerkers
     */
    // <editor-fold defaultstate="" desc="public Medewerkers getMedewerker()">
    public Medewerkers getMedewerker() {
        return medewerker;
    }
    // </editor-fold>
    
    /** 
     * Set de medewerker horende bij de thema verantwoordelijkheden.
     *
     * @param medewerker Medewerkers de medewerker horende bij de thema verantwoordelijkheden.
     *
     * @see Medewerkers
     */
    // <editor-fold defaultstate="" desc="public void setMedewerker(Medewerkers medewerker)">
    public void setMedewerker(Medewerkers medewerker) {
        this.medewerker = medewerker;
    }
    // </editor-fold>
    
    /** 
     * Return de rol horende bij de thema verantwoordelijkheden.
     *
     * @return Rollen de rol horende bij de thema verantwoordelijkheden.
     *
     * @see Rollen
     */
    // <editor-fold defaultstate="" desc="public Rollen getRol()">
    public Rollen getRol() {
        return rol;
    }
    // </editor-fold>
    
    /** 
     * Set de rol horende bij de thema verantwoordelijkheden.
     *
     * @param rol Medewerkers de rol horende bij de thema verantwoordelijkheden.
     *
     * @see Rollen
     */
    // <editor-fold defaultstate="" desc="public void setRol(Rollen rol)">
    public void setRol(Rollen rol) {
        this.rol = rol;
    }
    // </editor-fold>

    /** 
     * Return het onderdeel horende bij de thema verantwoordelijkheden.
     *
     * @return Onderdeel het onderdeel horende bij de thema verantwoordelijkheden.
     *
     * @see Onderdeel
     */
    // <editor-fold defaultstate="" desc="public Onderdeel getOnderdeel()">
    public Onderdeel getOnderdeel() {
        return onderdeel;
    }
    // </editor-fold>
    
    /** 
     * Set het onderdeel horende bij de thema verantwoordelijkheden.
     *
     * @param onderdeel Onderdeel het onderdeel horende bij de thema verantwoordelijkheden.
     *
     * @see Onderdeel
     */
    // <editor-fold defaultstate="" desc="public void setOnderdeel(Onderdeel onderdeel)">
    public void setOnderdeel(Onderdeel onderdeel) {
        this.onderdeel = onderdeel;
    }
    // </editor-fold>

    /** 
     * Return opmerkingen horende bij de thema verantwoordelijkheden.
     *
     * @return String met opmerkingen bij de thema verantwoordelijkheden.
     */
    // <editor-fold defaultstate="" desc="public String getOpmerkingen()">
    public String getOpmerkingen() {
        return opmerkingen;
    }
    // </editor-fold>
    
    /** 
     * Set opmerkingen bij de thema verantwoordelijkheden.
     *
     * @param opmerkingen String met opmerkingen bij de thema verantwoordelijkheden.
     */
    // <editor-fold defaultstate="" desc="public void setOpmerkingen(String opmerkingen)">
    public void setOpmerkingen(String opmerkingen) {
        this.opmerkingen = opmerkingen;
    }
    // </editor-fold>  
}
