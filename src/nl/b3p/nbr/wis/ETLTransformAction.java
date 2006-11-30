/*
 * ETLTransformAction.java
 *
 * Created on 30 november 2006, 12:54
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
 * @author Geert
 * @version
 */

public class ETLTransformAction extends Action {
    
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
        
        ArrayList geoafwijking = new ArrayList();
        geoafwijking.add(new AfwijkingsItem("GeoAfwijking #1", "g1", "oud"));
        geoafwijking.add(new AfwijkingsItem("GeoAfwijking #2", "g2", "nieuw"));
        geoafwijking.add(new AfwijkingsItem("GeoAfwijking #3", "g3", "ontkoppeld"));
        
        ArrayList adminafwijking = new ArrayList();
        adminafwijking.add(new AfwijkingsItem("AdminAfwijking #1", "a1", "oud"));
        adminafwijking.add(new AfwijkingsItem("AdminAfwijking #2", "a2", "ontkoppeld"));
        adminafwijking.add(new AfwijkingsItem("AdminAfwijking #3", "a3", "parkeren"));
        adminafwijking.add(new AfwijkingsItem("AdminAfwijking #4", "a4", "definitief_ontkoppeld"));
        
        request.setAttribute("geoafwijking", geoafwijking);
        request.setAttribute("adminafwijking", adminafwijking);
        
        return mapping.findForward(SUCCESS);
        
    }
}
