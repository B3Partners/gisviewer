/**
 * @(#)LayerItem.java
 * @author Roy Braam
 * @version 1.00 2007/11/29
 *
 * Purpose: een bean klasse die de verschillende properties van een LayerItem opslaat en weer kan tonen.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.gis.viewer;

import java.util.ArrayList;

public class LayerItem {
    
    private String name;
    private boolean checked     = false;
    private boolean clickAction = false;
    private boolean cluster     = false;
    private ArrayList childs    = null;
    private ArrayList adminData = null;
    private ArrayList labelData = null;
    
    /** 
     * Creates a new instance of LayerItem.
     */
    // <editor-fold defaultstate="" desc="public LayerItem()">
    public LayerItem(){}
    // </editor-fold>
    
    /** 
     * Creates a new instance of LayerItem.
     *
     * @param n String met de naam van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public LayerItem(String n)">
    public LayerItem(String n){
        name=n;
    }
    // </editor-fold>
    
    /** 
     * Creates a new instance of LayerItem.
     *
     * Wanneer een LayerItem als cluster boolean de waarde 'true' meekrijgt wordt deze in uitgeklapte
     * vorm getoond bij het laden van het scherm. Bij een 'false' waarde wordt ze ingeklapt weergegeven.
     *
     * Indien het LayerItem een layer is wordt deze bij de waarde 'true' aangevinkt weergegeven anders uitgevinkt.
     *
     * @param n String met de naam van dit layer item.
     * @param c boolean om aan te geven of dit layer item een cluster is.
     */
    // <editor-fold defaultstate="" desc="public LayerItem(String n, boolean c)">
    public LayerItem(String n, boolean c) {
        name = n;
        cluster = c;
    }
    // </editor-fold>
    
    /** 
     * Return de naam van dit layer item.
     *
     * @return String met de naam van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public String getName()">
    public String getName() {
        return name;
    }
    // </editor-fold>
    
    /** 
     * Set de naam van dit layer item.
     *
     * @param name String met de naam van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public void setName(String name)">
    public void setName(String name) {
        this.name = name;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit layer item gechecked is.
     *
     * @return boolean true als dit layer item gechecked is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isChecked()">
    public boolean isChecked() {
        return checked;
    }
    // </editor-fold>
    
    /** 
     * Set dit layer item als gechecked. Als dit layer item gechecked is zet deze dan true, anders false.
     *
     * @param checked boolean met true als dit layer item gechecked is.
     */
    // <editor-fold defaultstate="" desc="public void setChecked(boolean checked)">
    public void setChecked(boolean checked) {
        this.checked = checked;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit layer item een click action heeft.
     *
     * @return boolean true als dit layer item een click action heeft, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isClickAction()">   
    public boolean isClickAction() {
        return clickAction;
    }
    // </editor-fold>
    
    /** 
     * Set dit layer item met een click action. Als dit layer item een click action heeft zet deze dan true, anders false.
     *
     * @param clickAction boolean met true als dit layer item een click action heeft.
     */
    // <editor-fold defaultstate="" desc="public void setClickAction(boolean clickAction)">    
    public void setClickAction(boolean clickAction) {
        this.clickAction = clickAction;
    }
    // </editor-fold>
    
    /** 
     * Returns een boolean of dit layer item een cluster is.
     *
     * Wanneer een LayerItem als cluster boolean de waarde 'true' meekrijgt wordt deze in uitgeklapte
     * vorm getoond bij het laden van het scherm. Bij een 'false' waarde wordt ze ingeklapt weergegeven.
     *
     * Indien het LayerItem een layer is wordt deze bij de waarde 'true' aangevinkt weergegeven anders uitgevinkt.
     *
     * @return boolean true als dit layer item een cluster is, anders false.
     */
    // <editor-fold defaultstate="" desc="public boolean isCluster()">    
    public boolean isCluster() {
        return cluster;
    }
    // </editor-fold>
    
    /** 
     * Set dit layer item als gechecked. Als dit layer item een cluster is zet deze dan true, anders false.
     *
     * Wanneer een LayerItem als cluster boolean de waarde 'true' meekrijgt wordt deze in uitgeklapte
     * vorm getoond bij het laden van het scherm. Bij een 'false' waarde wordt ze ingeklapt weergegeven.
     *
     * Indien het LayerItem een layer is wordt deze bij de waarde 'true' aangevinkt weergegeven anders uitgevinkt.
     *
     * @param cluster boolean met true als dit layer item een cluster is.
     */
    // <editor-fold defaultstate="" desc="public void setCluster(boolean cluster)">  
    public void setCluster(boolean cluster) {
        this.cluster = cluster;
    }
    // </editor-fold>
    
    /** 
     * Return een lijst met kinderen van dit layer item.
     *
     * @return ArrayList met een lijst met kinderen van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public ArrayList getChilds()">
    public ArrayList getChilds() {
        return childs;
    }
    // </editor-fold>
    
    /** 
     * Set een lijst met kinderen van dit layer item.
     *
     * @param childs ArrayList met een lijst met kinderen van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public void setChilds(ArrayList childs)">
    public void setChilds(ArrayList childs) {
        this.childs = childs;
    }
    // </editor-fold>
    
    /** 
     * Voeg een nieuw item toe aan de lijst met childs binnen dit layer item.
     *
     * @param li LayerItem.
     */
    // <editor-fold defaultstate="" desc="public void addChild(LayerItem li)">        
    public void addChild(LayerItem li) {
        if (childs==null){
            childs=new ArrayList();
        }
        childs.add(li);
    }
    // </editor-fold>
    
    /** 
     * Return een lijst met admin data van dit layer item.
     *
     * @return ArrayList met een lijst met admin data van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public ArrayList getAdminData()">    
    public ArrayList getAdminData() {
        return adminData;
    }
    // </editor-fold>
    
    /** 
     * Set een lijst met admin data van dit layer item.
     *
     * @param adminData ArrayList met een lijst met admin data van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public void setAdminData(ArrayList adminData)">
    public void setAdminData(ArrayList adminData) {
        this.adminData = adminData;
    }
    // </editor-fold>
    
    /** 
     * Voeg nieuwe admin data aan dit layer item toe.
     *
     * @param s String[] met een lijst met admin data voor dit layer item.
     */
    // <editor-fold defaultstate="" desc="public void addAdmindata(String[] s)">
    public void addAdmindata(String[] s){
        if (adminData==null){
            adminData=new ArrayList();
        }
        for (int i=0; i < s.length; i++){
            adminData.add(s[i]);
        }
    }
    // </editor-fold>
    
    /** 
     * Return de label data van dit layer item.
     *
     * @return ArrayList met de label data van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public ArrayList getLabelData()">
    public ArrayList getLabelData() {
        return labelData;
    }
    // </editor-fold>
    
    /** 
     * Set de label data van dit layer item.
     *
     * @param labelData ArrayList met de label data van dit layer item.
     */
    // <editor-fold defaultstate="" desc="public void setLabelData(ArrayList labelData)">
    public void setLabelData(ArrayList labelData) {
        this.labelData = labelData;
    }
    // </editor-fold>
    
    /** 
     * Voeg nieuwe label data aan dit layer item toe.
     *
     * @param s String[] met een lijst met label data voor dit layer item.
     */
    // <editor-fold defaultstate="" desc="public void addLabelData(String s[])">    
    public void addLabelData(String s[]) {
        if (labelData==null) {
            labelData=new ArrayList();
        }
        for (int i=0; i < s.length; i++) {
            labelData.add(s[i]);
        }
    }
    // </editor-fold>
}