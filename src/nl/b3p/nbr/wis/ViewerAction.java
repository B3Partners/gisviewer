/*
 * ViewerAction.java
 *
 * Created on 29 november 2006, 9:49
 */

package nl.b3p.nbr.wis;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
/**
 *
 * @author Roy
 * @version
 */

public class ViewerAction extends Action {
    
    /* forward name="success" path="" */
    private final static String SUCCESS = "success";
    
    /**
     * This is the action called from the Struts framework.
     * @param mapping The ActionMapping used to select this instance.
     * @param form The optional ActionForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @throws java.lang.Exception
     * @return
     */
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        ArrayList layers= new ArrayList();
        
        LayerItem li1 = new LayerItem("Alg/basis");
        li1.addChild(new LayerItem("layer1",true));
        li1.addChild(new LayerItem("layer2",false));
        li1.addChild(new LayerItem("layer3",true));
        
        LayerItem li2= new LayerItem("Groen",true);
        LayerItem li20= new LayerItem("Bos",true);
        li2.addChild(li20);
        li2.addChild(new LayerItem("Berm",false));
        String [] s = new String [6];
        s[0]="Lengte";
        s[1]="Breedte";
        s[2]="Afstand weg";
        s[3]="Verhard";
        s[4]="Greppel";
        s[5]="Bomen";
        li20.addLabelData(s);
        s = new String [6];
        s[0]="100m";
        s[1]="10m";
        s[2]="1m";
        s[3]="ja";
        s[4]="2m";
        s[5]="100";
        li20.addAdmindata(s);
        s= new String [6];
        s[0]="2000m";
        s[1]="200m";
        s[2]="100m";
        s[3]="ja";
        s[4]="3m";
        s[5]="100";
        li20.addAdmindata(s);
        s = new String [6];
        s[0]="2m";
        s[1]="1m";
        s[2]="1m";
        s[3]="ja";
        s[4]="2m";
        s[5]="0";
        li20.addAdmindata(s);
        
        LayerItem li3= new LayerItem("Verkeer",true);
        LayerItem li30=new LayerItem("Wegen",true);
        li3.addChild(li30);
        li3.addChild(new LayerItem("Stoplichten",true));
        s = new String [4];
        s[0]="Lengte";
        s[1]="Breedte";
        s[2]="Hoogte";
        s[3]="Verhard";
        li30.addLabelData(s);
        s = new String [4];
        s[0]="100m";
        s[1]="10m";
        s[2]="10cm";
        s[3]="ja";
        li30.addAdmindata(s);
        s= new String [4];
        s[0]="2000m";
        s[1]="5";
        s[2]="10cm";
        s[3]="ja";
        li30.addAdmindata(s);
        s = new String [4];
        s[0]="2m";
        s[1]="1m";
        s[2]="10cm";
        s[3]="ja";
        li30.addAdmindata(s);
        
        LayerItem li4= new LayerItem("Gebieden");
        li4.addChild(new LayerItem("Gevaar",false));
        
        layers.add(li1);
        layers.add(li2);
        layers.add(li3);
        layers.add(li4);
               
        
        request.setAttribute("layers",layers);
        
        return mapping.findForward(SUCCESS);
        
    }
}
