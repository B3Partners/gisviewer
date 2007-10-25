/*
 * $Id$
 */

package nl.b3p.gis.viewer.services;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.*;

/**
 * Deze Action invalideert de sessie (met eventuele authenticatie info).
 */
public class LogoutAction extends Action {
    
    private static final Log log = LogFactory.getLog(LogoutAction.class);
    private static final int RTIMEOUT = 3000;
    private static final String LOGOUT_URL = "logout.do";
    
    
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        // eerst uitloggen bij kaartenbalie
        HttpClient client = new HttpClient();
        client.getHttpConnectionManager().
                getParams().setConnectionTimeout(RTIMEOUT);
        
        String url = HibernateUtil.KBURL;
        int pos = url.lastIndexOf("wms");
        if (pos>=0) {
            String logoutLocation = url.substring(0,pos) + LOGOUT_URL;
            GetMethod method = new GetMethod(logoutLocation);
            
            try {
                int statusCode =client.executeMethod(method);
                if (statusCode != HttpStatus.SC_OK) {
                    log.error("Could not log out at Kaartenbalie, reason: " + 
                            method.getStatusLine().getReasonPhrase());
                } else
                    log.info("Logged out at Kaartenbalie");
            } finally {
                // Release the connection.
                method.releaseConnection();
            }
        }
        
        //dam zelf uitloggen
        request.getSession().invalidate();
        log.info("Logged out here");
        return mapping.findForward("success");
    }
}

