/*
 * RegelAttributen.java
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
public class RegelAttributen {
    
    private int id;
    private ThemaItemsAdmin tia;
    private DataRegels regel;
    private String waarde;
    
    /** Creates a new instance of RegelAttributen */
    public RegelAttributen() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getWaarde() {
        return waarde;
    }

    public void setWaarde(String waarde) {
        this.waarde = waarde;
    }

    public ThemaItemsAdmin getTia() {
        return tia;
    }

    public void setTia(ThemaItemsAdmin tia) {
        this.tia = tia;
    }

    public DataRegels getRegel() {
        return regel;
    }

    public void setRegel(DataRegels regel) {
        this.regel = regel;
    }
    
}
