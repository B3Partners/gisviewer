/*
 * $Id: LogoutAction.java 6755 2007-09-07 10:00:31Z Matthijs $
 */

package nl.b3p.gis.viewer.services;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import nl.b3p.gis.viewer.BaseGisAction;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.*;
import org.apache.struts.validator.DynaValidatorForm;

/**
 * Deze Action haalt alle analyse thema's op.
 */
public class IndexAction extends BaseGisAction {
    
    private static final Log log = LogFactory.getLog(IndexAction.class);
    
    protected static final String LOGIN = "login";
    protected static final String LOGINERROR = "loginError";
    protected static final String LOGOUT = "logout";

    protected Map getActionMethodPropertiesMap() {
        Map map = new HashMap();
        
        ExtendedMethodProperties hibProp = null;
        
        hibProp = new ExtendedMethodProperties(LOGIN);
        hibProp.setDefaultForwardName(LOGIN);
        hibProp.setAlternateForwardName(FAILURE);
        map.put(LOGIN, hibProp);
        
        hibProp = new ExtendedMethodProperties(LOGINERROR);
        hibProp.setDefaultMessageKey("error.inlog");
        hibProp.setDefaultForwardName(LOGINERROR);
        hibProp.setAlternateForwardName(FAILURE);
        map.put(LOGINERROR, hibProp);
        
        hibProp = new ExtendedMethodProperties(LOGOUT);
        hibProp.setDefaultForwardName(LOGOUT);
        hibProp.setAlternateForwardName(FAILURE);
        map.put(LOGOUT, hibProp);
        
        return map;
    }
    
    /**
     *
     * @param mapping The ActionMapping used to select this instance.
     * @param dynaForm The DynaValidatorForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     *
     * @return an Actionforward object.
     *
     * @throws Exception
     */
    public ActionForward unspecified(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        List themalist = getValidThemas(false, null, request);
        request.setAttribute("themalist", themalist);
        return mapping.findForward(SUCCESS);
    }
    
    public ActionForward login(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        addDefaultMessage(mapping, request);
        return getDefaultForward(mapping, request);
    }
    
    public ActionForward loginError(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        addDefaultMessage(mapping, request);
        return getDefaultForward(mapping, request);
    }
    
    public ActionForward logout(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        String sesId = session.getId();
        session.invalidate();
        log.info("Logged out from session: " + sesId);
        
        addDefaultMessage(mapping, request);
        return getDefaultForward(mapping, request);
    }
    
}

