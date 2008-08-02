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
import nl.b3p.commons.services.FormUtils;
import nl.b3p.gis.viewer.db.Connecties;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.gis.viewer.services.HibernateUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.gis.viewer.services.WfsUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

public class GetLocationData {

    private static final Log log = LogFactory.getLog(GetLocationData.class);

    public GetLocationData() {
    }

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
     *
     * @param elementId element in html pagina waar nieuwe waarde naar wordt geschreven
     * @param themaId id van thema waar update betrekking op heeft
     * @param keyName naam van primary key voor selectie van juiste row
     * @param keyValue waarde van primary key voor selectie
     * @param attributeName kolomnaam die veranderd moet worden
     * @param oldValue oude waarde van de kolom
     * @param newValue nieuwe waarde van de kolom
     * @return array van 2 return waarden: 1=elementId, 2=oude of nieuwe waarde met fout indicatie
     */
    public String[] setAttributeValue(String elementId, String themaId, String keyName, String keyValue, String attributeName, String oldValue, String newValue) {
        String[] returnValue = new String[2];
        Transaction transaction = null;
        try {
            returnValue[0] = elementId;
            returnValue[1] = oldValue + " (fout)";

            Integer id = FormUtils.StringToInteger(themaId);
            int keyValueInt = FormUtils.StringToInt(keyValue);
            if (id == null || keyValueInt == 0) {
                return returnValue;
            }
            Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
            transaction = sess.beginTransaction();
            Themas t = (Themas) sess.get(Themas.class, id);

            String connectionType = null;
            Connection conn = null;
            if (t.getConnectie() != null) {
                if (t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_JDBC)) {
                    try {
                        conn = t.getConnectie().getJdbcConnection();
                    } catch (SQLException ex) {
                        log.debug("Invalid jdbc connection in thema: ", ex);
                    }
                    if (conn == null) {
                        conn = sess.connection();
                    }
                    connectionType = Connecties.TYPE_JDBC;
                } else if (t.getConnectie().getType().equalsIgnoreCase(Connecties.TYPE_WFS)) {
                    connectionType = Connecties.TYPE_WFS;
                }
            } else {
                connectionType = Connecties.TYPE_JDBC;
                conn = sess.connection();
            }
            if (conn == null || connectionType == null) {
                return returnValue;
            }

            //Schrijf met jdbc connectie
            if (connectionType.equalsIgnoreCase(Connecties.TYPE_JDBC)) {
                String tableName = t.getSpatial_tabel();

                try {
                    String retVal = SpatialUtil.setAttributeValue(conn, tableName, keyName, keyValueInt, attributeName, newValue);
                    returnValue[1] = retVal;
                } catch (SQLException ex) {
                    log.error("", ex);
                } finally {
                    if (conn != null) {
                        try {
                            conn.close();
                        } catch (SQLException ex) {
                            log.error("", ex);
                        }
                    }
                }
            } else if (connectionType.equalsIgnoreCase(Connecties.TYPE_WFS)) {
                // TODO WFS
                //Feature f=WfsUtil.getWfsObject(t,attributeName,oldValue);
            }
        } catch (Exception e) {
            log.error("", e);
        }
        return returnValue;
    }

    /**
     * In eerste instantie direct uit jsp via dwr aanroepen, later wrappen voor meer veiligheid
     * @param x_input
     * @param y_input
     * @param cols
     * @param sptn
     * @param distance
     * @param srid
     * @return
     */
    public String[] getData(String x_input, String y_input, String[] cols, String sptn, double distance, int srid) {

        double x, y;
        String rdx, rdy;
        try {
            x = Double.parseDouble(x_input);
            y = Double.parseDouble(y_input);
            rdx = Long.toString(Math.round(x));
            rdy = Long.toString(Math.round(y));
        } catch (NumberFormatException nfe) {
            return new String[]{nfe.getMessage()};
        }

        if (cols == null || cols.length == 0) {
            return new String[]{rdx, rdy, "No cols"};
        }
        if (sptn == null || sptn.length() == 0) {
            return new String[]{rdx, rdy, "No sptn"};
        }
        if (srid == 0) {
            srid = 28992; // RD-new
        }
        ArrayList columns = new ArrayList();
        for (int i = 0; i < cols.length; i++) {
            columns.add(cols[i]);
        }

        String[] results = new String[cols.length + 3];
        results[0] = rdx;
        results[1] = rdy;
        results[2] = "";

        SessionFactory sf = HibernateUtil.getSessionFactory();
        Session sess = sf.openSession();
        Connection connection = sess.connection();

        try {
            String q = SpatialUtil.closestSelectQuery(columns, sptn, x, y, distance, srid);
            PreparedStatement statement = connection.prepareStatement(q);
            try {
                ResultSet rs = statement.executeQuery();
                if (rs.next()) {
                    results[2] = rs.getString("dist");
                    for (int i = 0; i < cols.length; i++) {
                        results[i + 3] = rs.getString(cols[i]);
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

        return results;
    }

    public ArrayList getMapCoords(String waarde, String[] cols, String sptn, double distance, int srid) {

        ArrayList coords = new ArrayList();

        if (cols == null || cols.length == 0) {
            MapCoordsBean mbc = new MapCoordsBean();
            mbc.setNaam("No cols");
            coords.add(mbc);
            return coords;
        }

        waarde = waarde.replaceAll("\\'", "''");

        StringBuffer q = new StringBuffer();
        q.append("select distinct ");
        q.append(cols[0]);
        for (int i = 1; i < cols.length; i++) {
            q.append(",");
            q.append(cols[i]);
        }
        q.append(", astext(Envelope(tbl.the_geom)) as bbox from ");
        q.append(sptn);
        q.append(" tbl where (");

        q.append(" lower(tbl.");
        q.append(cols[0]);
        q.append(") like lower('%");
        q.append(waarde);
        q.append("%')");
        for (int i = 1; i < cols.length; i++) {
            q.append(" or");
            q.append(" lower(tbl.");
            q.append(cols[i]);
            q.append(") like lower('%");
            q.append(waarde);
            q.append("%')");
        }
        q.append(")");

        SessionFactory sf = HibernateUtil.getSessionFactory();
        Session sess = sf.openSession();
        Connection connection = sess.connection();

        try {
            PreparedStatement statement = connection.prepareStatement(q.toString());
            try {
                ResultSet rs = statement.executeQuery();
                int loopnum = 0;
                while (rs.next() && loopnum < 15) {

                    //bbox: POLYGON((223700 524300,223700 526567.125,225934.25 526567.125,225934.25 524300,223700 524300))
                    String bbox = rs.getString("bbox");
                    bbox = bbox.replaceAll("POLYGON\\(\\(", "");
                    bbox = bbox.replaceAll("\\)\\)", "");
                    String[] bboxArray = bbox.split(",");
                    if (bboxArray == null || bboxArray.length != 5) {
                        continue;
                    }
                    double minx, maxx, miny, maxy;
                    try {
                        minx = Double.parseDouble(bboxArray[0].split(" ")[0]);
                        maxx = Double.parseDouble(bboxArray[2].split(" ")[0]);
                        miny = Double.parseDouble(bboxArray[0].split(" ")[1]);
                        maxy = Double.parseDouble(bboxArray[2].split(" ")[1]);
                    } catch (NumberFormatException nfe) {
                        return null;
                    }

                    if (Math.abs(minx - maxx) < 1) {
                        maxx = minx + distance;
                    }
                    if (Math.abs(miny - maxy) < 1) {
                        maxy = miny + distance;
                    }
                    StringBuffer naam = new StringBuffer();
                    naam.append(rs.getString(cols[0]));
                    for (int i = 1; i < cols.length; i++) {
                        naam.append(", ");
                        naam.append(rs.getString(cols[i]));
                    }

                    MapCoordsBean mbc = new MapCoordsBean();
                    mbc.setNaam(naam.toString());
                    mbc.setMinx(Double.toString(minx));
                    mbc.setMiny(Double.toString(miny));
                    mbc.setMaxx(Double.toString(maxx));
                    mbc.setMaxy(Double.toString(maxy));
                    coords.add(mbc);
                    loopnum++;
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
        }
        return null;
    }
}