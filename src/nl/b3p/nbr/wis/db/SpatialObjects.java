/*
 * SpatialObjects.java
 *
 * Created on 16 januari 2007, 15:04
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis.db;

import java.util.Date;

/**
 *
 * @author Chris
 */
public class SpatialObjects {
    
    private int id;
    private ThemaItemsSpatial tis;
    private DataRegels regel;
    private String geometry;
    private Date timestamp;
    
    /** Creates a new instance of SpatialObjects */
    public SpatialObjects() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getGeometry() {
        return geometry;
    }

    public void setGeometry(String geometry) {
        this.geometry = geometry;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public ThemaItemsSpatial getTis() {
        return tis;
    }

    public void setTis(ThemaItemsSpatial tis) {
        this.tis = tis;
    }

    public DataRegels getRegel() {
        return regel;
    }

    public void setRegel(DataRegels regel) {
        this.regel = regel;
    }
    
}
