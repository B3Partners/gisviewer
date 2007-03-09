/*
 * SpatialUtil.java
 *
 * Created on 8 maart 2007, 17:47
 *
 */

package nl.b3p.nbr.wis.services;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import nl.b3p.nbr.wis.db.Themas;
import org.hibernate.Query;
import org.hibernate.Session;


/**
 *
 * @author Chris
 */
public class SpatialUtil {
    
    static public int getPkDataType(Themas t, Connection conn) throws SQLException {
        DatabaseMetaData dbmd = conn.getMetaData();
        String dbtn = t.getAdmin_tabel();
        String adminPk = t.getAdmin_pk();
        int dt = java.sql.Types.VARCHAR;
        ResultSet rs = dbmd.getColumns(null, null, dbtn, adminPk);
        if (rs.next()) {
            dt = rs.getInt("DATA_TYPE");
        }
        return dt;
    }
    
    static public String createClickGeom(double x, double y, int srid) {
        StringBuffer sq = new StringBuffer();
        sq.append(" GeometryFromText ( ");
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
    
}
