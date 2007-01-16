/*
 * ETLbatch.java
 *
 * Created on 16 januari 2007, 15:02
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
public class ETLbatch {
    
    private int id;
    private String omschrijving;
    private Date timestamp;
    
    /** Creates a new instance of ETLbatch */
    public ETLbatch() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOmschrijving() {
        return omschrijving;
    }

    public void setOmschrijving(String omschrijving) {
        this.omschrijving = omschrijving;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }
    
}
