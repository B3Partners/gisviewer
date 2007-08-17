/**
 * @(#)MapCoordsBean.java
 * @author Roy Braam
 * @version 1.00 2007/06/22
 *
 * Purpose: een bean klasse die de verschillende properties van een MapCoordsBean opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis;

public class MapCoordsBean {
    
    private String naam;
    private String minx;
    private String miny;
    private String maxx;
    private String maxy;
    
    /** Creates a new instance of MapCoordsBean */
    public MapCoordsBean() {
    }

    /** 
     * Return de naam van de map coordinaten bean.
     *
     * @return String met de naam van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public String getNaam()">
    public String getNaam() {
        return naam;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van de map coordinaten bean.
     *
     * @param naam String met de naam van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public void setNaam(String naam)">
    public void setNaam(String naam) {
        this.naam = naam;
    }
    // </editor-fold>
    
    /** 
     * Return de minimale x waarde van de map coordinaten bean.
     *
     * @return String met de minimale x waarde van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public String getMinx()">
    public String getMinx() {
        return minx;
    }
    // </editor-fold>
    
    /** 
     * Set de minimale x waarde van de map coordinaten bean.
     *
     * @param minx String met de minimale x waarde van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public void setMinx(String minx)>
    public void setMinx(String minx) {
        this.minx = minx;
    }
    // </editor-fold>
    
    /** 
     * Return de minimale y waarde van de map coordinaten bean.
     *
     * @return String met de minimale y waarde van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public String getMiny()">
    public String getMiny() {
        return miny;
    }
    // </editor-fold>
    
    /** 
     * Set de minimale y waarde van de map coordinaten bean.
     *
     * @param miny String met de minimale y waarde van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public void setMiny(String miny)">
    public void setMiny(String miny) {
        this.miny = miny;
    }
    // </editor-fold>
    
    /** 
     * Return de maximale x waarde van de map coordinaten bean.
     *
     * @return String met de maximale x waarde van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public String getMaxx()">
    public String getMaxx() {
        return maxx;
    }
    // </editor-fold>
    
    /** 
     * Set de maximale x waarde van de map coordinaten bean.
     *
     * @param maxx String met de maximale x waarde van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public void setMaxx(String maxx)">
    public void setMaxx(String maxx) {
        this.maxx = maxx;
    }
    // </editor-fold>
    
    /** 
     * Return de maximale y waarde van de map coordinaten bean.
     *
     * @return String met de maximale y waarde van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public String getMaxy()">
    public String getMaxy() {
        return maxy;
    }
    // </editor-fold>
    
    /** 
     * Set de maximale y waarde van de map coordinaten bean.
     *
     * @param maxy String met de maximale y waarde van de map coordinaten bean.
     */
    // <editor-fold defaultstate="" desc="public void setMaxy(String maxy)">
    public void setMaxy(String maxy) {
        this.maxy = maxy;
    }
    // </editor-fold>    
}
