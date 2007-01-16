/*
 * Applicaties.java
 *
 * Created on 16 januari 2007, 15:02
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class Applicaties {
    
    private int id;
    private String pakket;
    private String module;
    private String beschrijving;
    private boolean extern;
    private boolean acceptabel;
    private boolean administratief;
    private boolean spatial;
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

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPakket() {
        return pakket;
    }

    public void setPakket(String pakket) {
        this.pakket = pakket;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getBeschrijving() {
        return beschrijving;
    }

    public void setBeschrijving(String beschrijving) {
        this.beschrijving = beschrijving;
    }

    public boolean isExtern() {
        return extern;
    }

    public void setExtern(boolean extern) {
        this.extern = extern;
    }

    public boolean isAcceptabel() {
        return acceptabel;
    }

    public void setAcceptabel(boolean acceptabel) {
        this.acceptabel = acceptabel;
    }

    public boolean isAdministratief() {
        return administratief;
    }

    public void setAdministratief(boolean administratief) {
        this.administratief = administratief;
    }

    public boolean isSpatial() {
        return spatial;
    }

    public void setSpatial(boolean spatial) {
        this.spatial = spatial;
    }

    public String getTaal() {
        return taal;
    }

    public void setTaal(String taal) {
        this.taal = taal;
    }

    public String getSpatialKoppeling() {
        return spatialKoppeling;
    }

    public void setSpatialKoppeling(String spatialKoppeling) {
        this.spatialKoppeling = spatialKoppeling;
    }

    public String getDbKoppeling() {
        return dbKoppeling;
    }

    public void setDbKoppeling(String dbKoppeling) {
        this.dbKoppeling = dbKoppeling;
    }

    public boolean isWebbased() {
        return webbased;
    }

    public void setWebbased(boolean webbased) {
        this.webbased = webbased;
    }

    public boolean isGps() {
        return gps;
    }

    public void setGps(boolean gps) {
        this.gps = gps;
    }

    public boolean isCrow() {
        return crow;
    }

    public void setCrow(boolean crow) {
        this.crow = crow;
    }

    public String getOpmerking() {
        return opmerking;
    }

    public void setOpmerking(String opmerking) {
        this.opmerking = opmerking;
    }

    public Leveranciers getLeverancier() {
        return leverancier;
    }

    public void setLeverancier(Leveranciers leverancier) {
        this.leverancier = leverancier;
    }

}
