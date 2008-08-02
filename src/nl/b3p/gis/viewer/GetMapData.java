/*
 * B3P Gisviewer is an extension to Flamingo MapComponents making
 * it a complete webbased GIS viewer and configuration tool that
 * works in cooperation with B3P Kaartenbalie.
 *
 * Copyright 2006, 2007, 2008 B3Partners BV
 * 
 * This file is part of B3P Gisviewer.
 * 
 * B3P Gisviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * B3P Gisviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
 */
package nl.b3p.gis.viewer;

import com.vividsolutions.jump.feature.Feature;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import nl.b3p.gis.viewer.db.Connecties;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.gis.viewer.services.WfsUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

public class GetMapData {

    private static final Log log = LogFactory.getLog(GetMapData.class);

    /** 
     * Creeert een nieuwe instantie van GetMapData.
     */
    // <editor-fold defaultstate="" desc="public GetMapData()">
    public GetMapData() {
    }
    // </editor-fold>
    public String[] getArea(String elementId, String themaId, String attributeName, String compareValue, String eenheid) throws SQLException {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        sess.beginTransaction();
        Themas t = (Themas) sess.get(Themas.class, new Integer(themaId));
        String[] returnValue = new String[2];
        returnValue[0] = elementId;


        //Haal op met jdbc connectie
        double area = 0.0;
        if (t.getConnectie() == null || t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_JDBC)) {
            Connection conn = null;
            if (t.getConnectie() != null) {
                conn = t.getConnectie().getJdbcConnection();
            }
            if (conn == null) {
                conn = sess.connection();
            }
            String geomColumn = SpatialUtil.getTableGeomName(t, conn);
            String tableName = t.getSpatial_tabel();
            if (tableName == null) {
                tableName = t.getAdmin_tabel();
            }
            try {
                String q = SpatialUtil.getAreaQuery(tableName, geomColumn, attributeName, compareValue);
                PreparedStatement statement = conn.prepareStatement(q);
                try {
                    ResultSet rs = statement.executeQuery();
                    if (rs.next()) {
                        area = new Double(rs.getString(1)).doubleValue();
                    }
                } finally {
                    statement.close();
                }
            } catch (SQLException ex) {
                log.error("", ex);
                returnValue[1] = "Fout (zie log)";
            } finally {
                sess.close();
            }

        }//Haal op met WFS
        else if (t.getConnectie() != null && t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
            try {
                Feature f = WfsUtil.getWfsObject(t, attributeName, compareValue);
                area = f.getGeometry().getArea();
            } catch (Exception ex) {
                log.error("", ex);
                returnValue[1] = "Fout (zie log)";
            } finally {
                sess.close();
            }
        }
        if (eenheid != null && eenheid.equals("null")) {
            eenheid = null;
        }
        int divide = 0;
        if (eenheid != null) {
            if (eenheid.equalsIgnoreCase("km")) {
                divide = 1000000;
            } else if (eenheid.equalsIgnoreCase("hm")) {
                divide = 10000;
            }
        }
        if (returnValue[1] == null) {
            if (area > 0.0) {
                if (divide > 0) {
                    area /= divide;
                }
                area *= 100;
                area = Math.round(area);
                area /= 100;
            }
            String value = new String("" + area);
            if (eenheid != null) {
                value += " " + eenheid;
            } else {
                value += " m";
            }
            returnValue[1] = value;
        }
        return returnValue;
    }

    /** 
     * DOCUMENT ME!!!
     *
     * @param x_input String
     * @param y_input String
     *
     * @return String [] met de data.
     */
    // <editor-fold defaultstate="" desc="public String[] getData(String x_input, String y_input)">
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
                if (rs.next()) {
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
    // </editor-fold>
    /** 
     * DOCUMENT ME!!!
     *
     * @param x_input String
     * @param y_input String
     *
     * @return String [] met de kadastrale data.
     */
    // <editor-fold defaultstate="" desc="public String getKadastraleData(String x_input, String y_input)">
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
                if (rs.next()) {
                    postcode = rs.getString("postcode");
                    huisnr = rs.getString("huisnr");
                    String toevoeg = rs.getString("toevoeg");
                    toev = toevoeg == null ? "" : toevoeg;
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
    // </editor-fold>
    /** 
     * DOCUMENT ME!!!
     *
     * @param postcode String met de postcode
     * @param plaatsnaam String met de plaatsnaam
     * @param n_nr String met het wegnummer
     * @param hm String met hectometer paal nummer
     *
     * @return String [] met de kadastrale data.
     */
    // <editor-fold defaultstate="" desc="public ArrayList getMapCoords(String postcode, String plaatsnaam, String n_nr, String hm)">
    public ArrayList getMapCoords(String postcode, String plaatsnaam, String n_nr, String hm) {
        String searchparam = new String();
        String param = new String();
        String tabel = new String();
        String query = new String();

        int xdist = 0;
        int ydist = 0;

        if (!postcode.equals("")) {
            xdist = 200;
            ydist = 200;
            tabel = "algm_pstk_acn_p";
            searchparam = "postcode";
            param = postcode.replaceAll(" ", "");
            query = SpatialUtil.postalcodeRDCoordinates(tabel, searchparam, param);
        } else if (!plaatsnaam.equals("") && (plaatsnaam.indexOf("%") == -1)) {
            xdist = 1600;
            ydist = 1600;
            tabel = "algm_kom_10_wgw_v";
            searchparam = "kom";
            param = plaatsnaam.replaceAll("\\'", "''");
            query = SpatialUtil.cityRDCoordinates(tabel, searchparam, param);
        } else if (!n_nr.equals("") && !hm.equals("")) {
            xdist = 50;
            ydist = 50;
            tabel = "verv_nwb_hmn_p";
            searchparam = "hm";
            query = SpatialUtil.wolHMRDCoordinates(tabel, searchparam, hm.toUpperCase(), n_nr);
        }

        SessionFactory sf = HibernateUtil.getSessionFactory();
        Session sess = sf.openSession();
        Connection connection = sess.connection();
        ArrayList coords = new ArrayList();

        try {
            PreparedStatement statement = connection.prepareStatement(query);
            try {
                boolean searchplaats = true;
                ResultSet rs = statement.executeQuery();
                while (rs.next()) {
                    String point = rs.getString("pointsresult");
                    int x = (int) (Double.parseDouble(point.substring(point.indexOf("(") + 1, point.indexOf(" "))));
                    int y = (int) (Double.parseDouble(point.substring(point.indexOf(" ") + 1, point.indexOf(")"))));
                    String naam = rs.getString("naam");
                    if (x != 0 && y != 0 && searchplaats) {
                        MapCoordsBean mbc = new MapCoordsBean();
                        mbc.setNaam(rs.getString("naam"));
                        mbc.setMinx("" + (x - xdist));
                        mbc.setMiny("" + (y - ydist));
                        mbc.setMaxx("" + (x + xdist));
                        mbc.setMaxy("" + (y + ydist));
                        coords.add(mbc);
                        searchplaats = (!plaatsnaam.equals(""));
                    }
                }
            } finally {
                statement.close();
            }
        } catch (SQLException ex) {
            log.error("", ex);
        } finally {
            sess.close();
        }

        if (!coords.isEmpty()) {
            return coords;
        } else {
            return null;
        }
    }
    // </editor-fold>
}