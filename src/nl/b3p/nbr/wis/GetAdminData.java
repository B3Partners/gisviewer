/*
 * GetAdminData.java
 *
 * Created on 30 november 2006, 16:36
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis;

import java.util.ArrayList;
import java.util.Iterator;

/**
 *
 * @author Geert
 */
public class GetAdminData {
    
    ArrayList values = new ArrayList();
    
    public GetAdminData() {
        String[] tmp = new String[2];
        String[] tmp1 = new String[2];
        String[] tmp2 = new String[2];
        String[] tmp3 = new String[2];
        
        tmp[0] = "a1";
        tmp[1] = "<b>Inhoud van AdminData #1</b><br /><br />TestData...";
        values.add(tmp);
        
        tmp1[0] = "a2";
        tmp1[1] = "<b>Inhoud van AdminData #2</b><br /><br />TestData...";
        values.add(tmp1);
        
        tmp2[0] = "a3";
        tmp2[1] = "<b>Inhoud van AdminData #3</b><br /><br />TestData...";
        values.add(tmp2);
        
        tmp3[0] = "a4";
        tmp3[1] = "<b>Inhoud van AdminData #4</b><br /><br />TestData...";
        values.add(tmp3);
    }
    
    public String getData(String id) {
        for(Iterator i = values.iterator(); i.hasNext();) {
            String[] tmp = (String[]) i.next();
            if(tmp[0].equals(id)) return tmp[1];
        }
        return "Not Found...";
    }
    
}
