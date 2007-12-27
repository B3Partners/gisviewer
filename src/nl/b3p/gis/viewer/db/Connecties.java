/*
 * Connectie.java
 *
 * Created on 7 december 2007, 15:09
 *
 * Autor: Roy Braam
 */

package nl.b3p.gis.viewer.db;

import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Roy Braam
 */
public class Connecties {
    public static final String TYPE_JDBC="jdbc";
    public static final String TYPE_WFS="wfs";
    public static final String DIALECT_POSTGRESQL="postgresql";
    public static final String DIALECT_MYSQL="mysql";
    
    private int id;
    private String naam;
    private String connectie_url;
    private String gebruikersnaam;
    private String wachtwoord;
    private String type;
    private String dialect;
    
    /** Creates a new instance of Connectie */
    public Connecties() {
    }
    
    
    
    
    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNaam() {
        return naam;
    }

    public void setNaam(String naam) {
        this.naam = naam;
    }

    public String getConnectie_url() {
        return connectie_url;
    }

    public void setConnectie_url(String connectie_url) {
        this.connectie_url = connectie_url;
        type=null;
        dialect=null;
        if (connectie_url!=null && connectie_url.length()>0){
            //controleer of het een jdbc connectie is
            if (connectie_url.toLowerCase().startsWith("jdbc:")){
                this.setType(TYPE_JDBC);
                //als postgres is:                
                if (connectie_url.toLowerCase().substring(5,connectie_url.length()).startsWith("postgresql:")){
                    this.setDialect(DIALECT_POSTGRESQL);
                }else if (connectie_url.toLowerCase().substring(5,connectie_url.length()).startsWith("mysql:")){
                    this.setDialect(DIALECT_MYSQL);
                }
            }else{
                this.setType(TYPE_WFS);
            }
        }
    }

    public String getGebruikersnaam() {
        return gebruikersnaam;
    }

    public void setGebruikersnaam(String gebruikersnaam) {
        this.gebruikersnaam = gebruikersnaam;
    }

    public String getWachtwoord() {
        return wachtwoord;
    }

    public void setWachtwoord(String wachtwoord) {
        this.wachtwoord = wachtwoord;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDialect() {
        return dialect;
    }

    public void setDialect(String dialect) {
        this.dialect = dialect;
    }
    
    public java.sql.Connection getJdbcConnection() throws SQLException{        
        if (getType().equalsIgnoreCase(TYPE_JDBC)){
            if (getDialect().equalsIgnoreCase(DIALECT_POSTGRESQL)){
                DriverManager.registerDriver(new org.postgresql.Driver());
            }else if (getDialect().equalsIgnoreCase(DIALECT_MYSQL)){
                DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            }else {
                return null;
            }           
            return DriverManager.getConnection(this.getConnectie_url(),getGebruikersnaam(),getWachtwoord());
        }else{            
            return null;
        }
        
    }
}