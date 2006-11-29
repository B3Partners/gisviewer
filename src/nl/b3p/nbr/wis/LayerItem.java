/*
 * LayerItem.java
 *
 * Created on 29 november 2006, 9:53
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package nl.b3p.nbr.wis;

import java.util.ArrayList;

/**
 *
 * @author Roy
 */
public class LayerItem {
    
    private String name;
    private boolean checked=false;
    private ArrayList childs=null;
    
    /** Creates a new instance of LayerItem */
    public LayerItem(){}
    public LayerItem(String n,boolean c) {
        name=n;
        checked=c;
    }
    public LayerItem(String n){
        name=n;
    }
    

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public ArrayList getChilds() {
        return childs;
    }

    public void setChilds(ArrayList childs) {
        this.childs = childs;
    }
    public void addChild(LayerItem li){
        if (childs==null){
            childs=new ArrayList();
        }
        childs.add(li);
    }
    
    
}
