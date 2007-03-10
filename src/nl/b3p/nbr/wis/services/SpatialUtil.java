/*
 * SpatialUtil.java
 *
 * Created on 8 maart 2007, 17:47
 *
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


/**
 *
 * @author Chris
 */
public class SpatialUtil {
    
    private static final Log log = LogFactory.getLog(SpatialUtil.class);
    
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
    
    static public List getThemaData(Themas t, boolean basisregel) {
        Session sess = HibernateUtil.getSessionFactory().getCurrentSession();
        
        Query q = sess.createQuery("from ThemaData td where td.thema.id = :tid "
                + "and td.basisregel = :br");
        q.setInteger("tid", t.getId());
        q.setBoolean("br", basisregel);
        return q.list();
    }
    
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
    
    static public void testMetaData(Connection conn) throws SQLException {
        
        Hashtable allTables = new Hashtable();
        allTables.put("baanvakken", "id");
        allTables.put("beh_10_wwl_m", "id");
        allTables.put("algm_grs_2006_1_gem_v", "id");
        allTables.put("algm_grs_2006_1_gga_v", "id");
        allTables.put("algm_kom_10_wgw_v", "id");
        allTables.put("algm_pstk_acn_p", "id");
        allTables.put("bel_sp_2002_100_agh_v", "id");
        allTables.put("cyclomedia", "id");
        allTables.put("dtb_all", "id");
        allTables.put("dtb_preferred", "id");
        allTables.put("groenv8", "id");
        allTables.put("lki_pnb_v", "kadperc_id");
        allTables.put("strooiroutes", "id");
        allTables.put("tankstations_centroid", "id");
        allTables.put("telvakken", "id");
        allTables.put("verv_beh_10_vri_p", "id");
        allTables.put("verv_beh_vta", "id");
        allTables.put("verv_nwb_hmn_p", "id");
        
        DatabaseMetaData dbmd = conn.getMetaData();
        
        Iterator it = allTables.keySet().iterator();
        while (it.hasNext()) {
            String dbtn = (String) it.next();
            String adminPk = (String)allTables.get(dbtn);
            int dt = java.sql.Types.NULL;
            ResultSet rs = dbmd.getColumns(null, null, dbtn, adminPk);
            int loop = 0;
            while (rs.next()) {
                dt = rs.getInt("DATA_TYPE");
                log.info("#: " + loop++ +
                        ", tabelnaam: " + dbtn +
                        ", pknaam: " + adminPk +
                        ", SQL_DATA_TYPE:" + dt +
                        "");
            }
        }
        return;
    }
    
}
