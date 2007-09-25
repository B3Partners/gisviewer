/*
 * $Id: LogoutAction.java 6755 2007-09-07 10:00:31Z Matthijs $
 */

package nl.b3p.gis.viewer.services;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.*;

/**
 * Deze Action wordt aangeroepen na een fout inlog, voegt message toe en forward.
 */
public class LoginAction extends Action {
    
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        ActionMessages messages = getMessages(request);
        ActionMessage message = new ActionMessage("error.inlog");
        messages.add(ActionMessages.GLOBAL_MESSAGE, message);
        saveMessages(request, messages);
        
        return mapping.findForward("success");
    }
}

