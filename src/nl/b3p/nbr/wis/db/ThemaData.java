/*
 * ThemaData.java
 *
 * Created on 16 januari 2007, 15:05
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

/**
 *
 * @author Chris
 */
public class ThemaData {
    
    private int id;
    private String label;
    private String eenheid;
    private String omschrijving;
    private Themas thema;
    private boolean basisregel;
    private String voorbeelden;
    private int kolombreedte;
    private Moscow moscow;
    private WaardeTypen waardeType;
    private DataTypen dataType;
    private String commando;
    private String kolomnaam;
    
    /**
     * Creates a new instance of ThemaData
     */
    public ThemaData() {
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

    public String getEenheid() {
        return eenheid;
    }

    public void setEenheid(String eenheid) {
        this.eenheid = eenheid;
    }

    public String getOmschrijving() {
        return omschrijving;
    }

    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }

    public boolean isBasisregel() {
        return basisregel;
    }

    public void setBasisregel(boolean basisregel) {
        this.basisregel = basisregel;
    }

    public String getVoorbeelden() {
        return voorbeelden;
    }

    public void setVoorbeelden(String voorbeelden) {
        this.voorbeelden = voorbeelden;
    }

    public int getKolombreedte() {
        return kolombreedte;
    }

    public void setKolombreedte(int kolombreedte) {
        this.kolombreedte = kolombreedte;
    }

    public Themas getThema() {
        return thema;
    }

    public void setThema(Themas thema) {
        this.thema = thema;
    }

    public Moscow getMoscow() {
        return moscow;
    }

    public void setMoscow(Moscow moscow) {
        this.moscow = moscow;
    }

    public WaardeTypen getWaardeType() {
        return waardeType;
    }

    public void setWaardeType(WaardeTypen waardeType) {
        this.waardeType = waardeType;
    }

    public String getKolomnaam() {
        return kolomnaam;
    }

    public void setKolomnaam(String kolomnaam) {
        this.kolomnaam = kolomnaam;
    }

    public DataTypen getDataType() {
        return dataType;
    }

    public void setDataType(DataTypen dataType) {
        this.dataType = dataType;
    }

    public String getCommando() {
        return commando;
    }

    public void setCommando(String commando) {
        this.commando = commando;
    }

}
