/**
 * @(#)FunctieItems.java
 * @author Chris van Lith
 * @version 1.00 2007/01/16
 *
 * Purpose: een bean klasse die de verschillende properties van een FunctieItems opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer.db;

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

    /** 
     * Return het ID van het functieitem.
     *
     * @return int ID van het functieitem.
     */
    // <editor-fold defaultstate="" desc="public int getId()">
    public int getId() {
        return id;
    }
    // </editor-fold>
    
    /** 
     * Set het ID van het functieitem.
     *
     * @param id int id
     */
    // <editor-fold defaultstate="" desc="public void setId(int id)">
    public void setId(int id) {
        this.id = id;
    }
    // </editor-fold>
    
    /** 
     * Return het label van het FunctieItem.
     *
     * @return String met het label.
     */
    // <editor-fold defaultstate="" desc="public String getLabel()">
    public String getLabel() {
        return label;
    }
    // </editor-fold>
    
    /** 
     * Set het label van het FunctieItem.
     *
     * @param label String met het label van het FunctieItem.
     */
    // <editor-fold defaultstate="" desc="public void setLabel(String label)">
    public void setLabel(String label) {
        this.label = label;
    }
    // </editor-fold>
    
    /** 
     * Return de omschrijving van het FunctieItem.
     *
     * @return String met de omschrijving van het FunctieItem.
     */
    // <editor-fold defaultstate="" desc="public String getOmschrijving()">
    public String getOmschrijving() {
        return omschrijving;
    }
    // </editor-fold>
    
    /** 
     * Set de omschrijving van het FunctieItem.
     *
     * @param omschrijving String met de omschrijving van het FunctieItem.
     */
    // <editor-fold defaultstate="" desc="public void setOmschrijving(String omschrijving)">
    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }
    // </editor-fold>
    
    /** 
     * Return de eenheid van het FunctieItem.
     *
     * @return String met de eenheid van het FunctieItem.
     */
    // <editor-fold defaultstate="" desc="public String getEenheid()">
    public String getEenheid() {
        return eenheid;
    }
    // </editor-fold>
    
    /** 
     * Set de eenheid van het FunctieItem.
     *
     * @param eenheid String met de eenheid van het FunctieItem.
     */
    // <editor-fold defaultstate="" desc="public void setEenheid(String eenheid)">
    public void setEenheid(String eenheid) {
        this.eenheid = eenheid;
    }
    // </editor-fold>
    
    /** 
     * Return voorbeelden die gelden voor dit FunctieItem.
     *
     * @return String met voorbeelden die gelden voor FunctieItem.
     */
    // <editor-fold defaultstate="" desc="public String getVoorbeelden()">
    public String getVoorbeelden() {
        return voorbeelden;
    }
    // </editor-fold>
    
    /** 
     * Set voorbeelden die gelden voor dit FunctieItem.
     *
     * @param voorbeelden String met voorbeelden die gelden voor FunctieItem.
     */
    // <editor-fold defaultstate="" desc="public void setVoorbeelden(String voorbeelden)">
    public void setVoorbeelden(String voorbeelden) {
        this.voorbeelden = voorbeelden;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit FuntieItem voor invoer is.
     *
     * @return boolean true als dit FuntieItem voor invoer is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isExtern()">
    public boolean isInvoer() {
        return invoer;
    }
    // </editor-fold>
    
    /** 
     * Set dit FunctieItem op invoer. Als dit FunctieItem voor invoer gebruikt wordt zet deze dan true, anders false.
     *
     * @param invoer boolean met true als deze invoer is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setInvoer(boolean invoer)">
    public void setInvoer(boolean invoer) {
        this.invoer = invoer;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit FuntieItem voor uitvoer is.
     *
     * @return boolean true als dit FuntieItem voor uitvoer is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isUitvoer()">
    public boolean isUitvoer() {
        return uitvoer;
    }
    // </editor-fold>
    
    /** 
     * Set dit FunctieItem op uitvoer. Als dit FunctieItem voor uitvoer gebruikt wordt zet deze dan true, anders false.
     *
     * @param uitvoer boolean met true als deze uitvoer is anders false.
     */
    // <editor-fold defaultstate="" desc="public void setUitvoer(boolean uitvoer)">
    public void setUitvoer(boolean uitvoer) {
        this.uitvoer = uitvoer;
    }
    // </editor-fold>
    
    /** 
     * Return de thema functies van dit FunctieItem.
     *
     * @return ThemaFuncties met de thema functies van het FunctieItem.
     *
     * @see ThemaFuncties
     */
    // <editor-fold defaultstate="" desc="public ThemaFuncties getFunctie()">
    public ThemaFuncties getFunctie() {
        return functie;
    }
    // </editor-fold>
    
    /** 
     * Set de thema functies van dit FunctieItem.
     *
     * @param functie ThemaFuncties met de thema functies van het FunctieItem.
     *
     * @see ThemaFuncties
     */
    // <editor-fold defaultstate="" desc="public void setFunctie(ThemaFuncties functie)">
    public void setFunctie(ThemaFuncties functie) {
        this.functie = functie;
    }
    // </editor-fold>
}
