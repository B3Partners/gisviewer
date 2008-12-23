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
import java.util.List;
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
    private static int maxSearchResults=25;
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
     *
     * TODO: ook een WFS thema moet mogelijk worden.
     */
    public String[] getData(String x_input, String y_input, String[] cols, int themaId, double distance, int srid) throws SQLException {
        String[] results = new String[cols.length + 3];
        try {
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
            /*if (sptn == null || sptn.length() == 0) {
            return new String[]{rdx, rdy, "No sptn"};
            }*/
            if (srid == 0) {
                srid = 28992; // RD-new
            }
            ArrayList columns = new ArrayList();
            for (int i = 0; i < cols.length; i++) {
                columns.add(cols[i]);
            }
            
            results[0] = rdx;
            results[1] = rdy;
            results[2] = "";
            
            Session sess = HibernateUtil.getSessionFactory().openSession();
            Themas t = (Themas) sess.get(Themas.class, new Integer(themaId));
            Connection connection = null;
            if (t.getConnectie() != null) {
                connection = t.getConnectie().getJdbcConnection();
            }
            if (connection == null) {
                connection = sess.connection();
            }
            try {
                String geomColumn = SpatialUtil.getTableGeomName(t, connection);
                String sptn = t.getSpatial_tabel();
                if (sptn == null) {
                    sptn = t.getAdmin_tabel();
                }
                String q = SpatialUtil.closestSelectQuery(columns, sptn, geomColumn, x, y, distance, srid);
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
        } catch (Exception e) {
            log.error("", e);
        }
        return results;
    }
    
    public ArrayList getMapCoords(String[] waarden, String[] colomns, int[] themaIds, double distance, int srid) {
        double distance2=0.0;
        if (distance > 0)
            distance2=distance/2;
        ArrayList coords = new ArrayList();
        if (colomns.length != themaIds.length) {
            log.error("Aantal kolommen en themas is niet gelijk");
            MapCoordsBean mbc = new MapCoordsBean();
            mbc.setNaam("Zoeker is verkeerd geconfigureerd");
            coords.add(mbc);
            return coords;
        }
        String waarde=null;
        if (waarden.length==1)
            waarde = waarden[0].replaceAll("\\'", "''");
        
        Session sess = null;
        try {
            sess = HibernateUtil.getSessionFactory().openSession();
            for (int ti = 0; ti < themaIds.length; ti++) {
                String[] cols = colomns[ti].split(",");                
                if (cols == null || cols.length == 0) {
                    MapCoordsBean mbc = new MapCoordsBean();
                    mbc.setNaam("No cols");
                    coords.add(mbc);
                    return coords;
                }                
                if (waarde==null){                    
                    if (waarden.length != cols.length){
                        MapCoordsBean mbc = new MapCoordsBean();
                        mbc.setNaam("Number of values missing!");
                        coords.add(mbc);
                        return coords;
                    }
                }
                Connection connection = null;
                try {
                    Themas t = (Themas) sess.get(Themas.class, new Integer(themaIds[ti]));
                    if (t==null) {
                        MapCoordsBean mbc = new MapCoordsBean();
                        mbc.setNaam("Ongeldig thema met id: " + themaIds[ti] + " geconfigureerd");
                        coords.add(mbc);
                        return coords;
                    }
                    if (t.getConnectie() != null) {
                        connection = t.getConnectie().getJdbcConnection();
                    }
                    if (connection == null) {
                        connection = sess.connection();
                    }
                    String sptn = t.getSpatial_tabel();
                    String geomcolomn = SpatialUtil.getTableGeomName(t, connection);
                    if (sptn == null || sptn.length() == 0) {
                        sptn = t.getAdmin_tabel();
                    }
                    //maak de query voor het ophalen van de objecten die voldoen aan de zoekopdracht
                    StringBuffer q = new StringBuffer();
                    q.append("select ");
                    
                    for (int i = 0; i < cols.length; i++) {
                        if (cols[i]!=null && cols[i].length()>0){
                            if (i!=0)
                                q.append(",");
                            q.append("\""+cols[i]+"\"");
                        }
                    }
                    q.append(", astext(Envelope(collect(tbl.");
                    q.append(geomcolomn);
                    q.append("))) as bbox from \"");
                    q.append(sptn);
                    q.append("\" tbl where (");
                    StringBuffer whereS= new StringBuffer();
                    for (int i = 0; i < cols.length; i++) {
                        //als er maar 1 waarde is dan op alle thema attributen de zelfde criteria los laten met een OR er tussen
                        if (waarde!=null){
                            if (i!=0)
                                whereS.append(" or");
                            whereS.append(" lower(CAST(tbl.");
                            whereS.append("\""+cols[i]+"\" AS VARCHAR)");
                            whereS.append(") like lower('%");
                            whereS.append(waarde);
                            whereS.append("%')");
                        }else{
                            if (waarden[i].length()>0){
                                if (whereS.length()>0){
                                    whereS.append(" AND");
                                }
                                whereS.append(" lower(CAST(tbl.");
                                whereS.append("\""+cols[i]+"\" AS VARCHAR)");
                                whereS.append(") like lower('%");
                                whereS.append(waarden[i]);
                                whereS.append("%')");
                            }
                        }                        
                    }
                    q.append(whereS.toString());
                    q.append(")");
                    StringBuffer qc=new StringBuffer();
                    for (int i = 0; i < cols.length; i++) {
                        if (cols[i]!=null && cols[i].length()>0){
                            if (i!=0)
                                qc.append(",");
                            qc.append("\""+cols[i]+"\"");
                        }
                    }
                    q.append(" group by ");
                    q.append(qc);
                    q.append(" order by ");
                    q.append(qc);

                    if (maxSearchResults>0){
                        q.append(" LIMIT ");
                        q.append(maxSearchResults);
                    }
                    log.debug(q.toString());
                    PreparedStatement statement = connection.prepareStatement(q.toString());
                    try {
                        ResultSet rs = statement.executeQuery();
                        //int loopnum = 0;
                        while (rs.next() && coords.size()<=maxSearchResults) {
                            double minx, maxx, miny, maxy;
                            String bbox = rs.getString("bbox");
                            if (bbox==null){
                                StringBuffer errorMessage = new StringBuffer();
                                errorMessage.append("Er wordt geen BBOX gegeven door de database voor record met ");
                                for (int i = 0; i < cols.length; i++) {
                                    if (rs.getString(cols[i]) != null) {                                        
                                        if (i != 0) {
                                            errorMessage.append(",");
                                        }
                                        errorMessage.append(cols[i]);
                                        errorMessage.append("=");
                                        errorMessage.append(rs.getString(cols[i]));
                                    }
                                }
                                log.error(errorMessage.toString());
                                continue;
                            }
                            else if (bbox.trim().toLowerCase().startsWith("polygon")){
                                //bbox: POLYGON((223700 524300,223700 526567.125,225934.25 526567.125,225934.25 524300,223700 524300))
                                
                                bbox = bbox.replaceAll("POLYGON\\(\\(", "");
                                bbox = bbox.replaceAll("\\)\\)", "");
                                String[] bboxArray = bbox.split(",");
                                if (bboxArray == null || bboxArray.length != 5) {
                                    log.error("Kan geen coordinaten uit WKT geometry halen");
                                    continue;
                                }                            
                                try {
                                    minx = Double.parseDouble(bboxArray[0].split(" ")[0]);
                                    maxx = Double.parseDouble(bboxArray[2].split(" ")[0]);
                                    miny = Double.parseDouble(bboxArray[0].split(" ")[1]);
                                    maxy = Double.parseDouble(bboxArray[2].split(" ")[1]);
                                } catch (NumberFormatException nfe) {
                                    log.error("Kan geen coordinaten uit WKT geometry POLYGON halen");
                                    continue;
                                }
                            }else{//its a point
                                bbox= bbox.replaceAll("POINT\\(","");
                                bbox= bbox.replaceAll("\\)","");
                                String[] bboxArray=bbox.split(" ");
                                 try {
                                    minx = Double.parseDouble(bboxArray[0]);
                                    maxx = Double.parseDouble(bboxArray[0]);
                                    miny = Double.parseDouble(bboxArray[1]);
                                    maxy = Double.parseDouble(bboxArray[1]);
                                } catch (NumberFormatException nfe) {
                                    log.error("Kan geen coordinaten uit WKT geometry POINT halen");
                                    continue;
                                }                                
                            }
                            if (Math.abs(minx - maxx) < 1) {
                                //maxx = minx + distance;
                                minx-=distance2;
                                maxx+=distance2;
                            }
                            if (Math.abs(miny - maxy) < 1) {
                                //maxy = miny + distance;
                                maxy+=distance2;
                                miny-=distance2;
                            }
                            StringBuffer naam = new StringBuffer();
                            for (int i = 0; i < cols.length; i++) {
                                if (rs.getString(cols[i]) != null) {
                                    if (i != 0) {
                                        naam.append(",");
                                    }
                                    naam.append(rs.getString(cols[i]));
                                }
                            }
                            MapCoordsBean mbc = new MapCoordsBean();
                            mbc.setNaam(naam.toString());
                            mbc.setMinx(Double.toString(minx));
                            mbc.setMiny(Double.toString(miny));
                            mbc.setMaxx(Double.toString(maxx));
                            mbc.setMaxy(Double.toString(maxy));
                            coords.add(mbc);
                        }
                    } finally {
                        statement.close();
                    }
                } catch (SQLException ex) {
                    log.error("", ex);
                } finally {
                    try {
                        if (connection != null) {
                            connection.close();
                        }
                    } catch (Exception e) {
                    }
                }
            }
        } finally {
            if (sess != null) {
                sess.close();
            }
        }
        if (!coords.isEmpty()) {
            return coords;
        }
        return null;
    }
    //}catch(Exception )
}