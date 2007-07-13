/*
 * @(#)Batchverwerking.java
 * @author N. de Goeij
 * @version 1.00, 12 juli 2007
 *
 * @copyright 2007 B3Partners. All rights reserved.
 * B3Partners PROPRIETARY/CONFIDENTIAL. Use is subject to license terms.
 *
 */

package nl.b3p.nbr.wis;

/**
 * Batchverwerking definition:
 *
 */

public class Batchverwerking {
    private int id;
    private String name;
    
    /** Creates a new instance of Batchverwerking */
    public Batchverwerking() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    
}
