/*
 * $Id$
 */

package nl.b3p.nbr.wis;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.*;

/**
 * Deze Action invalideert de sessie (met eventuele authenticatie info) en forward
 * naar de locatie die is aangegeven met het "parameter" attribuut in de action
 * mapping.
 */
public class LogoutAction extends Action {

    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.getSession().invalidate();
        response.sendRedirect(request.getContextPath() + mapping.getParameter());
        return null;
    }
}

