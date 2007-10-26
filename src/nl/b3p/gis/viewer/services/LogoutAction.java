/*
 * $Id$
 */

package nl.b3p.gis.viewer.services;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.*;

/**
 * Deze Action invalideert de sessie (met eventuele authenticatie info).
 */
public class LogoutAction extends Action {
    
    private static final Log log = LogFactory.getLog(LogoutAction.class);
    
    
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
        String sesId = session.getId();
        session.invalidate();
        log.info("Logged out from session: " + sesId);
        return mapping.findForward("success");
    }
}

