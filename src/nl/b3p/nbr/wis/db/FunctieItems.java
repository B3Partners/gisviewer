/*
 * FunctieItems.java
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
public class FunctieItems {
    
    private int id;
    private String label;
    private String omschrijving;
    private String eenheid;
    private String voorbeelden;
    private boolean invoer;
    private boolean uitvoer;
    private ThemaFuncties functie;
    
    /** Creates a new instance of FunctieItems */
    public FunctieItems() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getOmschrijving() {
        return omschrijving;
    }

    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }

    public String getEenheid() {
        return eenheid;
    }

    public void setEenheid(String eenheid) {
        this.eenheid = eenheid;
    }

    public String getVoorbeelden() {
        return voorbeelden;
    }

    public void setVoorbeelden(String voorbeelden) {
        this.voorbeelden = voorbeelden;
    }

    public boolean isInvoer() {
        return invoer;
    }

    public void setInvoer(boolean invoer) {
        this.invoer = invoer;
    }

    public boolean isUitvoer() {
        return uitvoer;
    }

    public void setUitvoer(boolean uitvoer) {
        this.uitvoer = uitvoer;
    }

    public ThemaFuncties getFunctie() {
        return functie;
    }

    public void setFunctie(ThemaFuncties functie) {
        this.functie = functie;
    }

}
