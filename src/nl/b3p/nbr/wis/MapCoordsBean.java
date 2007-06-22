/*
 * MapCoordsBean.java
 *
 * Created on 22 juni 2007, 9:49
 *
 * Autor: Roy
 */

package nl.b3p.nbr.wis;

/**
 *
 * @author Roy
 */
public class MapCoordsBean {
    
    private String naam;
    private String minx;
    private String miny;
    private String maxx;
    private String maxy;
    
    /** Creates a new instance of MapCoordsBean */
    public MapCoordsBean() {
    }

    public String getNaam() {
        return naam;
    }

    public void setNaam(String naam) {
        this.naam = naam;
    }

    public String getMinx() {
        return minx;
    }

    public void setMinx(String minx) {
        this.minx = minx;
    }

    public String getMiny() {
        return miny;
    }

    public void setMiny(String miny) {
        this.miny = miny;
    }

    public String getMaxx() {
        return maxx;
    }

    public void setMaxx(String maxx) {
        this.maxx = maxx;
    }

    public String getMaxy() {
        return maxy;
    }

    public void setMaxy(String maxy) {
        this.maxy = maxy;
    }
    
}
