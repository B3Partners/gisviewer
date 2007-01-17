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
    /*Als een LayerItem de waarde 'true' mee krijgt wordt hij uitgeklapt getoond bij het laden van het scherm.
     *Bij false dicht. Als het een layer is wordt hij aangevinkt/uitgevinkt getoond.
     */
    private boolean checked=false;
    private boolean clickAction=false;
    private boolean cluster=false;
    private ArrayList childs=null;
    private ArrayList adminData=null;
    private ArrayList labelData=null;
    
    /** Creates a new instance of LayerItem */
    public LayerItem(){}
    public LayerItem(String n,boolean c) {
        name=n;
        cluster=c;
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
    
    public boolean isClickAction() {
        return clickAction;
    }
    
    public void setClickAction(boolean clickAction) {
        this.clickAction = clickAction;
    }
    
    public boolean isCluster() {
        return cluster;
    }
    
    public void setCluster(boolean cluster) {
        this.cluster = cluster;
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
    public void addAdmindata(String[] s){
        if (adminData==null){
            adminData=new ArrayList();
        }
        for (int i=0; i < s.length; i++){
            adminData.add(s[i]);
        }
    }

    public ArrayList getAdminData() {
        return adminData;
    }

    public void setAdminData(ArrayList adminData) {
        this.adminData = adminData;
    }

    public ArrayList getLabelData() {
        return labelData;
    }

    public void setLabelData(ArrayList labelData) {
        this.labelData = labelData;
    }
    public void addLabelData(String s[]){
        if (labelData==null){
            labelData=new ArrayList();
        }
        for (int i=0; i < s.length; i++){
            labelData.add(s[i]);
        }
    }
    
    
}
