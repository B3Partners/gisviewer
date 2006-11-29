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
        
        LayerItem li2= new LayerItem("Groen");
        li2.addChild(new LayerItem("Bos",true));
        li2.addChild(new LayerItem("Berm",false));
        
        LayerItem li3= new LayerItem("Verkeer");
        li3.addChild(new LayerItem("Wegen",true));
        li3.addChild(new LayerItem("Stoplichten",true));
        
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
