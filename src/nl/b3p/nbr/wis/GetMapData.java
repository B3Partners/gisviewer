package nl.b3p.nbr.wis;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Random;
import nl.b3p.nbr.wis.db.Themas;
import nl.b3p.nbr.wis.services.HibernateUtil;
import nl.b3p.nbr.wis.services.SpatialUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

public class GetMapData {
    
    private static final Log log = LogFactory.getLog(GetMapData.class);
    
    public GetMapData() {}
    
    public String[] getData(String x_input, String y_input) {
        
        double x = Double.parseDouble(x_input);
        double y = Double.parseDouble(y_input);
        int srid = 28992; // RD-new
        
        // bepaal dichstbijzijnde hm paal
        double distance = 5000.0;
        String hm = "onbekend";
        String n_nr = "onbekend";
        double dist = 0.0;
        
        ArrayList cols = new ArrayList();
        String sptn = "verv_nwb_hmn_p";
        cols.add("hm");
        cols.add("n_nr");
        
        SessionFactory sf = HibernateUtil.getSessionFactory();
        Session sess = sf.openSession();
        Connection connection = sess.connection();
        
        try {
            String q = SpatialUtil.closestSelectQuery(cols, sptn, x, y, distance, srid);
            PreparedStatement statement = connection.prepareStatement(q);
            try {
                ResultSet rs = statement.executeQuery();
                if(rs.next()) {
                    hm = rs.getString("hm");
                    n_nr = rs.getString("n_nr");
                    dist = rs.getDouble("dist");
                }
            } finally {
                statement.close();
            }
        } catch (SQLException ex) {
            log.error("", ex);
        } finally {
            sess.close();
        }
        
        String rdX = "" + Math.round(x);
        String rdY = "" + Math.round(y);
        String rd = "X: " + rdX + "<br />" +
                "Y: " + rdY + "<br />";
        
        
        /* String ret = "<b>RD Co&ouml;rdinaten</b><br />" + rd + "<br />" +
                "<b>Hectometer aanduiding</b><br />" + hm + " (afstand: " +
                Math.round(dist) +
                " m.)<br /><br />" +
                "<b>Wegnaam</b><br />" + n_nr + "<br /><br />"; */
        return new String[]{rdX, rdY, hm, "" + Math.round(dist), n_nr};
    }
    
    public String getKadastraleData(String x_input, String y_input) {
        ArrayList cols = new ArrayList();
        
        // bepaal gemeente
        double distance = 500.0;
        String postcode = "onbekend";
        String huisnr = "onbekend";
        String toev = "onbekend";
        String plaats = "onbekend";
        
        cols = new ArrayList();
        String sptn = "algm_pstk_acn_p";
        cols.add("postcode");
        cols.add("huisnr");
        cols.add("toevoeg");
        cols.add("nenwpl");
        
        double x = Double.parseDouble(x_input);
        double y = Double.parseDouble(y_input);
        int srid = 28992; // RD-new
        
        SessionFactory sf = HibernateUtil.getSessionFactory();
        Session sess = sf.openSession();
        Connection connection = sess.connection();
        
        try {
            String q = SpatialUtil.closestSelectQuery(cols, sptn, x, y, distance, srid);
            PreparedStatement statement = connection.prepareStatement(q);
            try {
                ResultSet rs = statement.executeQuery();
                if(rs.next()) {
                    postcode = rs.getString("postcode");
                    huisnr = rs.getString("huisnr");
                    String toevoeg = rs.getString("toevoeg");
                    toev = toevoeg==null?"":toevoeg;
                    plaats = rs.getString("nenwpl");
                }
            } finally {
                statement.close();
            }
        } catch (SQLException ex) {
            log.error("", ex);
        } finally {
            sess.close();
        }
        
        return "" + postcode + " " + huisnr + " " + toev + " - " + plaats;
    }
}