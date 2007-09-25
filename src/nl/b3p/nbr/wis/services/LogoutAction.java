/*
 * $Id$
 */

package nl.b3p.gis.viewer.services;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.*;

/**
 * Deze Action invalideert de sessie (met eventuele authenticatie info).
 */
public class LogoutAction extends Action {

    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.getSession().invalidate();
        return mapping.findForward("success");
    }
}

