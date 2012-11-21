package nl.b3p.gis.viewer;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.struts.ExtendedMethodProperties;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.DynaValidatorForm;

public class ViewerLogAction extends BaseGisAction {
    private static final Log log = LogFactory.getLog(ViewerLogAction.class);

    private static final String JDBC_URL = "jdbc:postgresql://localhost:5432/digitree_gis";
    private static final String DB_USER = "digitree";
    private static final String DB_PASSW = "04zIYpUKFLUgAU0op";
    private static final String TABLE = "digitree_labels";

    protected static final String LOGINFO = "loginfo";
    public static final List column_names = Arrays.asList(new String[] {
        "Project id",
        "Boom id",
        "Datum",
        "Tijd",
        "Uitvoering",
        "Inspecteur"
    });

    protected Map getActionMethodPropertiesMap() {
        Map map = new HashMap();

        ExtendedMethodProperties hibProp = null;
        hibProp = new ExtendedMethodProperties(LOGINFO);
        hibProp.setDefaultForwardName(SUCCESS);
        hibProp.setAlternateForwardName(FAILURE);
        hibProp.setAlternateMessageKey("error.analysewaarde.failed");
        map.put(LOGINFO, hibProp);

        return map;
    }

    public ActionForward loginfo(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        request.setAttribute("column_names", column_names);

        String id = (String) request.getParameter("id");
        //Themas t = getThema(mapping, dynaForm, request);

        List column_data = getLogColumnData(id);
        request.setAttribute("column_data", column_data);

        //return mapping.findForward("loginfo");
        return mapping.findForward(SUCCESS);
    }

    private List getLogColumnData(String id) {

        String query = "select di.projectid, di.boomid, di.datum, di.tijd, di.uitvoering, di.inspecteur from " +
                "digitree_bomen as db inner join digitree_inspecties as di on db.boomid = di.boomid " +
                "and db.projectid = di.projectid and db.project = di.project and db.id = ";

        query += id;

        List results=new ArrayList();

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSW);

            PreparedStatement statement = conn.prepareStatement(query);

            try {
                ResultSet rs = statement.executeQuery();

                while (rs.next()) {
                    List resultRow = new ArrayList();
                    resultRow.add(rs.getObject(1));
                    resultRow.add(rs.getObject(2));
                    resultRow.add(rs.getObject(3));
                    resultRow.add(rs.getObject(4));
                    resultRow.add(rs.getObject(5));
                    resultRow.add(rs.getObject(6));
                    results.add(resultRow);
                }

            } finally {

                statement.close();
            }

        } catch (SQLException ex) {
            log.error("", ex);

        } finally {

            try {
                conn.close();
            } catch (SQLException ex) {
                log.error("", ex);
            }
        }
        return results;
    }

}