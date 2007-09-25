/**
 * @(#)Applicaties.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een Applicaties opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer.db;

public class Applicaties {
    
    private int id;
    private String pakket;
    private String module;
    private String beschrijving;
    private boolean extern;
    private boolean acceptabel;
    private boolean administratief;
    private boolean geodata;
    private String taal;
    private String spatialKoppeling;
    private String dbKoppeling;
    private boolean webbased;
    private boolean gps;
    private boolean crow;
    private String opmerking;
    private Leveranciers leverancier;
    
    
    /** Creates a new instance of Applicaties */
    public Applicaties() {
    }
    
    /** 
     * Return het ID van de Applicatie.
     *
     * @return int ID van de applicatie
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van de Applicaties.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return het pakket.
     *
     * @return String pakket.
     */
    // <editor-fold defaultstate="" desc="public String getPakket()">
    public String getPakket() {
        return pakket;
    }
    // </editor-fold>
    
    /** 
     * Set het pakket.
     *
     * @param pakket String pakket.
     */
    // <editor-fold defaultstate="" desc="public void setPakket(String pakket)">
    public void setPakket(String pakket) {
        this.pakket = pakket;
    }
    // </editor-fold>
    
    /** 
     * Return de module van de Applicatie.
     *
     * @return String met de module.
     */
    // <editor-fold defaultstate="" desc="public String getModule()">
    public String getModule() {
        return module;
    }
    // </editor-fold>
    
    /** 
     * Set de module van de Applicatie.
     *
     * @param module String met de module van de Applicatie.
     */
    // <editor-fold defaultstate="" desc="public void setModule(String module)">
    public void setModule(String module) {
        this.module = module;
    }
    // </editor-fold>
    
    /** 
     * Return de beschrijving van deze applicatie.
     *
     * @return String met de beschrijving van de Applicatie.
     */
    // <editor-fold defaultstate="" desc="public String getBeschrijving()">
    public String getBeschrijving() {
        return beschrijving;
    }
    // </editor-fold>
    
    /** 
     * Set de beschrijving van de Applicatie.
     *
     * @param beschrijving String met beschrijving van de Applicatie.
     */
    // <editor-fold defaultstate="" desc="public void setBeschrijving(String beschrijving)">
    public void setBeschrijving(String beschrijving) {
        this.beschrijving = beschrijving;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of deze Applicatie extern is of niet.
     *
     * @return boolean true als de Applicatie extern is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isExtern()">
    public boolean isExtern() {
        return extern;
    }
    // </editor-fold>
    
    /** 
     * Set deze Applicatie extern. Als de Applicatie extern is zet deze dan true, anders false.
     *
     * @param extern boolean met true als deze extern is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setExtern(boolean extern)">
    public void setExtern(boolean extern) {
        this.extern = extern;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of deze Applicatie acceptabel is of niet.
     *
     * @return boolean met true als deze acceptabel is anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isAcceptabel()">
    public boolean isAcceptabel() {
        return acceptabel;
    }
    // </editor-fold>
    
    /** 
     * Set deze Applicatie acceptabel. Als de Applicatie acceptabel is zet deze dan true, anders false.
     *
     * @param acceptabel boolean met true als deze acceptabel is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setAcceptabel(boolean acceptabel)">
    public void setAcceptabel(boolean acceptabel) {
        this.acceptabel = acceptabel;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of deze Applicatie administratief is of niet.
     *
     * @return boolean met true als deze administratief is anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isAdministratief()">
    public boolean isAdministratief() {
        return administratief;
    }
    // </editor-fold>
    
    /** 
     * Set deze Applicatie administratief. Als de Applicatie administratief is zet deze dan true, anders false.
     *
     * @param administratief boolean met true als deze administratief is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setAdministratief(boolean administratief)">
    public void setAdministratief(boolean administratief) {
        this.administratief = administratief;
    }
    // </editor-fold>
    
    /** 
     * Return de taal van deze Applicatie.
     *
     * @return String met de taal van de Applicatie.
     */
    // <editor-fold defaultstate="" desc="public String getTaal()">
    public String getTaal() {
        return taal;
    }
    // </editor-fold>
    
    /** 
     * Set de taal van deze Applicatie.
     *
     * @param taal String met de taal van deze Applicatie.
     */
    // <editor-fold defaultstate="" desc="public void setTaal(String taal)">
    public void setTaal(String taal) {
        this.taal = taal;
    }
    // </editor-fold>
    
    /** 
     * Return de Spatial koppeling van deze Applicatie.
     *
     * @return String met de spatial koppeling.
     */
    // <editor-fold defaultstate="" desc="public String getSpatialKoppeling()">
    public String getSpatialKoppeling() {
        return spatialKoppeling;
    }
    // </editor-fold>
    
    /** 
     * Set de spatial koppeling van deze Applicatie.
     *
     * @param spatialKoppeling String met de spatial koppeling van de Applicatie.
     */
    // <editor-fold defaultstate="" desc="public void setSpatialKoppeling(String spatialKoppeling)">
    public void setSpatialKoppeling(String spatialKoppeling) {
        this.spatialKoppeling = spatialKoppeling;
    }
    // </editor-fold>
    
    /** 
     * Return de database koppeling van deze applicatie.
     *
     * @return String met de database koppeling.
     */
    // <editor-fold defaultstate="" desc="public String getDbKoppeling()">
    public String getDbKoppeling() {
        return dbKoppeling;
    }
    // </editor-fold>
    
    /** 
     * Set de database koppeling van deze Applicatie.
     *
     * @param dbKoppeling String met de database koppeling.
     */
    // <editor-fold defaultstate="" desc="public void setDbKoppeling(String dbKoppeling)">
    public void setDbKoppeling(String dbKoppeling) {
        this.dbKoppeling = dbKoppeling;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of deze Applicatie webbased is of niet.
     *
     * @return boolean met true als deze webbased is anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isWebbased()">
    public boolean isWebbased() {
        return webbased;
    }
    // </editor-fold>
    
    /** 
     * Set deze Applicatie webbased. Als de Applicatie webbased is zet deze dan true, anders false.
     *
     * @param webbased boolean met true als deze webbased is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setWebbased(boolean webbased)">
    public void setWebbased(boolean webbased) {
        this.webbased = webbased;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of deze Applicatie gps is of niet.
     *
     * @return boolean met true als deze gps is anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isGps()">
    public boolean isGps() {
        return gps;
    }
    // </editor-fold>
    
    /** 
     * Set deze Applicatie gps. Als de Applicatie gps is zet deze dan true, anders false.
     *
     * @param gps boolean met true als deze gps is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setGps(boolean gps)">
    public void setGps(boolean gps) {
        this.gps = gps;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of deze Applicatie crow is of niet.
     *
     * @return boolean met true als deze crow is anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isCrow()">
    public boolean isCrow() {
        return crow;
    }
    // </editor-fold>
    
    /** 
     * Set deze Applicatie crow. Als de Applicatie crow is zet deze dan true, anders false.
     *
     * @param crow boolean met true als deze crow is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setCrow(boolean crow)">
    public void setCrow(boolean crow) {
        this.crow = crow;
    }
    // </editor-fold>
    
    /** 
     * Return opmerkingen behorende bij deze Applicatie.
     *
     * @return String met opmerkingen.
     */
    // <editor-fold defaultstate="" desc="public String getOpmerking()">
    public String getOpmerking() {
        return opmerking;
    }
    // </editor-fold>
    
    /** 
     * Set opmerkingen horende bij deze Applicatie.
     *
     * @param opmerking String met opmerkingen horende bij de Applicatie.
     */
    // <editor-fold defaultstate="" desc="public void setOpmerking(String opmerking)">
    public void setOpmerking(String opmerking) {
        this.opmerking = opmerking;
    }
    // </editor-fold>
    
    /** 
     * Return de leverancier horende bij de Applicatie.
     *
     * @return Leveranciers object met informatie over de leverancier.
     *
     * @see Leveranciers
     */
    // <editor-fold defaultstate="" desc="public Leveranciers getLeverancier()">
    public Leveranciers getLeverancier() {
        return leverancier;
    }
    // </editor-fold>
    
    /** 
     * Set de leverancier van deze Applicatie.
     *
     * @param leverancier Leveranciers object met informatie over de leverancier.
     *
     * @see Leveranciers
     */
    // <editor-fold defaultstate="" desc="public void setLeverancier(Leveranciers leverancier)">
    public void setLeverancier(Leveranciers leverancier) {
        this.leverancier = leverancier;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of deze Applicatie geodata is of niet.
     *
     * @return boolean met true als deze geodata is anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isGeodata()">
    public boolean isGeodata() {
        return geodata;
    }
    // </editor-fold>
    
    /** 
     * Set deze Applicatie geodata. Als de Applicatie geodata is zet deze dan true, anders false.
     *
     * @param geodata boolean met true als deze geodata is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setGeodata(boolean geodata)">
    public void setGeodata(boolean geodata) {
        this.geodata = geodata;
    }
    // </editor-fold>
}
