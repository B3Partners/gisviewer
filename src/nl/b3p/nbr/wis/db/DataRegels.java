/*
 * DataRegels.java
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
public class DataRegels {
    
    private int id;
    private Themas thema;
    private ETLbatch etlbatch;
    private Date timestamp;
    
    /** Creates a new instance of DataRegels */
    public DataRegels() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public Themas getThema() {
        return thema;
    }

    public void setThema(Themas thema) {
        this.thema = thema;
    }

    public ETLbatch getEtlbatch() {
        return etlbatch;
    }

    public void setEtlbatch(ETLbatch etlbatch) {
        this.etlbatch = etlbatch;
    }
    
}
