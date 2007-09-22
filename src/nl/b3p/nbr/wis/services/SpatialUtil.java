/**
 * @(#)SpatialUtil.java
 * @author Chris van Lith
 * @version 1.00 2007/03/08
 *
 * Purpose: Een klasse specifiek voor de uitvoering van alle spatial query's
 * die binnen het project van belang zijn. Iedere query kent zijn eigen methode
 * of maakt gebruik van een combinatie van methoden om het gewenste resultaat
 * op een zo efficient mogelijke manier te bereiken.
 *
 * @copyright 2007 All rights reserved. B3Partners
 */

package nl.b3p.nbr.wis.services;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import nl.b3p.nbr.wis.db.Themas;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Query;
import org.hibernate.Session;

public class SpatialUtil {
    
    private static final Log log = LogFactory.getLog(SpatialUtil.class);
    
    public static final String MULTIPOINT="multipoint";
    public static final String MULTILINESTRING="multilinestring";
    public static final String MULTIPOLYGON="multipolygon";
    
    public static List getValidClusters() {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        String hquery = "FROM Clusters WHERE id != 9";
        Query q = sess.createQuery(hquery);
        return q.list();
    }
    
    public static List getValidThemas(boolean locatie) {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        String hquery = "FROM Themas WHERE cluster != 9 ";
        hquery += "AND (moscow = 1 OR moscow = 2 OR moscow = 3) ";
        if (locatie)
            hquery += "AND locatie_thema = true ";
        hquery += "AND code < 3 ORDER BY naam";
        Query q = sess.createQuery(hquery);
        return q.list();
    }
    
    /**
     * DOCUMENT ME!
     *
     * @param t Themas
     * @param conn Connection
     *
     * @return int
     *
     */
    static public int getPkDataType(Themas t, Connection conn) throws SQLException {
        DatabaseMetaData dbmd = conn.getMetaData();
        String dbtn = t.getAdmin_tabel();
        String adminPk = t.getAdmin_pk();
        int dt = java.sql.Types.NULL;
        ResultSet rs = dbmd.getColumns(null, null, dbtn, adminPk);
        if (rs.next()) {
            dt = rs.getInt("DATA_TYPE");
        }
        if (dt==java.sql.Types.NULL) {
            log.debug("java.sql.Types.NULL voor tabelnaam: " + dbtn +
                    ", pknaam: " + adminPk +
                    ", SQL_DATA_TYPE:" + dt);
        }
        return dt;
    }
    
    static public boolean isEtlThema(Themas t, Connection conn) throws SQLException {
        DatabaseMetaData dbmd = conn.getMetaData();
        String dbtn = t.getAdmin_tabel();
        int dt = java.sql.Types.NULL;
        ResultSet rs = dbmd.getColumns(null, null, dbtn, "status_etl");
        if (rs.next()) {
            return true;
        }
        return false;
    }
    
    /**
     * DOCUMENT ME!
     *
     * @param x double
     * @param y double
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String createClickGeom(double x, double y, int srid)">
    static public String createClickGeom(double x, double y, int srid) {
        StringBuffer sq = new StringBuffer();
        sq.append(" PointFromText ( ");
        sq.append("'POINT(");
        sq.append(x);
        sq.append(" ");
        sq.append(y);
        sq.append(")'");
        sq.append(", ");
        sq.append(srid);
        sq.append(") ");
        return sq.toString();
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param t Themas
     * @param basisregel boolean
     *
     * @return List
     *
     */
    // <editor-fold defaultstate="" desc="static public List getThemaData(Themas t, boolean basisregel)">
    static public List getThemaData(Themas t, boolean basisregel) {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        
        String query = "from ThemaData td where td.thema.id = :tid ";
        if (basisregel)
            query += "and td.basisregel = :br ";
        query += " order by td.dataorder";
        Query q = sess.createQuery(query);
        q.setInteger("tid", t.getId());
        if (basisregel)
            q.setBoolean("br", basisregel);
        return q.list();
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param kolom String
     * @param tabel String
     * @param x double
     * @param y double
     * @param distance double
     * @param srid int
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String maxDistanceQuery(String kolom, String tabel, double x, double y, double distance, int srid)">
    static public String maxDistanceQuery(String kolom, String tabel, double x, double y, double distance, int srid) {
        StringBuffer sq = new StringBuffer();
        sq.append("select ");
        sq.append(kolom);
        sq.append(" from ");
        sq.append(tabel);
        sq.append(" tbl where ");
        sq.append(" distance( ");
        sq.append(" tbl.the_geom, ");
        sq.append(createClickGeom(x, y, srid));
        sq.append(") < ");
        sq.append(distance);
        return sq.toString();
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param kolom String
     * @param tabel String
     * @param x double
     * @param y double
     * @param srid int
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String intersectQuery(String kolom, String tabel, double x, double y, int srid)">
    static public String intersectQuery(String kolom, String tabel, double x, double y, int srid) {
        StringBuffer sq = new StringBuffer();
        sq.append("select ");
        sq.append(kolom);
        sq.append(" from ");
        sq.append(tabel);
        sq.append(" tbl where ");
        sq.append(" Intersects( ");
        sq.append(createClickGeom(x, y, srid));
        sq.append(", tbl.the_geom");
        sq.append(") = true ");
        return sq.toString();
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param kolom String
     * @param tabel String
     * @param x double
     * @param y double
     * @param distance double
     * @param srid int
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String InfoSelectQuery(String kolom, String tabel, double x, double y, double distance, int srid)">
    static public String InfoSelectQuery(String kolom, String tabel, double x, double y, double distance, int srid) {
        // Als thema punten of lijnen dan afstand
        // Als thema polygon dan Intersects
        StringBuffer sq = new StringBuffer();
        sq.append("select ");
        sq.append(kolom);
        sq.append(" from ");
        sq.append(tabel);
        sq.append(" tbl where ");
        sq.append("(");
        sq.append("(Dimension(tbl.the_geom) < 2) ");
        sq.append("and ");
        sq.append("(Distance(tbl.the_geom, ");
        sq.append(createClickGeom(x, y, srid));
        sq.append(") < ");
        sq.append(distance);
        sq.append(")");
        sq.append(") or (");
        sq.append("(Dimension(tbl.the_geom) = 2)");
        sq.append(" and ");
        sq.append("(Intersects(");
        sq.append(createClickGeom(x, y, srid));
        sq.append(", tbl.the_geom) = true)");
        sq.append(")");
        
        log.debug("InfoSelectQuery: " + sq.toString());
        
        return sq.toString();
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param cols ArrayList
     * @param tabel String
     * @param x double
     * @param y double
     * @param distance double
     * @param srid int
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String closestSelectQuery(ArrayList cols, String tabel, double x, double y, double distance, int srid)">
    static public String closestSelectQuery(ArrayList cols, String tabel, double x, double y, double distance, int srid) {
        StringBuffer sq = new StringBuffer();
        sq.append("select ");
        Iterator it = cols.iterator();
        while (it.hasNext()) {
            sq.append("tbl.");
            sq.append(it.next());
            sq.append(", ");
        }
        sq.append("(Distance(tbl.the_geom, ");
        sq.append(createClickGeom(x, y, srid));
        sq.append(")) as dist ");
        sq.append("from ");
        sq.append(tabel);
        sq.append(" tbl where ");
        sq.append(" distance( ");
        sq.append(" tbl.the_geom, ");
        sq.append(createClickGeom(x, y, srid));
        sq.append(") < ");
        sq.append(distance);
        sq.append(" order by dist limit 1");
        return sq.toString();
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param tabel String
     * @param searchparam String
     * @param param String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String postalcodeRDCoordinates(String tabel, String searchparam, String param)">
    static public String postalcodeRDCoordinates(String tabel, String searchparam, String param) {
        return "select distinct " + searchparam + " as naam, astext(tbl.the_geom) as pointsresult from " +
                tabel + " tbl where lower(tbl." + searchparam + ") = lower('" + param + "')";
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param tabel String
     * @param searchparam String
     * @param param String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String cityRDCoordinates(String tabel, String searchparam, String param)">
    static public String cityRDCoordinates(String tabel, String searchparam, String param) {
        return "select distinct " + searchparam + " as naam, astext(centroid(tbl.the_geom)) as pointsresult from " +
                tabel + " tbl where lower(tbl." + searchparam + ") like lower('%" + param + "%')";
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param tabel String
     * @param searchparam String
     * @param hm String
     * @param n_nr String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String wolHMRDCoordinates(String tabel, String searchparam, String hm, String n_nr)">
    static public String wolHMRDCoordinates(String tabel, String searchparam, String hm, String n_nr) {
        return  "select " + searchparam + " as naam, astext(hecto.the_geom) as pointsresult from " + tabel + " hecto where (" +
                "(CAST(hecto." + searchparam + " AS FLOAT) - " + hm + ")*" +
                "(CAST(hecto." + searchparam + " AS FLOAT) - " + hm + ")) = " +
                "(select min("+
                "(CAST(hecto." + searchparam + " AS FLOAT) - " + hm + ")*" +
                "(CAST(hecto." + searchparam + " AS FLOAT) - " + hm + ")) " +
                "from " + tabel + " hecto where lower(hecto.n_nr) = lower('" + n_nr + "') ) " +
                "AND lower(hecto.n_nr) = lower('" + n_nr + "')";
        
        /* Example query:
         * select astext(hecto.the_geom) from verv_nwb_hmn_p hecto where
         * ((CAST(hecto.hm AS FLOAT) - 10.2)*(CAST(hecto.hm AS FLOAT) - 10.2)) =
         * (select min((CAST(hecto.hm AS FLOAT) - 10.2)*(CAST(hecto.hm AS FLOAT)
         * - 10.2)) from verv_nwb_hmn_p hecto where hecto.n_nr = 'N261' )
         * AND hecto.n_nr = 'N261'
         */
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param operator String
     * @param tb1 String
     * @param tb2 String
     * @param divide int
     * @param extraCriteria String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="public static String intersectionArea(String operator,String tb1, String tb2, String id,int divide, String extraCriteria)">
    public static String intersectionArea(String operator,String tb1, String tb2, String id, int divide, String extraCriteria) {
        return intersectionArea(operator,tb1,"the_geom",tb2,"the_geom","id",id,divide, extraCriteria);
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param operator String
     * @param tb1 String
     * @param geomColumn1 String
     * @param tb2 String
     * @param geomColumn2 String
     * @param idColumnName String
     * @param id String
     * @param divide int
     * @param extraCriteria String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String intersectionArea(String operator,String tb1,String geomColumn1,String tb2, String geomColumn2,String idColumnName, String id,int divide, String extraCriteria)">
    static public String intersectionArea(String operator,String tb1,String geomColumn1,String tb2, String geomColumn2,
            String idColumnName, String id, int divide, String extraCriteria){
        StringBuffer sq = new StringBuffer();
        sq.append("select ("+operator+"(area(Intersection(tb1."+geomColumn1+",tb2."+geomColumn2+"))))/"+divide+" as result ");
        sq.append("from "+tb1+" tb1, "+tb2+" tb2 ");
        sq.append("where tb2."+idColumnName+" = "+id+" ");
        /*Voor optimalizatie van de query een where statement toevoegen
         *bij testen verkleinde de tijd een 4 voud
         */
        sq.append("and intersects(tb1."+geomColumn1+",tb2."+geomColumn2+")" + extraCriteria);
        return sq.toString();
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param operator String
     * @param tb1 String
     * @param tb2 String
     * @param id String
     * @param divide int
     * @param extraCriteria String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String intersectionLength(String operator,String tb1,String tb2,String id,int divide, String extraCriteria)">
    static public String intersectionLength(String operator, String tb1, String tb2, String id, int divide, String extraCriteria){
        return intersectionLength(operator,tb1,"the_geom",tb2,"the_geom","id",id,divide, extraCriteria);
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param operator String
     * @param tb1 String
     * @param geomColumn1 String
     * @param tb2 String
     * @param geomColumn2 String
     * @param idColumnName String
     * @param id String
     * @param divide int
     * @param extraCriteria String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String intersectionLength(String operator,String tb1,String geomColumn1,String tb2, String geomColumn2, String idColumnName, String id,int divide, String extraCriteria)">
    static public String intersectionLength(String operator, String tb1, String geomColumn1, String tb2, String geomColumn2,
            String idColumnName, String id, int divide, String extraCriteria){
        StringBuffer sq = new StringBuffer();
        sq.append("select "+operator+"(length(Intersection(tb1."+geomColumn1+",tb2."+geomColumn2+")))/"+divide+" as result ");
        sq.append("from "+tb1+" tb1, "+tb2+" tb2 ");
        sq.append("where tb2."+idColumnName+" = "+id+" ");
        /*Voor optimalizatie van de query een where statement toevoegen
         *bij testen verkleinde de tijd een 4 voud
         */
        sq.append("and intersects(tb1."+geomColumn1+",tb2."+geomColumn2+")" + extraCriteria);
        return sq.toString();
    }
    // </editor-fold>
    
    /**
     *Maakt een query string die alle objecten selecteerd uit tb1 waarvan het object een relatie heeft volgens de meegegeven relatie
     *met het geo object van tb2
     */
    /**
     * DOCUMENT ME!
     *
     * @param tb1 String
     * @param tb2 String
     * @param relationFunction String
     * @param saf String
     * @param analyseObjectId String
     * @param extraCriteriaString String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String hasRelationQuery(String tb1,String tb2, String relationFunction,String saf, String analyseObjectId, String extraCriteriaString)">
    static public String hasRelationQuery(String tb1, String tb2, String relationFunction, String saf, String analyseObjectId, String extraCriteriaString){
        //"select * from <themaGeomTabel> tb1, <analyseGeomTable> tb2 where tb1.<theGeom> tb2.<theGeom>";
        return hasRelationQuery(tb1,"the_geom",tb2,"the_geom",relationFunction,saf,"id",analyseObjectId, extraCriteriaString);
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param tb1 String
     * @param geomColumn1 String
     * @param tb2 String
     * @param geomColumn2 String
     * @param relationFunction String
     * @param saf String
     * @param idColumnName String
     * @param analyseObjectId String
     * @param extraCriteriaString String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String hasRelationQuery(String tb1,String geomColumn1,String tb2, String geomColumn2, String relationFunction,String saf,String idColumnName,String analyseObjectId, String extraCriteriaString)">
    static public String hasRelationQuery(String tb1, String geomColumn1, String tb2, String geomColumn2,
            String relationFunction, String saf, String idColumnName, String analyseObjectId, String extraCriteriaString){
        //"select * from <themaGeomTabel> tb1, <analyseGeomTable> tb2 where tb1.<theGeom> tb2.<theGeom>";
        StringBuffer sq= new StringBuffer();
        sq.append("select tb1."+saf+" ");
        sq.append("from "+tb1+" tb1, "+tb2+" tb2 ");
        sq.append("where tb2."+idColumnName+" = "+analyseObjectId+" ");
        sq.append("and "+relationFunction+"(tb1."+geomColumn1+", tb2."+geomColumn2+") ");
        sq.append(extraCriteriaString + "limit 50");
        return sq.toString();
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param select String
     * @param table1 String
     * @param table2 String
     * @param tableIdColumn1 String
     * @param tableId1 String
     * @param extraCriteria String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String containsQuery(String select,String table1, String table2, String tableIdColumn1,String tableId1, String extraCriteria)">
    static public String containsQuery(String select, String table1, String table2, String tableIdColumn1,
            String tableId1, String extraCriteria){
        return containsQuery(select,table1,"the_geom",table2,"the_geom",tableIdColumn1,tableId1, extraCriteria);
    }
    // </editor-fold>
    
    /**
     * DOCUMENT ME!
     *
     * @param select String
     * @param table1 String
     * @param geomColumn1 String
     * @param table2 String
     * @param geomColumn2 String
     * @param tableIdColumn1 String
     * @param tableId1 String
     * @param extraCriteria String
     *
     * @return String
     *
     */
    // <editor-fold defaultstate="" desc="static public String containsQuery(String select,String table1,String geomColumn1, String table2, String geomColumn2,String tableIdColumn1,String tableId1, String extraCriteria)">
    static public String containsQuery(String select, String table1, String geomColumn1, String table2,
            String geomColumn2, String tableIdColumn1, String tableId1, String extraCriteria){
        StringBuffer sq = new StringBuffer();
        sq.append("select ");
        sq.append(select+" ");
        sq.append("from ");
        sq.append(table1+ " tb1, "+table2+" tb2 where ");
        sq.append("tb1."+tableIdColumn1+" = "+tableId1+" ");
        sq.append("and Contains(tb1."+geomColumn1+",tb2."+geomColumn2+")" + extraCriteria);
        return sq.toString();
    }
    // </editor-fold>
    
}
